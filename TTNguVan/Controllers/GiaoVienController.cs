using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TTNguVan.Models;
using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using System.Linq;
using System;

namespace TTNguVan.Controllers
{
    public class GiaoVienController : Controller
    {
        private readonly TrungTamNguVanContext _context;

        public GiaoVienController(TrungTamNguVanContext context)
        {
            _context = context;
        }
        private void LayThongTinProfile()
        {
            var maTk = HttpContext.Session.GetString("MaTK");
            ViewBag.TenGV = HttpContext.Session.GetString("HoTen");
            ViewBag.EmailGV = HttpContext.Session.GetString("Email");
            ViewBag.AllUsers = _context.TaiKhoans.ToList();
            ViewBag.AllPhuTrach = _context.CtPhuTraches.ToList();

            if (!string.IsNullOrEmpty(maTk))
            {
                int countLoiNhac = _context.LoiNhacs.Count(l => l.MaTk == maTk && l.TrangThai != true);

                int countCanhBao = _context.CanhBaos.Count(c => c.TrangThai != true);

                int soBaiCho = _context.BaiLams.Count(b => !_context.KqBaiTests.Any(k => k.MaBaiLam == b.MaBaiLam));
                ViewBag.SoBaiChoCham = soBaiCho;

                ViewBag.SoLoiNhac = countLoiNhac + countCanhBao;
            }
        }

        public IActionResult Index() => RedirectToAction("LichDay");

        // Trang Lịch dạy
        public IActionResult LichDay(int? thang, int? nam)
        {
            LayThongTinProfile();
            var maTk = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(maTk)) return RedirectToAction("DangNhap", "TaiKhoan");

            // Hàm xử lý thời gian, mặc định là tháng hiện tại
            int month = thang ?? DateTime.Now.Month;
            int year = nam ?? DateTime.Now.Year;
            ViewBag.Thang = month;
            ViewBag.Nam = year;

            // Lấy danh sách lớp giáo viên/trợ giảng đó phụ trách
            var dsMaLop = _context.CtPhuTraches
                                  .Where(p => p.MaTk == maTk)
                                  .Select(p => p.MaLop)
                                  .ToList();

            // Lấy Lời nhắc và cảnh báo trong tháng này
            var loiNhacs = _context.LoiNhacs
                           .Where(l => l.MaTk == maTk && l.HanChot.HasValue && l.HanChot.Value.Month == month && l.HanChot.Value.Year == year)
                           .ToList();

            var canhBaos = _context.CanhBaos
                                   .Where(c => c.HanChot.HasValue && c.HanChot.Value.Month == month && c.HanChot.Value.Year == year)
                                   .ToList();
            var lichDay = _context.LichHocs
                 .Include(l => l.MaLopNavigation)
                 .Where(l => dsMaLop.Contains(l.MaLop))
                 .ToList();

            ViewBag.LichDay = lichDay;
            ViewBag.LoiNhacs = loiNhacs;
            ViewBag.CanhBaos = canhBaos;

            return View("LichDay");
        }

        // Trang theo dõi học tập 
        public IActionResult TheoDoiHocTap(string ngay, string searchString, string maLop)
        {
            LayThongTinProfile();
            var maTk = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(maTk)) return RedirectToAction("DangNhap", "TaiKhoan");

            // Nửa bên trái: Danh sách lớp
            var queryLop = (from pt in _context.CtPhuTraches
                            join lh in _context.LopHocs on pt.MaLop equals lh.MaLop
                            where pt.MaTk == maTk
                            select lh).Distinct().AsQueryable();

