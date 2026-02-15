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
                // Redirect logged-in users to Countries page
                if (Session["UserID"] != null)
                {
                    Response.Redirect("~/Pages/Countries.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return; // Important! Stop execution after redirect
                }

                // Load stats and featured countries for non-logged-in users
                LoadHomepageStats();
                LoadFeaturedCountries();
            }
        }

        // Load stats for homepage
        private void LoadHomepageStats()
        {
            try
            {
                // Get counts from database
                int countries = DBHelper.GetTotalCount("Countries");
                int quizzes = DBHelper.GetTotalCount("Quizzes");
                int users = DBHelper.GetTotalCount("Users");

                // Display with "+" sign for marketing effect
                lblCountries.Text = countries > 0 ? countries.ToString() + "+" : "50+";
                lblQuizzes.Text = quizzes > 0 ? quizzes.ToString() + "+" : "200+";
                lblUsers.Text = users > 0 ? users.ToString() + "+" : "1000+";
            }
            catch (Exception ex)
            {
                // If database fails, show default marketing numbers
                System.Diagnostics.Debug.WriteLine($"LoadHomepageStats error: {ex.Message}");
                lblCountries.Text = "50+";
                lblQuizzes.Text = "200+";
                lblUsers.Text = "1000+";
            }
        }

        // Load top 4 countries dynamically
        private void LoadFeaturedCountries()
        {
            try
            {
                DataTable dt = DBHelper.GetTopViewedCountries(4); // top 4 countries

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptCountries.DataSource = dt;
                    rptCountries.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadFeaturedCountries error: {ex.Message}");
                // Hide repeater if no data
                rptCountries.Visible = false;
            }
        }
    }
}