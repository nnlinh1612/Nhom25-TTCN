using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore; // <-- ĐÃ THÊM THƯ VIỆN NÀY ĐỂ DÙNG INCLUDE
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;
using TTNguVan.Models;

namespace TTNguVan.Controllers
{
    public class QuanLyController : Controller
    {
        private readonly TrungTamNguVanContext _context;

        public QuanLyController(TrungTamNguVanContext context)
        {
            _context = context;
        }

        // Dashboard giao diện quản lý
        [HttpGet]
        public IActionResult Dashboard(DateTime? ngayXemLich)
        {
            var maTK = HttpContext.Session.GetString("MaTK");
            var role = HttpContext.Session.GetString("Role");
            var qlCheck = _context.TaiKhoans.FirstOrDefault(t => t.MaTk == maTK);

            if (qlCheck == null || role != "CV006" || qlCheck.TrangThai != "Đã duyệt")
            {
                HttpContext.Session.Clear();
                return RedirectToAction("DangNhap", "TaiKhoan");
            }

            // Dữ liệu KPI trên cùng
            double tongKhach = _context.KhachHangs.Count();
            double tongHocVien = _context.HocViens.Count(k => k.MaHocVien != null);
            double tyLe = tongKhach > 0 ? (tongHocVien / tongKhach) * 100 : 0;
            int tongLop = _context.LopHocs.Count();

            ViewBag.TongKhachHang = tongKhach;
            ViewBag.TongHocVien = tongHocVien;
            ViewBag.TyLeChuyenDoi = Math.Round(tyLe, 1);
            ViewBag.SoLopHoc = tongLop;

            var allKhachHang = _context.KhachHangs.ToList();

            // Biểu đồ thu hút và chuyển đổi (6 tháng gần nhất)
            var labelsTrend = new List<string>();
            var dataLeads = new List<int>();
            var dataSuccess = new List<int>();
            for (int i = 5; i >= 0; i--)
            {
                var targetDate = DateTime.Now.AddMonths(-i);
                labelsTrend.Add($"Tháng {targetDate.Month}");
                dataLeads.Add(allKhachHang.Count(x => x.NgayTiepNhan?.Month == targetDate.Month && x.NgayTiepNhan?.Year == targetDate.Year));
                dataSuccess.Add(allKhachHang.Count(x => x.NgayDangKy?.Month == targetDate.Month && x.NgayDangKy?.Year == targetDate.Year && x.TrangThai == "Đã đăng ký"));
            }
            ViewBag.LabelsTrend = string.Join(",", labelsTrend.Select(x => "'" + x + "'"));
            ViewBag.DataLeads = string.Join(",", dataLeads);
            ViewBag.DataSuccess = string.Join(",", dataSuccess);

            // Biểu đồ điểm số trung bình của lớp theo tháng (6 tháng)
            var monthLabelsScore = new List<string>();
            var targetMonths = new List<(int Year, int Month)>();

            // Lùi 6 tháng 
            for (int i = 5; i >= 0; i--)
            {
                var targetDate = DateTime.Now.AddMonths(-i);
                monthLabelsScore.Add($"Tháng {targetDate.Month}");
                targetMonths.Add((targetDate.Year, targetDate.Month));
            }
            ViewBag.LabelsScore = string.Join(",", monthLabelsScore.Select(x => "'" + x + "'"));

            // Mốc thời gian 6 tháng trước 
            var sixMonthsAgoDate = DateOnly.FromDateTime(DateTime.Now.AddMonths(-6));

            // Kéo toàn bộ điểm số trong 6 tháng qua từ SQL để xử lý
            var allKetQua = _context.KqHocTaps
                .Include(k => k.MaBuoiHocNavigation)
                .Where(k => k.DiemSo != null && k.MaBuoiHocNavigation.NgayHoc >= sixMonthsAgoDate)
                .ToList();

            var lineDatasets = new List<object>();
            // Dải màu cho 21 lớp
            var colors = new[] { "#ef4444", "#f97316", "#f59e0b", "#84cc16", "#10b981", "#14b8a6", "#06b6d4", "#0ea5e9", "#3b82f6", "#6366f1", "#8b5cf6", "#a855f7", "#d946ef", "#ec4899", "#f43f5e" };
            int colorIdx = 0;

            // Lấy toàn bộ lớp đang có trong hệ thống
            var allLopHocs = _context.LopHocs.OrderBy(l => l.TenLop).ToList();

            foreach (var lop in allLopHocs)
            {
                var dataPoints = new List<double?>();

                foreach (var tm in targetMonths)
                {
                    // Lọc ra điểm của lớp này trong tháng đang xét
                    var diemTrongThang = allKetQua
                        .Where(k => k.MaBuoiHocNavigation.MaLop == lop.MaLop
                                 && k.MaBuoiHocNavigation.NgayHoc.Month == tm.Month
                                 && k.MaBuoiHocNavigation.NgayHoc.Year == tm.Year)
                        .Select(k => (double)k.DiemSo)
                        .ToList();

                    if (diemTrongThang.Any())
                    {
                        dataPoints.Add(Math.Round(diemTrongThang.Average(), 1)); // Tính trung bình tháng
                    }
                    else
                    {
                        dataPoints.Add(null); // Nếu tháng đó nghỉ học, điểm sẽ bị đứt quãng
                    }
                }

                // Bộ lọc: Chỉ vẽ những lớp có ít nhất 1 bài test/chấm điểm trong 6 tháng qua
                if (dataPoints.Any(d => d != null))
                {
                    lineDatasets.Add(new
                    {
                        label = lop.TenLop,
                        data = dataPoints,
                        borderColor = colors[colorIdx % colors.Length],
                        backgroundColor = "transparent", 
                        borderWidth = 2,
                        tension = 0.4,
                        spanGaps = true 
                    });
                    colorIdx++;
                }
            }

            // Đóng gói mảng 21 lớp thành JSON đẩy xuống View
            ViewBag.LineDatasets = JsonSerializer.Serialize(lineDatasets);

            // Biểu đồ khối lớp
            var thongKeKhoi = _context.HocViens
                .Where(h => h.KhoiLop != null)
                .GroupBy(h => h.KhoiLop)
                .OrderBy(g => g.Key)
                .Select(g => new {
                    Khoi = "Khối " + g.Key,
                    SoLuong = g.Count()
                })
                .ToList();

            ViewBag.LabelsKhoi = string.Join(",", thongKeKhoi.Select(x => "'" + x.Khoi + "'"));
            ViewBag.DataKhoi = string.Join(",", thongKeKhoi.Select(x => x.SoLuong));
            
            // Biểu đồ nguồn
            var thongKeNguon = allKhachHang
                .GroupBy(k => k.NguonDen)
                .Select(g => new { TenNguon = g.Key ?? "Khác", SoLuong = g.Count() }).ToList();

            ViewBag.LabelsNguon = string.Join(",", thongKeNguon.Select(x => "'" + x.TenNguon + "'"));
            ViewBag.DataNguon = string.Join(",", thongKeNguon.Select(x => x.SoLuong));

            ViewBag.TenQL = qlCheck.HoTen;
            ViewBag.EmailQL = qlCheck.Email;

            // Biểu đồ khối và học lực (6 tuần gần nhất)

            var kqHocTapData = _context.KqHocTaps
                .Include(k => k.MaBuoiHocNavigation)
                .Include(k => k.MaHocVienNavigation)
                .AsEnumerable().ToList();

            var top6Weeks = kqHocTapData
                .Select(k => {
                    var date = k.MaBuoiHocNavigation.NgayHoc;
                    int weekNum = ((date.Day - 1) / 7) + 1;
                    if (weekNum > 4) weekNum = 4;
                    int sortKey = date.Year * 1000 + date.Month * 10 + weekNum;
                    return new { SortKey = sortKey, Label = $"Tuần {weekNum} - T{date.Month}" };
                })
                .Distinct().OrderByDescending(x => x.SortKey).Take(6).Reverse().ToList();

            var mixedChartData = new Dictionary<string, object>();
            var khoiLops = new[] { 6, 7, 8, 9, 10, 11, 12 };

            var mucHocLuc = new[] {
               new { K = "ALL", V = "Tất cả" },
               new { K = "TB", V = "Trung bình" },
               new { K = "KHA", V = "Khá" },
               new { K = "GIOI", V = "Giỏi" } };

            foreach (var khoi in khoiLops)
            {
                foreach (var muc in mucHocLuc)
                {
                    // Nếu mục là "All" thì bỏ qua điều kiện lọc tên lớp
                    var dataPhanKhuc = kqHocTapData
                        .Where(k => k.MaHocVienNavigation.KhoiLop == khoi
                                 && (muc.K == "ALL" || k.MaBuoiHocNavigation.MaLopNavigation.TenLop.Contains(muc.V)))
                        .ToList();

                    var labels = new List<string>();
                    var avgScores = new List<double>();
                    var attendanceRates = new List<double>();
                    bool hasData = false;

                    foreach (var week in top6Weeks)
                    {
                        labels.Add(week.Label);
                        var group = dataPhanKhuc.Where(k => {
                            var date = k.MaBuoiHocNavigation.NgayHoc;
                            int weekNum = ((date.Day - 1) / 7) + 1;
                            int sortKey = date.Year * 1000 + date.Month * 10 + (weekNum > 4 ? 4 : weekNum);
                            return sortKey == week.SortKey;
                        }).ToList();

                        if (group.Any())
                        {
                            avgScores.Add(Math.Round(group.Average(k => (double)k.DiemSo), 1));
                            attendanceRates.Add(Math.Round(((double)group.Count(k => k.DiemDanh != "Vắng") / group.Count()) * 100, 1));
                            hasData = true;
                        }
                        else
                        {
                            avgScores.Add(0);
                            attendanceRates.Add(0);
                        }
                    }

                    // Hệ thống sẽ tự động sinh thêm các key như: "6_ALL", "7_ALL", "8_ALL"...
                    mixedChartData[$"{khoi}_{muc.K}"] = new
                    {
                        labels = labels,
                        diemTB = avgScores,
                        diemDanh = attendanceRates,
                        isStarted = hasData
                    };
                }
            }
            ViewBag.MixedChartData = System.Text.Json.JsonSerializer.Serialize(mixedChartData);

            DateTime ngayMucTieu = ngayXemLich ?? DateTime.Now;
            ViewBag.NgayXemLich = ngayMucTieu;

            int targetDayOfWeek = (int)ngayMucTieu.DayOfWeek == 0 ? 8 : (int)ngayMucTieu.DayOfWeek + 1;

            var listLichHoc = (from lh in _context.LichHocs
                               where lh.Thu == targetDayOfWeek
                               join lop in _context.LopHocs on lh.MaLop equals lop.MaLop
                               join ct in _context.CtPhuTraches on lh.MaLop equals ct.MaLop
                               join tk in _context.TaiKhoans on ct.MaTk equals tk.MaTk
                               where ct.VaiTro == "Giáo viên"
                               orderby lh.GioBatDau
                               select new
                               {
                                   TenLop = lop.TenLop,
                                   CaHoc = lh.TenCa,
                                   GioBatDau = lh.GioBatDau,
                                   GioKetThuc = lh.GioKetThuc,
                                   TenGiaoVien = tk.HoTen
                               }).Take(6).ToList();

            ViewBag.LichHocHomNayJson = System.Text.Json.JsonSerializer.Serialize(listLichHoc);

            return View();
        }

