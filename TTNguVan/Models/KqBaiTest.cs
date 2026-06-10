using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class KqBaiTest
{
    public string MaBaiLam { get; set; } = null!;

    public string MaTk { get; set; } = null!;

    public DateOnly NgayCham { get; set; }

    public double DiemTest { get; set; }

    public string NhanXet { get; set; } = null!;

    public string GhiChu { get; set; } = null!;

    public virtual BaiLam MaBaiLamNavigation { get; set; } = null!;

    public virtual TaiKhoan MaTkNavigation { get; set; } = null!;
}
