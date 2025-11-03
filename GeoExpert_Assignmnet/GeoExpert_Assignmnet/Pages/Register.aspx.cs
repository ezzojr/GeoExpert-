using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace GeoExpert_Assignment.Pages
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // TODO: Member C - Implement registration logic
            // 1. Validate all fields
            // 2. Check if username already exists
            // 3. Insert new user into database
            // 4. Show success message and redirect to login

            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Check if username already exists
            string checkQuery = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
            SqlParameter[] checkParams = {
                new SqlParameter("@Username", username)
            };

            int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkQuery, checkParams));

            if (count > 0)
            {
                lblMessage.Text = "Username already exists!";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // Insert new user
            string insertQuery = "INSERT INTO Users (Username, Password, Email, Role) VALUES (@Username, @Password, @Email, 'User')";
            SqlParameter[] insertParams = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", password), // TODO: Hash password in production
                new SqlParameter("@Email", email)
            };

            int result = DBHelper.ExecuteNonQuery(insertQuery, insertParams);

            if (result > 0)
            {
                lblMessage.Text = "Registration successful! Redirecting to login...";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
            else
            {
                lblMessage.Text = "Registration failed. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}