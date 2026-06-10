using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class BaiTest
{
    public string MaBaiTest { get; set; } = null!;

    public string TenBaiTest { get; set; } = null!;

    public string? NoiDungDe { get; set; }

    public virtual ICollection<BaiLam> BaiLams { get; set; } = new List<BaiLam>();
}
