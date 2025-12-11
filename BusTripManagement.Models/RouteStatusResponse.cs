using System;
using System.Collections.Generic;

namespace BusTripManagement.Models
{
    public class RouteStatusResponse
    {
        public int RouteId { get; set; }
        public int NextStopIndex { get; set; }
        public List<StopStatusInfo> ReachedStops { get; set; } = new();
        public LocationInfo? LastLocation { get; set; }
    }

    public class LocationInfo
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public DateTime Timestamp { get; set; }
    }

    public class StopStatusInfo
    {
        public int StopNumber { get; set; }
        public string StopName { get; set; } = string.Empty;
        public DateTime ReachedTime { get; set; }
    }
}
