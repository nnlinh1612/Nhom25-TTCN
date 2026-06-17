using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TTNguVan.Models;

namespace TTNguVan.Controllers
{
    [AllowAnonymous]
    public class BaiTestController : Controller
    {
        private readonly TrungTamNguVanContext _context;

        public BaiTestController(TrungTamNguVanContext context)
        {
            _context = context;
        }

        // trang nhập sđt để xác thực đầu vào 
        [HttpGet]
        public IActionResult XacThucDauVao(string maDe)
        {
            ViewBag.MaDeHienTai = maDe;
            return View();
        }

        // Hàm xử lý xác thực 
        [HttpPost]
        public IActionResult XuLyXacThuc(string sdt, string maDe)
        {
            if (string.IsNullOrEmpty(sdt))
            {
                TempData["Error"] = "Vui lòng nhập số điện thoại!";
                return RedirectToAction("XacThucDauVao", new { maDe = maDe });
            }

            // Tìm xem SĐT này có tồn tại trong hệ thống không 
            var danhSachTatCa = _context.HocViens
                                        .Where(k => k.Sdt == sdt)
                                        .ToList();

            if (danhSachTatCa.Count == 0)
            {
                TempData["Error"] = "Số điện thoại này chưa có trên hệ thống!";
                return RedirectToAction("XacThucDauVao", new { maDe = maDe });
            }

            // Nếu có SĐT trong hệ thống => lọc ra những người có trạng thái "Chờ xếp lớp"
            var danhSachHopLe = danhSachTatCa.Where(k => k.TrangThai == "Chờ xếp lớp").ToList();

            // Có SĐT nhưng không ai ở trạng thái Chờ xếp lớp
            if (danhSachHopLe.Count == 0)
            {
                TempData["Error"] = "Bạn không thể làm bài test này!";
                return RedirectToAction("XacThucDauVao", new { maDe = maDe });
            }

            // Nếu SĐT hợp lệ
            if (danhSachHopLe.Count == 1)
            {
                // Nếu chỉ có 1 người hợp lệ, cho vào thi luôn
                var hv = danhSachHopLe.First();

                // Lưu vào Session
                HttpContext.Session.SetString("MaHocVien", hv.MaHocVien ?? "KHACH");
                HttpContext.Session.SetString("TenHocVien", hv.TenHocVien);

                return RedirectToAction("LamTest", new { maDe = maDe });
            }

            // Nếu có từ 2 người trở lên hợp lệ (Anh em dùng chung số ĐT và đều đang chờ xếp lớp)
            ViewBag.MaDeHienTai = maDe;
            return View("ChonHocVien", danhSachHopLe);
        }

        // Trang làm bài
        [HttpGet]
        public IActionResult LamTest(string maDe, string ma, string ten)
        {
            if (!string.IsNullOrEmpty(ma) && !string.IsNullOrEmpty(ten))
            {
                HttpContext.Session.SetString("MaHocVien", ma);
                HttpContext.Session.SetString("TenHocVien", ten);
            }

            var tenHV = HttpContext.Session.GetString("TenHocVien");
            var maHV = HttpContext.Session.GetString("MaHocVien");

            if (string.IsNullOrEmpty(tenHV))
            {
                return RedirectToAction("XacThucDauVao", new { maDe = maDe });
            }

            ViewBag.TenHocVien = tenHV;
            ViewBag.MaHocVien = maHV;

            var baiTest = _context.BaiTests.FirstOrDefault(b => b.MaBaiTest == maDe);
            if (baiTest == null) return Content("Đề thi không tồn tại!");

            return View(baiTest);
        }

        [HttpPost]
        public IActionResult NopBai(string MaBaiTest, string MaHocVien, string NoiDungBaiLam)
        {
            try
            {
                // Lưu bài làm của học sinh
                var lastRecord = _context.BaiLams.OrderByDescending(b => b.MaBaiLam).FirstOrDefault();
                string newMa = (lastRecord == null) ? "BL001" : "BL" + (int.Parse(lastRecord.MaBaiLam.Replace("BL", "")) + 1).ToString("D3");

                var baiLam = new BaiLam
                {
                    MaBaiLam = newMa,
                    MaBaiTest = MaBaiTest,
                    MaHocVien = MaHocVien,
                    NoiDungBaiLam = NoiDungBaiLam ?? "(Trống)",
                    NgayLam = DateOnly.FromDateTime(DateTime.Now)
                };
                _context.BaiLams.Add(baiLam);
                _context.SaveChanges();

                // Tạo lời nhắc gửi cho giáo viên + trợ giảng
                try
                {
                    var hv = _context.HocViens.FirstOrDefault(h => h.MaHocVien == MaHocVien);
                    string tenHocVien = hv != null ? hv.TenHocVien : "Một học viên";

                    // Lấy danh sách các chức vụ được quyền nhận thông báo chấm bài test
                    var rolesAllowed = new List<string> { "Giáo viên", "Trợ giảng" };

                    // Tìm tất cả các tài khoản của Giáo viên và Trợ giảng
                    var dsNguoiNhan = _context.TaiKhoans
                        .Include(t => t.MaChucVuNavigation)
                        .Where(t => rolesAllowed.Contains(t.MaChucVuNavigation.TenChucVu))
                        .ToList();

                    // Tạo lời nhắc cho từng người một
                    foreach (var tk in dsNguoiNhan)
                    {
                        var loiNhacMoi = new LoiNhac
                        {
                            MaTk = tk.MaTk, 
                            TieuDe = "CÓ BÀI TEST CHỜ CHẤM",
                            NoiDung = $"Học viên {tenHocVien} ({MaHocVien}) vừa nộp bài test. Vui lòng chấm điểm để tư vấn xếp lớp.",
                            HanChot = DateTime.Now.AddDays(1), 
                            MucDo = "Quan trọng",
                            TrangThai = false
                        };
                        _context.LoiNhacs.Add(loiNhacMoi);
                    }

                    _context.SaveChanges();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Lỗi tạo lời nhắc: " + ex.Message);
                }

                // Nếu nộp bài thành công
                return RedirectToAction("NopBaiThanhCong"); 
            }
            catch (Exception ex)
            {
                return BadRequest("Lỗi nộp bài: " + ex.Message);
            }
        }
        // Hàm để hiện trang thông báo sau khi nộp
        [HttpGet]
        public IActionResult NopBaiThanhCong()
        {
            return View();
        }
    }
}