        // Trang Quản lý lớp học
        [HttpGet]
        public IActionResult QuanLyLop()
        {
            // Kiểm tra quyền 
            if (HttpContext.Session.GetString("Role") != "CV006")
                return RedirectToAction("DangNhap", "TaiKhoan");

            // Thống kê 3 thẻ trên đầu
            ViewBag.TongSoLop = _context.LopHocs.Count();
            ViewBag.SoGiaoVien = _context.TaiKhoans.Count(t => t.MaChucVu == "CV004");
            ViewBag.SoTroGiang = _context.TaiKhoans.Count(t => t.MaChucVu == "CV005");

            // Lấy danh sách giáo viên + trợ giảng đổ vào Dropdown 
            var gvList = _context.TaiKhoans.Where(t => t.MaChucVu == "CV004").ToList();
            ViewBag.DsGiaoVien = new SelectList(gvList, "MaTk", "HoTen");

            var TGList = _context.TaiKhoans.Where(t => t.MaChucVu == "CV005").ToList();
            ViewBag.DsTroGiang = new SelectList(TGList, "MaTk", "HoTen");

            // Lấy dữ liệu tra cứu 
            ViewBag.AllPhuTrach = _context.CtPhuTraches.ToList();
            ViewBag.AllUsers = _context.TaiKhoans.ToList();

            // Thông tin Profile chân sidebar 
            var maTK = HttpContext.Session.GetString("MaTK");
            var ql = _context.TaiKhoans.Find(maTK);
            ViewBag.TenQL = ql?.HoTen;
            ViewBag.EmailQL = ql?.Email;

            //Đếm sĩ số lớp
            var dsLop = _context.LopHocs.Include(l => l.HocViens).ToList();
            return View(dsLop);
        }

