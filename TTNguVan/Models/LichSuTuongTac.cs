using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class LichSuTuongTac
{
    public string MaTuongTac { get; set; } = null!;

    public string? MaTk { get; set; }

    public string? MaKhachHang { get; set; }

    public string? MaHocVien { get; set; }

    public DateOnly NgayTuongTac { get; set; }

    public string NoiDung { get; set; } = null!;

    public string LoaiTuongTac { get; set; } = null!;

    public virtual HocVien? MaHocVienNavigation { get; set; }

    public virtual KhachHang? MaKhachHangNavigation { get; set; }

    public virtual TaiKhoan? MaTkNavigation { get; set; }
}
