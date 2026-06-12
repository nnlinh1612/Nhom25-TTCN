using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace TTNguVan.Controllers
{
    [Route("Webhook")]
    [ApiController]
    public class WebhookController : ControllerBase
    {
        private const string VERIFY_TOKEN = "EduManage_Secret_2026"; // Mã này ông tự đặt

        // 1. Dùng để Facebook "bắt tay" với server ông lần đầu tiên
        [HttpGet]
        public IActionResult Verify([FromQuery(Name = "hub.mode")] string mode,
                                    [FromQuery(Name = "hub.verify_token")] string token,
                                    [FromQuery(Name = "hub.challenge")] string challenge)
        {
            if (mode == "subscribe" && token == VERIFY_TOKEN) return Ok(challenge);
            return Forbid();
        }

        // 2. Nơi Facebook "đổ" tin nhắn của khách về
        [HttpPost]
        public IActionResult Receive([FromBody] JsonElement data)
        {
            // Ở đây ông nhận được toàn bộ dữ liệu tin nhắn từ Facebook
            // Cứ ghi log ra file để xem nó gửi cái gì về nhé
            Console.WriteLine(data.GetRawText());
            return Ok(); // Luôn trả về 200 OK để Facebook không gửi lại
        }
    }
}
