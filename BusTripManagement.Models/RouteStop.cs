using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusTripManagement.Models
{
    public class RouteStop
    {
        public int RouteId { get; set; }
        public int StopId { get; set; }
        public int Sequence { get; set; }

        public string Name { get; set; } = "";
        public double Lat { get; set; }
        public double Lng { get; set; }
    }
}
