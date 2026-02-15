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

        // Hide actions for current logged-in admin
        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView drv = (DataRowView)e.Row.DataItem;
                int rowUserId = Convert.ToInt32(drv["UserID"]);
                int currentUserId = Convert.ToInt32(Session["UserID"]);

                // Hide action buttons if this row is the current logged-in admin
                if (rowUserId == currentUserId)
                {
                    Panel pnlActions = (Panel)e.Row.FindControl("pnlActions");
                    if (pnlActions != null)
                    {
                        pnlActions.Visible = false;
                    }
                }
            }
        }

        private void LoadUsers(string search = "")
        {
            string query = @"
                SELECT U.UserID, U.Username, U.Email, U.Role, U.CurrentStreak, U.CreatedDate
                FROM Users U";

            SqlParameter[] parameters = null;
            if (!string.IsNullOrEmpty(search))
            {
                query += " WHERE U.Username LIKE @Search OR U.Email LIKE @Search";
                parameters = new SqlParameter[] { new SqlParameter("@Search", "%" + search + "%") };
            }

            query += " ORDER BY U.CreatedDate DESC";

            DataTable dt = DBHelper.ExecuteReader(query, parameters);
            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text.Trim());
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadUsers();
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            int userId;
            if (!int.TryParse(hfTargetUserId.Value, out userId))
            {
                lblMessage.Text = "Invalid user selected.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // Prevent deleting self
            if (Session["UserID"] != null && userId == Convert.ToInt32(Session["UserID"]))
            {
                lblMessage.Text = "❌ You cannot delete your own account.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            DeleteUserById(userId);
        }

        protected void btnConfirmChangeRole_Click(object sender, EventArgs e)
        {
            int userId;
            if (!int.TryParse(hfTargetUserId.Value, out userId))
            {
                lblMessage.Text = "Invalid user selected.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string newRole = hfNewRole.Value;
            if (string.IsNullOrEmpty(newRole))
            {
                lblMessage.Text = "Invalid role selected.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // Prevent changing your own role
            if (Session["UserID"] != null && userId == Convert.ToInt32(Session["UserID"]))
            {
                lblMessage.Text = "❌ You cannot change your own role.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            ChangeUserRole(userId, newRole);
        }

        private void DeleteUserById(int userId)
        {
            string query = "DELETE FROM Users WHERE UserID = @UserID";
            SqlParameter[] parameters = { new SqlParameter("@UserID", userId) };

            int result = DBHelper.ExecuteNonQuery(query, parameters);
            if (result > 0)
            {
                lblMessage.Text = "🗑️ User deleted successfully!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                LoadUsers();
            }
            else
            {
                lblMessage.Text = "Error deleting user.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        private void ChangeUserRole(int userId, string newRole)
        {
            // Validate role
            if (newRole != "User" && newRole != "Teacher" && newRole != "Admin")
            {
                lblMessage.Text = "Invalid role.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string updateQ = "UPDATE Users SET Role = @Role WHERE UserID = @UserID";
            SqlParameter[] updParams = {
                new SqlParameter("@Role", newRole),
                new SqlParameter("@UserID", userId)
            };

            int rows = DBHelper.ExecuteNonQuery(updateQ, updParams);
            if (rows > 0)
            {
                lblMessage.Text = $"✅ Role changed to {newRole}!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                LoadUsers();
            }
            else
            {
                lblMessage.Text = "Error updating role.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}