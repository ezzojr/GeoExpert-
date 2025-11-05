using System;
using System.Collections.Generic;
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
            
            string query = "SELECT CountryID, Name, FoodName, FunFact FROM Countries WHERE 1 = 1";

            List<SqlParameter> parameters = new List<SqlParameter>();

            // Search active
            if (!string.IsNullOrWhiteSpace(searchQuery))
            {
                query += " AND Name LIKE @Search";

                parameters.Add(new SqlParameter("@Search", "%" + searchQuery + "%"));
            }

            if (!string.IsNullOrWhiteSpace(region))
            {
                query += " ANd Region = @Region";

                parameters.Add( new SqlParameter("@Region", region ));
            }

            DataTable countries = DBHelper.ExecuteReader(query, parameters.ToArray());
            rptCountries.DataSource = countries;
            rptCountries.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            LoadCountries(searchTerm);
        }

        protected void regionFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            string region = regionFilter.SelectedValue;
            LoadCountries(txtSearch.Text, region);
        }

        protected void rptCountries_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {

        }
    }
}