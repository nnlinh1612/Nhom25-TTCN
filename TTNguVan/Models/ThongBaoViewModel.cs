namespace TTNguVan.Models
{
    public class ThongBaoViewModel
    {
        public string Id { get; set; } // Đổi tất cả thành string ở đây
        public string TieuDe { get; set; }
        public string NoiDung { get; set; }
        public DateTime? HanChot { get; set; }
        public string MucDo { get; set; }
        public bool TrangThai { get; set; }
        public bool IsHeThong { get; set; }
    }
}