using System;
using System.Data;

namespace GeoExpert_Assignment
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHomepageStats();
                LoadFeaturedCountries();
            }
        }

        // -Load stats for homepage
        private void LoadHomepageStats()
        {
            try
            {
                lblCountries.Text = DBHelper.GetTotalCount("Countries").ToString();
                lblQuizzes.Text = DBHelper.GetTotalCount("Quizzes").ToString();
                lblUsers.Text = DBHelper.GetTotalCount("Users").ToString();
            }
            catch (Exception)
            {
                lblCountries.Text = "0";
                lblQuizzes.Text = "0";
                lblUsers.Text = "0";
            }
        }

        // Load top 4 countries dynamically
        private void LoadFeaturedCountries()
        {
            DataTable dt = DBHelper.GetTopViewedCountries(4); // top 4 countries
            rptCountries.DataSource = dt;
            rptCountries.DataBind();
        }
    }
}
