using BusTripManagement.API.Hubs;
using BusTripManagement.BAL;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;

namespace BusTripManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RouteTrackingController : Controller
    {

        private readonly IRouteTrackingManager _routeTrackingManager;
        private readonly IHubContext<LiveLocationHub> _hubContext;

        public RouteTrackingController(IRouteTrackingManager trackingManager, IHubContext<LiveLocationHub> hubContext)
        {
            _routeTrackingManager = trackingManager;
            _hubContext = hubContext;
        }

        //temporary for testing
        [HttpPost("reset")]
        public async Task<IActionResult> Reset([FromBody] int routeId)
        {
            _routeTrackingManager.ResetRoute(routeId);

            var groupName = $"route-{routeId}";
            await _hubContext.Clients.Group(groupName).SendAsync("resetRouteStatus", null);
            return Ok(new { message = $"Route {routeId} reset" });
        }
    }

}

