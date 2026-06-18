using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TTNguVan.Models;

namespace TTNguVan.Controllers
{
    [Route("DangKyTuVan")]
    public class DangKyTuVanController : Controller
    {
        private readonly TrungTamNguVanContext _context;

        public DangKyTuVanController(TrungTamNguVanContext context)
        {
            _context = context;
        }

        // Gộp dữ liệu đăng ký vào một model
        [HttpGet("")]
        public IActionResult Index()
        {
            return View("DangKyTuVan", new DangKyTuVanViewModel());
        }

        // Kiểm tra các trường nhập liệu
        [HttpPost("")]
        public async Task<IActionResult> Index(DangKyTuVanViewModel model)
        {
            if (string.IsNullOrWhiteSpace(model.HoTen))
            {
                ModelState.AddModelError("HoTen", "Vui lòng nhập họ tên.");
            }

            if (string.IsNullOrWhiteSpace(model.SoDienThoai))
            {
                ModelState.AddModelError("SoDienThoai", "Vui lòng nhập số điện thoại.");
            }
            else if (model.SoDienThoai.Trim().Length > 10)
            {
                ModelState.AddModelError("SoDienThoai", "Số điện thoại tối đa 10 số.");
            }

            if (model.KhoiLop <= 0)
            {
                ModelState.AddModelError("KhoiLop", "Vui lòng chọn khối lớp.");
            }

            if (!ModelState.IsValid)
            {
                return View("DangKyTuVan", model);
            }

            if (string.IsNullOrWhiteSpace(model.NguonDen))
            {
                ModelState.AddModelError("NguonDen", "Vui lòng chọn nguồn tiếp nhận.");
            }

            string sdt = model.SoDienThoai.Trim();
            string hoTen = model.HoTen.Trim();

            var khachHangTonTai = await _context.KhachHangs
                .FirstOrDefaultAsync(x => x.Sdt == sdt && x.TenKhachHang.ToLower() == hoTen.ToLower());

            if (khachHangTonTai != null)
            {
                return RedirectToAction("ThanhCong");
            }

            // Khách hàng mới, trạng thái mặc định là quan tâm
            // Tự động cộng mã khách hàng
            var khachHang = new KhachHang
            {
                MaKhachHang = await TaoMaKhachHangMoi(),
                MaHocVien = null,
                TenKhachHang = model.HoTen.Trim(),
                KhoiLop = model.KhoiLop,
                Sdt = sdt,
                NguonDen = model.NguonDen,
                TrangThai = "Quan tâm",
                NgayTiepNhan = DateOnly.FromDateTime(DateTime.Now),
                NgayDangKy = null
            };

            _context.KhachHangs.Add(khachHang);
            await _context.SaveChangesAsync();

            await TaoLoiNhacChoSale(khachHang);
            return RedirectToAction("ThanhCong");
        }

        [HttpGet("ThanhCong")]
        public IActionResult ThanhCong()
        {
            return View("DangKyThanhCong");
        }

        private async Task<string> TaoMaKhachHangMoi()
        {
            var lastKH = await _context.KhachHangs
                .Where(x => x.MaKhachHang.StartsWith("KH"))
                .OrderByDescending(x => x.MaKhachHang)
                .FirstOrDefaultAsync();

            string newMaKH = "KH001";

            if (lastKH != null && !string.IsNullOrWhiteSpace(lastKH.MaKhachHang))
            {
                string numberPart = lastKH.MaKhachHang.Substring(2);

                if (int.TryParse(numberPart, out int number))
                {
                    newMaKH = "KH" + (number + 1).ToString("D3");
                }
            }

            while (await _context.KhachHangs.AnyAsync(x => x.MaKhachHang == newMaKH))
            {
                int number = int.Parse(newMaKH.Substring(2));
                newMaKH = "KH" + (number + 1).ToString("D3");
            }

            return newMaKH;
        }

        // Sau khi có người đăng kí, hệ thống sẽ gửi thông báo đến sale
        private async Task TaoLoiNhacChoSale(KhachHang khachHang)
        {
            var dsNhanVienSale = await _context.TaiKhoans
                .Include(t => t.MaChucVuNavigation)
                .Where(t =>
                    t.MaChucVuNavigation != null &&
                    (
                        t.MaChucVuNavigation.TenChucVu.Contains("Sale") ||
                        t.MaChucVuNavigation.TenChucVu.Contains("CSKH")
                    )
                )
                .ToListAsync();

            foreach (var nv in dsNhanVienSale)
            {
                string noiDung =
                    $"Có học sinh/phụ huynh mới điền form đăng ký: " +
                    $"{khachHang.TenKhachHang} - SĐT: {khachHang.Sdt} - Lớp {khachHang.KhoiLop}. " +
                    $"Hãy tư vấn ngay.";

                bool daCoNhac = await _context.LoiNhacs.AnyAsync(l =>
                    l.MaTk == nv.MaTk &&
                    l.NoiDung == noiDung &&
                    l.TrangThai != true
                );

                if (!daCoNhac)
                {
                    var loiNhac = new LoiNhac
                    {
                        MaTk = nv.MaTk,
                        TieuDe = "KHÁCH MỚI TỪ FORM ĐĂNG KÝ",
                        NoiDung = noiDung,
                        HanChot = DateTime.Now.AddHours(2),
                        MucDo = "Quan trọng",
                        TrangThai = false
                    };

                    _context.LoiNhacs.Add(loiNhac);
                }
            }

            await _context.SaveChangesAsync();
        }
    }

    public class DangKyTuVanViewModel
    {
        public string HoTen { get; set; } = string.Empty;

        public string SoDienThoai { get; set; } = string.Empty;

        public int KhoiLop { get; set; } = 9;

        public string NguonDen { get; set; } = "Website";

        public string? NhuCau { get; set; }
    }
}