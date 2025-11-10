using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
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
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // 🔹 -Password strength check
            if (password.Length < 6)
            {
                lblMessage.Text = "Password must be at least 6 characters long.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // 🔹 Check if username already exists
            string checkUserQuery = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
            SqlParameter[] userParams = { new SqlParameter("@Username", username) };
            int userCount = Convert.ToInt32(DBHelper.ExecuteScalar(checkUserQuery, userParams));

            if (userCount > 0)
            {
                lblMessage.Text = "Username already exists!";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // 🔹 Check if email already exists
            string checkEmailQuery = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
            SqlParameter[] emailParams = { new SqlParameter("@Email", email) };
            int emailCount = Convert.ToInt32(DBHelper.ExecuteScalar(checkEmailQuery, emailParams));

            if (emailCount > 0)
            {
                lblMessage.Text = "Email already registered!";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // 🔹 Hash password using SHA256
            string hashedPassword = HashPassword(password);

            // 🔹 Insert new user
            string insertQuery = @"INSERT INTO Users (Username, Password, Email, Role, CreatedDate)
                                   VALUES (@Username, @Password, @Email, 'User', GETDATE())";
            SqlParameter[] insertParams = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", hashedPassword),
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

        // 🔒 Helper method for password hashing
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