        // Thêm lớp
        [HttpPost]
        public IActionResult ThemLop(LopHoc lop, string MaGV, string MaTG, DateOnly NgayBD, DateOnly NgayKT)
        {
            if (NgayKT <= NgayBD)
            {
                TempData["Error"] = "Lỗi: Ngày kết thúc phải lớn hơn ngày bắt đầu!";
                return RedirectToAction("QuanLyLop");
            }

            int nextId = _context.LopHocs.Count() + 1;
            lop.MaLop = "LH" + nextId.ToString("D3");
            _context.LopHocs.Add(lop);
            _context.SaveChanges();

            if (!string.IsNullOrEmpty(MaGV))
            {
                _context.CtPhuTraches.Add(new CtPhuTrach { MaLop = lop.MaLop, MaTk = MaGV, VaiTro = "Giáo viên", NgayBatDauPt = NgayBD, NgayKetThucPt = NgayKT });
            }
            if (!string.IsNullOrEmpty(MaTG))
            {
                _context.CtPhuTraches.Add(new CtPhuTrach { MaLop = lop.MaLop, MaTk = MaTG, VaiTro = "Trợ giảng", NgayBatDauPt = NgayBD, NgayKetThucPt = NgayKT });
            }

            _context.SaveChanges();
            TempData["SuccessMessage"] = "Đã thêm lớp thành công!";
            return RedirectToAction("QuanLyLop");
        }

