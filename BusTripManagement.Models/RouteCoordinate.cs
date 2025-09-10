using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusTripManagement.Models
{
   
    public class RouteCoordinate
    {
        public int CoordId { get; set; }   
        public int RouteId { get; set; }   
        public int Sequence { get; set; }  
        public decimal Lat { get; set; }   
        public decimal Lng { get; set; }   
    }

}
