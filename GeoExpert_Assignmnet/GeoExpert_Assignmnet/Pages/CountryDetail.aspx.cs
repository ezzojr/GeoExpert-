using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GeoExpert_Assignment.Pages
{
    public partial class CountryDetail : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // ✅ Check first if the query string has "id"
                if (Request.QueryString["id"] != null)
                {
                    int countryId;

                    // ✅ Safely convert to int
                    if (int.TryParse(Request.QueryString["id"], out countryId))
                    {
                        // ✅ Increment view count
                        string updateQuery = "UPDATE Countries SET ViewCount = ISNULL(ViewCount, 0) + 1 WHERE CountryID = @CountryID";
                        SqlParameter[] param = { new SqlParameter("@CountryID", countryId) };
                        DBHelper.ExecuteNonQuery(updateQuery, param);

                        // ✅ Load the country details
                        LoadCountryDetails(); // no parameters
                    }
                    else
                    {
                        // Optional: redirect if invalid ID
                        Response.Redirect("~/Pages/Countries.aspx");
                    }
                }
                else
                {
                    // Optional: redirect if no ID in query string
                    Response.Redirect("~/Pages/Countries.aspx");
                }
            }
        }



        private void LoadCountryDetails()
        {
            // Check if a country ID exists in query string
            if (Request.QueryString["id"] == null)
                return;

            int countryId = Convert.ToInt32(Request.QueryString["id"]);

            // ✅ Increment the view count safely
            string updateQuery = "UPDATE Countries SET ViewCount = ISNULL(ViewCount, 0) + 1 WHERE CountryID = @CountryID";
            SqlParameter[] updateParams = { new SqlParameter("@CountryID", countryId) };
            DBHelper.ExecuteNonQuery(updateQuery, updateParams);

            // ✅ Fetch full country details
            string query = "SELECT * FROM Countries WHERE CountryID = @CountryID";
            SqlParameter[] selectParams = { new SqlParameter("@CountryID", countryId) };
            DataTable dt = DBHelper.ExecuteReader(query, selectParams);

            if (dt.Rows.Count == 0)
                return;

            DataRow row = dt.Rows[0];

            // ✅ Display data in literals
            litCountryName.Text = row["Name"].ToString();
            litFoodName.Text = row["FoodName"].ToString();
            litFoodDesc.Text = row["FoodDescription"].ToString();
            litCulture.Text = row["CultureInfo"].ToString();
            litFunFact.Text = row["FunFact"].ToString();

            // ✅ Embed video if available
            string videoUrl = row["VideoURL"].ToString();
            if (!string.IsNullOrEmpty(videoUrl))
            {
                litVideo.Text = $"<iframe width='560' height='315' src='{videoUrl}' frameborder='0' allowfullscreen></iframe>";
            }
            else
            {
                litVideo.Text = "<p><em>No video available for this country.</em></p>";
            }
        }

    }
}