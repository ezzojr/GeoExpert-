using System;
using System.Data;
using System.Data.SqlClient;

public class DBHelper
{
    // -UPDATE THIS CONNECTION STRING WITH YOUR SQL SERVER DETAILS
    private static string connString = @"Data Source=(LocalDB)\MSSQLLocalDB;
                                    AttachDbFilename=|DataDirectory|\GeoExpertDB.mdf;
                                    Integrated Security=True;
                                    Connect Timeout=30";

    // Alternative if using SQL Server Express:
    // private static string connString = @"Data Source=.\SQLEXPRESS;Initial Catalog=GeoExpertDB;Integrated Security=True";

    public static SqlConnection GetConnection()
    {
        return new SqlConnection(connString);
    }

    // Execute INSERT, UPDATE, DELETE
    public static int ExecuteNonQuery(string query, SqlParameter[] parameters = null)
    {
        using (SqlConnection conn = GetConnection())
        {
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }
    }

    // Execute SELECT for single value (COUNT, MAX, etc.)
    public static object ExecuteScalar(string query, SqlParameter[] parameters = null)
    {
        using (SqlConnection conn = GetConnection())
        {
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                conn.Open();
                return cmd.ExecuteScalar();
            }
        }
    }

    // Execute SELECT for multiple rows
    public static DataTable ExecuteReader(string query, SqlParameter[] parameters = null)
    {
        using (SqlConnection conn = GetConnection())
        {
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                return dt;
            }
        }
    }

    // ==================== MEMBER A METHODS ====================
    // Added by Member A - Dynamic Homepage

    public static DataTable GetTopViewedCountries(int count)
    {
        string query = "SELECT TOP (@Count) Name, FlagImage, ViewCount FROM Countries ORDER BY ViewCount DESC";
        SqlParameter[] parameters = { new SqlParameter("@Count", count) };
        return ExecuteReader(query, parameters);
    }

    public static int GetTotalCount(string tableName)
    {
        string query = $"SELECT COUNT(*) FROM {tableName}";
        return Convert.ToInt32(ExecuteScalar(query));
    }
}
