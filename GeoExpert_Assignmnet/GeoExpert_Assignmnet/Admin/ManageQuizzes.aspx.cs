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
            // Allow only Admin or Teacher
            if (Session["Role"] == null ||
                (Session["Role"].ToString() != "Admin" && Session["Role"].ToString() != "Teacher"))
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
            string role = Session["Role"].ToString();
            string userId = Session["UserID"]?.ToString();

            string query;

            if (role == "Admin")
            {
                // Admin can view all quizzes
                query = @"
                    SELECT Q.QuizID, C.Name AS CountryName, Q.Question,
                           COUNT(O.OptionID) AS TotalOptions,
                           SUM(CASE WHEN O.IsCorrect = 1 THEN 1 ELSE 0 END) AS CorrectAnswers,
                           U.Username AS CreatedBy
                    FROM Quizzes Q
                    INNER JOIN Countries C ON Q.CountryID = C.CountryID
                    INNER JOIN Users U ON Q.CreatedBy = U.UserID
                    LEFT JOIN QuizOptions O ON Q.QuizID = O.QuizID
                    GROUP BY Q.QuizID, C.Name, Q.Question, U.Username
                    ORDER BY C.Name, Q.QuizID";
            }
            else
            {
                // Teachers can view only their own quizzes
                query = @"
                    SELECT Q.QuizID, C.Name AS CountryName, Q.Question,
                           COUNT(O.OptionID) AS TotalOptions,
                           SUM(CASE WHEN O.IsCorrect = 1 THEN 1 ELSE 0 END) AS CorrectAnswers,
                           U.Username AS CreatedBy
                    FROM Quizzes Q
                    INNER JOIN Countries C ON Q.CountryID = C.CountryID
                    INNER JOIN Users U ON Q.CreatedBy = U.UserID
                    LEFT JOIN QuizOptions O ON Q.QuizID = O.QuizID
                    WHERE Q.CreatedBy = @CreatedBy
                    GROUP BY Q.QuizID, C.Name, Q.Question, U.Username
                    ORDER BY C.Name, Q.QuizID";
            }

            SqlParameter[] param = (role == "Teacher")
                ? new SqlParameter[] { new SqlParameter("@CreatedBy", userId) }
                : null;

            DataTable dt = DBHelper.ExecuteReader(query, param);
            gvQuizzes.DataSource = dt;
            gvQuizzes.DataBind();
        }

        protected void btnAddQuiz_Click(object sender, EventArgs e)
        {
            try
            {
                string role = Session["Role"]?.ToString();
                if (role != "Admin" && role != "Teacher")
                {
                    lblMessage.Text = "Access denied.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                if (ddlCountry.SelectedValue == "0")
                {
                    lblMessage.Text = "Please select a country!";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Validate question and options
                if (string.IsNullOrWhiteSpace(txtQuestion.Text) ||
                    string.IsNullOrWhiteSpace(txtOption1.Text) ||
                    string.IsNullOrWhiteSpace(txtOption2.Text) ||
                    string.IsNullOrWhiteSpace(txtOption3.Text) ||
                    string.IsNullOrWhiteSpace(txtOption4.Text))
                {
                    lblMessage.Text = "Please fill in all question and options.";
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

                int createdBy = Convert.ToInt32(Session["UserID"]);

                // ✅ If editing an existing quiz
                if (ViewState["EditQuizID"] != null)
                {
                    int quizId = Convert.ToInt32(ViewState["EditQuizID"]);

                    // Teacher can only edit their own quizzes
                    if (role == "Teacher" && !CanTeacherModify(quizId, createdBy))
                    {
                        lblMessage.Text = "You can only edit your own quizzes.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    string updateQuery = "UPDATE Quizzes SET CountryID = @CountryID, Question = @Question WHERE QuizID = @QuizID";
                    SqlParameter[] updateParams = {
                        new SqlParameter("@CountryID", ddlCountry.SelectedValue),
                        new SqlParameter("@Question", txtQuestion.Text),
                        new SqlParameter("@QuizID", quizId)
                    };

                    DBHelper.ExecuteNonQuery(updateQuery, updateParams);

                    // Delete old options then reinsert
                    string deleteOptionsQuery = "DELETE FROM QuizOptions WHERE QuizID = @QuizID";
                    SqlParameter[] deleteParams = { new SqlParameter("@QuizID", quizId) };
                    DBHelper.ExecuteNonQuery(deleteOptionsQuery, deleteParams);

                    InsertOption(quizId, txtOption1.Text, chkCorrect1.Checked);
                    InsertOption(quizId, txtOption2.Text, chkCorrect2.Checked);
                    InsertOption(quizId, txtOption3.Text, chkCorrect3.Checked);
                    InsertOption(quizId, txtOption4.Text, chkCorrect4.Checked);

                    lblMessage.Text = "✅ Quiz updated successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    ViewState["EditQuizID"] = null;
                    btnAddQuiz.Text = "Add Quiz";
                }
                else
                {
                    // ✅ Add new quiz
                    string quizQuery = @"
                        INSERT INTO Quizzes (CountryID, Question, CreatedBy)
                        VALUES (@CountryID, @Question, @CreatedBy);
                        SELECT SCOPE_IDENTITY();";

                    SqlParameter[] quizParams = {
                        new SqlParameter("@CountryID", ddlCountry.SelectedValue),
                        new SqlParameter("@Question", txtQuestion.Text),
                        new SqlParameter("@CreatedBy", createdBy)
                    };

                    int newQuizID = Convert.ToInt32(DBHelper.ExecuteScalar(quizQuery, quizParams));

                    InsertOption(newQuizID, txtOption1.Text, chkCorrect1.Checked);
                    InsertOption(newQuizID, txtOption2.Text, chkCorrect2.Checked);
                    InsertOption(newQuizID, txtOption3.Text, chkCorrect3.Checked);
                    InsertOption(newQuizID, txtOption4.Text, chkCorrect4.Checked);

                    lblMessage.Text = "✅ Quiz added successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }

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
            int quizId = Convert.ToInt32(e.CommandArgument);
            string role = Session["Role"].ToString();
            int userId = Convert.ToInt32(Session["UserID"]);

            if (e.CommandName == "EditQuiz")
            {
                // Teacher can only edit their own quizzes
                if (role == "Teacher" && !CanTeacherModify(quizId, userId))
                {
                    lblMessage.Text = "You can only edit your own quizzes.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                LoadQuizForEdit(quizId);
            }
            else if (e.CommandName == "DeleteQuiz")
            {
                // Teacher can only delete their own quizzes
                if (role == "Teacher" && !CanTeacherModify(quizId, userId))
                {
                    lblMessage.Text = "You can only delete your own quizzes.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                string query = "DELETE FROM Quizzes WHERE QuizID = @QuizID";
                SqlParameter[] parameters = { new SqlParameter("@QuizID", quizId) };
                int result = DBHelper.ExecuteNonQuery(query, parameters);

                if (result > 0)
                {
                    lblMessage.Text = "🗑️ Quiz deleted successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    LoadQuizzes();
                }
            }
            else if (e.CommandName == "ViewSolvers")
            {
                Response.Redirect("~/Teacher/ViewSolvers.aspx?quizId=" + quizId);
            }
        }

        private void LoadQuizForEdit(int quizId)
        {
            // Load quiz details
            string query = @"
                SELECT CountryID, Question 
                FROM Quizzes 
                WHERE QuizID = @QuizID";

            SqlParameter[] param = { new SqlParameter("@QuizID", quizId) };
            DataTable dt = DBHelper.ExecuteReader(query, param);

            if (dt.Rows.Count > 0)
            {
                ddlCountry.SelectedValue = dt.Rows[0]["CountryID"].ToString();
                txtQuestion.Text = dt.Rows[0]["Question"].ToString();

                // Load options
                string optionsQuery = @"
                    SELECT OptionText, IsCorrect 
                    FROM QuizOptions 
                    WHERE QuizID = @QuizID 
                    ORDER BY OptionID";

                SqlParameter[] optionsParam = { new SqlParameter("@QuizID", quizId) };
                DataTable optionsDt = DBHelper.ExecuteReader(optionsQuery, optionsParam);

                if (optionsDt.Rows.Count >= 4)
                {
                    txtOption1.Text = optionsDt.Rows[0]["OptionText"].ToString();
                    chkCorrect1.Checked = Convert.ToBoolean(optionsDt.Rows[0]["IsCorrect"]);

                    txtOption2.Text = optionsDt.Rows[1]["OptionText"].ToString();
                    chkCorrect2.Checked = Convert.ToBoolean(optionsDt.Rows[1]["IsCorrect"]);

                    txtOption3.Text = optionsDt.Rows[2]["OptionText"].ToString();
                    chkCorrect3.Checked = Convert.ToBoolean(optionsDt.Rows[2]["IsCorrect"]);

                    txtOption4.Text = optionsDt.Rows[3]["OptionText"].ToString();
                    chkCorrect4.Checked = Convert.ToBoolean(optionsDt.Rows[3]["IsCorrect"]);
                }

                // Store QuizID in ViewState for updating
                ViewState["EditQuizID"] = quizId;
                btnAddQuiz.Text = "Update Quiz";
                lblMessage.Text = "✏️ Editing quiz... Make your changes and click 'Update Quiz'";
                lblMessage.ForeColor = System.Drawing.Color.Yellow;
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearFields();
            ViewState["EditQuizID"] = null;
            btnAddQuiz.Text = "Add Quiz";
            lblMessage.Text = "";
        }

        private bool CanTeacherModify(int quizId, int teacherId)
        {
            string query = "SELECT COUNT(*) FROM Quizzes WHERE QuizID = @QuizID AND CreatedBy = @TeacherID";
            SqlParameter[] param = {
                new SqlParameter("@QuizID", quizId),
                new SqlParameter("@TeacherID", teacherId)
            };

            int count = Convert.ToInt32(DBHelper.ExecuteScalar(query, param));
            return count > 0;
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

        protected void gvQuizzes_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}