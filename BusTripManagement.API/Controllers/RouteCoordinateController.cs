using BusTripManagement.BAL;
using BusTripManagement.Models;
using Microsoft.AspNetCore.Mvc;

namespace BusTripManagement.Controllers
{
    public record UploadKmlRequest(IFormFile File, int RouteId);

    [ApiController]
    [Route("api/[controller]")]
    public class RouteCoordinateController : ControllerBase
    {
        private readonly RouteCoordinateManager _routeCoordinateManager;

        public RouteCoordinateController(RouteCoordinateManager routeCoordinateManager)
        {
            _routeCoordinateManager = routeCoordinateManager;
        }

        /// <summary>
        /// Upload a KML file for a specific route and save its coordinates.
        /// </summary>
        [HttpPost("upload")]
        public async Task<IActionResult> UploadKml([FromForm] UploadKmlRequest request)
        {
            if (request.File == null || request.File.Length == 0)
                return BadRequest("No file uploaded.");

            if (request.RouteId <= 0)
                return BadRequest("Invalid routeId.");

            string kmlContent;
            using (var reader = new StreamReader(request.File.OpenReadStream()))
            {
                kmlContent = await reader.ReadToEndAsync();
            }

            var inserted = await _routeCoordinateManager.ImportCoordinatesFromKmlAsync(kmlContent, request.RouteId);

            return Ok(new
            {
                RouteId = request.RouteId,
                Inserted = inserted
            });
        }
        [HttpGet("segments/{routeId}")]
        public async Task<IActionResult> GetRouteSegments(int routeId)
        {
            if (routeId <= 0) return BadRequest("Invalid routeId.");

            var segments = await _routeCoordinateManager.GetRouteSegments(routeId);


            return Ok(new
            {
                RouteId = routeId,
                Segments = segments
            });
        }
        [HttpGet("{routeId}")]
        public async Task<ActionResult> GetRouteCoordinates(int routeId)
        {
            return Ok(await _routeCoordinateManager.GetRouteCoordinates(routeId));
        }
        

    }
}

