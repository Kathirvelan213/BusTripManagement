using BusTripManagement.BAL;
using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace BusTripManagement.API.Hubs
{
    public class LiveLocationHub : Hub
    {
        private IRouteTrackingManager _routeTrackingManager;

        public LiveLocationHub(IRouteTrackingManager routeTrackingManager)
        {
            _routeTrackingManager = routeTrackingManager;
        }
        public override async Task OnConnectedAsync()
        {
            await Clients.Caller.SendAsync("receiveAcknowledgement", null);
        }

        public async Task JoinRouteGroup(int routeId)
        {
            var groupName = $"route-{routeId}";
            await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
        }

        /// Client unsubscribes from a route group.
        public async Task LeaveRouteGroup(int routeId)
        {
            var groupName = $"route-{routeId}";
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupName);
        }

        /// Bus (or server) sends live location to route clients.
        public async Task SendLocationUpdate(int routeId, double latitude, double longitude)
        {
            var groupName = $"route-{routeId}";
            Console.WriteLine($"Route {routeId} location: {latitude}, {longitude}");

            StopReachedResult stopReachedResult =await _routeTrackingManager.ProcessLocation(routeId, latitude, longitude);
            if(stopReachedResult!=null){
                await NotifyStopReached(stopReachedResult);
            }

            await Clients.Group(groupName).SendAsync("receiveLocationUpdate", new
            {
                RouteId = routeId,
                Latitude = latitude,
                Longitude = longitude
            });
        }

        /// Server notifies that a bus has reached a stop in a route.
        public async Task NotifyStopReached(StopReachedResult stopReachedResult)
        {
            var groupName = $"route-{stopReachedResult.RouteId}";
            Console.WriteLine($"Route {stopReachedResult.RouteId} reached stop #{stopReachedResult.StopNumber} - {stopReachedResult.StopName}");

            await Clients.Group(groupName).SendAsync("stopReached", stopReachedResult);
        }
    }
}
