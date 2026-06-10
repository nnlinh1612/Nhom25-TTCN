using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class TaiKhoan
{
    public string MaTk { get; set; } = null!;

    public string MaChucVu { get; set; } = null!;

    public string HoTen { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string MatKhau { get; set; } = null!;

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<CtPhuTrach> CtPhuTraches { get; set; } = new List<CtPhuTrach>();

    public virtual ICollection<CtXuLy> CtXuLies { get; set; } = new List<CtXuLy>();

    public virtual ICollection<KqBaiTest> KqBaiTests { get; set; } = new List<KqBaiTest>();

    public virtual ICollection<LichSuTuongTac> LichSuTuongTacs { get; set; } = new List<LichSuTuongTac>();

    public virtual ICollection<LoiNhac> LoiNhacs { get; set; } = new List<LoiNhac>();

    public virtual ChucVu MaChucVuNavigation { get; set; } = null!;
}
