using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class BaiLam
{
    public string MaBaiLam { get; set; } = null!;

    public string? MaBaiTest { get; set; }

    public string? MaHocVien { get; set; }

    public DateOnly NgayLam { get; set; }

    public string? NoiDungBaiLam { get; set; }

    public virtual ICollection<KqBaiTest> KqBaiTests { get; set; } = new List<KqBaiTest>();

    public virtual BaiTest? MaBaiTestNavigation { get; set; }

    public virtual HocVien? MaHocVienNavigation { get; set; }
}
