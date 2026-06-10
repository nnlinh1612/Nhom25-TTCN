using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class KhachHang
{
    public string MaKhachHang { get; set; } = null!;

    public string? MaHocVien { get; set; }

    public string TenKhachHang { get; set; } = null!;

    public int KhoiLop { get; set; }

    public string Sdt { get; set; } = null!;

    public string NguonDen { get; set; } = null!;

    public string TrangThai { get; set; } = null!;

    public DateOnly? NgayTiepNhan { get; set; }

    public DateOnly? NgayDangKy { get; set; }

    public virtual ICollection<LichSuTuongTac> LichSuTuongTacs { get; set; } = new List<LichSuTuongTac>();

    public virtual HocVien? MaHocVienNavigation { get; set; }
}
