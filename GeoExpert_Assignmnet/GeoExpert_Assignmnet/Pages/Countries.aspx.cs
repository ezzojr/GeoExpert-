using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace GeoExpert_Assignment.Pages
{
    public partial class Countries : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCountries();
            }
        }

        private void LoadCountries(string searchQuery = "", string region = "")
        {
            
            string query = "SELECT CountryID, Name, FoodName, FunFact, Region FROM Countries WHERE 1 = 1";

            SqlParameter[] parameters = null;

            // Search active
            if (!string.IsNullOrWhiteSpace(searchQuery))
            {
                query += " WHERE Name LIKE @Search";
            
                parameters = new SqlParameter[]
                {
                    new SqlParameter("@Search", "%" + searchQuery + "%")
                };
            }
            if (!string.IsNullOrWhiteSpace(searchQuery))
            {
                query += " WHERE Name LIKE @Search";

                parameters = new SqlParameter[]
                {
                    new SqlParameter("@Search", "%" + searchQuery + "%")
                };
            }

            DataTable countries = DBHelper.ExecuteReader(query, parameters);
            rptCountries.DataSource = countries;
            rptCountries.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            LoadCountries(searchTerm);
        }

        protected void rptCountries_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {

        }
    }
}