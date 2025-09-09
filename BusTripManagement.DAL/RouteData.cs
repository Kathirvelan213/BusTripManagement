using Dapper;
using FarmersGrid.DAL;
using System.Data;
using System.Text;
using YourNamespace.Models; // adjust namespace
namespace YourNamespace.DAL
{
    public class RoutesData
    {
        private readonly DbService _dbService;

        public RoutesData(DbService dbService)
        {
            _dbService = dbService;
        }

        public async Task<IEnumerable<Route>> GetRoutes()
        {
            return await _dbService.QueryAsync<Route>("usp_GetRoutes", null);
        }

        public async Task<Route?> GetRouteById(int routeId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@route_id", routeId);
            return await _dbService.QueryFirstOrDefaultAsync<Route>("usp_GetRouteById", parameters);
        }

        public async Task<int> CreateRoute(string name, string destination)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@name", name);
            parameters.Add("@destination", destination);

            return await _dbService.ExecuteScalarAsync<int>("usp_CreateRoute", parameters);
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
