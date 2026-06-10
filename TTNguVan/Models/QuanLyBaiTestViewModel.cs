using System.Collections.Generic;

namespace TTNguVan.Models
{
    public class QuanLyBaiTestViewModel
    {
        // Danh sách các bài học sinh nộp nhưng chưa được chấm
        public List<BaiLam> DanhSachChoCham { get; set; }

        // Danh sách các kết quả đã chấm xong
        public List<KqBaiTest> DanhSachDaCham { get; set; }
    }
}
