using Microsoft.AspNetCore.Mvc;

namespace ProductMVC.Controllers;

public class ProductsController : Controller
{
    public async Task<IActionResult> Index()
    {
        return View();
    }
}
