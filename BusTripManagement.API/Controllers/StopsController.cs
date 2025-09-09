using BusTripManagement.BAL;
using BusTripManagement.Models;
using Microsoft.AspNetCore.Mvc;

namespace BusTripManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StopsController : ControllerBase
    {
        private readonly StopsManager _stopsManager;

        public record CreateStopDTO(string Name, decimal Lat, decimal Lng);
        public record UpdateStopDTO(int StopId, string Name, decimal Lat, decimal Lng);

        public StopsController(StopsManager stopsManager)
        {
            _stopsManager = stopsManager;
        }

        [HttpGet]
        public async Task<IEnumerable<Stop>> GetStops()
        {
            return await _stopsManager.GetStops();
        }

        [HttpGet("{stopId}")]
        public async Task<Stop?> GetStopById(int stopId)
        {
            return await _stopsManager.GetStopById(stopId);
        }

        [HttpPost("create")]
        public async Task<int> CreateStop([FromBody] CreateStopDTO dto)
        {
            return await _stopsManager.CreateStop(dto.Name, dto.Lat, dto.Lng);
        }

        [HttpPut("update")]
        public async Task<int> UpdateStop([FromBody] UpdateStopDTO dto)
        {
            return await _stopsManager.UpdateStop(dto.StopId, dto.Name, dto.Lat, dto.Lng);
        }

        [HttpDelete("delete/{stopId}")]
        public async Task<int> DeleteStop(int stopId)
        {
            return await _stopsManager.DeleteStop(stopId);
        }
    }
}
