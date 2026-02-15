using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GeoExpert_Assignment.Teacher
{
    public partial class ViewSolvers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Allow both Admin and Teacher to view
            if (Session["Role"] == null || (Session["Role"].ToString() != "Teacher" && Session["Role"].ToString() != "Admin"))
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["quizId"] != null)
                {
                    int quizId;
                    if (int.TryParse(Request.QueryString["quizId"], out quizId))
                    {
                        LoadQuizTitle(quizId);
                        LoadSolvers(quizId);
                    }
                    else
                    {
                        lblMessage.Text = "Invalid quiz ID.";
                    }
                }
                else
                {
                    lblMessage.Text = "No quiz selected.";
                }
            }
        }

        private void LoadQuizTitle(int quizId)
        {
            string query = "SELECT Question FROM Quizzes WHERE QuizID = @QuizID";
            SqlParameter[] p = { new SqlParameter("@QuizID", quizId) };

            object result = DBHelper.ExecuteScalar(query, p);
            if (result != null)
                litQuizTitle.Text = $"<h3 style='color:#00f2fe;'>Quiz: {result}</h3>";
        }

        private void LoadSolvers(int quizId)
        {
            string query = @"
        SELECT U.Username, 
               UP.Score, 
               UP.TotalQuestions,
               CAST((CAST(UP.Score AS FLOAT) / NULLIF(UP.TotalQuestions, 0) * 100) AS DECIMAL(5,2)) AS Percentage,
               UP.CompletedDate
        FROM UserProgress UP
        INNER JOIN Users U ON UP.UserID = U.UserID
        WHERE UP.QuizID = @QuizID
        ORDER BY UP.CompletedDate DESC";

            SqlParameter[] parameters = { new SqlParameter("@QuizID", quizId) };

            try
            {
                DataTable dt = DBHelper.ExecuteReader(query, parameters);

                if (dt.Rows.Count > 0)
                {
                    gvSolvers.DataSource = dt;
                    gvSolvers.DataBind();
                    lblMessage.Text = "";
                }
                else
                {
                    lblMessage.Text = "No students have solved this quiz yet.";
                    gvSolvers.DataSource = null;
                    gvSolvers.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading solvers: " + ex.Message;
            }
        }
    }
}
