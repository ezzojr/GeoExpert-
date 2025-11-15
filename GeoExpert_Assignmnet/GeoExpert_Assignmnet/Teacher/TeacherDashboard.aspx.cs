using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GeoExpert_Assignment.Teacher
{
    public partial class TeacherDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Allow both Admin and Teacher
            if (Session["Role"] == null ||
                (Session["Role"].ToString() != "Teacher" && Session["Role"].ToString() != "Admin"))
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadTeacherStats();
                LoadRecentQuizzes();
            }
        }

        private void LoadTeacherStats()
        {
            int teacherId = Convert.ToInt32(Session["UserID"]); // ✅ FIXED: Use UserID not Username

            // 1️⃣ Total quizzes by this teacher
            string query1 = "SELECT COUNT(*) FROM Quizzes WHERE CreatedBy = @CreatedBy";
            litMyQuizzes.Text = DBHelper.ExecuteScalar(query1, new SqlParameter[] {
                new SqlParameter("@CreatedBy", teacherId)
            }).ToString();

            // 2️⃣ Countries covered
            string query2 = @"
                SELECT COUNT(DISTINCT C.CountryID)
                FROM Quizzes Q
                INNER JOIN Countries C ON Q.CountryID = C.CountryID
                WHERE Q.CreatedBy = @CreatedBy";
            litCountriesCovered.Text = DBHelper.ExecuteScalar(query2, new SqlParameter[] {
                new SqlParameter("@CreatedBy", teacherId)
            }).ToString();

            // 3️⃣ Average questions per quiz
            string query3 = @"
                SELECT ISNULL(AVG(COUNT_O), 0)
                FROM (
                    SELECT COUNT(O.OptionID) AS COUNT_O
                    FROM QuizOptions O
                    INNER JOIN Quizzes Q ON O.QuizID = Q.QuizID
                    WHERE Q.CreatedBy = @CreatedBy
                    GROUP BY Q.QuizID
                ) AS X";
            object avg = DBHelper.ExecuteScalar(query3, new SqlParameter[] {
                new SqlParameter("@CreatedBy", teacherId)
            });
            litAvgQuestions.Text = avg != DBNull.Value ? Convert.ToDecimal(avg).ToString("0.0") : "0";

            // 4️⃣ Most recent quiz
            string query4 = "SELECT TOP 1 Question FROM Quizzes WHERE CreatedBy = @CreatedBy ORDER BY QuizID DESC";
            object recent = DBHelper.ExecuteScalar(query4, new SqlParameter[] {
                new SqlParameter("@CreatedBy", teacherId)
            });
            litRecentQuiz.Text = recent != null ? recent.ToString() : "None yet";
        }

        private void LoadRecentQuizzes()
        {
            int teacherId = Convert.ToInt32(Session["UserID"]); // ✅ FIXED

            string query = @"
                SELECT TOP 5 Q.QuizID, C.Name AS CountryName, Q.Question, Q.CreatedDate
                FROM Quizzes Q
                INNER JOIN Countries C ON Q.CountryID = C.CountryID
                WHERE Q.CreatedBy = @CreatedBy
                ORDER BY Q.CreatedDate DESC";

            SqlParameter[] parameters = { new SqlParameter("@CreatedBy", teacherId) };
            DataTable dt = DBHelper.ExecuteReader(query, parameters);

            gvMyQuizzes.DataSource = dt;
            gvMyQuizzes.DataBind();
        }
    }
}
