using Dapper;
using BusTripManagement.Models;
using System.Data;

namespace BusTripManagement.DAL
{
    public class RouteStopsData
    {
        private readonly DbService _dbService;

        public RouteStopsData(DbService dbService)
        {
            _dbService = dbService;
        }

        public async Task<IEnumerable<RouteStop>> GetStopsForRoute(int routeId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@route_id", routeId);
            return await _dbService.QueryAsync<RouteStop>("usp_GetStopsForRoute", parameters);
        }

        public async Task<int> CreateStopRoute(int routeId, int stopId, int sequence)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@route_id", routeId);
            parameters.Add("@stop_id", stopId);
            parameters.Add("@sequence", sequence);
            parameters.Add("ReturnValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

            return (int)(decimal)await _dbService.ExecuteScalarAsync("usp_CreateStopRoute", parameters);
        }

        public async Task<int> UpdateStopRoute(int stopRouteId, int sequence)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@stop_route_id", stopRouteId);
            parameters.Add("@sequence", sequence);

            return await _dbService.ExecuteAsync("usp_UpdateStopRoute", parameters);
        }

        public async Task<int> DeleteStopRoute(int stopRouteId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@stop_route_id", stopRouteId);

            return await _dbService.ExecuteAsync("usp_DeleteStopRoute", parameters);
        }
    }
}
