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

builder.Services.AddSingleton<IRouteTrackingManager, RouteTrackingManager>();

builder.Logging.AddFilter("Microsoft.AspNetCore.SignalR", LogLevel.Trace);
builder.Logging.AddConsole();

//builder.Services.AddSingleton<IRouteTrackingManager>(sp =>
//{
//    var routeStopsDataFactory = sp.GetRequiredService<IServiceProvider>();
//    return new RouteTrackingManager(() => routeStopsDataFactory.GetRequiredService<RouteStopsData>());
//}); // this is done since the props of the tracking manager have to be kept alive, thus singleton, but also a scoped object (routeStopData) cant live inside singleton. thus, we use factory to get the instance only whenever we want (inside the funcs of the singleton) which is destroyed after the scope of the fun ends. i think?!
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
