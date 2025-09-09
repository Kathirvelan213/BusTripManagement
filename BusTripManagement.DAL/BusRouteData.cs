using Dapper;
using BusTripManagement.Models;
using System.Data;

namespace BusTripManagement.DAL
{
    public class BusRouteData
    {
        private readonly DbService _dbService;

        public BusRouteData(DbService dbService)
        {
            _dbService = dbService;
        }

        public async Task<IEnumerable<BusRoute>> GetRoutes()
        {
            return await _dbService.QueryAsync<BusRoute>("usp_GetRoutes", new DynamicParameters());
        }

        public async Task<BusRoute?> GetRouteById(int routeId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@route_id", routeId);
            return (await _dbService.QueryAsync<BusRoute>("usp_GetRouteById", parameters)).FirstOrDefault();
        }

        public async Task<int> CreateRoute(string name, string destination)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@name", name);
            parameters.Add("@destination", destination);
            parameters.Add("ReturnValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

            return (int)(decimal)await _dbService.ExecuteScalarAsync("usp_CreateRoute", parameters);
        }

        public async Task<int> UpdateRoute(int routeId, string name, string destination)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@route_id", routeId);
            parameters.Add("@name", name);
            parameters.Add("@destination", destination);

            return await _dbService.ExecuteAsync("usp_UpdateRoute", parameters);
        }

        public async Task<int> DeleteRoute(int routeId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@route_id", routeId);

            return await _dbService.ExecuteAsync("usp_DeleteRoute", parameters);
        }
    }
}
