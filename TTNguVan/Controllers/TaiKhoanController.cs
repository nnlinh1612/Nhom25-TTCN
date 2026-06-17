using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Net;
using System.Net.Mail;
using TTNguVan.Models;
using Microsoft.Data.SqlClient;


namespace TTNguVan.Controllers
{
    public class TaiKhoanController : Controller
    {
        private readonly TrungTamNguVanContext _context;

        public TaiKhoanController(TrungTamNguVanContext context)
        {
            _context = context;
        }

        // Hàm để mở trang Đăng Ký
        [HttpGet]
        public IActionResult DangKy()
        {
            ViewBag.MaChucVu = new SelectList(_context.ChucVus, "MaChucVu", "TenChucVu");
            return View();
        }

        // Khi nhấn nút đăng ký
        [HttpPost]
        public IActionResult DangKy(TaiKhoan user)
        {
            // Kiểm tra xem Email đã có người dùng chưa
            var checkEmail = _context.TaiKhoans.FirstOrDefault(u => u.Email == user.Email);
            if (checkEmail != null)
            {
                ViewBag.Loi = "Email này đã có người sử dụng. Vui lòng sử dụng Email khác!";
                ViewBag.MaChucVu = new SelectList(_context.ChucVus, "MaChucVu", "TenChucVu");
                return View(user);
            }

            // Tạo MaTK tự động
            int soLuong = _context.TaiKhoans.Count();
            int soMoi = soLuong + 1;

            string maTuDong = "";
            if (soMoi < 10) maTuDong = "TK00" + soMoi;
            else if (soMoi < 100) maTuDong = "TK0" + soMoi;
            else maTuDong = "TK" + soMoi;

            user.MaTk = maTuDong;
            user.TrangThai = "Chờ duyệt";

            // Kiểm tra xem người dùng có nhập mật khẩu không
            if (!string.IsNullOrEmpty(user.MatKhau))
            {
                // Ghi đè mật khẩu chữ thường bằng mã hóa 
                user.MatKhau = BCrypt.Net.BCrypt.HashPassword(user.MatKhau);
            }

            _context.TaiKhoans.Add(user);
            _context.SaveChanges();

            TempData["ThongBao"] = "Đăng ký thành công! Vui lòng chờ Admin duyệt.";
            return RedirectToAction("DangKy");
        }

        [HttpGet]
        public IActionResult DangNhap()
        {
            return View();
        }

        // Khi bấm nút Đăng Nhập
        [HttpPost]
        public IActionResult DangNhap(string Email, string MatKhau)
        {
            // Kiểm tra người dùng
            var user = _context.TaiKhoans.FirstOrDefault(u => u.Email == Email); if (user == null)
                if (user == null || !BCrypt.Net.BCrypt.Verify(MatKhau, user.MatKhau))
                {
                    ViewBag.Loi = "Sai email hoặc mật khẩu. Vui lòng thử lại!";
                    return View();
                }

            if (user.TrangThai != "Đã duyệt")
            {
                if (user.TrangThai == "Chờ duyệt")
                    ViewBag.Loi = "Tài khoản của bạn đang chờ Admin phê duyệt!";
                else
                    ViewBag.Loi = "Trạng thái tài khoản không hợp lệ!";

                return View();
            }

            // Vượt qua hết lỗi => Đăng nhập thành công 
            HttpContext.Session.SetString("MaTK", user.MaTk);
            HttpContext.Session.SetString("Role", user.MaChucVu ?? "");
            HttpContext.Session.SetString("HoTen", user.HoTen ?? "");
            HttpContext.Session.SetString("Email", user.Email ?? "");

            switch (user.MaChucVu)
            {
                // Admin => Vào AdminController, trang Dashboard
                case "CV001":
                    return RedirectToAction("QuanLyNguoiDung", "Admin");

                // Nhóm Sale & CSKH => Vào SaleController, trang QuanLyKhachHang
                case "CV002":
                case "CV003":
                    return RedirectToAction("QuanLyKhachHang", "Sale");

                // Nhóm Giáo viên & Trợ giảng => Vào GiaoVienController, trang Dashboard
                case "CV004": 
                case "CV005": 
                    return RedirectToAction("LichDay", "GiaoVien");

                // Quản lý => Vào QuanLyController, trang Dashboard
                case "CV006":
                    return RedirectToAction("Dashboard", "QuanLy");

                default:
                    ViewBag.Loi = "Tài khoản của bạn chưa được phân quyền!";
                    return View();
            }
        }

