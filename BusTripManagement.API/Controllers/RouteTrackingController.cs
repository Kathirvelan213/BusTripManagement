using BusTripManagement.BAL;
using Microsoft.AspNetCore.Mvc;

namespace BusTripManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RouteTrackingController : Controller
    {

        private readonly IRouteTrackingManager _routeTrackingManager;

        public RouteTrackingController(IRouteTrackingManager trackingManager)
        {
            _routeTrackingManager = trackingManager;
        }

        [HttpPost("reset")]
        public IActionResult Reset(int routeId)
        {
            _routeTrackingManager.ResetRoute(routeId);
            return Ok(new { message = $"Route {routeId} reset" });

        }
    }

}

