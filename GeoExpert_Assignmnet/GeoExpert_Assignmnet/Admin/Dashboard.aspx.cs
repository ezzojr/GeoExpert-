using System;
using System.Web.UI;

namespace GeoExpert_Assignment.Admin
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is admin
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStatistics();
            }
        }

        private void LoadStatistics()
        {
            // TODO: Member D - Load statistics from database
            litTotalUsers.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users").ToString();
            litTotalCountries.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Countries").ToString();
            litTotalQuizzes.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Quizzes").ToString();
            litTotalBadges.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Badges").ToString();
        }
    }
}