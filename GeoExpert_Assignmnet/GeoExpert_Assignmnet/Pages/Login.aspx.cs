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
            if (!IsPostBack)
            {
                // Check if already logged in
                if (Session["UserID"] != null)
                {
                    string role = Session["Role"]?.ToString();
                    if (role == "Admin")
                        Response.Redirect("~/Admin/Dashboard.aspx", false);
                    else
                        Response.Redirect("~/Default.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();

                // Validate input
                if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                {
                    lblMessage.Text = "Please enter both username and password.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                string hashedPassword = HashPassword(password);

                // Check if user exists and get lockout info
                string lockQuery = "SELECT UserID, FailedLoginAttempts, LockoutEnd FROM Users WHERE Username = @Username";
                SqlParameter[] lockParams = { new SqlParameter("@Username", username) };
                DataTable lockDt = DBHelper.ExecuteReader(lockQuery, lockParams);

                if (lockDt.Rows.Count == 0)
                {
                    lblMessage.Text = "Invalid username or password.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Get lockout info (SAFE - handle NULL)
                object failedAttemptsObj = lockDt.Rows[0]["FailedLoginAttempts"];
                int failedAttempts = (failedAttemptsObj != null && failedAttemptsObj != DBNull.Value)
                                    ? Convert.ToInt32(failedAttemptsObj)
                                    : 0;

                object lockoutValue = lockDt.Rows[0]["LockoutEnd"];

                // Check if account is currently locked
                if (lockoutValue != null && lockoutValue != DBNull.Value)
                {
                    DateTime lockoutEnd = Convert.ToDateTime(lockoutValue);
                    if (lockoutEnd > DateTime.Now)
                    {
                        TimeSpan remaining = lockoutEnd - DateTime.Now;
                        int minutesLeft = (int)remaining.TotalMinutes;
                        int secondsLeft = remaining.Seconds;
                        lblMessage.Text = $"Account locked. Try again in {minutesLeft}m {secondsLeft}s.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        return;
                    }
                    else
                    {
                        // Lock period expired - reset (NEW PARAMETERS!)
                        string resetLockQuery = "UPDATE Users SET FailedLoginAttempts = 0, LockoutEnd = NULL WHERE Username = @Username";
                        SqlParameter[] resetParams = { new SqlParameter("@Username", username) };
                        DBHelper.ExecuteNonQuery(resetLockQuery, resetParams);
                    }
                }

                // Verify credentials (NEW PARAMETERS!)
                string query = "SELECT UserID, Username, Role FROM Users WHERE Username = @Username AND Password = @Password";
                SqlParameter[] parameters = {
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Password", hashedPassword)
                };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);

                if (dt.Rows.Count > 0)
                {
                    // ✅ LOGIN SUCCESS
                    DataRow row = dt.Rows[0];
                    int userId = Convert.ToInt32(row["UserID"]);
                    string role = row["Role"].ToString();

                    // Set session
                    Session["UserID"] = userId;
                    Session["Username"] = row["Username"].ToString();
                    Session["Role"] = role;

                    // Reset failed attempts (NEW PARAMETERS!)
                    string resetQuery = "UPDATE Users SET FailedLoginAttempts = 0, LockoutEnd = NULL WHERE Username = @Username";
                    SqlParameter[] resetParams2 = { new SqlParameter("@Username", username) };
                    DBHelper.ExecuteNonQuery(resetQuery, resetParams2);

                    // Update last login and streak
                    UpdateLoginStreak(userId);

                    // Redirect based on role (prevent ThreadAbortException)
                    if (role == "Admin")
                        Response.Redirect("~/Admin/Dashboard.aspx", false);
                    else
                        Response.Redirect("~/Default.aspx", false);

                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    // ❌ LOGIN FAILED
                    HandleFailedLogin(username);
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An error occurred. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine($"Login error: {ex.Message}");
            }
        }

        private void HandleFailedLogin(string username)
        {
            try
            {
                // Get current failed attempts (NEW PARAMETERS!)
                string getQuery = "SELECT FailedLoginAttempts FROM Users WHERE Username = @Username";
                SqlParameter[] getParams = { new SqlParameter("@Username", username) };

                object attemptsObj = DBHelper.ExecuteScalar(getQuery, getParams);
                int currentAttempts = (attemptsObj != null && attemptsObj != DBNull.Value)
                                    ? Convert.ToInt32(attemptsObj)
                                    : 0;

                int newAttempts = currentAttempts + 1;

                // Lock account after 5 failed attempts
                if (newAttempts >= 5)
                {
                    DateTime lockoutEnd = DateTime.Now.AddMinutes(15);

                    // NEW PARAMETERS for lock query
                    string lockQuery = @"UPDATE Users 
                                        SET FailedLoginAttempts = @Attempts, 
                                            LockoutEnd = @LockoutEnd 
                                        WHERE Username = @Username";
                    SqlParameter[] lockParams = {
                        new SqlParameter("@Attempts", newAttempts),
                        new SqlParameter("@LockoutEnd", lockoutEnd),
                        new SqlParameter("@Username", username)
                    };
                    DBHelper.ExecuteNonQuery(lockQuery, lockParams);

                    lblMessage.Text = "Too many failed attempts. Account locked for 15 minutes.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    // NEW PARAMETERS for update query
                    string updateQuery = "UPDATE Users SET FailedLoginAttempts = @Attempts WHERE Username = @Username";
                    SqlParameter[] updateParams = {
                        new SqlParameter("@Attempts", newAttempts),
                        new SqlParameter("@Username", username)
                    };
                    DBHelper.ExecuteNonQuery(updateQuery, updateParams);

                    int remainingAttempts = 5 - newAttempts;
                    lblMessage.Text = $"Invalid username or password. {remainingAttempts} attempts remaining.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Invalid username or password.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine($"HandleFailedLogin error: {ex.Message}");
            }
        }

        private void UpdateLoginStreak(int userId)
        {
            try
            {
                // NEW PARAMETERS for get query
                string getLastLoginQuery = "SELECT LastLoginDate, CurrentStreak FROM Users WHERE UserID = @UserID";
                SqlParameter[] getParams = { new SqlParameter("@UserID", userId) };

                DataTable dt = DBHelper.ExecuteReader(getLastLoginQuery, getParams);

                if (dt.Rows.Count == 0) return;

                object lastLoginObj = dt.Rows[0]["LastLoginDate"];
                object currentStreakObj = dt.Rows[0]["CurrentStreak"];

                int currentStreak = (currentStreakObj != null && currentStreakObj != DBNull.Value)
                                  ? Convert.ToInt32(currentStreakObj)
                                  : 0;

                int newStreak = 1;

                if (lastLoginObj != null && lastLoginObj != DBNull.Value)
                {
                    DateTime lastLogin = Convert.ToDateTime(lastLoginObj);
                    TimeSpan diff = DateTime.Now.Date - lastLogin.Date;

                    if (diff.Days == 0)
                    {
                        // Same day - keep current streak
                        newStreak = currentStreak > 0 ? currentStreak : 1;
                    }
                    else if (diff.Days == 1)
                    {
                        // Consecutive day - increment streak
                        newStreak = currentStreak + 1;
                    }
                    else
                    {
                        // Streak broken - reset to 1
                        newStreak = 1;
                    }
                }

                // NEW PARAMETERS for update query
                string updateQuery = "UPDATE Users SET LastLoginDate = GETDATE(), CurrentStreak = @Streak WHERE UserID = @UserID";
                SqlParameter[] updateParams = {
                    new SqlParameter("@Streak", newStreak),
                    new SqlParameter("@UserID", userId)
                };
                DBHelper.ExecuteNonQuery(updateQuery, updateParams);
            }
            catch (Exception ex)
            {
                // Don't let streak calculation crash login
                System.Diagnostics.Debug.WriteLine($"UpdateLoginStreak error: {ex.Message}");
            }
        }

        private string HashPassword(string password)
        {
            try
            {
                using (var sha256 = System.Security.Cryptography.SHA256.Create())
                {
                    byte[] bytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                    return BitConverter.ToString(bytes).Replace("-", "").ToLower();
                }
            }
            catch
            {
                return password;
            }
        }
    }
}
