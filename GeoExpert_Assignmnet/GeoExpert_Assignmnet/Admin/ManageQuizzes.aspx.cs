using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Admin
{
    public partial class ManageQuizzes : Page
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
                LoadCountries();
                LoadQuizzes();
            }
        }

        private void LoadCountries()
        {
            string query = "SELECT CountryID, Name FROM Countries ORDER BY Name";
            DataTable dt = DBHelper.ExecuteReader(query);
            ddlCountry.DataSource = dt;
            ddlCountry.DataTextField = "Name";
            ddlCountry.DataValueField = "CountryID";
            ddlCountry.DataBind();
            ddlCountry.Items.Insert(0, new ListItem("-- Select Country --", "0"));
        }

        private void LoadQuizzes()
        {
            string query = @"
                SELECT Q.QuizID, C.Name AS CountryName, Q.Question,
                       COUNT(O.OptionID) AS TotalOptions,
                       SUM(CASE WHEN O.IsCorrect = 1 THEN 1 ELSE 0 END) AS CorrectAnswers
                FROM Quizzes Q
                INNER JOIN Countries C ON Q.CountryID = C.CountryID
                LEFT JOIN QuizOptions O ON Q.QuizID = O.QuizID
                GROUP BY Q.QuizID, C.Name, Q.Question
                ORDER BY C.Name, Q.QuizID";

            DataTable dt = DBHelper.ExecuteReader(query);
            gvQuizzes.DataSource = dt;
            gvQuizzes.DataBind();
        }

        protected void btnAddQuiz_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlCountry.SelectedValue == "0")
                {
                    lblMessage.Text = "Please select a country!";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Validate inputs
                if (string.IsNullOrWhiteSpace(txtQuestion.Text) ||
                    string.IsNullOrWhiteSpace(txtOption1.Text) ||
                    string.IsNullOrWhiteSpace(txtOption2.Text) ||
                    string.IsNullOrWhiteSpace(txtOption3.Text) ||
                    string.IsNullOrWhiteSpace(txtOption4.Text))
                {
                    lblMessage.Text = "Please fill in all 4 options and a question.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                bool hasCorrect = chkCorrect1.Checked || chkCorrect2.Checked || chkCorrect3.Checked || chkCorrect4.Checked;
                if (!hasCorrect)
                {
                    lblMessage.Text = "Please mark at least one correct answer!";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Insert quiz question
                string quizQuery = "INSERT INTO Quizzes (CountryID, Question) VALUES (@CountryID, @Question); SELECT SCOPE_IDENTITY();";
                SqlParameter[] quizParams = {
                    new SqlParameter("@CountryID", ddlCountry.SelectedValue),
                    new SqlParameter("@Question", txtQuestion.Text)
                };

                int newQuizID = Convert.ToInt32(DBHelper.ExecuteScalar(quizQuery, quizParams));

                // Insert options
                InsertOption(newQuizID, txtOption1.Text, chkCorrect1.Checked);
                InsertOption(newQuizID, txtOption2.Text, chkCorrect2.Checked);
                InsertOption(newQuizID, txtOption3.Text, chkCorrect3.Checked);
                InsertOption(newQuizID, txtOption4.Text, chkCorrect4.Checked);

                lblMessage.Text = "✅ Quiz added successfully!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                ClearFields();
                LoadQuizzes();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        private void InsertOption(int quizId, string optionText, bool isCorrect)
        {
            if (!string.IsNullOrEmpty(optionText))
            {
                string query = "INSERT INTO QuizOptions (QuizID, OptionText, IsCorrect) VALUES (@QuizID, @OptionText, @IsCorrect)";
                SqlParameter[] parameters = {
                    new SqlParameter("@QuizID", quizId),
                    new SqlParameter("@OptionText", optionText),
                    new SqlParameter("@IsCorrect", isCorrect)
                };

                DBHelper.ExecuteNonQuery(query, parameters);
            }
        }

        protected void gvQuizzes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                string query = "DELETE FROM Quizzes WHERE QuizID = @QuizID";
                SqlParameter[] parameters = {
                    new SqlParameter("@QuizID", quizId)
                };

                int result = DBHelper.ExecuteNonQuery(query, parameters);

                if (result > 0)
                {
                    lblMessage.Text = "🗑️ Quiz deleted successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    LoadQuizzes();
                }
            }
        }

        private void ClearFields()
        {
            txtQuestion.Text = "";
            txtOption1.Text = "";
            txtOption2.Text = "";
            txtOption3.Text = "";
            txtOption4.Text = "";
            chkCorrect1.Checked = chkCorrect2.Checked = chkCorrect3.Checked = chkCorrect4.Checked = false;
            ddlCountry.SelectedIndex = 0;
        }
    }
}
