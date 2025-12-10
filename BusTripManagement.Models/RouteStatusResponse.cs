using System;
using System.Collections.Generic;

namespace BusTripManagement.Models
{
    public class RouteStatusResponse
    {
        public int RouteId { get; set; }
        public int NextStopIndex { get; set; }
        public List<StopStatusInfo> ReachedStops { get; set; } = new();
    }

    public class StopStatusInfo
    {
        public int StopNumber { get; set; }
        public string StopName { get; set; } = string.Empty;
        public DateTime ReachedTime { get; set; }
    }
}
