using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;

namespace GeoExpert_Assignment.Pages
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //- 🔹 If user is already logged in, redirect based on role
            if (Session["UserID"] != null)
            {
                RedirectByRole(Session["Role"].ToString());
            }

            // 🔹 Load saved cookie (Remember Me)
            if (!IsPostBack && Request.Cookies["RememberMe"] != null)
            {
                txtUsername.Text = Request.Cookies["RememberMe"].Value;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hashedPassword = HashPassword(password); // 🔒 Hash the entered password

            // 🔹 Check if account is locked
            string lockCheckQuery = "SELECT FailedLoginAttempts, LockoutEnd FROM Users WHERE Username = @Username";
            SqlParameter[] lockParams = { new SqlParameter("@Username", username) };
            DataTable lockDt = DBHelper.ExecuteReader(lockCheckQuery, lockParams);

            if (lockDt.Rows.Count > 0)
            {
                int failedAttempts = Convert.ToInt32(lockDt.Rows[0]["FailedLoginAttempts"]);
                object lockoutValue = lockDt.Rows[0]["LockoutEnd"];

                if (lockoutValue != DBNull.Value && Convert.ToDateTime(lockoutValue) > DateTime.Now)
                {
                    TimeSpan remaining = Convert.ToDateTime(lockoutValue) - DateTime.Now;
                    lblMessage.Text = $"Account locked. Try again in {remaining.Minutes}m {remaining.Seconds}s.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }
            }

            // 🔹 Verify credentials
            string query = "SELECT UserID, Username, Role FROM Users WHERE Username = @Username AND Password = @Password";
            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", hashedPassword)
            };

            DataTable dt = DBHelper.ExecuteReader(query, parameters);

            if (dt.Rows.Count > 0)
            {
                // ✅ Login successful → reset failed attempts
                string resetQuery = "UPDATE Users SET FailedLoginAttempts = 0, LockoutEnd = NULL WHERE Username = @Username";
                DBHelper.ExecuteNonQuery(resetQuery, new SqlParameter[] { new SqlParameter("@Username", username) });

                // Create session
                Session["UserID"] = dt.Rows[0]["UserID"].ToString();
                Session["Username"] = dt.Rows[0]["Username"].ToString();
                Session["Role"] = dt.Rows[0]["Role"].ToString();

                // 🔹 Remember Me
                if (Request.Form["rememberMe"] == "on")
                {
                    HttpCookie cookie = new HttpCookie("RememberMe", username);
                    cookie.Expires = DateTime.Now.AddDays(7);
                    Response.Cookies.Add(cookie);
                }
                else
                {
                    if (Request.Cookies["RememberMe"] != null)
                    {
                        HttpCookie cookie = new HttpCookie("RememberMe");
                        cookie.Expires = DateTime.Now.AddDays(-1);
                        Response.Cookies.Add(cookie);
                    }
                }

                // Redirect by role
                RedirectByRole(dt.Rows[0]["Role"].ToString());
            }
            else
            {
                // ❌ Wrong credentials → increase failed attempts
                string updateQuery = @"UPDATE Users 
                                       SET FailedLoginAttempts = FailedLoginAttempts + 1,
                                           LockoutEnd = CASE WHEN FailedLoginAttempts + 1 >= 3 THEN DATEADD(MINUTE, 5, GETDATE()) ELSE LockoutEnd END
                                       WHERE Username = @Username";
                DBHelper.ExecuteNonQuery(updateQuery, new SqlParameter[] { new SqlParameter("@Username", username) });

                // Get new attempt count
                string countQuery = "SELECT FailedLoginAttempts FROM Users WHERE Username = @Username";
                int attempts = Convert.ToInt32(DBHelper.ExecuteScalar(countQuery, new SqlParameter[] { new SqlParameter("@Username", username) }));

                if (attempts >= 3)
                {
                    lblMessage.Text = "Too many failed attempts. Account locked for 5 minutes.";
                }
                else
                {
                    lblMessage.Text = $"Invalid password. {3 - attempts} attempt(s) remaining.";
                }

                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // 🔒 Helper method for SHA256 hashing (same as Register)
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

        // 🔄 Redirect user based on role
        private void RedirectByRole(string role)
        {
            if (role == "Admin")
                Response.Redirect("~/Admin/Dashboard.aspx");
            else
                Response.Redirect("~/Pages/Profile.aspx");
        }
    }
}
