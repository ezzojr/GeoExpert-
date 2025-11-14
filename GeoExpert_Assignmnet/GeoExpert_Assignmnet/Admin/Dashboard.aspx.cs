using System;
using System.Data;
using System.Web.UI;

namespace GeoExpert_Assignment.Admin
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Restrict access to admins
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStatistics();
                LoadRecentActivity();
                LoadTopCountries();
            }
        }

        private void LoadStatistics()
        {
            try
            {
                litTotalUsers.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users").ToString();
                litTotalCountries.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Countries").ToString();
                litTotalQuizzes.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Quizzes").ToString();
                litTotalBadges.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Badges").ToString();
            }
            catch (Exception ex)
            {
                Response.Write("<p style='color:red'>Error loading stats: " + ex.Message + "</p>");
            }
        }

        private void LoadRecentActivity()
        {
            string query = @"
                SELECT TOP 10 U.Username, Q.Question AS QuizName, UP.Score, UP.TotalQuestions, UP.CompletedDate
                FROM UserProgress UP
                INNER JOIN Users U ON UP.UserID = U.UserID
                INNER JOIN Quizzes Q ON UP.QuizID = Q.QuizID
                ORDER BY UP.CompletedDate DESC";

            DataTable dt = DBHelper.ExecuteReader(query);
            gvRecentActivity.DataSource = dt;
            gvRecentActivity.DataBind();
        }

        protected void btnViewCountries_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ViewCountries.aspx");
        }

        protected void btnViewQuizzes_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ViewQuizzes.aspx");
        }

        private void LoadTopCountries()
        {
            string query = @"
                SELECT TOP 5 Name, ViewCount
                FROM Countries
                ORDER BY ViewCount DESC";

            DataTable dt = DBHelper.ExecuteReader(query);
            gvTopCountries.DataSource = dt;
            gvTopCountries.DataBind();
        }
    }
}
