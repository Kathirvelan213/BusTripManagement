using BusTripManagement.DAL;
using BusTripManagement.Models;
using Microsoft.Extensions.DependencyInjection;
using System.Numerics;

namespace BusTripManagement.BAL
{
    public interface IRouteTrackingManager
    {
        Task<StopReachedResult?> ProcessLocation(int routeId, double lat, double lng);
        void ResetRoute(int routeId);
        Task<RouteStatusResponse?> GetRouteStatus(int routeId);
    }

    public class RouteTrackingManager : IRouteTrackingManager
    {
        private readonly IServiceProvider _serviceProvider;

        private readonly Dictionary<int, int> _nextStopIndex = new();
        private readonly Dictionary<int, List<RouteStop>> _routeStops = new();

        public RouteTrackingManager(IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;
        }

        public async Task<StopReachedResult?> ProcessLocation(int routeId, double lat, double lng)
        {
            // Create a new scope to safely resolve scoped services
            using var scope = _serviceProvider.CreateScope();
            var _routeStopsData = scope.ServiceProvider.GetRequiredService<RouteStopsData>();
            if (!_routeStops.ContainsKey(routeId))
            {
                var routeStops = await _routeStopsData.GetStopsForRoute(routeId);
                _routeStops[routeId] = routeStops.ToList();
            }

            if (!_nextStopIndex.ContainsKey(routeId))
                _nextStopIndex[routeId] = 0; // start from first stop

            var stops = _routeStops[routeId];
            var idx = _nextStopIndex[routeId];

            if (idx >= stops.Count) return null; // already finished

            var nextStop = stops[idx];
            var distance = DistanceInMeters(lat, lng, nextStop.Lat, nextStop.Lng);

            if (distance <= 50) // threshold in meters
            {
                _nextStopIndex[routeId]++; // move to next
                return new StopReachedResult
                {
                    RouteId = routeId,
                    StopNumber = nextStop.Sequence,
                    StopName = nextStop.Name,
                    ReachedTime = DateTime.Now,
                    Reached = true
                };
            }

            return null;
        }

        public void ResetRoute(int routeId)
        {
            _nextStopIndex.Remove(routeId);
            _routeStops.Remove(routeId);
        }

        public async Task<RouteStatusResponse?> GetRouteStatus(int routeId)
        {
            // Create a new scope to safely resolve scoped services
            using var scope = _serviceProvider.CreateScope();
            var _routeStopsData = scope.ServiceProvider.GetRequiredService<RouteStopsData>();
            
            // Load stops if not already cached
            if (!_routeStops.ContainsKey(routeId))
            {
                var routeStops = await _routeStopsData.GetStopsForRoute(routeId);
                _routeStops[routeId] = routeStops.ToList();
            }

            if (!_nextStopIndex.ContainsKey(routeId))
            {
                // Route hasn't started tracking yet
                return new RouteStatusResponse
                {
                    RouteId = routeId,
                    NextStopIndex = 0,
                    ReachedStops = new List<StopStatusInfo>()
                };
            }

            var stops = _routeStops[routeId];
            var nextIndex = _nextStopIndex[routeId];
            var reachedStops = new List<StopStatusInfo>();

            // All stops before nextIndex have been reached
            for (int i = 0; i < nextIndex && i < stops.Count; i++)
            {
                reachedStops.Add(new StopStatusInfo
                {
                    StopNumber = stops[i].Sequence,
                    StopName = stops[i].Name,
                    ReachedTime = DateTime.Now // Note: We don't store actual times, using current time as placeholder
                });
            }

            return new RouteStatusResponse
            {
                RouteId = routeId,
                NextStopIndex = nextIndex,
                ReachedStops = reachedStops
            };
        }

        private double DistanceInMeters(double lat1, double lon1, double lat2, double lon2)
        {
            const double R = 6371000; // Earth's radius in meters
            var dLat = (lat2 - lat1) * Math.PI / 180;
            var dLon = (lon2 - lon1) * Math.PI / 180;
            var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                    Math.Cos(lat1 * Math.PI / 180) * Math.Cos(lat2 * Math.PI / 180) *
                    Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
            var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            return R * c;
        }
    }

    public class StopReachedResult
    {
        public int RouteId { get; set; }
        public int StopNumber { get; set; }
        public string StopName { get; set; } = string.Empty;
        public DateTime ReachedTime { get; set; }
        public bool Reached { get; set; } = false;
    }
}
