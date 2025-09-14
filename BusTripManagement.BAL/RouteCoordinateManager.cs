using BusTripManagement.DAL;
using BusTripManagement.Models;
using System.Xml.Linq;

namespace BusTripManagement.BAL
{
    public class RouteCoordinateManager
    {
        private readonly RouteCoordinateData _routeCoordinateData;

        public RouteCoordinateManager(RouteCoordinateData routeCoordinateData)
        {
            _routeCoordinateData = routeCoordinateData;
        }

        public async Task<int> ImportCoordinatesFromKmlAsync(string kml, int routeId)
        {
            var coords = ParseKml(kml, routeId);
            return await _routeCoordinateData.InsertCoordinatesAsync(coords);
        }

        private List<RouteCoordinate> ParseKml(string kml, int routeId)
        {
            var doc = XDocument.Parse(kml);
            var coords = new List<RouteCoordinate>();
            int seq = 1;

            foreach (var line in doc.Descendants().Where(x => x.Name.LocalName == "coordinates"))
            {
                var coordText = line.Value.Trim();
                var coordPairs = coordText.Split(
                    new[] { ' ', '\n', '\r', '\t' },
                    StringSplitOptions.RemoveEmptyEntries);

                foreach (var pair in coordPairs)
                {
                    var parts = pair.Split(',');
                    if (parts.Length >= 2 &&
                        double.TryParse(parts[1], out var lat) &&
                        double.TryParse(parts[0], out var lon))
                    {
                        coords.Add(new RouteCoordinate
                        {
                            RouteId = routeId,
                            Sequence = seq++,
                            Lat = (decimal)lat,
                            Lng = (decimal)lon
                        });
                    }
                }
            }

            return coords;
        }
        public async Task<List<List<RouteCoordinate>>> GetRouteSegments(int routeId)
        {
            var coords = await _routeCoordinateData.GetCoordinatesAsync(routeId);
            var segments = ProcessCoordinates(coords.ToList());

            return coords != null ? segments : new List<List<RouteCoordinate>>();
        }

        private List<List<RouteCoordinate>> ProcessCoordinates(List<RouteCoordinate> coords)
        {
            var segments = new List<List<RouteCoordinate>>();
            var current = new List<RouteCoordinate>();

            const double loopTolerance = 8.0; // meters
            const double jumpThreshold = 300.0; // meters

            RouteCoordinate prev = null;
            foreach (var c in coords.OrderBy(c => c.Sequence))
            {
                if (prev != null)
                {
                    var dist = _DistanceInMeters((double)prev.Lat, (double)prev.Lng, (double)c.Lat, (double)c.Lng);
                    if (dist >= jumpThreshold)
                    {
                        // split segment here
                        if (current.Count > 1 &&
                            _DistanceInMeters((double)current.First().Lat, (double)current.First().Lng,
                                             (double)current.Last().Lat, (double)current.Last().Lng) <= loopTolerance)
                        {
                            current.RemoveAt(current.Count - 1); // remove closing loop
                        }

                        if (current.Count > 0)
                            segments.Add(current); // save segment
                        current = new List<RouteCoordinate>(); // start new segment
                    }
                }

                current.Add(c);
                prev = c;
            }

            // finalize last segment
            if (current.Count > 0)
            {
                if (current.Count > 1 &&
                    _DistanceInMeters((double)current.First().Lat, (double)current.First().Lng,
                                     (double)current.Last().Lat, (double)current.Last().Lng) <= loopTolerance)
                {
                    current.RemoveAt(current.Count - 1);
                }
                segments.Add(current);
            }

            return segments;
        }


        private double _DistanceInMeters(double lat1, double lon1, double lat2, double lon2)
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
        public async Task<List<RouteCoordinate>> GetRouteCoordinates(int routeId)
        {
            return await _routeCoordinateData.GetCoordinatesAsync(routeId);
        }

    }
}
