using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GeoExpert_Assignment.Pages
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // TODO: Member C - Implement login logic
            // 1. Get username and password
            // 2. Query database to verify credentials
            // 3. Create session if valid
            // 4. Redirect to appropriate page (admin or user profile)

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string query = "SELECT UserID, Username, Role FROM Users WHERE Username = @Username AND Password = @Password";
            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", password)
            };

            DataTable dt = DBHelper.ExecuteReader(query, parameters);

            if (dt.Rows.Count > 0)
            {
                // Login successful
                Session["UserID"] = dt.Rows[0]["UserID"].ToString();
                Session["Username"] = dt.Rows[0]["Username"].ToString();
                Session["Role"] = dt.Rows[0]["Role"].ToString();

                // Redirect based on role
                if (dt.Rows[0]["Role"].ToString() == "Admin")
                {
                    Response.Redirect("~/Admin/Dashboard.aspx");
                }
                else
                {
                    Response.Redirect("~/Pages/Profile.aspx");
                }
            }
            else
            {
                lblMessage.Text = "Invalid username or password!";
            }
        }
    }
}