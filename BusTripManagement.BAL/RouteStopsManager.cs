using BusTripManagement.DAL;
using BusTripManagement.Models;

namespace BusTripManagement.BAL
{
    public class RouteStopsManager
    {
        private readonly RouteStopsData _routeStopsData;

        public RouteStopsManager(RouteStopsData routeStopsData)
        {
            _routeStopsData = routeStopsData;
        }

        public async Task<IEnumerable<RouteStop>> GetStopsForRoute(int routeId)
        {
            return await _routeStopsData.GetStopsForRoute(routeId);
        }

        public async Task<int> CreateStopRoute(int routeId, int stopId, int sequence)
        {
            return await _routeStopsData.CreateStopRoute(routeId, stopId, sequence);
        }

        public async Task<int> UpdateStopRoute(int stopRouteId, int sequence)
        {
            return await _routeStopsData.UpdateStopRoute(stopRouteId, sequence);
        }

        public async Task<int> DeleteStopRoute(int stopRouteId)
        {
            return await _routeStopsData.DeleteStopRoute(stopRouteId);
        }
    }
}
