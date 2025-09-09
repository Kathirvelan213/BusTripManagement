using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusTripManagement.Models
{
    public class Stop
    {
        public int StopId { get; set; }         
        public string Name { get; set; } = null!;
        public decimal Lat { get; set; }
        public decimal Lng { get; set; }
    }
}

