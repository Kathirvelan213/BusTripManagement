using BusTripManagement.DAL;
using BusTripManagement.Models;

namespace BusTripManagement.BAL
{
    public class BusRoutesManager
    {
        private readonly BusRouteData _routesData;

        public BusRoutesManager(BusRouteData routesData)
        {
            _routesData = routesData;
        }

        public async Task<IEnumerable<BusRoute>> GetRoutes()
        {
            return await _routesData.GetRoutes();
        }

        public async Task<BusRoute?> GetRouteById(int routeId)
        {
            return await _routesData.GetRouteById(routeId);
        }

        public async Task<int> CreateRoute(string name, string destination)
        {
            return await _routesData.CreateRoute(name, destination);
        }

        public async Task<int> UpdateRoute(int routeId, string name, string destination)
        {
            return await _routesData.UpdateRoute(routeId, name, destination);
        }

        public async Task<int> DeleteRoute(int routeId)
        {
            return await _routesData.DeleteRoute(routeId);
        }
    }
}
