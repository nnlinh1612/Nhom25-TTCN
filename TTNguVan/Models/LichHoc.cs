using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class LichHoc
{
    public string MaLich { get; set; } = null!;

    public string MaLop { get; set; } = null!;

    public int Thu { get; set; }

    public string TenCa { get; set; } = null!;

    public TimeOnly? GioBatDau { get; set; }

    public TimeOnly? GioKetThuc { get; set; }

    public virtual LopHoc MaLopNavigation { get; set; } = null!;
}
