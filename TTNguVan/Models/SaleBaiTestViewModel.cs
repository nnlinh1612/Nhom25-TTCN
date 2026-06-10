using System.Collections.Generic;

namespace TTNguVan.Models 
{
    public class SaleBaiTestViewModel
    {
        public IEnumerable<BaiTest> DanhSachDeTest { get; set; }
        public IEnumerable<KqBaiTest> DanhSachKetQua { get; set; }
    }
}