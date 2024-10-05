using Microsoft.EntityFrameworkCore;

namespace ProductApi;

public class ProductDbContext : DbContext
{
    public ProductDbContext(DbContextOptions<ProductDbContext> options) 
        : base(options) { }

    public DbSet<Product> Products { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Product>()
            .ToTable("Product");

        modelBuilder.Entity<Product>()
            .ToTable(tb => tb.UseSqlOutputClause(false));
    }
}
