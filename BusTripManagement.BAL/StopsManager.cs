using BusTripManagement.DAL;
using BusTripManagement.Models;

namespace BusTripManagement.BAL
{
    public class StopsManager
    {
        private readonly StopsData _stopsData;

        public StopsManager(StopsData stopsData)
        {
            _stopsData = stopsData;
        }

        public async Task<IEnumerable<Stop>> GetStops()
        {
            return await _stopsData.GetStops();
        }

        public async Task<Stop?> GetStopById(int stopId)
        {
            return await _stopsData.GetStopById(stopId);
        }

        public async Task<int> CreateStop(string name, decimal lat, decimal lng)
        {
            return await _stopsData.CreateStop(name, lat, lng);
        }

        public async Task<int> UpdateStop(int stopId, string name, decimal lat, decimal lng)
        {
            return await _stopsData.UpdateStop(stopId, name, lat, lng);
        }

        public async Task<int> DeleteStop(int stopId)
        {
            return await _stopsData.DeleteStop(stopId);
        }
    }
}
