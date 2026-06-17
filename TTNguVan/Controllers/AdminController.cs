using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Linq;
using System.Net;
using System.Net.Mail;
using TTNguVan.Models;

namespace TTNguVan.Controllers
{
    public class AdminController : Controller
    {
        private readonly TrungTamNguVanContext _context;

        public AdminController(TrungTamNguVanContext context)
        {
            _context = context;
        }

        public IActionResult QuanLyNguoiDung()
        {
            var maTK = HttpContext.Session.GetString("MaTK");
            var userAdmin = _context.TaiKhoans.FirstOrDefault(t => t.MaTk == maTK);
            if (userAdmin == null || HttpContext.Session.GetString("Role") != "CV001") return RedirectToAction("DangNhap", "TaiKhoan");

            var danhSach = _context.TaiKhoans.ToList();
            ViewBag.ChoDuyet = danhSach.Where(t => t.TrangThai == "Chờ duyệt").ToList();
            ViewBag.DaDuyet = danhSach.Where(t => t.TrangThai == "Đã duyệt" || t.TrangThai == "Đã khóa").ToList();
            ViewBag.TenAdmin = userAdmin.HoTen;
            ViewBag.EmailAdmin = userAdmin.Email;

            return View();
        }

        // Hàm Phê Duyệt
        [HttpPost]
        public IActionResult PheDuyet(string id)
        {
            var user = _context.TaiKhoans.Find(id);
            if (user != null)
            {
                user.TrangThai = "Đã duyệt";
                _context.SaveChanges();

                // Gửi email thông báo
                GuiEmail(user.Email, "Chúc mừng! Tài khoản của bạn đã được duyệt",
                    $"Chào {user.HoTen}, tài khoản của bạn đã được kích hoạt. Bạn có thể đăng nhập ngay bây giờ.");

                TempData["ThongBao"] = "Đã phê duyệt và gửi email thành công!";
            }
            return RedirectToAction("QuanLyNguoiDung");
        }

        // Hàm Từ Chối (Xóa khỏi DB)
        [HttpPost]
        public IActionResult TuChoi(string id)
        {
            var user = _context.TaiKhoans.Find(id);
            if (user != null)
            {
                string emailNhanVien = user.Email;
                string tenNhanVien = user.HoTen;

                _context.TaiKhoans.Remove(user);
                _context.SaveChanges();

                // Gửi email thông báo từ chối
                GuiEmail(emailNhanVien, "Thông báo kết quả đăng ký tài khoản",
                    $"Chào {tenNhanVien}, rất tiếc yêu cầu của bạn đã bị từ chối. Tài khoản đã bị xóa khỏi hệ thống.");

                TempData["ThongBao"] = "Đã từ chối và xóa tài khoản thành công!";
            }
            return RedirectToAction("QuanLyNguoiDung");
        }
        // Lấy thông tin người dùng khi ấn nút Sửa
        [HttpGet]
        public IActionResult LayThongTinNguoiDung(string id)
        {
            var user = _context.TaiKhoans.Find(id);
            if (user == null) return Json(new { success = false });

            return Json(new
            {
                success = true,
                data = new
                {
                    maTk = user.MaTk,
                    hoTen = user.HoTen,
                    maChucVu = user.MaChucVu,
                    trangThai = user.TrangThai 
                }
            });
        }

        // Cập nhật thông tin người dùng (hoặc sửa)
        [HttpPost]
        public IActionResult SuaNguoiDung(string maTk, string hoTen, string maChucVu, string trangThai)
        {
            var user = _context.TaiKhoans.Find(maTk);
            if (user != null)
            {
                user.HoTen = hoTen;
                user.MaChucVu = maChucVu;
                user.TrangThai = trangThai; 
                _context.SaveChanges();
                TempData["ThongBao"] = "Cập nhật nhân sự thành công!";
            }
            return RedirectToAction("QuanLyNguoiDung");
        }

        // Xóa nhân sự đã được duyệt
        [HttpPost]
        public IActionResult XoaNguoiDung(string id)
        {
            var user = _context.TaiKhoans.Find(id);
            if (user != null)
            {
                _context.TaiKhoans.Remove(user);
                _context.SaveChanges();
                TempData["ThongBao"] = "Đã xóa nhân sự khỏi hệ thống!";
            }
            return RedirectToAction("QuanLyNguoiDung");
        }

        // Hàm gửi email
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