using Microsoft.AspNetCore.Mvc;

namespace TTNguVan.Controllers
{
    public class WebhookController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