        // Xóa lớp
        [HttpPost]
        public IActionResult XoaLop(string id)
        {
            bool dangCoHocVien = _context.HocViens.Any(h => h.MaLop == id);
            if (dangCoHocVien)
            {
                TempData["Error"] = "Không thể xóa! Lớp học này đang có học viên theo học.";
                return RedirectToAction("QuanLyLop");
            }

            var lop = _context.LopHocs.Find(id);
            if (lop != null)
            {
                _context.LopHocs.Remove(lop);
                _context.SaveChanges();
                TempData["SuccessMessage"] = "Đã xóa lớp học thành công!";
            }
            return RedirectToAction("QuanLyLop");
        }

        // Sửa lớp
        [HttpPost]
        public IActionResult SuaLop(LopHoc lop, string MaGV, string MaTG, DateOnly NgayBD, DateOnly NgayKT)
        {
            var l = _context.LopHocs.Find(lop.MaLop);
            if (l != null) { l.TenLop = lop.TenLop; l.MoTa = lop.MoTa; }

            var oldAssigns = _context.CtPhuTraches.Where(p => p.MaLop == lop.MaLop).ToList();
            _context.CtPhuTraches.RemoveRange(oldAssigns);

            if (!string.IsNullOrEmpty(MaGV)) _context.CtPhuTraches.Add(new CtPhuTrach { MaLop = lop.MaLop, MaTk = MaGV, VaiTro = "Giáo viên", NgayBatDauPt = NgayBD, NgayKetThucPt = NgayKT });
            if (!string.IsNullOrEmpty(MaTG)) _context.CtPhuTraches.Add(new CtPhuTrach { MaLop = lop.MaLop, MaTk = MaTG, VaiTro = "Trợ giảng", NgayBatDauPt = NgayBD, NgayKetThucPt = NgayKT });

            _context.SaveChanges();
            return RedirectToAction("QuanLyLop");
        }

        // Trang Quản lý bài test
        [HttpGet]
        public IActionResult QuanLyBaiTest()
        {
            if (HttpContext.Session.GetString("Role") != "CV006")
                return RedirectToAction("DangNhap", "TaiKhoan");

            var maTK = HttpContext.Session.GetString("MaTK");
            var ql = _context.TaiKhoans.Find(maTK);

            if (ql != null)
            {
                ViewBag.TenQL = ql.HoTen;   
                ViewBag.EmailQL = ql.Email; 
            }

            var dsBaiTest = _context.BaiTests.ToList();
            return View(dsBaiTest);
        }

        // Hàm thêm bài test
        [HttpPost]
        public IActionResult ThemBaiTest(BaiTest bt)
        {
            // Tự động sinh mã bài test
            int count = _context.BaiTests.Count() + 1;
            bt.MaBaiTest = "BT" + count.ToString("D3");

            _context.BaiTests.Add(bt);
            _context.SaveChanges();
            TempData["SuccessMessage"] = "Đã thêm bài test mới thành công!";
            return RedirectToAction("QuanLyBaiTest");
        }

        // Hàm sửa bài test
        [HttpPost]
        public IActionResult SuaBaiTest(BaiTest bt)
        {
            var existing = _context.BaiTests.Find(bt.MaBaiTest);
            if (existing != null)
            {
                existing.TenBaiTest = bt.TenBaiTest;
                existing.NoiDungDe = bt.NoiDungDe;
                _context.SaveChanges();
            }
            TempData["SuccessMessage"] = "Đã cập nhật bài test thành công!";
            return RedirectToAction("QuanLyBaiTest");
        }

        // Hàm xóa bài test
        [HttpPost]
        public IActionResult XoaBaiTest(string id)
        {
            var bt = _context.BaiTests.Find(id);
            if (bt != null)
            {
                _context.BaiTests.Remove(bt);
                _context.SaveChanges();
            }
            TempData["SuccessMessage"] = "Đã xóa bài test!";
            return RedirectToAction("QuanLyBaiTest");
        }
    }
}

