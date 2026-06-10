using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class CanhBao
{
    public string MaCanhBao { get; set; } = null!;

    public string MaKqht { get; set; } = null!;

    public string? TieuDe { get; set; }

    public string NoiDungCb { get; set; } = null!;

    public DateTime? HanChot { get; set; }

    public string? MucDo { get; set; }

    public bool? TrangThai { get; set; }

    public virtual ICollection<CtXuLy> CtXuLies { get; set; } = new List<CtXuLy>();

    public virtual KqHocTap MaKqhtNavigation { get; set; } = null!;
}
