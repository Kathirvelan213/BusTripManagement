using BusTripManagement.API.Hubs;
using BusTripManagement.BAL;
using BusTripManagement.DAL;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins(builder.Configuration["Cors:AllowedOrigins"])
        .AllowCredentials()
        .AllowAnyHeader()
        .AllowAnyMethod();
    });
});

builder.Services.AddControllers();
builder.Services.AddSignalR();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<DbService>();

builder.Services.AddScoped<BusRoutesManager>();
builder.Services.AddScoped<BusRouteData>();

builder.Services.AddScoped<StopsManager>();
builder.Services.AddScoped<StopsData>();

builder.Services.AddScoped<RouteStopsManager>();
builder.Services.AddScoped<RouteStopsData>();

builder.Services.AddScoped<RouteCoordinateManager>();
builder.Services.AddScoped<RouteCoordinateData>();

var app = builder.Build();



// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseCors("AllowFrontend");

app.UseAuthorization();

app.MapControllers();
app.MapHub<LiveLocationHub>("/location-hub");

app.Run();
