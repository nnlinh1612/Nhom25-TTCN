using System;
using System.Collections.Generic;

namespace TTNguVan.Models;

public partial class LopHoc
{
    public string MaLop { get; set; } = null!;

    public string TenLop { get; set; } = null!;

    public string MoTa { get; set; } = null!;

    public virtual ICollection<BuoiHoc> BuoiHocs { get; set; } = new List<BuoiHoc>();

    public virtual ICollection<CtPhuTrach> CtPhuTraches { get; set; } = new List<CtPhuTrach>();

    public virtual ICollection<HocVien> HocViens { get; set; } = new List<HocVien>();

    public virtual ICollection<LichHoc> LichHocs { get; set; } = new List<LichHoc>();
}
