using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Pages
{
    public partial class Profile : Page
    {
        private int userId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            userId = Convert.ToInt32(Session["UserID"]);

            if (!IsPostBack)
            {
                LoadUserProfile();

                // Check role and hide/show sections
                string role = Session["Role"]?.ToString();
                if (role == "Admin" || role == "Teacher")
                {
                    // Hide progress and achievements for Admin/Teacher
                    HideUserSections();
                }
                else
                {
                    // Show everything for regular users
                    LoadUserStats();
                    LoadUserProgress();
                    LoadBadges();
                }
            }
        }

        private void HideUserSections()
        {
            // Find and hide the panels
            pnlProgressSection.Visible = false;
            pnlStatsGrid.Visible = false;
            pnlAchievementsSection.Visible = false;
        }

        private void LoadUserProfile()
        {
            try
            {
                string query = @"SELECT Username, Email, Role, CurrentStreak, CreatedDate 
                                FROM Users 
                                WHERE UserID = @UserID";

                SqlParameter[] parameters = {
                    new SqlParameter("@UserID", userId)
                };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    string username = row["Username"].ToString();
                    string email = row["Email"].ToString();
                    string role = row["Role"].ToString();
                    DateTime joinedDate = Convert.ToDateTime(row["CreatedDate"]);

                    // Display profile info
                    litUsername.Text = username;
                    litEmail.Text = email;
                    litJoinedDate.Text = joinedDate.ToString("MMMM dd, yyyy");
                    litAvatar.Text = GetAvatarEmoji(username);

                    // Populate edit form
                    txtUsername.Text = username;
                    txtEmail.Text = email;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadUserProfile error: {ex.Message}");
                ShowError("Failed to load profile information.");
            }
        }

        private void LoadUserStats()
        {
            try
            {
                // Get total quizzes taken
                string quizzesQuery = "SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID";
                SqlParameter[] quizzesParams = { new SqlParameter("@UserID", userId) };
                object quizResult = DBHelper.ExecuteScalar(quizzesQuery, quizzesParams);
                int quizzesTaken = quizResult != null ? Convert.ToInt32(quizResult) : 0;
                litQuizzesTaken.Text = quizzesTaken.ToString();

                // Get current streak
                string streakQuery = "SELECT ISNULL(CurrentStreak, 0) FROM Users WHERE UserID = @UserID";
                SqlParameter[] streakParams = { new SqlParameter("@UserID", userId) };
                object streakResult = DBHelper.ExecuteScalar(streakQuery, streakParams);
                int currentStreak = streakResult != null ? Convert.ToInt32(streakResult) : 0;
                litCurrentStreak.Text = currentStreak.ToString();

                // Get badges count
                string badgesQuery = "SELECT COUNT(*) FROM Badges WHERE UserID = @UserID";
                SqlParameter[] badgesParams = { new SqlParameter("@UserID", userId) };
                object badgesResult = DBHelper.ExecuteScalar(badgesQuery, badgesParams);
                int badgesCount = badgesResult != null ? Convert.ToInt32(badgesResult) : 0;
                litBadges.Text = badgesCount.ToString();

                // Get total score
                string scoreQuery = "SELECT ISNULL(SUM(Score), 0) FROM UserProgress WHERE UserID = @UserID";
                SqlParameter[] scoreParams = { new SqlParameter("@UserID", userId) };
                object scoreResult = DBHelper.ExecuteScalar(scoreQuery, scoreParams);
                int totalScore = scoreResult != null ? Convert.ToInt32(scoreResult) : 0;
                litTotalScore.Text = totalScore.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadUserStats error: {ex.Message}");
            }
        }

        private void LoadUserProgress()
        {
            try
            {
                // Countries explored
                string countriesQuery = "SELECT COUNT(DISTINCT CountryID) FROM UserProgress UP INNER JOIN Quizzes Q ON UP.QuizID = Q.QuizID WHERE UP.UserID = @UserID";
                SqlParameter[] countriesParams = { new SqlParameter("@UserID", userId) };
                object countriesResult = DBHelper.ExecuteScalar(countriesQuery, countriesParams);
                int countriesExplored = countriesResult != null ? Convert.ToInt32(countriesResult) : 0;

                // Quizzes completed
                string quizzesQuery = "SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID";
                SqlParameter[] quizzesParams = { new SqlParameter("@UserID", userId) };
                object quizzesResult = DBHelper.ExecuteScalar(quizzesQuery, quizzesParams);
                int quizzesCompleted = quizzesResult != null ? Convert.ToInt32(quizzesResult) : 0;

                // Badges earned
                string badgesQuery = "SELECT COUNT(*) FROM Badges WHERE UserID = @UserID";
                SqlParameter[] badgesParams = { new SqlParameter("@UserID", userId) };
                object badgesResult = DBHelper.ExecuteScalar(badgesQuery, badgesParams);
                int badgesEarned = badgesResult != null ? Convert.ToInt32(badgesResult) : 0;

                // Current streak
                string streakQuery = "SELECT ISNULL(CurrentStreak, 0) FROM Users WHERE UserID = @UserID";
                SqlParameter[] streakParams = { new SqlParameter("@UserID", userId) };
                object streakResult = DBHelper.ExecuteScalar(streakQuery, streakParams);
                int currentStreak = streakResult != null ? Convert.ToInt32(streakResult) : 0;

                // Calculate overall progress
                int totalGoals = 50 + 50 + 8 + 30; // 138 total
                int completedGoals = countriesExplored + quizzesCompleted + badgesEarned + currentStreak;

                if (completedGoals < 0) completedGoals = 0;
                if (completedGoals > totalGoals) completedGoals = totalGoals;

                int overallPercent = totalGoals > 0 ? (int)Math.Round((double)completedGoals / totalGoals * 100) : 0;

                // Calculate individual percentages
                int countriesPercent = (int)Math.Round((double)countriesExplored / 50 * 100);
                int quizzesPercent = (int)Math.Round((double)quizzesCompleted / 50 * 100);
                int badgesPercent = (int)Math.Round((double)badgesEarned / 8 * 100);
                int streakPercent = (int)Math.Round((double)currentStreak / 30 * 100);

                // CRITICAL: Set progress bar widths to actual percentages (not always 100%)
                overallProgressBar.Style["width"] = overallPercent + "%";
                countriesProgressBar.Style["width"] = countriesPercent + "%";
                quizzesProgressBar.Style["width"] = quizzesPercent + "%";
                badgesProgressBar.Style["width"] = badgesPercent + "%";
                streakProgressBar.Style["width"] = streakPercent + "%";

                // Update text labels
                litOverallProgress.Text = overallPercent.ToString();
                litOverallGoals.Text = $"{completedGoals} of {totalGoals}";
                litCountriesCount.Text = countriesExplored.ToString();
                litQuizzesProgress.Text = quizzesCompleted.ToString();
                litBadgesProgress.Text = badgesEarned.ToString();
                litStreakProgress.Text = currentStreak.ToString();

                // Debug output
                System.Diagnostics.Debug.WriteLine($"=== PROGRESS DEBUG ===");
                System.Diagnostics.Debug.WriteLine($"Countries: {countriesExplored}/50 = {countriesPercent}%");
                System.Diagnostics.Debug.WriteLine($"Quizzes: {quizzesCompleted}/50 = {quizzesPercent}%");
                System.Diagnostics.Debug.WriteLine($"Badges: {badgesEarned}/8 = {badgesPercent}%");
                System.Diagnostics.Debug.WriteLine($"Streak: {currentStreak}/30 = {streakPercent}%");
                System.Diagnostics.Debug.WriteLine($"Overall: {completedGoals}/138 = {overallPercent}%");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadUserProgress error: {ex.Message}");
                // Set defaults to 0%
                if (overallProgressBar != null) overallProgressBar.Style["width"] = "0%";
                if (countriesProgressBar != null) countriesProgressBar.Style["width"] = "0%";
                if (quizzesProgressBar != null) quizzesProgressBar.Style["width"] = "0%";
                if (badgesProgressBar != null) badgesProgressBar.Style["width"] = "0%";
                if (streakProgressBar != null) streakProgressBar.Style["width"] = "0%";

                litOverallProgress.Text = "0";
                litOverallGoals.Text = "0 of 138";
                litCountriesCount.Text = "0";
                litQuizzesProgress.Text = "0";
                litBadgesProgress.Text = "0";
                litStreakProgress.Text = "0";
            }
        }

        private void LoadBadges()
        {
            try
            {
                var allBadges = new[]
                {
                    new { BadgeIcon = "🌟", BadgeName = "First Steps", Description = "Complete your first quiz" },
                    new { BadgeIcon = "🔥", BadgeName = "On Fire", Description = "Maintain a 7-day streak" },
                    new { BadgeIcon = "🎯", BadgeName = "Quiz Master", Description = "Take 10 quizzes" },
                    new { BadgeIcon = "🌍", BadgeName = "Explorer", Description = "Visit 5 different countries" },
                    new { BadgeIcon = "⭐", BadgeName = "Perfect Score", Description = "Get 100% on a quiz" },
                    new { BadgeIcon = "🏆", BadgeName = "Champion", Description = "Take 25 quizzes" },
                    new { BadgeIcon = "💎", BadgeName = "Dedicated", Description = "Maintain a 30-day streak" },
                    new { BadgeIcon = "🚀", BadgeName = "Overachiever", Description = "Earn 1000 points" },
                };

                string query = "SELECT BadgeName, AwardedDate AS EarnedDate FROM Badges WHERE UserID = @UserID";
                SqlParameter[] parameters = { new SqlParameter("@UserID", userId) };
                DataTable earnedBadges = DBHelper.ExecuteReader(query, parameters);

                var badgesList = new System.Collections.Generic.List<object>();

                foreach (var badge in allBadges)
                {
                    bool isEarned = false;
                    DateTime earnedDate = DateTime.MinValue;

                    foreach (DataRow row in earnedBadges.Rows)
                    {
                        if (row["BadgeName"].ToString() == badge.BadgeName)
                        {
                            isEarned = true;
                            earnedDate = Convert.ToDateTime(row["EarnedDate"]);
                            break;
                        }
                    }

                    badgesList.Add(new
                    {
                        badge.BadgeIcon,
                        badge.BadgeName,
                        IsEarned = isEarned,
                        EarnedDate = earnedDate
                    });
                }

                rptBadges.DataSource = badgesList;
                rptBadges.DataBind();
                pnlBadges.Visible = true;
                pnlNoBadges.Visible = false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadBadges error: {ex.Message}");
                pnlBadges.Visible = false;
                pnlNoBadges.Visible = true;
            }
        }

        protected void btnToggleEdit_Click(object sender, EventArgs e)
        {
            // Toggle the edit form visibility
            if (pnlEditForm.CssClass.Contains("active"))
            {
                pnlEditForm.CssClass = "edit-section";
            }
            else
            {
                pnlEditForm.CssClass = "edit-section active";
            }

            // Clear password fields
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";

            // Hide messages
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string newUsername = txtUsername.Text.Trim();
                string newEmail = txtEmail.Text.Trim();
                string currentPassword = txtCurrentPassword.Text;
                string newPassword = txtNewPassword.Text;

                if (!IsUsernameAvailable(newUsername, userId))
                {
                    ShowError("Username is already taken. Please choose a different one.");
                    return;
                }

                if (!IsEmailAvailable(newEmail, userId))
                {
                    ShowError("Email is already registered. Please use a different email.");
                    return;
                }

                if (!string.IsNullOrEmpty(newPassword))
                {
                    if (string.IsNullOrEmpty(currentPassword))
                    {
                        ShowError("Please enter your current password to change it.");
                        return;
                    }

                    if (!VerifyCurrentPassword(currentPassword))
                    {
                        ShowError("Current password is incorrect.");
                        return;
                    }

                    if (newPassword.Length < 6)
                    {
                        ShowError("New password must be at least 6 characters long.");
                        return;
                    }

                    string hashedPassword = HashPassword(newPassword);
                    UpdateUserProfileWithPassword(newUsername, newEmail, hashedPassword);
                }
                else
                {
                    UpdateUserProfile(newUsername, newEmail);
                }

                Session["Username"] = newUsername;
                LoadUserProfile();

                pnlEditForm.CssClass = "edit-section";
                ShowSuccess("Your profile has been updated successfully!");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"btnSaveChanges error: {ex.Message}");
                ShowError("An error occurred while updating your profile. Please try again.");
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            LoadUserProfile();
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";
            pnlEditForm.CssClass = "edit-section";
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                string password = txtDeleteConfirmPassword.Text;

                if (string.IsNullOrEmpty(password))
                {
                    ShowError("Please enter your password to confirm account deletion.");
                    return;
                }

                if (!VerifyCurrentPassword(password))
                {
                    ShowError("Incorrect password. Account deletion cancelled.");
                    txtDeleteConfirmPassword.Text = "";
                    return;
                }

                DeleteUserAccount();

                Session.Clear();
                Session.Abandon();

                Response.Redirect("~/Default.aspx?deleted=true", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"btnConfirmDelete error: {ex.Message}");
                ShowError("An error occurred while deleting your account. Please try again.");
            }
        }

        #region Helper Methods

        private bool IsUsernameAvailable(string username, int currentUserId)
        {
            try
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username AND UserID != @UserID";
                SqlParameter[] parameters = {
                    new SqlParameter("@Username", username),
                    new SqlParameter("@UserID", currentUserId)
                };

                object result = DBHelper.ExecuteScalar(query, parameters);
                int count = result != null ? Convert.ToInt32(result) : 0;
                return count == 0;
            }
            catch
            {
                return false;
            }
        }

        private bool IsEmailAvailable(string email, int currentUserId)
        {
            try
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email AND UserID != @UserID";
                SqlParameter[] parameters = {
                    new SqlParameter("@Email", email),
                    new SqlParameter("@UserID", currentUserId)
                };

                object result = DBHelper.ExecuteScalar(query, parameters);
                int count = result != null ? Convert.ToInt32(result) : 0;
                return count == 0;
            }
            catch
            {
                return false;
            }
        }

        private bool VerifyCurrentPassword(string password)
        {
            try
            {
                string hashedPassword = HashPassword(password);
                string query = "SELECT COUNT(*) FROM Users WHERE UserID = @UserID AND Password = @Password";

                SqlParameter[] parameters = {
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@Password", hashedPassword)
                };

                object result = DBHelper.ExecuteScalar(query, parameters);
                int count = result != null ? Convert.ToInt32(result) : 0;
                return count > 0;
            }
            catch
            {
                return false;
            }
        }

        private void UpdateUserProfile(string username, string email)
        {
            string query = @"UPDATE Users 
                            SET Username = @Username, 
                                Email = @Email
                            WHERE UserID = @UserID";

            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Email", email),
                new SqlParameter("@UserID", userId)
            };

            DBHelper.ExecuteNonQuery(query, parameters);
        }

        private void UpdateUserProfileWithPassword(string username, string email, string hashedPassword)
        {
            string query = @"UPDATE Users 
                            SET Username = @Username, 
                                Email = @Email, 
                                Password = @Password
                            WHERE UserID = @UserID";

            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Email", email),
                new SqlParameter("@Password", hashedPassword),
                new SqlParameter("@UserID", userId)
            };

            DBHelper.ExecuteNonQuery(query, parameters);
        }

        private void DeleteUserAccount()
        {
            try
            {
                string deleteBadges = "DELETE FROM Badges WHERE UserID = @UserID";
                DBHelper.ExecuteNonQuery(deleteBadges, new[] { new SqlParameter("@UserID", userId) });
            }
            catch { /* Table may not exist */ }

            try
            {
                string deleteProgress = "DELETE FROM UserProgress WHERE UserID = @UserID";
                DBHelper.ExecuteNonQuery(deleteProgress, new[] { new SqlParameter("@UserID", userId) });
            }
            catch { /* Table may not exist */ }

            string deleteUser = "DELETE FROM Users WHERE UserID = @UserID";
            DBHelper.ExecuteNonQuery(deleteUser, new[] { new SqlParameter("@UserID", userId) });
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return BitConverter.ToString(bytes).Replace("-", "").ToLower();
            }
        }

        private string GetAvatarEmoji(string username)
        {
            string[] emojis = { "👤", "😊", "🎯", "🚀", "⭐", "🌟", "💫", "🎨", "🎭", "🎪" };
            int hash = Math.Abs(username.GetHashCode());
            return emojis[hash % emojis.Length];
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = message;
            pnlError.Visible = false;
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = message;
            pnlSuccess.Visible = false;
        }

        #endregion
    }
}