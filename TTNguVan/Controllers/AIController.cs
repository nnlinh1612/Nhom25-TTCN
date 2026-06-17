using GenerativeAI;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TTNguVan.Models;

namespace TTNguVan.Controllers
{
    [Route("api/ai")]
    public class AIController : Controller
    {
        private readonly TrungTamNguVanContext _context;
        private readonly IConfiguration _config;

        public AIController(TrungTamNguVanContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        [HttpPost("chat")]
        public async Task<IActionResult> Chat(
            string mode,
            string message,
            string? maKhachHang,
            int? khoiLop,
            string? maBaiTest)
        {
            if (string.IsNullOrWhiteSpace(message))
            {
                return Json(new
                {
                    success = false,
                    reply = "Vui lòng nhập nội dung cần hỗ trợ."
                });
            }

            string prompt = await TaoPromptTheoCheDo(
                mode,
                message,
                maKhachHang,
                khoiLop,
                maBaiTest
            );

            string ketQua = await GoiGemini(prompt);

            return Json(new
            {
                success = true,
                reply = ketQua
            });
        }

        private async Task<string> TaoPromptTheoCheDo(
            string mode,
            string message,
            string? maKhachHang,
            int? khoiLop = null,
            string? maBaiTest = null)
        {
            if (mode == "reply")
            {
                return
                    "Bạn là nhân viên chăm sóc khách hàng của Trung tâm Ngữ Văn Minh Anh.\n" +
                    "Nhiệm vụ: hỗ trợ nhân viên soạn câu trả lời cho phụ huynh/học sinh.\n\n" +

                    "Yêu cầu khi trả lời:\n" +
                    "- Giọng văn lịch sự, thân thiện, chuyên nghiệp.\n" +
                    "- Trả lời ngắn gọn, dễ hiểu, phù hợp để gửi qua Zalo/Facebook/Messenger.\n" +
                    "- Nếu phụ huynh hỏi học phí, lịch học, cam kết đầu ra nhưng nội dung không cung cấp thông tin cụ thể, hãy hướng dẫn nhân viên mời phụ huynh để lại số điện thoại hoặc hẹn tư vấn trực tiếp.\n" +
                    "- Không tự bịa học phí, lịch học, giáo viên, cam kết điểm số.\n" +
                    "- Nếu nội dung của phụ huynh chưa rõ, hãy gợi ý hỏi thêm: khối lớp, mục tiêu học, tình trạng hiện tại, thời gian mong muốn học.\n\n" +

                    "Cấu trúc câu trả lời mong muốn:\n" +
                    "1. Lời chào ngắn.\n" +
                    "2. Xác nhận nhu cầu của phụ huynh/học sinh.\n" +
                    "3. Câu tư vấn phù hợp.\n" +
                    "4. Câu kêu gọi hành động: xin số điện thoại / hẹn tư vấn / mời đến trung tâm.\n\n" +

                    "Tin nhắn/nội dung cần trả lời:\n" + message;
            }

            if (mode == "grade")
            {
                string baremChamDiem = LayBaremChamDiemTheoKhoi(khoiLop);
                string thongTinDeBai = "";

                if (!string.IsNullOrWhiteSpace(maBaiTest))
                {
                    string maBaiTestCanTim = maBaiTest.Trim();

                    var baiTest = await _context.BaiTests
                        .FirstOrDefaultAsync(x => x.MaBaiTest == maBaiTestCanTim);

                    if (baiTest != null)
                    {
                        thongTinDeBai =
                            "THÔNG TIN ĐỀ BÀI TRONG HỆ THỐNG:\n" +
                            $"- Mã bài test: {baiTest.MaBaiTest}\n" +
                            $"- Tên bài test: {baiTest.TenBaiTest}\n\n" +
                            "NỘI DUNG ĐỀ BÀI:\n" +
                            $"{baiTest.NoiDungDe}\n\n";
                    }
                    else
                    {
                        thongTinDeBai =
                            $"Không tìm thấy mã bài test '{maBaiTestCanTim}' trong hệ thống. " +
                            "Hãy chấm theo nội dung bài làm và barem theo khối lớp.\n\n";
                    }
                }
                else
                {
                    thongTinDeBai =
                        "Chưa cung cấp mã bài test. Hãy chấm theo nội dung bài làm và barem theo khối lớp.\n\n";
                }

                return
                    "Bạn là giáo viên Ngữ văn tại Việt Nam, chuyên chấm bài kiểm tra cho học sinh từ lớp 6 đến lớp 12.\n" +
                    "Nhiệm vụ của bạn là chấm bài theo đúng đề bài và barem được cung cấp, không chấm cảm tính.\n\n" +

                    "NGUYÊN TẮC CHẤM BÀI:\n" +
                    "- Chấm đúng theo khối lớp, đề bài và barem tương ứng.\n" +
                    "- Nếu học sinh không trả lời đúng yêu cầu đề, phải trừ điểm rõ ràng.\n" +
                    "- Nếu bài làm lạc đề, nêu rõ mức độ lạc đề và không cho điểm cao.\n" +
                    "- Không tự bịa nội dung học sinh không viết.\n" +
                    "- Không viết lại toàn bộ bài thay học sinh.\n" +
                    "- Nhận xét phải cụ thể, chỉ rõ điểm mạnh, điểm yếu và cách cải thiện.\n" +
                    "- Với lớp 6-7: góp ý nhẹ nhàng, ưu tiên bố cục cơ bản, diễn đạt rõ ý, đúng kiểu bài.\n" +
                    "- Với lớp 8-9: chú ý lập luận, dẫn chứng, phân tích chi tiết, liên kết đoạn.\n" +
                    "- Với lớp 10-12: yêu cầu tư duy phân tích sâu, lập luận chặt chẽ, dẫn chứng phù hợp, biết bình luận/mở rộng.\n\n" +

                    thongTinDeBai +

                    "BAREM CHẤM ĐIỂM:\n" +
                    baremChamDiem + "\n\n" +

                    "ĐỊNH DẠNG KẾT QUẢ BẮT BUỘC:\n" +
                    "1. Nhận xét tổng quan:\n" +
                    "- Viết 2-4 câu nhận xét khái quát về bài làm.\n\n" +

                    "2. Chấm điểm chi tiết:\n" +
                    "- Liệt kê từng phần/câu/tiêu chí trong barem.\n" +
                    "- Với mỗi tiêu chí, ghi: điểm đạt được / điểm tối đa.\n" +
                    "- Giải thích ngắn vì sao cho điểm như vậy.\n\n" +

                    "3. Tổng điểm:\n" +
                    "- Ghi tổng điểm theo thang 10.\n" +
                    "- Nếu điểm lẻ, làm tròn đến 0,25 điểm.\n\n" +

                    "4. Điểm mạnh:\n" +
                    "- Nêu các điểm học sinh làm tốt.\n\n" +

                    "5. Điểm cần cải thiện:\n" +
                    "- Nêu lỗi cụ thể về nội dung, bố cục, lập luận, diễn đạt, chính tả nếu có.\n\n" +

                    "6. Gợi ý cải thiện:\n" +
                    "- Gợi ý cách sửa bài hoặc cách học tiếp theo.\n\n" +

                    "7. Lời động viên:\n" +
                    "- Một câu động viên phù hợp với học sinh.\n\n" +

                    $"KHỐI LỚP: {(khoiLop.HasValue ? khoiLop.Value.ToString() : "Chưa cung cấp")}\n\n" +
                    "BÀI LÀM CỦA HỌC SINH:\n" +
                    message;
            }

            if (mode == "summary")
            {
                return
                    "Bạn là nhân viên chăm sóc khách hàng của Trung tâm Ngữ Văn Minh Anh.\n" +
                    "Nhiệm vụ: tóm tắt đoạn chat tư vấn thành một nội dung ngắn gọn để lưu vào lịch sử tư vấn khách hàng.\n\n" +

                    "Yêu cầu bắt buộc:\n" +
                    "- Chỉ viết 1 đoạn văn ngắn, khoảng 1-2 câu.\n" +
                    "- Chỉ viết chung là phụ huynh/học sinh, không cần nêu cụ thể họ tên. \n" +
                    "- Không chia mục, không đánh số, không gạch đầu dòng.\n" +
                    "- Không viết tiêu đề như 'Tóm tắt tư vấn', 'Trạng thái hiện tại'.\n" +
                    "- Không bịa thông tin không có trong đoạn chat.\n" +
                    "- Viết tự nhiên như nội dung ghi chú trong lịch sử tư vấn.\n" +
                    "- Ưu tiên nêu: phụ huynh/học sinh quan tâm gì, khối lớp nếu có, nhu cầu học, việc đã tư vấn hoặc bước tiếp theo nếu có.\n\n" +

                    "Ví dụ cách viết đúng:\n" +
                    "Phụ huynh quan tâm lớp ôn thi vào 10 môn Văn, muốn được tư vấn lộ trình học và chất lượng giảng dạy của trung tâm.\n\n" +

                    "Đoạn chat cần tóm tắt:\n" + message;
            }

            return
                "Bạn là trợ lý AI nội bộ cho Trung tâm Ngữ Văn Minh Anh.\n" +
                "Hãy hỗ trợ nhân viên một cách ngắn gọn, chính xác và dễ hiểu.\n" +
                "Không bịa thông tin nếu dữ liệu không được cung cấp.\n\n" +
                "Yêu cầu:\n" + message;
        }

        private string LayBaremChamDiemTheoKhoi(int? khoiLop)
        {
            if (khoiLop == 6)
            {
                return
                    "BAREM LỚP 6 - THANG 10\n\n" +
                    "I. Đọc hiểu - 6 điểm:\n" +
                    "- Câu 1 - 1 điểm: Xác định đúng nhân vật “tôi” là con đường: 0,5 điểm; nêu được đặc điểm nổi bật như nhỏ, lớn tuổi, yêu thương con người, có ích: 0,5 điểm.\n" +
                    "- Câu 2 - 1 điểm: Nêu đúng trình tự thời gian trong ngày: sáng, chiều, tối, đêm khuya, sáng mai: 0,5 điểm; nêu tác dụng giúp văn bản mạch lạc, thể hiện một ngày sống có ích và hạnh phúc của con đường: 0,5 điểm.\n" +
                    "- Câu 3 - 1 điểm: Chỉ ra biện pháp nhân hóa: 0,5 điểm; nêu tác dụng làm con đường trở nên gần gũi, có cảm xúc, biết yêu thương và cống hiến: 0,5 điểm.\n" +
                    "- Câu 4 - 1 điểm: Lí giải được con đường hạnh phúc vì còn có ích, được nâng đỡ bước chân mọi người, chứng kiến cuộc sống bình dị: 1 điểm.\n" +
                    "- Câu 5 - 2 điểm: Viết đoạn 8-10 câu: 0,5 điểm; nêu bài học sống có ích, yêu thương, cống hiến: 0,75 điểm; có lí lẽ/dẫn chứng phù hợp: 0,5 điểm; diễn đạt rõ, ít lỗi: 0,25 điểm.\n\n" +
                    "II. Viết - 4 điểm:\n" +
                    "- Đúng kiểu bài theo đề đã chọn: 0,75 điểm.\n" +
                    "- Bố cục đủ mở bài, thân bài, kết bài: 0,75 điểm.\n" +
                    "- Nội dung triển khai rõ, có chi tiết cụ thể: 1 điểm.\n" +
                    "- Thể hiện được cảm xúc/suy nghĩ phù hợp: 0,75 điểm.\n" +
                    "- Diễn đạt, chính tả, trình bày: 0,75 điểm.";
            }

            if (khoiLop == 7)
            {
                return
                    "BAREM LỚP 7 - THANG 10\n\n" +
                    "Câu 1 - 3 điểm:\n" +
                    "- Nêu đúng khái niệm so sánh: 1 điểm.\n" +
                    "- Xác định đúng phép so sánh trong bài ca dao: “Công cha như núi ngất trời”, “Nghĩa mẹ như nước ở ngoài biển Đông”: 1 điểm.\n" +
                    "- Nêu tác dụng: làm nổi bật công lao to lớn, sâu nặng của cha mẹ, thể hiện lòng biết ơn: 1 điểm.\n\n" +
                    "Câu 2 - 2 điểm:\n" +
                    "- Rút ra bài học từ “Cuộc chia tay của những con búp bê”: trân trọng gia đình, yêu thương anh em, bảo vệ hạnh phúc trẻ thơ: 1 điểm.\n" +
                    "- Trình bày suy nghĩ cá nhân rõ ràng, có ý nghĩa giáo dục: 1 điểm.\n\n" +
                    "Câu 3 - 5 điểm:\n" +
                    "- Đúng kiểu bài miêu tả người: 0,75 điểm.\n" +
                    "- Bố cục rõ ràng: 0,75 điểm.\n" +
                    "- Miêu tả ngoại hình tiêu biểu: 1 điểm.\n" +
                    "- Miêu tả tính cách, việc làm, kỉ niệm, tình cảm gắn bó: 1,25 điểm.\n" +
                    "- Thể hiện tình cảm chân thành: 0,75 điểm.\n" +
                    "- Diễn đạt, chính tả, dùng từ, đặt câu: 0,5 điểm.";
            }

            if (khoiLop == 8)
            {
                return
                    "BAREM LỚP 8 - THANG 10\n\n" +
                    "I. Văn - Tiếng Việt - 4 điểm:\n" +
                    "- Câu 1a - 2 điểm: Xác định đúng văn bản “Tinh thần yêu nước của nhân dân ta”, tác giả Hồ Chí Minh: 1 điểm; nêu đúng nội dung chính: ca ngợi truyền thống yêu nước và sức mạnh tinh thần yêu nước: 1 điểm.\n" +
                    "- Câu 1b - 0,5 điểm: Phương thức biểu đạt chính là nghị luận.\n" +
                    "- Câu 1c - 0,5 điểm: Tìm đúng trạng ngữ: “Từ xưa đến nay”, “mỗi khi Tổ quốc bị xâm lăng”.\n" +
                    "- Câu 2 - 1 điểm: Từ tượng thanh: hu hu, ư ử, sòng sọc: 0,5 điểm; từ tượng hình: móm mém, xồng xộc, rũ rượi, xộc xệch: 0,5 điểm.\n\n" +
                    "II. Tập làm văn - 6 điểm:\n" +
                    "- Đúng kiểu bài nghị luận chứng minh: 1 điểm.\n" +
                    "- Giải thích đúng nghĩa câu tục ngữ: 1 điểm.\n" +
                    "- Luận điểm rõ về lòng biết ơn và truyền thống đạo lí: 1,5 điểm.\n" +
                    "- Dẫn chứng phù hợp trong gia đình, nhà trường, xã hội, lịch sử: 1 điểm.\n" +
                    "- Lập luận mạch lạc, liên kết đoạn tốt: 0,75 điểm.\n" +
                    "- Diễn đạt, chính tả, trình bày: 0,75 điểm.";
            }

            if (khoiLop == 9)
            {
                return
                    "BAREM LỚP 9 - THANG 10\n\n" +
                    "I. Đọc hiểu - 4 điểm:\n" +
                    "- Câu 1 - 1 điểm: Xác định đúng phong cách ngôn ngữ chính luận/nghị luận xã hội.\n" +
                    "- Câu 2 - 1 điểm: Nêu đúng nội dung chính: bàn về năng lực tạo ra hạnh phúc và cách sống có ý nghĩa để chạm vào hạnh phúc.\n" +
                    "- Câu 3 - 1 điểm: Nêu công dụng dấu ngoặc kép để nhấn mạnh/tạo nghĩa đặc biệt: 0,4 điểm; giải thích “nhỏ bé”: 0,3 điểm; giải thích “con người lớn”: 0,3 điểm.\n" +
                    "- Câu 4 - 1 điểm: Nêu quan điểm cá nhân và ít nhất 2 lí do hợp lí, trình bày 5-7 dòng.\n\n" +
                    "II. Làm văn - 6 điểm:\n" +
                    "- Đúng ngôi kể, nhập vai ông giáo phù hợp: 1 điểm.\n" +
                    "- Bám sát sự việc lão Hạc sang báo tin bán chó: 1,5 điểm.\n" +
                    "- Tái hiện được diễn biến câu chuyện và tâm lí nhân vật: 1,5 điểm.\n" +
                    "- Có yếu tố miêu tả, biểu cảm, lời kể tự nhiên: 1 điểm.\n" +
                    "- Bố cục, diễn đạt, chính tả: 1 điểm.";
            }

            if (khoiLop == 10)
            {
                return
                    "BAREM LỚP 10 - THANG 10\n\n" +
                    "I. Đọc hiểu - 4 điểm:\n" +
                    "- Câu 1 - 0,5 điểm: Xác định đúng kiểu văn bản nghị luận.\n" +
                    "- Câu 2 - 0,5 điểm: Nêu nội dung chính: phê phán thói đố kị, khuyên con người trân trọng bản thân và vui trước thành công của người khác.\n" +
                    "- Câu 3 - 1 điểm: Chỉ ra biện pháp đối lập/tương phản: 0,5 điểm; phân tích tác dụng: 0,5 điểm.\n" +
                    "- Câu 4 - 1 điểm: Lí giải được người đố kị thường tự ti, ích kỉ, sợ bị so sánh, không muốn thừa nhận ưu điểm người khác.\n" +
                    "- Câu 5 - 1 điểm: Rút ra thông điệp ý nghĩa: sống không đố kị, biết nỗ lực, tự hào về bản thân, vui với thành công của người khác.\n\n" +
                    "II. Viết - 6 điểm:\n" +
                    "Câu 1 - 2 điểm: Đoạn văn khoảng 200 chữ về lối sống không đố kị: đúng hình thức 0,4; nêu vấn đề 0,4; lí lẽ/dẫn chứng 0,8; diễn đạt 0,4.\n" +
                    "Câu 2 - 4 điểm: Phân tích truyện ngắn “Bố tôi”: giới thiệu vấn đề 0,5; phân tích người bố 1,25; phân tích tình cảm gia đình và chi tiết lá thư 1; nghệ thuật 0,75; diễn đạt 0,5.";
            }

            if (khoiLop == 11)
            {
                return
                    "BAREM LỚP 11 - THANG 10\n\n" +
                    "I. Đọc hiểu - 5 điểm:\n" +
                    "- Câu 1 - 0,5 điểm: Chọn A. Văn bản nghị luận.\n" +
                    "- Câu 2 - 0,5 điểm: Chọn C. Nghị luận.\n" +
                    "- Câu 3 - 0,5 điểm: Nêu đúng nguyên nhân: sợ thất bại, thiếu niềm tin, ngại rủi ro/chế giễu.\n" +
                    "- Câu 4 - 0,5 điểm: Nêu quan điểm đồng tình/không đồng tình và lí giải hợp lí.\n" +
                    "- Câu 5 - 1 điểm: Giải thích vùng an toàn: 0,4; nêu ít nhất 2 cách bước ra khỏi vùng an toàn: 0,6.\n" +
                    "- Câu 6 - 2 điểm: Đoạn văn khoảng 200 chữ: đúng hình thức 0,4; luận điểm rõ 0,4; lí lẽ/dẫn chứng 0,8; diễn đạt 0,4.\n\n" +
                    "II. Viết - 5 điểm:\n" +
                    "- Đúng kiểu bài thuyết minh: 1 điểm.\n" +
                    "- Đối tượng thuyết minh rõ ràng, thông tin chính xác: 1 điểm.\n" +
                    "- Có lồng ghép yếu tố miêu tả/tự sự/biểu cảm/nghị luận hợp lí: 1 điểm.\n" +
                    "- Bố cục rõ ràng, triển khai mạch lạc: 1 điểm.\n" +
                    "- Diễn đạt, chính tả, trình bày: 1 điểm.";
            }

            if (khoiLop == 12)
            {
                return
                    "BAREM LỚP 12 - THANG 10\n\n" +
                    "I. Đọc hiểu - 5 điểm:\n" +
                    "- Câu 1 - 1 điểm: Xác định đúng ngôi kể thứ ba.\n" +
                    "- Câu 2 - 1 điểm: Chỉ ra biện pháp so sánh trong “như nước tràn lên phố”: 0,5; nêu tác dụng gợi không khí Tết rộn ràng, tràn đầy sức sống: 0,5. Có thể chấp nhận phép liệt kê nếu phân tích hợp lí.\n" +
                    "- Câu 3 - 1 điểm: Nêu tác dụng lời ông Chín: thúc đẩy Quí bày tỏ tình cảm, thể hiện sự cảm thông với Đậm, làm nổi bật vẻ đẹp bên trong của Đậm và giá trị nhân văn.\n" +
                    "- Câu 4 - 1 điểm: Nêu lời muốn nói với Quí: mạnh dạn, chân thành, trân trọng Đậm, không định kiến quá khứ.\n" +
                    "- Câu 5 - 1 điểm: Nêu quan điểm nhân văn về sai lầm tuổi trẻ: bao dung, biết sửa sai, không định kiến, cho con người cơ hội làm lại.\n\n" +
                    "II. Viết - 5 điểm:\n" +
                    "- Đúng kiểu bài nghị luận văn học so sánh: 0,75 điểm.\n" +
                    "- Giới thiệu đúng tác giả, tác phẩm, vấn đề giá trị nhân đạo: 0,5 điểm.\n" +
                    "- Phân tích giá trị nhân đạo trong Lão Hạc: 1 điểm.\n" +
                    "- Phân tích giá trị nhân đạo trong Làng: 1 điểm.\n" +
                    "- So sánh điểm giống và khác: 1 điểm.\n" +
                    "- Đánh giá nghệ thuật và ý nghĩa: 0,5 điểm.\n" +
                    "- Bố cục, diễn đạt, chính tả: 0,25 điểm.";
            }

            return
                "BAREM CHUNG - THANG 10\n" +
                "- Đúng yêu cầu đề bài: 2 điểm.\n" +
                "- Nội dung, ý tưởng, hiểu vấn đề: 3 điểm.\n" +
                "- Bố cục, lập luận, triển khai ý: 2 điểm.\n" +
                "- Diễn đạt, dùng từ, đặt câu: 2 điểm.\n" +
                "- Chính tả, trình bày, sáng tạo phù hợp: 1 điểm.";
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

                for (int lanThu = 1; lanThu <= 3; lanThu++)
                {
                    try
                    {
                        var response = await model.GenerateContentAsync(prompt);

                        if (string.IsNullOrWhiteSpace(response.Text))
                        {
                            return "AI chưa trả về nội dung phù hợp.";
                        }

                        return response.Text;
                    }
                    catch (Exception ex)
                    {
                        string message = ex.Message;

                        bool biQuaTai =
                            message.Contains("503") ||
                            message.Contains("UNAVAILABLE") ||
                            message.Contains("high demand");

                        if (biQuaTai && lanThu < 3)
                        {
                            await Task.Delay(1500);
                            continue;
                        }

                        if (biQuaTai)
                        {
                            return "Gemini đang quá tải tạm thời. Vui lòng thử lại sau vài phút.";
                        }

                        return "Lỗi khi gọi Gemini: " + ex.Message;
                    }
                }

                return "AI chưa phản hồi. Vui lòng thử lại.";
            }
            catch (Exception ex)
            {
                return "Lỗi khi gọi Gemini: " + ex.Message;
            }
        }
    }
}
