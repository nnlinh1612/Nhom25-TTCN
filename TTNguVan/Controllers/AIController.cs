using GenerativeAI;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TTNguVan.Models;

namespace TTNguVan.Controllers
{
    public class AIController : Controller
    {
        private readonly TrungTamNguVanContext _context;
        private readonly IConfiguration _config;

        public AIController(TrungTamNguVanContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        [HttpPost]
        public async Task<IActionResult> Chat(string mode, string message, string? maKhachHang)
        {
            if (string.IsNullOrWhiteSpace(message))
            {
                return Json(new
                {
                    success = false,
                    reply = "Vui lòng nhập nội dung cần hỗ trợ."
                });
            }

            string prompt = await TaoPromptTheoCheDo(mode, message, maKhachHang);

            string ketQua = await GoiGemini(prompt);

            return Json(new
            {
                success = true,
                reply = ketQua
            });
        }

        private async Task<string> TaoPromptTheoCheDo(string mode, string message, string? maKhachHang)
        {
            if (mode == "reply")
            {
                return
                    "Bạn là nhân viên chăm sóc khách hàng cho Trung tâm Ngữ Văn Minh Anh. " +
                    "Hãy giúp nhân viên soạn câu trả lời cho phụ huynh/học sinh. " +
                    "Giọng văn lịch sự, thân thiện, ngắn gọn, dễ hiểu. " +
                    "Không bịa học phí, lịch học, cam kết đầu ra nếu đề bài không cung cấp.\n\n" +
                    "Tin nhắn/nội dung cần trả lời:\n" + message;
            }

            if (mode == "grade")
            {
                return
                    "Bạn là giáo viên Ngữ văn. Hãy chấm và góp ý bài viết sau. " +
                    "Nhận xét theo các mục: nội dung, bố cục, diễn đạt, lỗi chính tả/ngữ pháp, điểm mạnh, điểm cần cải thiện. " +
                    "Nếu có thể, hãy cho điểm tham khảo theo thang 10. " +
                    "Không phê bình nặng lời, hãy góp ý mang tính xây dựng.\n\n" +
                    "Bài viết:\n" + message;
            }

            if (mode == "summary")
            {
                string lichSuCu = "";

                if (!string.IsNullOrWhiteSpace(maKhachHang))
                {
                    var lichSus = await _context.LichSuTuongTacs
                        .Where(x => x.MaKhachHang == maKhachHang)
                        .OrderByDescending(x => x.NgayTuongTac)
                        .Take(10)
                        .ToListAsync();

                    lichSuCu = string.Join("\n", lichSus.Select(x =>
                        $"- {x.NgayTuongTac}: [{x.LoaiTuongTac}] {x.NoiDung}"
                    ));
                }

                return
                    "Bạn là nhân viên chăm sóc khách hàng cho trung tâm Ngữ Văn Minh Anh. " +
                    "Hãy tóm tắt lịch sử tư vấn/ngữ cảnh khách hàng một cách ngắn gọn, khoảng 2-3 câu, rõ ràng. " +
                    "Nêu rõ: nhu cầu học, trạng thái tư vấn, vấn đề cần chăm sóc tiếp, đề xuất hành động tiếp theo.\n\n" +
                    "Lịch sử cũ trong hệ thống:\n" + lichSuCu + "\n\n" +
                    "Nội dung nhân viên nhập thêm:\n" + message;
            }

            return
                "Bạn là trợ lý AI nội bộ cho Trung tâm Ngữ Văn Minh Anh. " +
                "Hãy hỗ trợ nhân viên một cách ngắn gọn, chính xác và dễ hiểu.\n\n" +
                "Yêu cầu:\n" + message;
        }

        private async Task<string> GoiGemini(string prompt)
        {
            try
            {
                string? apiKey = _config["GeminiApiKey"];

                if (string.IsNullOrWhiteSpace(apiKey))
                {
                    return "Chưa cấu hình GeminiApiKey trong appsettings.json.";
                }

                var model = new GenerativeModel(apiKey, "gemini-2.5-flash");

                var response = await model.GenerateContentAsync(prompt);

                if (string.IsNullOrWhiteSpace(response.Text))
                {
                    return "AI chưa trả về nội dung phù hợp.";
                }

                return response.Text;
            }
            catch (Exception ex)
            {
                return "Lỗi khi gọi Gemini: " + ex.Message;
            }
        }
    }
}