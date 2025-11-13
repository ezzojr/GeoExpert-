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
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadProfileData();
                LoadBadges();
                LoadQuizHistory();
                LoadStats();
            }
        }

        private void LoadProfileData()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            string query = "SELECT Username, Email, CurrentStreak, CreatedDate FROM Users WHERE UserID = @UserID";
            SqlParameter[] parameters = {
                new SqlParameter("@UserID", userId)
            };

            DataTable dt = DBHelper.ExecuteReader(query, parameters);

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                litUsername.Text = row["Username"].ToString();
                litEmail.Text = row["Email"].ToString();
                litStreak.Text = row["CurrentStreak"].ToString();
                litJoinDate.Text = Convert.ToDateTime(row["CreatedDate"]).ToString("MMMM yyyy");
            }
        }

        private void LoadStats()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            // Total quizzes taken
            string totalQuizzesQuery = "SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID";
            SqlParameter[] totalParams = { new SqlParameter("@UserID", userId) };
            int totalQuizzes = Convert.ToInt32(DBHelper.ExecuteScalar(totalQuizzesQuery, totalParams));
            litTotalQuizzes.Text = totalQuizzes.ToString();

            // Average score percentage
            string avgQuery = @"SELECT AVG(CAST(Score AS FLOAT) / TotalQuestions * 100) 
                               FROM UserProgress WHERE UserID = @UserID AND TotalQuestions > 0";
            SqlParameter[] avgParams = { new SqlParameter("@UserID", userId) };
            object avgResult = DBHelper.ExecuteScalar(avgQuery, avgParams);
            int avgScore = avgResult != DBNull.Value ? Convert.ToInt32(avgResult) : 0;
            litAverageScore.Text = avgScore.ToString();

            // Total badges
            string badgesQuery = "SELECT COUNT(*) FROM Badges WHERE UserID = @UserID";
            SqlParameter[] badgeParams = { new SqlParameter("@UserID", userId) };
            int totalBadges = Convert.ToInt32(DBHelper.ExecuteScalar(badgesQuery, badgeParams));
            litTotalBadges.Text = totalBadges.ToString();

            // Perfect scores
            string perfectQuery = @"SELECT COUNT(*) FROM UserProgress 
                                   WHERE UserID = @UserID AND Score = TotalQuestions AND TotalQuestions > 0";
            SqlParameter[] perfectParams = { new SqlParameter("@UserID", userId) };
            int perfectScores = Convert.ToInt32(DBHelper.ExecuteScalar(perfectQuery, perfectParams));
            litPerfectScores.Text = perfectScores.ToString();
        }

        private void LoadBadges()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            string query = @"SELECT BadgeName, BadgeDescription, AwardedDate 
                            FROM Badges WHERE UserID = @UserID 
                            ORDER BY AwardedDate DESC";
            SqlParameter[] parameters = {
                new SqlParameter("@UserID", userId)
            };

            DataTable dt = DBHelper.ExecuteReader(query, parameters);

            if (dt.Rows.Count > 0)
            {
                rptBadges.DataSource = dt;
                rptBadges.DataBind();
                pnlNoBadges.Visible = false;
            }
            else
            {
                pnlNoBadges.Visible = true;
                rptBadges.Visible = false;
            }
        }

        private void LoadQuizHistory()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            string query = @"SELECT up.CompletedDate, q.Question, up.Score, up.TotalQuestions
                            FROM UserProgress up
                            INNER JOIN Quizzes q ON up.QuizID = q.QuizID
                            WHERE up.UserID = @UserID
                            ORDER BY up.CompletedDate DESC";
            SqlParameter[] parameters = {
                new SqlParameter("@UserID", userId)
            };

            DataTable dt = DBHelper.ExecuteReader(query, parameters);
            gvProgress.DataSource = dt;
            gvProgress.DataBind();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }

        // Helper method to get badge CSS class
        protected string GetBadgeClass(string badgeName)
        {
            if (badgeName.Contains("Perfect") || badgeName.Contains("Master"))
                return "gold";
            else if (badgeName.Contains("Streak") || badgeName.Contains("Expert"))
                return "silver";
            else
                return "bronze";
        }

        // Helper method to get badge icon
        protected string GetBadgeIcon(string badgeName)
        {
            if (badgeName.Contains("Perfect"))
                return "💯";
            else if (badgeName.Contains("Streak"))
                return "🔥";
            else if (badgeName.Contains("Master"))
                return "🎓";
            else if (badgeName.Contains("Explorer"))
                return "🌍";
            else
                return "🏆";
        }

        // Helper method to get score CSS class
        protected string GetScoreClass(object score, object total)
        {
            if (score == null || total == null) return "score-low";

            int scoreValue = Convert.ToInt32(score);
            int totalValue = Convert.ToInt32(total);

            if (totalValue == 0) return "score-low";

            double percentage = (double)scoreValue / totalValue * 100;

            if (percentage == 100)
                return "score-perfect";
            else if (percentage >= 80)
                return "score-good";
            else if (percentage >= 60)
                return "score-average";
            else
                return "score-low";
        }

        // Helper method to calculate percentage
        protected int GetPercentage(object score, object total)
        {
            if (score == null || total == null) return 0;

            int scoreValue = Convert.ToInt32(score);
            int totalValue = Convert.ToInt32(total);

            if (totalValue == 0) return 0;

            return (int)((double)scoreValue / totalValue * 100);
        }

        // Helper method to get performance emoji
        protected string GetPerformanceEmoji(object score, object total)
        {
            int percentage = GetPercentage(score, total);

            if (percentage == 100)
                return "🌟 Perfect!";
            else if (percentage >= 80)
                return "🎉 Great!";
            else if (percentage >= 60)
                return "👍 Good";
            else if (percentage >= 40)
                return "📚 Keep Going";
            else
                return "💪 Try Again";
        }

        // GridView row data bound event
        protected void gvProgress_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add hover effect or additional styling if needed
                e.Row.Attributes["onmouseover"] = "this.style.backgroundColor='rgba(79, 172, 254, 0.1)'";
                e.Row.Attributes["onmouseout"] = "this.style.backgroundColor='rgba(26, 26, 46, 0.6)'";
            }
        }
    }
}
