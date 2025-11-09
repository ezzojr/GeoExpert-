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
                LoadCountryDetails();
            }
        }

        private void LoadCountryDetails()
        {
            // TODO: Get country ID from query string and display details
            if (Request.QueryString["id"] != null)
            {
                int countryId = Convert.ToInt32(Request.QueryString["id"]);

                string query = "SELECT * FROM Countries WHERE CountryID = @CountryID";
                SqlParameter[] parameters = {
                    new SqlParameter("@CountryID", countryId)
                };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    litCountryName.Text = row["Name"].ToString();
                    litFoodName.Text = row["FoodName"].ToString();
                    litFoodDesc.Text = row["FoodDescription"].ToString();
                    litCulture.Text = row["CultureInfo"].ToString();
                    litFunFact.Text = row["FunFact"].ToString();

                    // Embed video if URL exists
                    if (!string.IsNullOrEmpty(row["VideoURL"].ToString()))
                    {
                        litVideo.Text = $"<iframe width='560' height='315' src='{row["VideoURL"]}' frameborder='0' allowfullscreen></iframe>";
                    }
                }
            }

        }
        protected void btnView_Click(object sender, EventArgs e)
        {
            int countryId = Convert.ToInt32(Request.QueryString["id"]);

            string query = "UPDATE Countries SET ViewCount = ViewCount + 1 WHERE CountryID = @CountryID";
            SqlParameter[] parameters = {
        new SqlParameter("@CountryID", countryId)
    };
            DBHelper.ExecuteNonQuery(query, parameters);
        }
    }
}