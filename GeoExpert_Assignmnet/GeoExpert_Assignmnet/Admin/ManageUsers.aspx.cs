using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Admin
{
    public partial class ManageUsers : Page
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
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            // TODO: Member D - Load all users
            string query = "SELECT UserID, Username, Email, Role, CurrentStreak, CreatedDate FROM Users ORDER BY CreatedDate DESC";
            DataTable dt = DBHelper.ExecuteReader(query);
            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUser")
            {
                // TODO: Member D - Delete user
                int userId = Convert.ToInt32(e.CommandArgument);

                // Prevent deleting yourself
                if (Session["UserID"] != null && userId == Convert.ToInt32(Session["UserID"]))
                {
                    lblMessage.Text = "You cannot delete your own account!";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                string query = "DELETE FROM Users WHERE UserID = @UserID";
                SqlParameter[] parameters = {
                    new SqlParameter("@UserID", userId)
                };

                int result = DBHelper.ExecuteNonQuery(query, parameters);

                if (result > 0)
                {
                    lblMessage.Text = "User deleted successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    LoadUsers();
                }
            }
        }
    }
}