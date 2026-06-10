using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class BuoiHoc
{
    public string MaBuoiHoc { get; set; } = null!;

    public string MaLop { get; set; } = null!;

    public DateOnly NgayHoc { get; set; }

    public virtual ICollection<KqHocTap> KqHocTaps { get; set; } = new List<KqHocTap>();

    public virtual LopHoc MaLopNavigation { get; set; } = null!;
}
