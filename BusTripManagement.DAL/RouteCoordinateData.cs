using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BusTripManagement.Models;

namespace BusTripManagement.DAL
{
    public class RouteCoordinateData
    {
        private readonly DbService _dbService;

        public RouteCoordinateData(DbService dbService)
        {
            _dbService = dbService;
        }
        public async Task<int> InsertCoordinatesAsync(IEnumerable<RouteCoordinate> coords)
        {
            var table = new DataTable();
            table.Columns.Add("routeId", typeof(int));
            table.Columns.Add("sequence", typeof(int));
            table.Columns.Add("lat", typeof(decimal));
            table.Columns.Add("lng", typeof(decimal));

            foreach (var coord in coords)
            {
                table.Rows.Add(coord.RouteId, coord.Sequence, coord.Lat, coord.Lng);
            }

            var parameters = new DynamicParameters();
            parameters.Add("@Coordinates", table.AsTableValuedParameter("dbo.RouteCoordinateType"));

            return await _dbService.ExecuteAsync("usp_InsertRouteCoordinates", parameters);
        }
        public async Task<IEnumerable<RouteCoordinate>> GetCoordinatesAsync(int routeId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@route_Id", routeId, DbType.Int32);

            return await _dbService.QueryAsync<RouteCoordinate>("usp_GetRouteCoordinates", parameters);
        }
    }
}
