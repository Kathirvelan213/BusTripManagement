<<<<<<< HEAD

using BusTripManagement.API.Hubs;

=======
>>>>>>> d00d9210a4ba15460a5cb47e90bea4d55e709dd8
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

<<<<<<< HEAD
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
=======
builder.Services.AddControllers();
>>>>>>> d00d9210a4ba15460a5cb47e90bea4d55e709dd8
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
<<<<<<< HEAD
//if (app.Environment.IsDevelopment())
=======
if (app.Environment.IsDevelopment())
>>>>>>> d00d9210a4ba15460a5cb47e90bea4d55e709dd8
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

<<<<<<< HEAD
app.UseCors("AllowFrontend");


app.UseAuthorization();

app.MapControllers();
app.MapHub<LiveLocationHub>("/location-hub");
=======
app.UseAuthorization();

app.MapControllers();
>>>>>>> d00d9210a4ba15460a5cb47e90bea4d55e709dd8

app.Run();
