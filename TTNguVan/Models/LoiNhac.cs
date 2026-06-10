using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class LoiNhac
{
    public int Id { get; set; }

    public string? MaTk { get; set; }

    public string? TieuDe { get; set; }

    public string? NoiDung { get; set; }

    public DateTime? HanChot { get; set; }

    public string? MucDo { get; set; }

    public bool? TrangThai { get; set; }

    public virtual TaiKhoan? MaTkNavigation { get; set; }
}
