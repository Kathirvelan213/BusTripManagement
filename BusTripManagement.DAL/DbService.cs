using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Data.SqlClient;
using System.Data;
using Dapper;

namespace FarmersGrid.DAL
{
    public class DbService
    {
        private readonly IConfiguration _config;
        private readonly string _connectionString;

        public DbService(IConfiguration config)
        {
            _config=config;
            _connectionString = config.GetConnectionString("DefaultConnectionString");
        }

        public IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }
        public async Task<IEnumerable<T>> QueryAsync<T>(string sp, DynamicParameters parameters)
        {
            using var sqlConnection = CreateConnection();
            return await sqlConnection.QueryAsync<T>(sp, parameters,commandType:CommandType.StoredProcedure);
        }

        public async Task<int> ExecuteAsync(string sp,DynamicParameters parameters)
        {
            using var SqlConnection=CreateConnection();
            return await SqlConnection.ExecuteAsync(sp, parameters, commandType:CommandType.StoredProcedure);
        }
        public async Task<Object> ExecuteScalarAsync(string sp,DynamicParameters parameters)
        {
            using var SqlConnection=CreateConnection();
            return await SqlConnection.ExecuteScalarAsync(sp, parameters, commandType:CommandType.StoredProcedure);
        }
    }
}
