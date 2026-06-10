using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class KqHocTap
{
    public string MaKqht { get; set; } = null!;

    public string MaBuoiHoc { get; set; } = null!;

    public string MaHocVien { get; set; } = null!;

    public string DiemDanh { get; set; } = null!;

    public string Btvn { get; set; } = null!;

    public double DiemSo { get; set; }

    public string NhanXet { get; set; } = null!;

    public virtual ICollection<CanhBao> CanhBaos { get; set; } = new List<CanhBao>();

    public virtual BuoiHoc MaBuoiHocNavigation { get; set; } = null!;

    public virtual HocVien MaHocVienNavigation { get; set; } = null!;
}
