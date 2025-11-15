using System;
using System.Data;
using System.Data.SqlClient;

namespace GeoExpert_Assignment.Admin
{
    public partial class ViewQuizzes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadQuizzes();
        }

        private void LoadQuizzes()
        {
            string query = @"
                SELECT Q.QuizID, C.Name AS CountryName, Q.Question,
                       U.Username AS CreatedBy
                FROM Quizzes Q
                INNER JOIN Countries C ON Q.CountryID = C.CountryID
                INNER JOIN Users U ON Q.CreatedBy = U.UserID
                ORDER BY C.Name, Q.QuizID";

            gvQuizzes.DataSource = DBHelper.ExecuteReader(query);
            gvQuizzes.DataBind();
        }

        protected void gvQuizzes_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewSolvers")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect("~/Teacher/ViewSolvers.aspx?quizId=" + quizId);
            }
        }
    }
}
