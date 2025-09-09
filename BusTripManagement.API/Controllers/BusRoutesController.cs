using BusTripManagement.BAL;
using BusTripManagement.Models;
using Microsoft.AspNetCore.Mvc;

namespace BusTripManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BusRoutesController : ControllerBase
    {
        private readonly BusRoutesManager _routesManager;

        public record CreateRouteDTO(string Name, string Destination);
        public record UpdateRouteDTO(int RouteId, string Name, string Destination);

        public BusRoutesController(BusRoutesManager routesManager)
        {
            _routesManager = routesManager;
        }

        [HttpGet]
        public async Task<IEnumerable<BusRoute>> GetRoutes()
        {
            return await _routesManager.GetRoutes();
        }

        [HttpGet("{routeId}")]
        public async Task<BusRoute?> GetRouteById(int routeId)
        {
            return await _routesManager.GetRouteById(routeId);
        }

        [HttpPost("create")]
        public async Task<int> CreateRoute([FromBody] CreateRouteDTO dto)
        {
            return await _routesManager.CreateRoute(dto.Name, dto.Destination);
        }

        [HttpPut("update")]
        public async Task<int> UpdateRoute([FromBody] UpdateRouteDTO dto)
        {
            return await _routesManager.UpdateRoute(dto.RouteId, dto.Name, dto.Destination);
        }

        [HttpDelete("delete/{routeId}")]
        public async Task<int> DeleteRoute(int routeId)
        {
            return await _routesManager.DeleteRoute(routeId);
        }
    }
}
