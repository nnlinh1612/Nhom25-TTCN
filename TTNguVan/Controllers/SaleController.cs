
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TTNguVan.Models;
using System.Net.Http;
using System.Text.Json;

namespace TTNguVan.Controllers
{
    public class SaleController : Controller
    {
        private readonly TrungTamNguVanContext _context;

        public SaleController(TrungTamNguVanContext context)
        {
            _context = context;
        }
        // Hàm hỗ trợ nạp thông tin Sidebar và dữ liệu dùng chung
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

                ViewBag.SoLoiNhac = countLoiNhac + countCanhBao;
            }
        }

        // TRANG QUẢN LÝ KHÁCH HÀNG
        // 1. HÀM HIỂN THỊ DANH SÁCH & TÌM KIẾM
        public async Task<IActionResult> QuanLyKhachHang(string searchString, string trangThai, string khoiLop)
        {
            LayThongTinProfile();
            string maTK = HttpContext.Session.GetString("MaTK");
            if (!string.IsNullOrEmpty(maTK))
            {
                var user = await _context.TaiKhoans.FirstOrDefaultAsync(u => u.MaTk == maTK);
                if (user != null)
                {
                    ViewBag.TenSale = user.HoTen;
                    ViewBag.EmailSale = user.Email;
                }
            }
            else
            {
                return RedirectToAction("DangNhap", "TaiKhoan");
            }

            var query = _context.KhachHangs.AsQueryable();

            if (!string.IsNullOrEmpty(searchString))
            {
                query = query.Where(k => k.TenKhachHang.Contains(searchString) ||
                                         k.Sdt.Contains(searchString) ||
                                         k.MaKhachHang.Contains(searchString));
            }

            if (!string.IsNullOrEmpty(trangThai))
            {
                query = query.Where(k => k.TrangThai == trangThai);
            }

            if (int.TryParse(khoiLop, out int lopInt))
            {
                query = query.Where(k => k.KhoiLop == lopInt);
            }

            var danhSachLop = await query.ToListAsync();

            ViewBag.CurrentSearch = searchString;
            ViewBag.CurrentStatus = trangThai;
            ViewBag.CurrentClass = khoiLop;

            TuDongNhacSaleKhachHang();

            return View(danhSachLop);
        }
        // 2. HÀM THÊM MỚI KHÁCH HÀNG 
        // 2. HÀM THÊM MỚI KHÁCH HÀNG 
        [HttpPost]
        // Chú ý: Đã xóa biến MaKhachHang ở tham số đầu vào
        public async Task<IActionResult> Create(string TenKhachHang, string SDT, string NguonDen, int KhoiLop, string TrangThai, DateTime? NgayTiepNhan, DateTime? NgayDangKy)
        {
            LayThongTinProfile();
            try
            {
                // LOGIC 1: TỰ ĐỘNG SINH MÃ VÀ CHỐNG TRÙNG BẰNG VÒNG LẶP (WHILE)
                var lastKh = await _context.KhachHangs
                    .OrderByDescending(k => k.MaKhachHang)
                    .FirstOrDefaultAsync();

                string newMaKh = "KH001";
                if (lastKh != null && !string.IsNullOrEmpty(lastKh.MaKhachHang))
                {
                    // Cắt lấy phần số sau chữ "KH" và cộng 1
                    if (int.TryParse(lastKh.MaKhachHang.Substring(2), out int num))
                    {
                        newMaKh = "KH" + (num + 1).ToString("D3");
                    }
                }

                // ĐÂY LÀ CHỐT CHẶN RACE CONDITION:
                // Cứ lặp liên tục để kiểm tra. Nếu mã KH011 bị thằng khác nhanh tay cướp mất rồi, 
                // nó sẽ tự động nhảy lên kiểm tra KH012, KH013... cho đến khi tìm được lỗ hổng thì thôi.
                while (await _context.KhachHangs.AnyAsync(k => k.MaKhachHang == newMaKh))
                {
                    int num = int.Parse(newMaKh.Substring(2));
                    newMaKh = "KH" + (num + 1).ToString("D3");
                }

                // LOGIC 2: LƯU KHÁCH HÀNG MỚI
                var khMoi = new KhachHang
                {
                    MaKhachHang = newMaKh, // Dùng cái mã hệ thống vừa sinh ra
                    TenKhachHang = TenKhachHang,
                    Sdt = SDT,
                    NguonDen = NguonDen,
                    KhoiLop = KhoiLop,
                    TrangThai = TrangThai,
                    NgayTiepNhan = NgayTiepNhan.HasValue ? DateOnly.FromDateTime(NgayTiepNhan.Value) : DateOnly.FromDateTime(DateTime.Now),
                    NgayDangKy = (TrangThai == "Đã đăng ký" && NgayDangKy.HasValue) ? DateOnly.FromDateTime(NgayDangKy.Value) : null
                };

                // LOGIC 3: NẾU TRẠNG THÁI LÀ "ĐÃ ĐĂNG KÝ", SINH LUÔN MÃ HỌC VIÊN
                if (TrangThai == "Đã đăng ký")
                {
                    var lastStudent = await _context.HocViens
                        .Where(h => h.MaHocVien.StartsWith("HV"))
                        .OrderByDescending(h => h.MaHocVien)
                        .FirstOrDefaultAsync();

                    string newMaHv = "HV001";
                    if (lastStudent != null)
                    {
                        if (int.TryParse(lastStudent.MaHocVien.Substring(2), out int number))
                        {
                            newMaHv = "HV" + (number + 1).ToString("D3");
                        }
                    }

                    // Chốt chặn Race Condition cho bảng Học Viên
                    while (await _context.HocViens.AnyAsync(h => h.MaHocVien == newMaHv))
                    {
                        int number = int.Parse(newMaHv.Substring(2));
                        newMaHv = "HV" + (number + 1).ToString("D3");
                    }

                    // Liên kết khóa ngoại
                    khMoi.MaHocVien = newMaHv;

                    var hocVienMoi = new HocVien
                    {
                        MaHocVien = newMaHv,
                        TenHocVien = khMoi.TenKhachHang,
                        Sdt = khMoi.Sdt,
                        KhoiLop = khMoi.KhoiLop,
                        TrangThai = "Chờ xếp lớp",
                        MaLop = null
                    };
                    _context.HocViens.Add(hocVienMoi);
                }

                // Lưu vào DB
                _context.KhachHangs.Add(khMoi);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = $"Thêm thành công! Mã khách hàng: {newMaKh}";
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi khi thêm: " + (ex.InnerException != null ? ex.InnerException.Message : ex.Message);
            }

            return RedirectToAction("QuanLyKhachHang");
        }

        [HttpGet]
        public async Task<IActionResult> CheckMaKhachHang(string maKhachHang)
        {
            if (string.IsNullOrEmpty(maKhachHang))
            {
                return Json(new { exists = false });
            }

            // Kiểm tra xem mã này đã có trong bảng KhachHangs chưa
            bool exists = await _context.KhachHangs.AnyAsync(k => k.MaKhachHang == maKhachHang);

            // Trả kết quả về cho giao diện (dạng JSON)
            return Json(new { exists = exists });
        }

        // 3. HÀM CẬP NHẬT CHỈNH SỬA KHÁCH HÀNG 
        // 3. HÀM CẬP NHẬT CHỈNH SỬA KHÁCH HÀNG 
        [HttpPost]
        public async Task<IActionResult> UpdateKhachHang(string MaKhachHang, string TenKhachHang, string Sdt, string NguonDen, int KhoiLop, string TrangThai, DateTime? NgayTiepNhan, DateTime? NgayDangKy)
        {
            LayThongTinProfile();
            try
            {
                var khachHangCu = await _context.KhachHangs.FindAsync(MaKhachHang);
                if (khachHangCu == null)
                {
                    TempData["ErrorMessage"] = "Không tìm thấy khách hàng này!";
                    return RedirectToAction("QuanLyKhachHang");
                }

                // 1. Cập nhật thông tin cơ bản cho bảng KHÁCH HÀNG
                khachHangCu.TenKhachHang = TenKhachHang;
                khachHangCu.Sdt = Sdt;
                khachHangCu.NguonDen = NguonDen;
                khachHangCu.KhoiLop = KhoiLop;
                khachHangCu.TrangThai = TrangThai;

                khachHangCu.NgayTiepNhan = NgayTiepNhan.HasValue ? DateOnly.FromDateTime(NgayTiepNhan.Value) : khachHangCu.NgayTiepNhan;
                khachHangCu.NgayDangKy = (TrangThai == "Đã đăng ký" && NgayDangKy.HasValue) ? DateOnly.FromDateTime(NgayDangKy.Value) : null;

                // 2. LOGIC ĐỒNG BỘ SANG BẢNG HỌC VIÊN (NẾU ĐÃ LÀ HỌC VIÊN)
                if (!string.IsNullOrEmpty(khachHangCu.MaHocVien))
                {
                    // Tìm hồ sơ học viên tương ứng
                    var hocVienLienQuan = await _context.HocViens.FindAsync(khachHangCu.MaHocVien);
                    if (hocVienLienQuan != null)
                    {
                        // Đồng bộ đè thông tin mới sang
                        hocVienLienQuan.TenHocVien = TenKhachHang;
                        hocVienLienQuan.Sdt = Sdt;
                        hocVienLienQuan.KhoiLop = KhoiLop;

                        _context.HocViens.Update(hocVienLienQuan);
                    }
                }
                // 3. LOGIC SINH MÃ HỌC VIÊN LẦN ĐẦU (Nếu chốt Sale thành công)
                else if (TrangThai == "Đã đăng ký" && string.IsNullOrEmpty(khachHangCu.MaHocVien))
                {
                    var lastStudent = await _context.HocViens
                        .Where(h => h.MaHocVien.StartsWith("HV"))
                        .OrderByDescending(h => h.MaHocVien)
                        .FirstOrDefaultAsync();

                    if (lastStudent == null)
                    {
                        khachHangCu.MaHocVien = "HV001";
                    }
                    else
                    {
                        string lastId = lastStudent.MaHocVien;
                        if (int.TryParse(lastId.Substring(2), out int number))
                        {
                            khachHangCu.MaHocVien = "HV" + (number + 1).ToString("D3");
                        }
                    }

                    var hocVienMoi = new HocVien
                    {
                        MaHocVien = khachHangCu.MaHocVien,
                        TenHocVien = khachHangCu.TenKhachHang,
                        Sdt = khachHangCu.Sdt,
                        KhoiLop = khachHangCu.KhoiLop,
                        TrangThai = "Chờ xếp lớp",
                        MaLop = null
                    };
                    _context.HocViens.Add(hocVienMoi);

                    if (khachHangCu.NgayDangKy == null) khachHangCu.NgayDangKy = DateOnly.FromDateTime(DateTime.Now);
                }

                _context.KhachHangs.Update(khachHangCu);
                await _context.SaveChangesAsync(); // Lưu 1 phát ăn ngay cả 2 bảng

                TempData["SuccessMessage"] = "Đã cập nhật và đồng bộ dữ liệu thành công!";
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi khi cập nhật: " + (ex.InnerException != null ? ex.InnerException.Message : ex.Message);
            }

            return RedirectToAction("QuanLyKhachHang");
        }

        // 4. HÀM XÓA KHÁCH HÀNG 
        [HttpPost]
        public async Task<IActionResult> Delete(string id)
        {
            LayThongTinProfile();
            if (string.IsNullOrEmpty(id)) return NotFound();
            try
            {
                var khachHang = await _context.KhachHangs.FindAsync(id);
                if (khachHang == null) return RedirectToAction("QuanLyKhachHang");

                // Xóa Học viên và các kết quả học tập liên quan trước
                if (!string.IsNullOrEmpty(khachHang.MaHocVien))
                {
                    var hv = await _context.HocViens.FirstOrDefaultAsync(h => h.MaHocVien == khachHang.MaHocVien);
                    if (hv != null)
                    {
                        var kqht = _context.KqHocTaps.Where(k => k.MaHocVien == hv.MaHocVien);
                        _context.KqHocTaps.RemoveRange(kqht);
                        _context.HocViens.Remove(hv);
                    }
                }

                // Xóa Lịch sử tương tác
                var lstt = _context.LichSuTuongTacs.Where(l => l.MaKhachHang == id);
                _context.LichSuTuongTacs.RemoveRange(lstt);

                _context.KhachHangs.Remove(khachHang);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = $"Đã xóa hồ sơ khách hàng {khachHang.TenKhachHang}!";
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi khi xóa: " + (ex.InnerException?.Message ?? ex.Message);
            }
            return RedirectToAction("QuanLyKhachHang");
        }
        // TRANG CHI TIẾT KHÁCH HÀNG
        // 1. HÀM XEM CHI TIẾT KHÁCH HÀNG
        [HttpGet]
        public async Task<IActionResult> ChiTietKhachHang(string id)
        {
            LayThongTinProfile();
            string maTK = HttpContext.Session.GetString("MaTK");

            if (!string.IsNullOrEmpty(maTK))
            {
                var user = await _context.TaiKhoans.FirstOrDefaultAsync(u => u.MaTk == maTK);
                if (user != null)
                {
                    ViewBag.TenSale = user.HoTen;
                    ViewBag.EmailSale = user.Email;
                }
            }

            if (string.IsNullOrEmpty(id)) return NotFound();

            // --- ĐÃ THÊM LẠI DÒNG NÀY: Truy vấn thông tin Khách hàng ---
            var khachHang = await _context.KhachHangs.FirstOrDefaultAsync(k => k.MaKhachHang == id);
            if (khachHang == null) return NotFound();

            // LẤY LỊCH SỬ TƯ VẤN (Chỉ lấy các nghiệp vụ của Sale)
            var cacLoaiTuVan = new List<string> { "Tư vấn qua điện thoại", "Gặp trực tiếp", "Nhắn tin (Zalo/Mess)", "Nhắn tin" };

            var lichSuList = await _context.LichSuTuongTacs
                                           .Where(l => l.MaKhachHang == id && cacLoaiTuVan.Contains(l.LoaiTuongTac))
                                           .OrderByDescending(l => l.NgayTuongTac)
                                           .ToListAsync();

            ViewBag.LichSuTuongTac = lichSuList;

            // Truyền thông tin khách hàng sang View
            return View(khachHang);
        }

        // --- 1. HÀM THÊM LỊCH SỬ TƯ VẤN (KHÁCH HÀNG) ---
        [HttpPost]
        public async Task<IActionResult> ThemLichSu(string MaKhachHang, string LoaiTuongTac, DateTime NgayTuongTac, string NoiDung)
        {
            try
            {
                string maTK = HttpContext.Session.GetString("MaTK") ?? "TK001";

                // Tìm mã học viên của khách hàng này (nếu đã chốt thành công)
                var kh = await _context.KhachHangs.FirstOrDefaultAsync(k => k.MaKhachHang == MaKhachHang);
                string maHocVienCheck = kh?.MaHocVien;

                // LOGIC TỰ ĐỘNG TĂNG MÃ (TT001, TT002...)
                var lastLS = await _context.LichSuTuongTacs
                    .OrderByDescending(x => x.MaTuongTac)
                    .FirstOrDefaultAsync();

                string newMaTT = "TT001";
                if (lastLS != null && !string.IsNullOrEmpty(lastLS.MaTuongTac))
                {
                    string numberPart = lastLS.MaTuongTac.Substring(2); // Cắt lấy phần số sau chữ "TT"
                    if (int.TryParse(numberPart, out int num))
                    {
                        newMaTT = "TT" + (num + 1).ToString("D3"); // D3 để format thành 3 số (001, 002...)
                    }
                }

                var lichSuMoi = new LichSuTuongTac
                {
                    MaTuongTac = newMaTT,
                    MaKhachHang = MaKhachHang,
                    MaHocVien = maHocVienCheck,
                    MaTk = maTK,
                    LoaiTuongTac = LoaiTuongTac,
                    NoiDung = NoiDung,
                    NgayTuongTac = DateOnly.FromDateTime(NgayTuongTac)
                };

                _context.LichSuTuongTacs.Add(lichSuMoi);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Đã thêm lịch sử tư vấn!";
                return RedirectToAction("ChiTietKhachHang", new { id = MaKhachHang });
            }
            catch (Exception)
            {
                TempData["ErrorMessage"] = "Có lỗi xảy ra khi thêm!";
                return RedirectToAction("ChiTietKhachHang", new { id = MaKhachHang });
            }
        }

        // --- 2. HÀM CẬP NHẬT LỊCH SỬ TƯ VẤN (KHÁCH HÀNG) ---
        [HttpPost]
        public async Task<IActionResult> UpdateLichSu(string MaTuongTac, string MaKhachHang, DateTime NgayTuongTac, string LoaiTuongTac, string NoiDung)
        {
            var lichSu = await _context.LichSuTuongTacs.FindAsync(MaTuongTac);
            if (lichSu != null)
            {
                var kh = await _context.KhachHangs.FirstOrDefaultAsync(k => k.MaKhachHang == MaKhachHang);

                lichSu.NgayTuongTac = DateOnly.FromDateTime(NgayTuongTac);
                lichSu.LoaiTuongTac = LoaiTuongTac;
                lichSu.NoiDung = NoiDung;
                lichSu.MaHocVien = kh?.MaHocVien; // Cập nhật luôn mã học viên nếu có

                _context.LichSuTuongTacs.Update(lichSu);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Cập nhật lịch sử thành công!";
            }
            return RedirectToAction("ChiTietKhachHang", new { id = MaKhachHang });
        }

        // --- 3. HÀM XÓA LỊCH SỬ TƯ VẤN (KHÁCH HÀNG) ---
        [HttpPost]
        public async Task<IActionResult> DeleteLichSu(string id, string maKhachHang) // ĐÃ SỬA LỖI: Đổi int id thành string id
        {
            var lichSu = await _context.LichSuTuongTacs.FindAsync(id);
            if (lichSu != null)
            {
                _context.LichSuTuongTacs.Remove(lichSu);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Đã xóa lịch sử tư vấn!";
            }
            return RedirectToAction("ChiTietKhachHang", new { id = maKhachHang });
        }
        // TRANG THEO DÕI HỌC TẬP
        // 1. HÀM THEO DÕI HỌC TẬP
        [HttpGet]
        public async Task<IActionResult> TheoDoiHocTap(string searchString, string trangThai, string khoiLop, string maLop)
        {
            LayThongTinProfile();
            // 1. Kiểm tra đăng nhập
            string maTK = HttpContext.Session.GetString("MaTK");
            if (!string.IsNullOrEmpty(maTK))
            {
                var user = await _context.TaiKhoans.FirstOrDefaultAsync(u => u.MaTk == maTK);
                if (user != null)
                {
                    ViewBag.TenSale = user.HoTen;
                    ViewBag.EmailSale = user.Email;
                }
            }
            else
            {
                return RedirectToAction("DangNhap", "TaiKhoan");
            }

            // 2. Tạo truy vấn cơ bản dưới Database (Chưa lấy dữ liệu về RAM vội)
            var query = _context.HocViens
                                .Include(h => h.MaLopNavigation)
                                .Include(h => h.KqHocTaps).ThenInclude(k => k.MaBuoiHocNavigation)
                                .AsQueryable();

            // 3. Xử lý các bộ lọc (Thực thi trên SQL Server giúp tăng tốc độ)
            if (!string.IsNullOrEmpty(trangThai))
            {
                query = query.Where(h => h.TrangThai == trangThai);
            }

            if (int.TryParse(khoiLop, out int khoiInt))
            {
                query = query.Where(h => h.KhoiLop == khoiInt);
            }

            if (!string.IsNullOrEmpty(maLop))
            {
                query = query.Where(h => h.MaLop == maLop);
            }

            // 4. Lấy dữ liệu đã lọc cơ bản từ Database lên RAM
            var allHocVien = await query.OrderBy(k => k.MaHocVien).ToListAsync();
            var filteredList = allHocVien.AsEnumerable();

            // 5. Lọc tìm kiếm chuỗi văn bản (Thực thi trên RAM do dùng hàm RemoveSign tự viết)
            if (!string.IsNullOrEmpty(searchString))
            {
                // Biến chuỗi tìm kiếm thành không dấu
                string searchNoSign = RemoveSign4VietnameseString(searchString);

                filteredList = filteredList.Where(k =>
                    RemoveSign4VietnameseString(k.TenHocVien).Contains(searchNoSign) || // Tìm tên không dấu
                    k.MaHocVien.ToLower().Contains(searchString.ToLower()) ||          // Tìm mã
                    k.KhoiLop.ToString() == searchString                               // Tìm khối lớp
                );
            }

            // 6. Trả lại các giá trị để giữ trạng thái bộ lọc trên giao diện (ViewBag)
            ViewBag.CurrentSearch = searchString;
            ViewBag.CurrentStatus = trangThai;
            ViewBag.CurrentKhoiLop = khoiLop;
            ViewBag.CurrentMaLop = maLop;

            // Nạp danh sách lớp cho ô SelectBox "Tất cả các lớp"
            ViewBag.DanhSachLop = await _context.LopHocs.ToListAsync();

            return View(filteredList.ToList());
        }

        // 2. HÀM LẤY THÔNG TIN HỌC VIÊN POPUP
        [HttpGet]
        public async Task<IActionResult> LayThongTinHocVien(string maHocVien)
        {
            LayThongTinProfile();
            var hocVien = await _context.HocViens.FirstOrDefaultAsync(h => h.MaHocVien == maHocVien);
            if (hocVien == null) return Json(new { success = false, message = "Không tìm thấy học viên" });

            return Json(new
            {
                success = true,
                data = new
                {
                    tenHocVien = hocVien.TenHocVien,
                    ngaySinh = hocVien.NgaySinh == DateOnly.MinValue ? "Chưa cập nhật" : hocVien.NgaySinh.ToString("dd/MM/yyyy"),
                    sdt = hocVien.Sdt,
                    khoiLop = hocVien.KhoiLop,
                    maLop = string.IsNullOrEmpty(hocVien.MaLop) ? "Chưa xếp" : hocVien.MaLop,
                    trangThai = hocVien.TrangThai
                }
            });
        }

        // 3. HÀM CẬP NHẬT TRẠNG THÁI VÀ MÃ LỚP 
        [HttpPost]
        public async Task<IActionResult> CapNhatHocTapSale(string maHocVien, string trangThaiHocVien, string maLopMoi)
        {
            LayThongTinProfile();
            try
            {
                var hocVien = await _context.HocViens.FirstOrDefaultAsync(h => h.MaHocVien == maHocVien);
                if (hocVien != null)
                {
                    hocVien.TrangThai = trangThaiHocVien;
                    if (!string.IsNullOrEmpty(maLopMoi))
                    {
                        hocVien.MaLop = maLopMoi;
                    }
                    _context.HocViens.Update(hocVien);
                    await _context.SaveChangesAsync();
                    TempData["SuccessMessage"] = "Đã cập nhật thông tin học tập thành công!";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi khi cập nhật!";
            }

            return RedirectToAction("TheoDoiHocTap");
        }

        // 4. HÀM XÓA HỌC VIÊN KHỎI TRANG THEO DÕI
        [HttpPost]
        public async Task<IActionResult> XoaHocTapSale(string maHocVien)
        {
            LayThongTinProfile();
            try
            {
                var hocVien = await _context.HocViens.FindAsync(maHocVien);
                if (hocVien != null)
                {
                    // 1. Xóa kết quả học tập liên quan (để không bị lỗi khóa ngoại)
                    var kqht = _context.KqHocTaps.Where(k => k.MaHocVien == maHocVien);
                    _context.KqHocTaps.RemoveRange(kqht);

                    // 2. Trả khách hàng về trạng thái trước đó (Tùy chọn)
                    var khachHang = await _context.KhachHangs.FirstOrDefaultAsync(k => k.MaHocVien == maHocVien);
                    if (khachHang != null)
                    {
                        khachHang.TrangThai = "Quan tâm";
                        khachHang.MaHocVien = null;
                        _context.KhachHangs.Update(khachHang);
                    }

                    // 3. Xóa học viên
                    _context.HocViens.Remove(hocVien);
                    await _context.SaveChangesAsync();

                    TempData["SuccessMessage"] = $"Đã xóa {hocVien.TenHocVien} khỏi danh sách theo dõi!";
                }
                else
                {
                    TempData["ErrorMessage"] = "Không tìm thấy học viên để xóa!";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi khi xóa: " + (ex.InnerException?.Message ?? ex.Message);
            }
            return RedirectToAction("TheoDoiHocTap");
        }

        //  TRANG HỒ SƠ HỌC TẬP 
        // 1. HÀM HỒ SƠ HỌC TẬP HỌC VIÊN (GET)
        [HttpGet]
        public async Task<IActionResult> HoSoHocTap(string id)
        {
            LayThongTinProfile();
            string maTK = HttpContext.Session.GetString("MaTK");

            if (!string.IsNullOrEmpty(maTK))
            {
                var user = await _context.TaiKhoans.FirstOrDefaultAsync(u => u.MaTk == maTK);
                if (user != null)
                {
                    ViewBag.TenSale = user.HoTen;
                    ViewBag.EmailSale = user.Email;
                }
            }

            if (string.IsNullOrEmpty(id)) return NotFound();

            // BƯỚC 1: Lấy thông tin học viên (Kèm theo thông tin Lớp)
            var hocVien = await _context.HocViens
                                        .Include(h => h.MaLopNavigation)
                                        .FirstOrDefaultAsync(h => h.MaHocVien == id);

            if (hocVien == null) return NotFound();

            // BƯỚC 2: Lấy danh sách kết quả học tập (Hiển thị ở TAB 1)
            var lichSuHoc = await _context.KqHocTaps
                                       .Include(k => k.MaBuoiHocNavigation)
                                       .Where(k => k.MaHocVien == id)
                                       .OrderByDescending(k => k.MaBuoiHocNavigation.NgayHoc)
                                       .ToListAsync();

            ViewBag.LichSuHocTap = lichSuHoc;

            // BƯỚC 3: LẤY LỊCH SỬ TƯƠNG TÁC (Chỉ lấy các nghiệp vụ chăm sóc học viên)
            var cacLoaiChamSoc = new List<string> { "Gọi điện hỏi thăm", "Phản hồi phụ huynh", "Nhắc nhở học tập", "Nghiệp vụ khác" };

            var lichSuTT = await _context.LichSuTuongTacs
                                         .Where(l => l.MaHocVien == id && cacLoaiChamSoc.Contains(l.LoaiTuongTac))
                                         .OrderByDescending(l => l.NgayTuongTac)
                                         .ToListAsync();

            ViewBag.LichSuTuongTac = lichSuTT;
            return View(hocVien);
        }
        // --- 2. HÀM THÊM NHẬT KÝ CHĂM SÓC (HỌC VIÊN) ---
        [HttpPost]
        public async Task<IActionResult> ThemLichSuTuongTacHV(string MaHocVien, string LoaiTuongTac, DateTime NgayTuongTac, string NoiDung)
        {
            try
            {
                string maTK = HttpContext.Session.GetString("MaTK") ?? "TK001";

                // TÌM NGƯỢC LẠI: Lấy thông tin Khách Hàng dựa vào Mã Học Viên
                var kh = await _context.KhachHangs.FirstOrDefaultAsync(k => k.MaHocVien == MaHocVien);

                // Sinh mã TT001, TT002... tự động
                var lastLS = await _context.LichSuTuongTacs
                    .OrderByDescending(x => x.MaTuongTac)
                    .FirstOrDefaultAsync();

                string newMaTT = "TT001";
                if (lastLS != null && !string.IsNullOrEmpty(lastLS.MaTuongTac))
                {
                    string numberPart = lastLS.MaTuongTac.Substring(2);
                    if (int.TryParse(numberPart, out int num))
                    {
                        newMaTT = "TT" + (num + 1).ToString("D3");
                    }
                }

                var lichSuMoi = new LichSuTuongTac
                {
                    MaTuongTac = newMaTT,
                    MaKhachHang = kh?.MaKhachHang, // Dò ra được mã KH thì lưu vào
                    MaHocVien = MaHocVien,         // Lưu mã Học viên được gửi lên
                    MaTk = maTK,
                    LoaiTuongTac = LoaiTuongTac,
                    NoiDung = NoiDung,
                    NgayTuongTac = DateOnly.FromDateTime(NgayTuongTac)
                };

                _context.LichSuTuongTacs.Add(lichSuMoi);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Đã lưu nhật ký chăm sóc!";
                return Redirect(Request.Headers["Referer"].ToString());
            }
            catch (Exception)
            {
                TempData["ErrorMessage"] = "Có lỗi xảy ra!";
                return Redirect(Request.Headers["Referer"].ToString());
            }
        }

        // 3. HÀM CẬP NHẬT NHẬT KÝ CHĂM SÓC (HỌC VIÊN) ---
        [HttpPost]
        public async Task<IActionResult> UpdateLichSuTuongTacHV(string MaTuongTac, string MaKhachHang, DateTime NgayTuongTac, string LoaiTuongTac, string NoiDung)
        {
            var lichSu = await _context.LichSuTuongTacs.FindAsync(MaTuongTac);
            if (lichSu != null)
            {
                var kh = await _context.KhachHangs.FirstOrDefaultAsync(k => k.MaKhachHang == MaKhachHang);

                lichSu.NgayTuongTac = DateOnly.FromDateTime(NgayTuongTac);
                lichSu.LoaiTuongTac = LoaiTuongTac;
                lichSu.NoiDung = NoiDung;
                lichSu.MaHocVien = kh?.MaHocVien;

                _context.LichSuTuongTacs.Update(lichSu);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Đã cập nhật nhật ký!";
            }
            return Redirect(Request.Headers["Referer"].ToString());
        }

        // 4. HÀM XÓA NHẬT KÝ CHĂM SÓC (HỌC VIÊN) ---
        [HttpPost]
        public async Task<IActionResult> DeleteLichSuTuongTacHV(string id)
        {
            var lichSu = await _context.LichSuTuongTacs.FindAsync(id);
            if (lichSu != null)
            {
                _context.LichSuTuongTacs.Remove(lichSu);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Đã xóa nhật ký chăm sóc!";
            }
            return Redirect(Request.Headers["Referer"].ToString());
        }

        // TRANG DANH SÁCH BÀI TEST
        [HttpGet]
        public async Task<IActionResult> DanhSachBaiTest()
        {
            LayThongTinProfile();
            // 1. Lấy danh sách các đề test (để lấy link gửi học viên)
            var deTests = await _context.BaiTests.ToListAsync();

            // 2. Lấy danh sách các bài ĐÃ CHẤM (để Sale xem kết quả)
            var ketQuas = await _context.KqBaiTests
                .Include(k => k.MaBaiLamNavigation)
                    .ThenInclude(b => b.MaHocVienNavigation)
                .Include(k => k.MaTkNavigation) // Giáo viên chấm
                .OrderByDescending(k => k.NgayCham)
                .ToListAsync();

            var viewModel = new SaleBaiTestViewModel
            {
                DanhSachDeTest = deTests,
                DanhSachKetQua = ketQuas
            };

            return View(viewModel);
        }
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
            return View("~/Views/GiaoVien/PhieuKetQuaPdf.cshtml", kq);
        }

        // TRANG BÁO CÁO
        public async Task<IActionResult> BaoCao()
        {
            LayThongTinProfile();

            // 1. Kiểm tra đăng nhập
            string maTK = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(maTK))
            {
                return RedirectToAction("DangNhap", "TaiKhoan", new { area = "" });
            }

            var user = await _context.TaiKhoans.FirstOrDefaultAsync(u => u.MaTk == maTK);
            if (user != null)
            {
                ViewBag.TenSale = user.HoTen;
                ViewBag.EmailSale = user.Email;
            }

            // 2. LẤY DỮ LIỆU SỐNG TỪ CSDL
            var allKhachHang = await _context.KhachHangs.ToListAsync();

            // --- KPI CARDS (Thẻ thông số tổng quát) ---
            int tongKhachHang = allKhachHang.Count;
            // Thống kê dựa trên trạng thái chuẩn
            int hocVienChinhThuc = allKhachHang.Count(x => x.TrangThai == "Đã đăng ký");

            double tyLeChuyenDoi = 0;
            if (tongKhachHang > 0)
            {
                tyLeChuyenDoi = Math.Round((double)hocVienChinhThuc / tongKhachHang * 100, 1);
            }

            ViewBag.TongKhachHang = tongKhachHang;
            ViewBag.HocVienChinhThuc = hocVienChinhThuc;
            ViewBag.TyLeChuyenDoi = tyLeChuyenDoi;
            ViewBag.PhanHoiMoi = 0; // Tạm để 0 vì chưa có bảng thông báo phản hồi

            // --- DỮ LIỆU BIỂU ĐỒ 1: XU HƯỚNG CỘT KÉP (6 tháng gần nhất) ---
            var labelsTrend = new List<string>();
            var totalLeads = new List<int>();      // Cột Tổng tiếp nhận
            var successLeads = new List<int>();    // Cột Đã đăng ký thành công

            for (int i = 5; i >= 0; i--)
            {
                var targetDate = DateTime.Now.AddMonths(-i);
                labelsTrend.Add($"Tháng {targetDate.Month}");

                // Lọc khách dựa trên NgayTiepNhan (Tổng phễu marketing)
                int countTong = allKhachHang.Count(x =>
                    x.NgayTiepNhan.HasValue &&
                    x.NgayTiepNhan.Value.Month == targetDate.Month &&
                    x.NgayTiepNhan.Value.Year == targetDate.Year);
                totalLeads.Add(countTong);

                // Lọc khách dựa trên NgayDangKy (Kết quả chốt Sale)
                int countThanhCong = allKhachHang.Count(x =>
                    x.NgayDangKy.HasValue &&
                    x.NgayDangKy.Value.Month == targetDate.Month &&
                    x.NgayDangKy.Value.Year == targetDate.Year &&
                    x.TrangThai == "Đã đăng ký");
                successLeads.Add(countThanhCong);
            }

            ViewBag.TrendLabels = "['" + string.Join("', '", labelsTrend) + "']";
            ViewBag.TrendDataTotal = "[" + string.Join(", ", totalLeads) + "]";
            ViewBag.TrendDataSuccess = "[" + string.Join(", ", successLeads) + "]";

            // --- DỮ LIỆU BIỂU ĐỒ 2: PHÂN BỐ KHỐI LỚP (Biểu đồ tròn) ---
            var khoiData = new List<int>();
            for (int i = 6; i <= 12; i++)
            {
                khoiData.Add(allKhachHang.Count(x => x.KhoiLop == i));
            }
            ViewBag.KhoiLabels = "['Lớp 6', 'Lớp 7', 'Lớp 8', 'Lớp 9', 'Lớp 10', 'Lớp 11', 'Lớp 12']";
            ViewBag.KhoiData = "[" + string.Join(", ", khoiData) + "]";

            // --- DỮ LIỆU BIỂU ĐỒ 3: NGUỒN TIẾP NHẬN (Biểu đồ tròn) ---
            var nguonGroup = allKhachHang.GroupBy(x => string.IsNullOrEmpty(x.NguonDen) ? "Chưa rõ" : x.NguonDen)
                                         .Select(g => new { Nguon = g.Key, Count = g.Count() })
                                         .ToList();

            ViewBag.NguonLabels = "['" + string.Join("', '", nguonGroup.Select(x => x.Nguon)) + "']";
            ViewBag.NguonData = "[" + string.Join(", ", nguonGroup.Select(x => x.Count)) + "]";

            // --- DỮ LIỆU BIỂU ĐỒ 4: TRẠNG THÁI HỌC VIÊN (Biểu đồ tròn) ---
            // Lấy toàn bộ dữ liệu từ bảng Học Viên
            var allHocVien = await _context.HocViens.ToListAsync();

            // Nhóm theo Trạng thái của học viên
            var trangThaiGroup = allHocVien.GroupBy(x => string.IsNullOrEmpty(x.TrangThai) ? "Chưa phân loại" : x.TrangThai)
                                             .Select(g => new { TT = g.Key, Count = g.Count() })
                                             .ToList();

            // Đẩy dữ liệu sang ViewBag
            ViewBag.TrangThaiLabels = "['" + string.Join("', '", trangThaiGroup.Select(x => x.TT)) + "']";
            ViewBag.TrangThaiData = "[" + string.Join(", ", trangThaiGroup.Select(x => x.Count)) + "]";

            return View();
        }

        // LỜI NHẮC
        // 1. TRANG DANH SÁCH LỜI NHẮC
        [HttpGet]
        public async Task<IActionResult> LoiNhac(string loai = "binhthuong")
        {
            LayThongTinProfile();
            string currentMaTk = HttpContext.Session.GetString("MaTK");
            if (string.IsNullOrEmpty(currentMaTk)) return RedirectToAction("DangNhap", "TaiKhoan");

            // 1. Lấy toàn bộ dữ liệu lời nhắc và cảnh báo
            var queryLoiNhac = _context.LoiNhacs
                .Where(ln => ln.MaTk == currentMaTk)
                .Select(ln => new ThongBaoViewModel
                {
                    Id = ln.Id.ToString(),
                    TieuDe = ln.TieuDe,
                    NoiDung = ln.NoiDung,
                    HanChot = ln.HanChot,
                    MucDo = ln.MucDo,
                    TrangThai = ln.TrangThai == true,
                    IsHeThong = false
                });

            var queryCanhBao = _context.CanhBaos
                .Select(cb => new ThongBaoViewModel
                {
                    Id = cb.MaCanhBao,
                    TieuDe = cb.TieuDe,
                    NoiDung = cb.NoiDungCb,
                    HanChot = cb.HanChot,
                    MucDo = cb.MucDo,
                    TrangThai = cb.TrangThai == true,
                    IsHeThong = true
                });

            var allData = await queryLoiNhac.Union(queryCanhBao).ToListAsync();
            ViewBag.TongCongViec = allData.Count;
            ViewBag.DaHoanThanh = allData.Count(x => x.TrangThai);
            ViewBag.ChuaHoanThanh = allData.Count(x => !x.TrangThai);

            // 2. PHÂN LOẠI DỮ LIỆU THEO THỜI GIAN
            DateTime bayGio = DateTime.Now;

            // Tab Bình thường: Những việc đã xong HOẶC những việc chưa xong nhưng còn hạn
            var dsBinhThuong = allData.Where(x => x.TrangThai || (x.HanChot >= bayGio))
                                      .OrderBy(x => x.TrangThai).ThenBy(x => x.HanChot).ToList();

            // Tab Quá hạn: Những việc CHƯA XONG và ĐÃ HẾT HẠN
            var dsQuaHan = allData.Where(x => !x.TrangThai && x.HanChot < bayGio)
                                  .OrderByDescending(x => x.HanChot).ToList();

            // 3. Đưa thông tin sang View
            ViewBag.TabActive = loai;
            ViewBag.CountBinhThuong = dsBinhThuong.Count;
            ViewBag.CountQuaHan = dsQuaHan.Count;

            // Trả về danh sách tương ứng với Tab người dùng bấm
            if (loai == "quahan") return View(dsQuaHan);
            return View(dsBinhThuong);
        }

        // 2. HÀM THÊM MỚI LỜI NHẮC
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
                // Hiện lỗi thật sự để debug cho nhanh
                var innerError = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                TempData["ErrorMessage"] = "Lỗi hệ thống: " + innerError;
            }
            return RedirectToAction("LoiNhac");
        }

        // 3. HÀM ĐÁNH DẤU ĐÃ XONG
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
            return RedirectToAction("LoiNhac");
        }

        // 4. HÀM XÓA LỜI NHẮC
        [HttpPost]
        public async Task<IActionResult> XoaLoiNhac(string id)
        {
            LayThongTinProfile();

            if (string.IsNullOrEmpty(id)) return RedirectToAction("LoiNhac");

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
                            TempData["SuccessMessage"] = "Đã xóa lời nhắc cá nhân.";
                        }
                    }
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi khi xóa: " + ex.Message;
            }

            return RedirectToAction("LoiNhac");
        }

        private string RemoveSign4VietnameseString(string str)
        {
            LayThongTinProfile();
            if (string.IsNullOrEmpty(str)) return "";
            str = str.Normalize(System.Text.NormalizationForm.FormD);
            var sb = new System.Text.StringBuilder();
            foreach (var c in str)
            {
                var unicodeCategory = System.Globalization.CharUnicodeInfo.GetUnicodeCategory(c);
                if (unicodeCategory != System.Globalization.UnicodeCategory.NonSpacingMark)
                {
                    sb.Append(c);
                }
            }
            return sb.ToString().Normalize(System.Text.NormalizationForm.FormC)
                     .ToLower()
                     .Replace('đ', 'd')
                     .Replace('Đ', 'D');
        }
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
        private void TuDongNhacSaleKhachHang()
        {
            // 1. Giữ nguyên mốc thời gian và danh sách khách hàng quá hạn
            var mocThoiGian = DateOnly.FromDateTime(DateTime.Now.AddDays(-7));
            var dsKhachHang = _context.KhachHangs
                .AsEnumerable()
                .Where(kh => kh.TrangThai != null &&
                             kh.TrangThai.Trim().Equals("Quan tâm", StringComparison.OrdinalIgnoreCase) &&
                             kh.NgayTiepNhan.HasValue &&
                             kh.NgayTiepNhan.Value <= mocThoiGian)
                .ToList();

            if (dsKhachHang.Any())
            {
                // 2. SỬA Ở ĐÂY: Lấy cả nhân viên Sale và CSKH
                var dsNhanVienRemind = _context.TaiKhoans
                    .Include(t => t.MaChucVuNavigation)
                    .Where(t => t.MaChucVuNavigation.TenChucVu.Contains("Sale") ||
                                t.MaChucVuNavigation.TenChucVu.Contains("CSKH"))
                    .ToList();

                foreach (var kh in dsKhachHang)
                {
                    foreach (var nv in dsNhanVienRemind) // Đổi biến thành 'nv' cho tổng quát
                    {
                        string uniqueNoiDung = $"[HỆ THỐNG] Khách hàng {kh.TenKhachHang} ({kh.MaKhachHang}) đã quan tâm 1 tuần. Hãy liên hệ lại ngay!";

                        // Kiểm tra xem nhân viên này (dù là Sale hay CSKH) đã có lời nhắc này chưa
                        bool daCoNhac = _context.LoiNhacs.Any(l =>
                            l.MaTk == nv.MaTk &&
                            l.NoiDung == uniqueNoiDung &&
                            l.TrangThai == false);

                        if (!daCoNhac)
                        {
                            var loiNhacMoi = new LoiNhac
                            {
                                MaTk = nv.MaTk,
                                TieuDe = "CHĂM SÓC KHÁCH HÀNG CŨ",
                                NoiDung = uniqueNoiDung,
                                HanChot = DateTime.Now.AddDays(1),
                                MucDo = "Quan trọng",
                                TrangThai = false
                            };
                            _context.LoiNhacs.Add(loiNhacMoi);
                        }
                    }
                }
                _context.SaveChanges();
            }
        }
    }
}







