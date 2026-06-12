using GenerativeAI;
using GenerativeAI.Types;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore; 
using System.Text.Json;
using TTNguVan.Models;

namespace TTNguVan.Controllers
{
    [Route("Webhook")]
    [ApiController]
    public class WebhookController : ControllerBase
    {
        private readonly TrungTamNguVanContext _context;
        private readonly IConfiguration _config;
        private const string VERIFY_TOKEN = "NGU_VAN_MINH_ANH";

        // Gộp chung vào 1 Constructor duy nhất
        public WebhookController(TrungTamNguVanContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        [HttpGet]
        [HttpGet]
        public IActionResult Verify([FromQuery(Name = "hub.mode")] string mode,
                            [FromQuery(Name = "hub.verify_token")] string token,
                            [FromQuery(Name = "hub.challenge")] string challenge)
        {
            // Kiểm tra xem Facebook có gửi đúng token không
            if (mode == "subscribe" && token == "NGU_VAN_MINH_ANH")
            {
                // Trả về số challenge ngay lập tức dưới dạng plain text
                return Ok(challenge);
            }

            // Nếu sai token thì trả về lỗi 403 (Forbidden)
            return Forbid();
        }

        [HttpPost]
        public async Task<IActionResult> Receive([FromBody] JsonElement data)
        {
            if (data.TryGetProperty("entry", out var entries))
            {
                foreach (var entry in entries.EnumerateArray())
                {
                    foreach (var messaging in entry.GetProperty("messaging").EnumerateArray())
                    {
                        string noiDungKhachNhan = messaging.GetProperty("message").GetProperty("text").GetString();
                        string senderId = messaging.GetProperty("sender").GetProperty("id").GetString();

                        // 1. Gọi AI tóm tắt
                        string tomTat = await TomTatTinNhan(noiDungKhachNhan);

                        // 2. LƯU VÀO DATABASE
                        var khachHang = await _context.KhachHangs.FirstOrDefaultAsync(k => k.FacebookId == senderId);

                        if (khachHang != null)
                        {
                            var lichSuMoi = new LichSuTuongTac
                            {
                                MaKhachHang = khachHang.MaKhachHang,
                                LoaiTuongTac = "AI Tóm tắt",
                                NoiDung = tomTat,
                                NgayTuongTac = DateOnly.FromDateTime(DateTime.Now)
                            };

                            _context.LichSuTuongTacs.Add(lichSuMoi);
                            await _context.SaveChangesAsync();
                        }
                    }
                }
            }
            return Ok();
        }

        public async Task<string> TomTatTinNhan(string noiDungChat)
        {
            string apiKey = _config["GeminiApiKey"];
            var model = new GenerativeModel("gemini-1.5-flash", apiKey);

            string prompt = $"Hãy là một nhân viên tư vấn chuyên nghiệp cho trung tâm Ngữ Văn Minh Anh. " +
                            $"Tóm tắt ngắn gọn về nhu cầu và trạng thái của khách hàng từ nội dung: {noiDungChat}";

            var response = await model.GenerateContentAsync(prompt);
            return response.Text ?? "Không thể tóm tắt.";
        }
    }
}