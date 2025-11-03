using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Pages
{
    public partial class Quiz : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuiz();
            }
        }

        private void LoadQuiz()
        {
            // TODO: Member D - Load quiz questions for selected country
            if (Request.QueryString["countryid"] != null)
            {
                int countryId = Convert.ToInt32(Request.QueryString["countryid"]);

                string query = "SELECT QuizID, Question FROM Quizzes WHERE CountryID = @CountryID";
                SqlParameter[] parameters = {
                    new SqlParameter("@CountryID", countryId)
                };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);
                rptQuestions.DataSource = dt;
                rptQuestions.DataBind();
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // TODO: Member D - Load options for each question
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfQuizID = (HiddenField)e.Item.FindControl("hfQuizID");
                RadioButtonList rblOptions = (RadioButtonList)e.Item.FindControl("rblOptions");

                int quizId = Convert.ToInt32(hfQuizID.Value);

                string query = "SELECT OptionID, OptionText FROM QuizOptions WHERE QuizID = @QuizID";
                SqlParameter[] parameters = {
                    new SqlParameter("@QuizID", quizId)
                };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);
                rblOptions.DataSource = dt;
                rblOptions.DataTextField = "OptionText";
                rblOptions.DataValueField = "OptionID";
                rblOptions.DataBind();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // TODO: Member D - Calculate score and save to database
            int score = 0;
            int totalQuestions = 0;

            foreach (RepeaterItem item in rptQuestions.Items)
            {
                HiddenField hfQuizID = (HiddenField)item.FindControl("hfQuizID");
                RadioButtonList rblOptions = (RadioButtonList)item.FindControl("rblOptions");

                if (!string.IsNullOrEmpty(rblOptions.SelectedValue))
                {
                    totalQuestions++;
                    int selectedOptionId = Convert.ToInt32(rblOptions.SelectedValue);

                    // Check if answer is correct
                    string query = "SELECT IsCorrect FROM QuizOptions WHERE OptionID = @OptionID";
                    SqlParameter[] parameters = {
                        new SqlParameter("@OptionID", selectedOptionId)
                    };

                    bool isCorrect = Convert.ToBoolean(DBHelper.ExecuteScalar(query, parameters));
                    if (isCorrect)
                    {
                        score++;
                    }
                }
            }

            // Save progress to database if user is logged in
            if (Session["UserID"] != null)
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                int quizId = Convert.ToInt32(((HiddenField)rptQuestions.Items[0].FindControl("hfQuizID")).Value);

                string insertQuery = "INSERT INTO UserProgress (UserID, QuizID, Score, TotalQuestions) VALUES (@UserID, @QuizID, @Score, @Total)";
                SqlParameter[] insertParams = {
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@QuizID", quizId),
                    new SqlParameter("@Score", score),
                    new SqlParameter("@Total", totalQuestions)
                };

                DBHelper.ExecuteNonQuery(insertQuery, insertParams);

                // Award badge if perfect score
                if (score == totalQuestions && totalQuestions > 0)
                {
                    AwardBadge(userId, "Perfect Score");
                    litBadge.Text = "<p class='badge-alert'>🏆 Congratulations! You earned the 'Perfect Score' badge!</p>";
                }
            }

            // Display results
            litScore.Text = score.ToString();
            litTotal.Text = totalQuestions.ToString();

            pnlQuiz.Visible = false;
            pnlResults.Visible = true;
        }

        private void AwardBadge(int userId, string badgeName)
        {
            // TODO: Member D - Check if badge already exists
            string checkQuery = "SELECT COUNT(*) FROM Badges WHERE UserID = @UserID AND BadgeName = @BadgeName";
            SqlParameter[] checkParams = {
                new SqlParameter("@UserID", userId),
                new SqlParameter("@BadgeName", badgeName)
            };

            int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkQuery, checkParams));

            if (count == 0)
            {
                string insertQuery = "INSERT INTO Badges (UserID, BadgeName, BadgeDescription) VALUES (@UserID, @BadgeName, @Description)";
                SqlParameter[] insertParams = {
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@BadgeName", badgeName),
                    new SqlParameter("@Description", "Achieved a perfect score on a quiz!")
                };

                DBHelper.ExecuteNonQuery(insertQuery, insertParams);
            }
        }
    }
}