            ViewBag.CaHoc = ""; 
            if (!string.IsNullOrEmpty(ngay))
            {
                if (DateTime.TryParse(ngay, out DateTime dt))
                {
                    int thu = ((int)dt.DayOfWeek == 0) ? 8 : (int)dt.DayOfWeek + 1;

                    // Tìm các lớp có lịch học ngày này
                    var cacLopCoLich = _context.LichHocs.Where(l => l.Thu == thu).Select(l => l.MaLop).Distinct().ToList();
                    queryLop = queryLop.Where(l => cacLopCoLich.Contains(l.MaLop));

                    // Nếu đang chọn 1 lớp cụ thể, lấy luôn Tên Ca của lớp đó trong ngày này
                    if (!string.IsNullOrEmpty(maLop))
                    {
                        ViewBag.CaHoc = _context.LichHocs.FirstOrDefault(l => l.MaLop == maLop && l.Thu == thu)?.TenCa ?? "";
                    }
                }
            }
            ViewBag.DanhSachLop = queryLop.ToList();

            // Nửa bên trái: Bảng học viên
            var queryHocVien = _context.HocViens
                .Include(h => h.MaLopNavigation)
                .Include(h => h.KqHocTaps)
                .AsQueryable();

            if (!string.IsNullOrEmpty(maLop))
            {
                // Lọc học viên theo lớp được chọn bên trái
                queryHocVien = queryHocVien.Where(h => h.MaLop == maLop);
            }

            if (!string.IsNullOrEmpty(searchString))
            {
                // Lọc học viên theo tên/mã
                queryHocVien = queryHocVien.Where(h => h.TenHocVien.Contains(searchString) || h.MaHocVien.Contains(searchString));
            }

            ViewBag.NgayLoc = ngay;
            ViewBag.MaLopLoc = maLop;
            ViewBag.CurrentSearch = searchString;

