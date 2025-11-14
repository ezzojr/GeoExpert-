using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Pages
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string userRole = Session["Role"]?.ToString();

            // Get user info
            string userQuery = "SELECT Username, Email, Role, CurrentStreak, CreatedDate FROM Users WHERE UserID = @UserID";
            SqlParameter[] userParams = {
                new SqlParameter("@UserID", userId)
            };

            DataTable dtUser = DBHelper.ExecuteReader(userQuery, userParams);
            if (dtUser.Rows.Count > 0)
            {
                litUsername.Text = dtUser.Rows[0]["Username"].ToString();
                litEmail.Text = dtUser.Rows[0]["Email"].ToString();
                litRole.Text = dtUser.Rows[0]["Role"].ToString();
                litJoinDate.Text = Convert.ToDateTime(dtUser.Rows[0]["CreatedDate"]).ToString("MMMM dd, yyyy");

                string role = dtUser.Rows[0]["Role"].ToString();

                // Only show badges and quiz history for regular users
                if (role == "User")
                {
                    pnlUserStats.Visible = true;
                    pnlBadges.Visible = true;
                    pnlProgress.Visible = true;

                    litStreak.Text = dtUser.Rows[0]["CurrentStreak"].ToString();

                    // Load badges
                    LoadBadges(userId);

                    // Load quiz progress
                    LoadProgress(userId);
                }
                else
                {
                    // Teachers and Admins don't see badges/progress
                    pnlUserStats.Visible = false;
                    pnlBadges.Visible = false;
                    pnlProgress.Visible = false;
                }
            }
        }

        private void LoadBadges(int userId)
        {
            string badgeQuery = "SELECT BadgeName, BadgeDescription, AwardedDate FROM Badges WHERE UserID = @UserID ORDER BY AwardedDate DESC";
            SqlParameter[] badgeParams = {
                new SqlParameter("@UserID", userId)
            };

            DataTable dtBadges = DBHelper.ExecuteReader(badgeQuery, badgeParams);
            if (dtBadges.Rows.Count > 0)
            {
                rptBadges.DataSource = dtBadges;
                rptBadges.DataBind();
            }
            else
            {
                lblNoBadges.Visible = true;
            }
        }

        private void LoadProgress(int userId)
        {
            string progressQuery = @"
                SELECT UP.CompletedDate, Q.Question, UP.Score, UP.TotalQuestions 
                FROM UserProgress UP
                INNER JOIN Quizzes Q ON UP.QuizID = Q.QuizID
                WHERE UP.UserID = @UserID
                ORDER BY UP.CompletedDate DESC";

            SqlParameter[] progressParams = {
                new SqlParameter("@UserID", userId)
            };

            DataTable dtProgress = DBHelper.ExecuteReader(progressQuery, progressParams);
            gvProgress.DataSource = dtProgress;
            gvProgress.DataBind();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }
    }
}