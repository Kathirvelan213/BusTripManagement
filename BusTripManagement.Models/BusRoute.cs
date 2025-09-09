namespace BusTripManagement.Models
{
    public class BusRoute
    {
        public int RouteId { get; set; }        
        public string Name { get; set; } = null!;
        public string Destination { get; set; } = null!;
    }
}
