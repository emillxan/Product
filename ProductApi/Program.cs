using Microsoft.EntityFrameworkCore;
using ProductApi;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<ProductDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowProductMVC",
        builder =>
        {
            builder.AllowAnyOrigin() // Разрешаем любые источники (Origin)
                  .AllowAnyHeader() // Разрешаем любые заголовки
                  .AllowAnyMethod();
        });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors("AllowProductMVC");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