            return View(queryHocVien.ToList());
        }

        // Hiển thị giao diện cập nhật buổi học cho cả 1 lớp
        [HttpGet]
        public IActionResult CapNhatBuoiHoc(string maLop, string ngay, string ca)
        {
            LayThongTinProfile();
            var maTk = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(maTk)) return RedirectToAction("DangNhap", "TaiKhoan");

            if (string.IsNullOrEmpty(maLop) || string.IsNullOrEmpty(ngay))
                return RedirectToAction("TheoDoiHocTap");

            ViewBag.Lop = _context.LopHocs.FirstOrDefault(l => l.MaLop == maLop);
            ViewBag.Ngay = ngay;
            ViewBag.Ca = ca;

            var dsHocVien = _context.HocViens.Where(h => h.MaLop == maLop).ToList();

            DateTime dt;
            if (DateTime.TryParse(ngay, out dt))
            {
                DateOnly ngayHocDate = DateOnly.FromDateTime(dt);

                // Tìm Buổi học cũ
                var buoiHocCu = _context.BuoiHocs.FirstOrDefault(b => b.MaLop == maLop && b.NgayHoc == ngayHocDate);

                // Nếu đã có dữ liệu buổi học đó, hiển thị lại dữ liệu đó lên màn hình
                if (buoiHocCu != null)
                {
                    ViewBag.DaCapNhat = true; 
                    ViewBag.DiemCu = _context.KqHocTaps.Where(k => k.MaBuoiHoc == buoiHocCu.MaBuoiHoc).ToList();
                }
                else
                {
                    ViewBag.DaCapNhat = false;
                    ViewBag.DiemCu = new List<KqHocTap>();
                }
            }
            else
            {
                return BadRequest("Định dạng ngày tháng không hợp lệ.");
            }

            return View(dsHocVien);
        }

        // Lưu nhật ký buổi học 
        [HttpPost]
        public IActionResult LuuNhatKy(DateTime ngay, string ca, string maLop, List<KqHocTap> danhSachKQ)
        {
            LayThongTinProfile();
            try
            {
                DateOnly ngayDateOnly = DateOnly.FromDateTime(ngay);
                var buoiHoc = _context.BuoiHocs.FirstOrDefault(b => b.NgayHoc == ngayDateOnly && b.MaLop == maLop);

                if (buoiHoc == null)
                {
                    string nextID = "BH" + (_context.BuoiHocs.Count() + 1).ToString("D3");
                    buoiHoc = new BuoiHoc
                    {
                        MaBuoiHoc = nextID.Length > 5 ? nextID.Substring(nextID.Length - 5) : nextID,
                        NgayHoc = ngayDateOnly,
                        MaLop = maLop
                    };
                    _context.BuoiHocs.Add(buoiHoc);
                    _context.SaveChanges();
                }

                foreach (var kq in danhSachKQ)
                {
                    var rCu = _context.KqHocTaps.FirstOrDefault(k => k.MaBuoiHoc == buoiHoc.MaBuoiHoc && k.MaHocVien == kq.MaHocVien);
                    if (rCu != null)
                    {
                        rCu.DiemDanh = kq.DiemDanh;
                        rCu.Btvn = kq.Btvn ?? "N/A";
                        rCu.DiemSo = kq.DiemSo;
                        rCu.NhanXet = kq.NhanXet ?? "";
                    }
                    else
                    {
                        string nextIDKQ = "KQ" + (_context.KqHocTaps.Count() + 1).ToString("D3");
                        kq.MaKqht = nextIDKQ.Length > 5 ? nextIDKQ.Substring(nextIDKQ.Length - 5) : nextIDKQ;
                        kq.MaBuoiHoc = buoiHoc.MaBuoiHoc;
                        kq.Btvn = kq.Btvn ?? "N/A";
                        kq.NhanXet = kq.NhanXet ?? "";
                        _context.KqHocTaps.Add(kq);
                    }
                }
                _context.SaveChanges();

                // Quét kết quả học tập để tạo lời nhắc
                var maTk = HttpContext.Session.GetString("MaTK");
                TaoLoiNhacTuDong(maLop, maTk);

                // Số thông báo hiển thị trên sidebar
                LayThongTinProfile();

                TempData["Success"] = "Cập nhật thành công!";
            }
            catch (Exception ex) { TempData["Error"] = "Lỗi: " + ex.Message; }

            return RedirectToAction("TheoDoiHocTap", new { ngay = ngay.ToString("yyyy-MM-dd"), maLop = maLop });
        }

        // Trang nhật ký chi tiết 
        public IActionResult NhatKyHocVien(string maHV, int? thang, int? nam)
        {
            LayThongTinProfile();
            var maTk = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(maTk)) return RedirectToAction("DangNhap", "TaiKhoan");

            var hocVien = _context.HocViens
                .Include(h => h.MaLopNavigation)
                .FirstOrDefault(h => h.MaHocVien == maHV);

            if (hocVien == null) return NotFound();

            ViewBag.HocVien = hocVien;

            // Lấy năm hiện tại nếu không chọn
            int namLoc = nam ?? DateTime.Now.Year;

            var query = _context.KqHocTaps
                .Include(k => k.MaBuoiHocNavigation)
                .Where(k => k.MaHocVien == maHV)
                .AsQueryable();

            // Lọc theo tháng và năm
            if (thang.HasValue)
            {
                query = query.Where(k => k.MaBuoiHocNavigation.NgayHoc.Month == thang.Value);
            }
            query = query.Where(k => k.MaBuoiHocNavigation.NgayHoc.Year == namLoc);

            // Lưu lại giá trị bộ lọc để View hiển thị
            ViewBag.ThangLoc = thang;
            ViewBag.NamLoc = namLoc;

            var nhatKy = query.OrderByDescending(k => k.MaBuoiHocNavigation.NgayHoc).ToList();

            return View(nhatKy);
        }

        // Dò lịch từ CSDL
        private string TimLopTheoLich(DateTime ngay, string ca)
        {
            int thu = ((int)ngay.DayOfWeek == 0) ? 8 : (int)ngay.DayOfWeek + 1;
            var maTk = HttpContext.Session.GetString("MaTK");
            var lich = _context.LichHocs.Where(l => l.Thu == thu && l.TenCa == ca)
                .FirstOrDefault(l => _context.CtPhuTraches.Any(p => p.MaLop == l.MaLop && p.MaTk == maTk));
            return lich?.MaLop;
        }

        // Trang quản lý bài test
        public IActionResult QuanLyBaiTest()
        {
            LayThongTinProfile();
            // check đăng nhập đầu tiên
            var maTk = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(maTk)) return RedirectToAction("DangNhap", "TaiKhoan");

            LayThongTinProfile();
            // Lấy ds bài chờ chấm: Có trong BaiLam nhưng chưa có trong KqBaiTest
            var choCham = _context.BaiLams
                .Include(b => b.MaHocVienNavigation) 
                .Where(b => !_context.KqBaiTests.Any(k => k.MaBaiLam == b.MaBaiLam))
                .ToList();

            // Lấy ds bài đã chấm: Lấy từ bảng KqBaiTest, nối ngược về BaiLam để lấy thông tin
            var daCham = _context.KqBaiTests
                .Include(k => k.MaBaiLamNavigation)
                    .ThenInclude(b => b.MaHocVienNavigation)
                .ToList();

            // Danh sách quản lý bài test
            var viewModel = new QuanLyBaiTestViewModel
            {
                DanhSachChoCham = choCham,
                DanhSachDaCham = daCham
            };

            // Số liệu cho các thẻ thống kê ở trên đầu
            ViewBag.CountCho = choCham.Count;
            ViewBag.CountDa = daCham.Count;
            ViewBag.Tong = choCham.Count + daCham.Count;

            return View(viewModel);
        }

        // Trang chấm bài
        public IActionResult ChamBai(string id)
        {
            LayThongTinProfile();

            // Lấy thông tin bài làm của học sinh
            var baiLam = _context.BaiLams
                .Include(b => b.MaHocVienNavigation)
                .Include(b => b.MaBaiTestNavigation)
                .FirstOrDefault(b => b.MaBaiLam == id);

            if (baiLam == null) return NotFound();

            // Tìm kết quả cũ (Nếu có)
            var kqCu = _context.KqBaiTests.FirstOrDefault(k => k.MaBaiLam == id);
            if (kqCu != null)
            {
                ViewBag.DiemCu = kqCu.DiemTest;
                ViewBag.NhanXetCu = kqCu.NhanXet;
                ViewBag.GhiChuCu = kqCu.GhiChu; 
            }
            else
            {
                ViewBag.DiemCu = null;
                ViewBag.NhanXetCu = "";
                ViewBag.GhiChuCu = "";
            }

            // Lấy danh sách lớp theo khối để hiện lên dropdown đề xuất lớp
            int? khoiCuaHocSinh = null;

            // Dò xem bài test cho khối mấy
            if (baiLam.MaBaiTestNavigation != null && !string.IsNullOrEmpty(baiLam.MaBaiTestNavigation.TenBaiTest))
            {
                // VD: TenBaiTest là "Đề kiểm tra đầu vào lớp 7" -> Lấy ra số 7
                string tenBai = baiLam.MaBaiTestNavigation.TenBaiTest;
                var match = System.Text.RegularExpressions.Regex.Match(tenBai, @"\d+");
                if (match.Success)
                {
                    khoiCuaHocSinh = int.Parse(match.Value);
                }
            }

            // Lấy ra tất cả các lớp của khối đó từ CSDL 
            var danhSachLopDeXuat = _context.LopHocs
                .Where(l => khoiCuaHocSinh == null || l.TenLop.Contains(khoiCuaHocSinh.ToString()))
                .Select(l => l.TenLop)
                .ToList();

            ViewBag.DanhSachLop = danhSachLopDeXuat;

            return View(baiLam);
        }

        // Sau khi chấm bài và lưu vào bảng KQ_BAI_TEST
        [HttpPost]
        public IActionResult LuuKetQua(KqBaiTest kq)
        {
            LayThongTinProfile();
            var maTk = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(maTk)) return BadRequest("Hết phiên đăng nhập");

            try
            {
                // Lưu điểm và nhận xét của giáo viên
                var ketQuaCu = _context.KqBaiTests
                    .FirstOrDefault(k => k.MaBaiLam == kq.MaBaiLam && k.MaTk == maTk);

                if (ketQuaCu != null)
                {
                    // Cập nhật
                    ketQuaCu.DiemTest = kq.DiemTest;
                    ketQuaCu.NhanXet = kq.NhanXet ?? "";
                    ketQuaCu.GhiChu = kq.GhiChu ?? "Chưa xếp lớp";
                    ketQuaCu.NgayCham = DateOnly.FromDateTime(DateTime.Now);
                }
                else
                {
                    // Thêm mới
                    kq.MaTk = maTk;
                    kq.NgayCham = DateOnly.FromDateTime(DateTime.Now);
                    if (string.IsNullOrEmpty(kq.GhiChu)) kq.GhiChu = "Chưa xếp lớp";
                    if (string.IsNullOrEmpty(kq.NhanXet)) kq.NhanXet = "";

                    _context.KqBaiTests.Add(kq);
                }
                _context.SaveChanges();

                // Lời nhắc xếp lớp cho CSKH
                try
                {
                    var baiLam = _context.BaiLams
                        .Include(b => b.MaHocVienNavigation)
                        .FirstOrDefault(b => b.MaBaiLam == kq.MaBaiLam);

                    string tenHocVien = baiLam?.MaHocVienNavigation?.TenHocVien ?? "Một học viên";
                    string maHV = baiLam?.MaHocVien ?? "";

                    // Danh sách các chức vụ cần nhận thông báo
                    var rolesCacBoPhan = new List<string> { "Sale", "CSKH" };

                    // Tìm tất cả tài khoản thuộc nhóm Sale hoặc CSKH
                    var danhSachNhanVien = _context.TaiKhoans
                        .Include(t => t.MaChucVuNavigation)
                        .Where(t => rolesCacBoPhan.Contains(t.MaChucVuNavigation.TenChucVu))
                        .ToList();

                    // Tạo lời nhắc cho từng người trong danh sách đó
                    foreach (var nv in danhSachNhanVien)
                    {
                        var loiNhacMoi = new LoiNhac
                        {
                            MaTk = nv.MaTk,
                            TieuDe = "XẾP LỚP CHO HỌC VIÊN",
                            NoiDung = $"Đã chấm xong bài test của HV {tenHocVien} ({maHV}). Điểm: {kq.DiemTest}. Đề xuất: {kq.GhiChu}. Vui lòng liên hệ và xếp lớp!",
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
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest("Lỗi Database: " + (ex.InnerException?.Message ?? ex.Message));
            }
        }

        // Hàm xuất phiếu kết quả bài test ra PDF
        public IActionResult XuatPdf(string id)
        {
            var kq = _context.KqBaiTests
                .Include(k => k.MaBaiLamNavigation)
                    .ThenInclude(b => b.MaHocVienNavigation) 
                .Include(k => k.MaBaiLamNavigation)
                    .ThenInclude(b => b.MaBaiTestNavigation) 
                .Include(k => k.MaTkNavigation) 
                .FirstOrDefault(k => k.MaBaiLam == id);

            if (kq == null) return NotFound();
            return View("PhieuKetQuaPdf", kq);
        }

        // Trang lời nhắc của GV
        [HttpGet]
        public async Task<IActionResult> LoiNhacGV(string loai = "binhthuong")
        {
            LayThongTinProfile();
            string currentMaTk = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(currentMaTk)) return RedirectToAction("DangNhap", "TaiKhoan");

            // 1. Lấy dữ liệu từ 2 bảng
            var queryLoiNhac = _context.LoiNhacs
                .Where(ln => ln.MaTk == currentMaTk)
                .Select(ln => new ThongBaoViewModel
                {
                    Id = ln.Id.ToString(),
                    TieuDe = ln.TieuDe,
                    NoiDung = ln.NoiDung,
                    HanChot = ln.HanChot,
                    MucDo = ln.MucDo,
                    TrangThai = ln.TrangThai == true
                });

            var queryCanhBao = _context.CanhBaos
                .Select(cb => new ThongBaoViewModel
                {
                    Id = cb.MaCanhBao,
                    TieuDe = cb.TieuDe,
                    NoiDung = cb.NoiDungCb,
                    HanChot = cb.HanChot,
                    MucDo = cb.MucDo,
                    TrangThai = cb.TrangThai == true
                });

            var allData = await queryLoiNhac.Union(queryCanhBao).ToListAsync();

            // Thống kê cho 3 thẻ đầu trang
            ViewBag.TongCongViec = allData.Count;
            ViewBag.DaHoanThanh = allData.Count(x => x.TrangThai);
            ViewBag.ChuaHoanThanh = allData.Count(x => !x.TrangThai);

            // Phân tab lời nhắc thành Lời nhắc và Quá hạn
            DateTime bayGio = DateTime.Now;
            var dsBinhThuong = allData.Where(x => x.TrangThai || (x.HanChot >= bayGio)).OrderBy(x => x.TrangThai).ThenBy(x => x.HanChot).ToList();
            var dsQuaHan = allData.Where(x => !x.TrangThai && x.HanChot < bayGio).OrderByDescending(x => x.HanChot).ToList();

            ViewBag.TabActive = loai;
            ViewBag.CountBinhThuong = dsBinhThuong.Count;
            ViewBag.CountQuaHan = dsQuaHan.Count;

            if (loai == "quahan") return View(dsQuaHan);
            return View(dsBinhThuong);
        }


        // 2Hàm thêm lời nhắc mới
        [HttpPost]
        public async Task<IActionResult> ThemLoiNhac(string TieuDe, string NoiDung, DateTime HanChot, string MucDo)
        {
            try
            {
                string maTkHienTai = HttpContext.Session.GetString("MaTK");

                var lnMoi = new LoiNhac
                {
                    MaTk = maTkHienTai,
                    TieuDe = TieuDe,
                    NoiDung = NoiDung,
                    HanChot = HanChot,
                    MucDo = MucDo,
                    TrangThai = false
                };

                _context.LoiNhacs.Add(lnMoi);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Thêm lời nhắc thành công!";
            }
            catch (Exception ex)
            {
                // Hiện lỗi 
                var innerError = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                TempData["ErrorMessage"] = "Lỗi hệ thống: " + innerError;
            }
            return RedirectToAction("LoiNhacGV");
        }


        // Hàm đánh dấu đã xong cho lời nhắc
        [HttpPost]
        public async Task<IActionResult> DanhDauXong(string id)
        {
            LayThongTinProfile();
            if (id.StartsWith("CB"))
            {
                var cb = await _context.CanhBaos.FindAsync(id);
                if (cb != null) cb.TrangThai = true;
            }
            else
            {
                var ln = await _context.LoiNhacs.FindAsync(int.Parse(id));
                if (ln != null) ln.TrangThai = true;
            }
            await _context.SaveChangesAsync();
            return RedirectToAction("LoiNhacGV");
        }

        // Hàm xóa lời nhắc
        [HttpPost]
        public async Task<IActionResult> XoaLoiNhac(string id)
        {
            LayThongTinProfile();

            if (string.IsNullOrEmpty(id)) return RedirectToAction("LoiNhacGV");

            try
            {
                // Kiểm tra xem đây là Cảnh báo hệ thống (bắt đầu bằng CB) hay Lời nhắc cá nhân
                if (id.StartsWith("CB"))
                {
                    // Xóa trong bảng CANH_BAO
                    var canhBao = await _context.CanhBaos.FindAsync(id);
                    if (canhBao != null)
                    {
                        _context.CanhBaos.Remove(canhBao);
                        TempData["SuccessMessage"] = "Đã xóa cảnh báo hệ thống.";
                    }
                }
                else
                {
                    // Xóa trong bảng LOI_NHAC 
                    if (int.TryParse(id, out int idInt))
                    {
                        var loiNhac = await _context.LoiNhacs.FindAsync(idInt);
                        if (loiNhac != null)
                        {
                            _context.LoiNhacs.Remove(loiNhac);
                            TempData["SuccessMessage"] = "Đã xóa lời nhắc.";
                        }
                    }
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi khi xóa: " + ex.Message;
            }

            return RedirectToAction("LoiNhacGV");
        }

        // Cảnh báo tự động của hệ thống
        private void TaoLoiNhacTuDong(string maLop, string maTk)
        {
            var dsHocVien = _context.HocViens.Where(h => h.MaLop == maLop).ToList();

            foreach (var hv in dsHocVien)
            {
                var lichSu = _context.KqHocTaps
                    .Include(k => k.MaBuoiHocNavigation)
                    .Where(k => k.MaHocVien == hv.MaHocVien)
                    .OrderByDescending(k => k.MaBuoiHocNavigation.NgayHoc)
                    .Take(3).ToList();

                if (lichSu.Count < 2) continue;

                void LuuCanhBaoHeThong(string tieuDe, string noiDung, string mucDo)
                {
                    string maKQHT = lichSu.First().MaKqht;

                    // Kiểm tra trùng lặp dựa trên MaKQHT và nội dung
                    bool daCo = _context.CanhBaos.Any(c => c.MaKqht == maKQHT && c.NoiDungCb == noiDung && c.TrangThai != true);

                    if (!daCo)
                    {
                        var cbMoi = new CanhBao
                        {
                            MaCanhBao = "CB" + Guid.NewGuid().ToString().Substring(0, 6).ToUpper(),
                            MaKqht = maKQHT,
                            TieuDe = tieuDe,       
                            NoiDungCb = noiDung,   
                            HanChot = DateTime.Now.AddDays(2), 
                            MucDo = mucDo,         
                            TrangThai = false
                        };
                        _context.CanhBaos.Add(cbMoi);
                    }
                }

                // 1. Nghỉ học 2 buổi
                if (lichSu.Take(2).All(k => k.DiemDanh?.Trim() == "Vắng"))
                    LuuCanhBaoHeThong("CẢNH BÁO NGHỈ HỌC", $"Học sinh {hv.TenHocVien} ({hv.MaHocVien}) nghỉ học 2 buổi liên tiếp.", "Quan trọng");

                // 2. Thiếu bài tập 2 buổi
                if (lichSu.Take(2).All(k => k.Btvn?.Trim().Equals("Không", StringComparison.OrdinalIgnoreCase) == true))
                    LuuCanhBaoHeThong("CẢNH BÁO BÀI TẬP", $"Học sinh {hv.TenHocVien} ({hv.MaHocVien}) thiếu BTVN 2 buổi liên tiếp.", "Bình thường");

                // 3. Điểm kém 2 buổi
                if (lichSu.Take(2).All(k => k.DiemSo < 5))
                    LuuCanhBaoHeThong("CẢNH BÁO ĐIỂM KÉM", $"Học sinh {hv.TenHocVien} ({hv.MaHocVien}) có điểm < 5 trong 2 buổi liên tiếp.", "Quan trọng");

                // 4. Đi muộn 3 buổi
                if (lichSu.Count >= 3 && lichSu.All(k => k.DiemDanh?.Trim().Equals("Muộn", StringComparison.OrdinalIgnoreCase) == true))
                    LuuCanhBaoHeThong("NHẮC NHỞ ĐI MUỘN", $"Học sinh {hv.TenHocVien} ({hv.MaHocVien}) đi học muộn 3 buổi liên tiếp.", "Bình thường");
            }
            _context.SaveChanges();
        }
    }
}




