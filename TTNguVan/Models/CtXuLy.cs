using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class CtXuLy
{
    public string MaTk { get; set; } = null!;

    public string MaCanhBao { get; set; } = null!;

    public DateOnly ThoiGian { get; set; }

    public string GhiChuXuLy { get; set; } = null!;

    public string TrangThaiXuLy { get; set; } = null!;

    public virtual CanhBao MaCanhBaoNavigation { get; set; } = null!;

    public virtual TaiKhoan MaTkNavigation { get; set; } = null!;
}
