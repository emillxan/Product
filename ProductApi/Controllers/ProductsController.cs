using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ProductApi.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ProductsController : ControllerBase
{
    private readonly ProductDbContext _context;

    public ProductsController(ProductDbContext context)
    {
        _context = context;
    }

    // Получение списка изделий по фильтру (по наименованию изделия)
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Product>>> GetProducts(string name = null)
    {
        var products = string.IsNullOrWhiteSpace(name)
            ? await _context.Products.ToListAsync()
            : await _context.Products.Where(p => p.Name.Contains(name)).ToListAsync();
        return Ok(products);
    }

    // Получение конкретного изделия по ID
    [HttpGet("{id}")]
    public async Task<ActionResult<Product>> GetProduct(Guid id)
    {
        var product = await _context.Products.FindAsync(id);
        if (product == null)
            return NotFound();

        return Ok(product);
    }

    // Добавление нового изделия
    [HttpPost]
    public async Task<ActionResult<Product>> AddProduct(Product product)
    {
        product.ID = Guid.NewGuid();
        _context.Products.Add(product);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetProduct), new { id = product.ID }, product);
    }

    // Редактирование существующего изделия
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateProduct(Guid id, Product product)
    {
        if (id != product.ID)
            return BadRequest();

        var existingProduct = await _context.Products.FindAsync(id);
        if (existingProduct == null)
            return NotFound();

        existingProduct.Name = product.Name;
        existingProduct.Description = product.Description;
        
        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!ProductExists(id))
                return NotFound();
            throw;
        }

        return NoContent();
    }

    // Удаление изделия по ID
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteProduct(Guid id)
    {
        var product = await _context.Products.FindAsync(id);
        if (product == null)
            return NotFound();

        _context.Products.Remove(product);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool ProductExists(Guid id)
    {
        return _context.Products.Any(e => e.ID == id);
    }
}

