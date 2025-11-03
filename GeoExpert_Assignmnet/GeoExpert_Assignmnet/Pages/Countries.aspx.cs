using System;
using System.Data;
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

        private void LoadCountries()
        {
            // TODO: Member C - Fetch and display all countries
            string query = "SELECT CountryID, Name, FoodName, FunFact FROM Countries";
            DataTable dt = DBHelper.ExecuteReader(query);
            rptCountries.DataSource = dt;
            rptCountries.DataBind();
        }

        protected void rptCountries_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {

        }
    }
}