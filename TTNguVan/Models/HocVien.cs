using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class HocVien
{
    public string MaHocVien { get; set; } = null!;

    public string? MaLop { get; set; }

    public string TenHocVien { get; set; } = null!;

    public DateOnly NgaySinh { get; set; }

    public string Sdt { get; set; } = null!;

    public int KhoiLop { get; set; }

    public string TrangThai { get; set; } = null!;

    public string? FacebookId { get; set; }

    public virtual ICollection<BaiLam> BaiLams { get; set; } = new List<BaiLam>();

    public virtual ICollection<KhachHang> KhachHangs { get; set; } = new List<KhachHang>();

    public virtual ICollection<KqHocTap> KqHocTaps { get; set; } = new List<KqHocTap>();

    public virtual ICollection<LichSuTuongTac> LichSuTuongTacs { get; set; } = new List<LichSuTuongTac>();

    public virtual LopHoc? MaLopNavigation { get; set; }
}
