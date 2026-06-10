using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class CtPhuTrach
{
    public string MaTk { get; set; } = null!;

    public string MaLop { get; set; } = null!;

    public string VaiTro { get; set; } = null!;

    public DateOnly NgayBatDauPt { get; set; }

    public DateOnly NgayKetThucPt { get; set; }

    public virtual LopHoc MaLopNavigation { get; set; } = null!;

    public virtual TaiKhoan MaTkNavigation { get; set; } = null!;
}
