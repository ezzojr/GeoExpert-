using System;
using System.Collections.Generic;
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
                // Check if user is logged in
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadQuiz();
            }
        }

        private void LoadQuiz()
        {
            if (Request.QueryString["countryid"] != null)
            {
                int countryId = Convert.ToInt32(Request.QueryString["countryid"]);
                int userId = Convert.ToInt32(Session["UserID"]);

                // Get country name for header
                string countryQuery = "SELECT Name FROM Countries WHERE CountryID = @CountryID";
                SqlParameter[] countryParams = {
            new SqlParameter("@CountryID", countryId)
        };
                object countryNameObj = DBHelper.ExecuteScalar(countryQuery, countryParams);
                string countryName = countryNameObj != null ? countryNameObj.ToString() : "Unknown Country";

                // Get quiz questions for this country
                string query = "SELECT QuizID, Question FROM Quizzes WHERE CountryID = @CountryID";
                SqlParameter[] parameters = {
            new SqlParameter("@CountryID", countryId)
        };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);

                if (dt.Rows.Count > 0)
                {
                    // Check cooldown for first quiz (24-hour rule)
                    int firstQuizId = Convert.ToInt32(dt.Rows[0]["QuizID"]);

                    // Check if user can take this quiz
                    string cooldownQuery = @"SELECT MAX(CompletedDate) FROM UserProgress 
                                    WHERE UserID = @UserID AND QuizID = @QuizID";
                    SqlParameter[] cooldownParams = {
                new SqlParameter("@UserID", userId),
                new SqlParameter("@QuizID", firstQuizId)
            };

                    object lastAttempt = DBHelper.ExecuteScalar(cooldownQuery, cooldownParams);

                    if (lastAttempt != null && lastAttempt != DBNull.Value)
                    {
                        DateTime lastDate = Convert.ToDateTime(lastAttempt);
                        TimeSpan diff = DateTime.Now - lastDate;

                        if (diff.TotalHours < 24)
                        {
                            // Show cooldown message
                            int hoursLeft = 24 - (int)diff.TotalHours;
                            int minutesLeft = 60 - diff.Minutes;

                            pnlCooldown.Visible = true;
                            litCooldownTime.Text = $"{hoursLeft} hours and {minutesLeft} minutes";

                            pnlQuizHeader.Visible = false;
                            pnlQuiz.Visible = false;
                            pnlNoQuiz.Visible = false;
                            return;
                        }
                    }

                    // Show quiz
                    pnlQuizHeader.Visible = true;
                    pnlQuiz.Visible = true;
                    pnlCooldown.Visible = false;
                    pnlNoQuiz.Visible = false;

                    // Set header info
                    litCountryName.Text = countryName;
                    litProgress.Text = $"{dt.Rows.Count} Questions";

                    // Load questions
                    rptQuestions.DataSource = dt;
                    rptQuestions.DataBind();
                }
                else
                {
                    // No quizzes available
                    pnlNoQuiz.Visible = true;
                    pnlQuizHeader.Visible = false;
                    pnlQuiz.Visible = false;
                    pnlCooldown.Visible = false;
                }
            }
            else
            {
                Response.Redirect("Countries.aspx");
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // Load options for each question
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
            //  Calculate score and save to database
            int score = 0;
            int totalQuestions = 0;
            int firstQuizId = 0;

            // Store for results page
            List<QuizReviewItem> reviewItems = new List<QuizReviewItem>();

            foreach (RepeaterItem item in rptQuestions.Items)
            {
                HiddenField hfQuizID = (HiddenField)item.FindControl("hfQuizID");
                RadioButtonList rblOptions = (RadioButtonList)item.FindControl("rblOptions");

                if (!string.IsNullOrEmpty(rblOptions.SelectedValue))
                {
                    totalQuestions++;
                    int quizId = Convert.ToInt32(hfQuizID.Value);
                    int selectedOptionId = Convert.ToInt32(rblOptions.SelectedValue);

                    if (firstQuizId == 0) firstQuizId = quizId;

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

                    // Get question details for review
                    string questionQuery = "SELECT Question FROM Quizzes WHERE QuizID = @QuizID";
                    SqlParameter[] questionParams = { new SqlParameter("@QuizID", quizId) };
                    string questionText = DBHelper.ExecuteScalar(questionQuery, questionParams).ToString();

                    string correctAnswerQuery = "SELECT OptionText FROM QuizOptions WHERE QuizID = @QuizID AND IsCorrect = 1";
                    SqlParameter[] correctParams = { new SqlParameter("@QuizID", quizId) };
                    string correctAnswer = DBHelper.ExecuteScalar(correctAnswerQuery, correctParams).ToString();

                    reviewItems.Add(new QuizReviewItem
                    {
                        Question = questionText,
                        UserAnswer = rblOptions.SelectedItem.Text,
                        CorrectAnswer = correctAnswer,
                        IsCorrect = isCorrect
                    });
                }
            }

            // Save progress to database if user is logged in
            if (Session["UserID"] != null && firstQuizId > 0)
            {
                int userId = Convert.ToInt32(Session["UserID"]);

                string insertQuery = "INSERT INTO UserProgress (UserID, QuizID, Score, TotalQuestions, CompletedDate) VALUES (@UserID, @QuizID, @Score, @Total, GETDATE())";
                SqlParameter[] insertParams = {
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@QuizID", firstQuizId),
                    new SqlParameter("@Score", score),
                    new SqlParameter("@Total", totalQuestions)
                };

                DBHelper.ExecuteNonQuery(insertQuery, insertParams);

                // Award badge if perfect score
                if (score == totalQuestions && totalQuestions > 0)
                {
                    AwardBadge(userId, "Perfect Score");
                }
            }

            // Store results in session
            Session["QuizScore"] = score;
            Session["QuizTotal"] = totalQuestions;
            Session["QuizReview"] = reviewItems;

            // Redirect to results page
            Response.Redirect("QuizResult.aspx");
        }

        private void AwardBadge(int userId, string badgeName)
        {
            //  Check if badge already exists
            string checkQuery = "SELECT COUNT(*) FROM Badges WHERE UserID = @UserID AND BadgeName = @BadgeName";
            SqlParameter[] checkParams = {
                new SqlParameter("@UserID", userId),
                new SqlParameter("@BadgeName", badgeName)
            };

            int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkQuery, checkParams));

            if (count == 0)
            {
                string insertQuery = "INSERT INTO Badges (UserID, BadgeName, BadgeDescription, AwardedDate) VALUES (@UserID, @BadgeName, @Description, GETDATE())";
                SqlParameter[] insertParams = {
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@BadgeName", badgeName),
                    new SqlParameter("@Description", "Achieved a perfect score on a quiz!")
                };

                DBHelper.ExecuteNonQuery(insertQuery, insertParams);
            }
        }
    }

    // Helper class to store review items
    public class QuizReviewItem
    {
        public string Question { get; set; }
        public string UserAnswer { get; set; }
        public string CorrectAnswer { get; set; }
        public bool IsCorrect { get; set; }
    }
}
