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

        // 1. Trang nhập SĐT
        [HttpGet]
        public IActionResult XacThucDauVao(string maDe)
        {
            ViewBag.MaDeHienTai = maDe;
            return View();
        }

        // 2. Xử lý xác thực 
        [HttpPost]
        public IActionResult XuLyXacThuc(string sdt, string maDe)
        {
            if (string.IsNullOrEmpty(sdt))
            {
                TempData["Error"] = "Vui lòng nhập số điện thoại!";
                return RedirectToAction("XacThucDauVao", new { maDe = maDe });
            }

            // BƯỚC 1: Tìm xem SĐT này có tồn tại trong hệ thống không đã
            var danhSachTatCa = _context.HocViens
                                        .Where(k => k.Sdt == sdt)
                                        .ToList();

            if (danhSachTatCa.Count == 0)
            {
                TempData["Error"] = "Số điện thoại này chưa có trên hệ thống!";
                return RedirectToAction("XacThucDauVao", new { maDe = maDe });
            }

            // BƯỚC 2: Có SĐT rồi thì lọc ra những người đang "Chờ xếp lớp"
            var danhSachHopLe = danhSachTatCa.Where(k => k.TrangThai == "Chờ xếp lớp").ToList();

            // SỬA TẠI ĐÂY: Có SĐT nhưng không ai ở trạng thái Chờ xếp lớp
            if (danhSachHopLe.Count == 0)
            {
                TempData["Error"] = "Bạn không thể làm bài test này!";
                return RedirectToAction("XacThucDauVao", new { maDe = maDe });
            }

            // BƯỚC 3: Xử lý bình thường với danh sách hợp lệ
            if (danhSachHopLe.Count == 1)
            {
                // Nếu chỉ có 1 người hợp lệ, cho vào thi luôn
                var hv = danhSachHopLe.First();

                // Lưu vào tủ đồ Session
                HttpContext.Session.SetString("MaHocVien", hv.MaHocVien ?? "KHACH");
                HttpContext.Session.SetString("TenHocVien", hv.TenHocVien);

                return RedirectToAction("LamTest", new { maDe = maDe });
            }

            // Nếu có từ 2 người trở lên hợp lệ (Anh em dùng chung số ĐT và đều đang chờ xếp lớp)
            ViewBag.MaDeHienTai = maDe;
            return View("ChonHocVien", danhSachHopLe);
        }

        // 3. Trang làm bài
        [HttpGet]
        public IActionResult LamTest(string maDe, string ma, string ten)
        {
            // Nếu có tham số truyền từ trang chọn vào, thực hiện nạp vào Session luôn
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
                // ==========================================
                // 1. LƯU BÀI LÀM CỦA HỌC SINH
                // ==========================================
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

                // ==========================================
                // 2. TẠO LỜI NHẮC (LOI_NHAC) GỬI CHO CÁN BỘ
                // ==========================================
                try
                {
                    var hv = _context.HocViens.FirstOrDefault(h => h.MaHocVien == MaHocVien);
                    string tenHocVien = hv != null ? hv.TenHocVien : "Một học viên";

                    // Lấy danh sách các chức vụ được quyền nhận thông báo chấm bài test
                    var rolesAllowed = new List<string> { "Giáo viên", "Trợ giảng" };

                    // Tìm tất cả các tài khoản thuộc các chức vụ trên
                    var dsNguoiNhan = _context.TaiKhoans
                        .Include(t => t.MaChucVuNavigation)
                        .Where(t => rolesAllowed.Contains(t.MaChucVuNavigation.TenChucVu))
                        .ToList();

                    // Tạo lời nhắc cho từng người một
                    foreach (var tk in dsNguoiNhan)
                    {
                        var loiNhacMoi = new LoiNhac
                        {
                            MaTk = tk.MaTk, // Gửi đích danh cho mã tài khoản này
                            TieuDe = "CÓ BÀI TEST CHỜ CHẤM",
                            NoiDung = $"Học viên {tenHocVien} ({MaHocVien}) vừa nộp bài test. Vui lòng chấm điểm để tư vấn xếp lớp.",
                            HanChot = DateTime.Now.AddDays(1), // Hạn chót chấm trong 1 ngày
                            MucDo = "Quan trọng",
                            TrangThai = false
                        };
                        _context.LoiNhacs.Add(loiNhacMoi);
                    }

                    _context.SaveChanges(); // Lưu một loạt lời nhắc vào DB
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Lỗi tạo lời nhắc: " + ex.Message);
                }

                // 3. CHUYỂN HƯỚNG BÁO THÀNH CÔNG
                return RedirectToAction("NopBaiThanhCong"); // Nhớ tạo cái trang View báo thành công nhé
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


