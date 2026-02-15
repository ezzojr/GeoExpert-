using System;
using System.Data;

namespace GeoExpert_Assignment.Admin
{
    public partial class ViewCountries : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCountries();
            }
        }

        private void LoadCountries()
        {
            string query = "SELECT CountryID, Name, Description FROM Countries ORDER BY Name";
            gvCountries.DataSource = DBHelper.ExecuteReader(query);
            gvCountries.DataBind();
        }
    }
}