        // Hàm đăng xuất
        public IActionResult DangXuat()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("DangNhap", "TaiKhoan");
        }

        // Hàm quên mật khẩu
        [HttpGet]
        public IActionResult QuenMatKhau() => View();

        [HttpPost]
        public async Task<IActionResult> QuenMatKhau(string email)
        {
            var user = await _context.TaiKhoans.FirstOrDefaultAsync(u => u.Email == email);
            if (user == null)
            {
                ViewBag.Loi = "Email này không tồn tại!";
                return View();
            }

            string maXacNhan = new Random().Next(100000, 999999).ToString();
            HttpContext.Session.SetString("ResetEmail", email);
            HttpContext.Session.SetString("ResetCode", maXacNhan);
            HttpContext.Session.SetString("ResetExpiry", DateTime.Now.AddMinutes(10).ToString());

            GuiEmail(email, "Mã xác nhận đổi mật khẩu", $"Mã của bạn là: {maXacNhan}");

            return RedirectToAction("XacNhanVaDatLai");
        }

        // Nhập mã và Mật khẩu mới
        [HttpGet]
        public IActionResult XacNhanVaDatLai() => View();

        [HttpPost]
        public async Task<IActionResult> XacNhanVaDatLai(string maNhap, string matKhauMoi)
        {
            string maGoc = HttpContext.Session.GetString("ResetCode");
            string email = HttpContext.Session.GetString("ResetEmail");
            string expiryStr = HttpContext.Session.GetString("ResetExpiry");

            if (string.IsNullOrEmpty(maGoc) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(expiryStr))
            {
                ViewBag.Loi = "Không tìm thấy yêu cầu đổi mật khẩu hoặc yêu cầu đã hết hạn!";
                return View();
            }

            // Kiểm tra thời gian 10 phút
            DateTime expiryTime = DateTime.Parse(expiryStr);
            if (DateTime.Now > expiryTime)
            {
                // Quá hạn => Xóa luôn session để chặn nhập lại
                HttpContext.Session.Remove("ResetCode");
                HttpContext.Session.Remove("ResetEmail");
                HttpContext.Session.Remove("ResetExpiry");

                ViewBag.Loi = "Mã xác nhận đã hết hạn (quá 10 phút)! Vui lòng yêu cầu mã mới.";
                return View();
            }

            // Nếu mã đúng, tìm user và đổi mật khẩu luôn
            var user = await _context.TaiKhoans.FirstOrDefaultAsync(u => u.Email == email);
            if (user != null)
            {
                user.MatKhau = BCrypt.Net.BCrypt.HashPassword(matKhauMoi);
                await _context.SaveChangesAsync();

                HttpContext.Session.Remove("ResetCode");
                HttpContext.Session.Remove("ResetEmail");
                HttpContext.Session.Remove("ResetExpiry");

                TempData["ThongBao"] = "Đổi mật khẩu thành công!";
                return RedirectToAction("DangNhap");
            }

            return RedirectToAction("QuenMatKhau");
        }
        private void GuiEmail(string toEmail, string subject, string body)
        {
            try
            {
                var fromAddress = new MailAddress("nnlinh1612@gmail.com", "Ngữ Văn Minh Anh");
                var toAddress = new MailAddress(toEmail);
                const string fromPassword = "xojtpzqkqlbwptij";

                var smtp = new SmtpClient
                {
                    Host = "smtp.gmail.com",
                    Port = 587,
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
                };
                using (var message = new MailMessage(fromAddress, toAddress)
                {
                    Subject = subject,
                    Body = body
                })
                {
                    smtp.Send(message);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi gửi mail: " + ex.Message);
            }
        }
    }

}