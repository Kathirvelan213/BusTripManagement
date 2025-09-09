using Dapper;
using BusTripManagement.Models;
using System.Data;

namespace BusTripManagement.DAL
{
    public class StopsData
    {
        private readonly DbService _dbService;

        public StopsData(DbService dbService)
        {
            _dbService = dbService;
        }

        public async Task<IEnumerable<Stop>> GetStops()
        {
            return await _dbService.QueryAsync<Stop>("usp_GetStops", new DynamicParameters());
        }

        public async Task<Stop?> GetStopById(int stopId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@stop_id", stopId);
            return (await _dbService.QueryAsync<Stop>("usp_GetStopById", parameters)).FirstOrDefault();
        }

        public async Task<int> CreateStop(string name, decimal lat, decimal lng)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@name", name);
            parameters.Add("@lat", lat);
            parameters.Add("@lng", lng);
            parameters.Add("ReturnValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

            return (int)(decimal)await _dbService.ExecuteScalarAsync("usp_CreateStop", parameters);
        }

        public async Task<int> UpdateStop(int stopId, string name, decimal lat, decimal lng)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@stop_id", stopId);
            parameters.Add("@name", name);
            parameters.Add("@lat", lat);
            parameters.Add("@lng", lng);

            return await _dbService.ExecuteAsync("usp_UpdateStop", parameters);
        }

        public async Task<int> DeleteStop(int stopId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@stop_id", stopId);

            return await _dbService.ExecuteAsync("usp_DeleteStop", parameters);
        }
    }
}
