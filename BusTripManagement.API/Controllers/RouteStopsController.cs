using BusTripManagement.BAL;
using BusTripManagement.Models;
using Microsoft.AspNetCore.Mvc;

namespace BusTripManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RouteStopsController : ControllerBase
    {
        private readonly RouteStopsManager _routeStopsManager;

        public record CreateStopRouteDTO(int RouteId, int StopId, int Sequence);
        public record UpdateStopRouteDTO(int StopRouteId, int Sequence);

        public RouteStopsController(RouteStopsManager stopsRoutesManager)
        {
            _routeStopsManager = stopsRoutesManager;
        }

        [HttpGet("for-route/{routeId}")]
        public async Task<IEnumerable<RouteStop>> GetStopsForRoute(int routeId)
        {
            return await _routeStopsManager.GetStopsForRoute(routeId);
        }

        [HttpPost("create")]
        public async Task<int> CreateRouteStops([FromBody] CreateStopRouteDTO dto)
        {
            return await _routeStopsManager.CreateStopRoute(dto.RouteId, dto.StopId, dto.Sequence);
        }

        [HttpPut("update")]
        public async Task<int> UpdateRouteStops([FromBody] UpdateStopRouteDTO dto)
        {
            return await _routeStopsManager.UpdateStopRoute(dto.StopRouteId, dto.Sequence);
        }

        [HttpDelete("delete/{stopRouteId}")]
        public async Task<int> DeleteStopRoute(int stopRouteId)
        {
            return await _routeStopsManager.DeleteStopRoute(stopRouteId);
        }
    }
}
