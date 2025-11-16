using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

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
                LoadUserStats();
                LoadUserProgress();
                LoadBadges();
            }
        }

        private void LoadUserProfile()
        {
            try
            {
                // Try with ProfilePicture column first
                string query = @"SELECT Username, Email, CreatedDate, ProfilePicture 
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
                    DateTime joinedDate = Convert.ToDateTime(row["CreatedDate"]);
                    string profilePic = row["ProfilePicture"] != DBNull.Value ? row["ProfilePicture"].ToString() : "";

                    // Display profile info
                    litUsername.Text = username;
                    litEmail.Text = email;
                    litJoinedDate.Text = joinedDate.ToString("MMMM dd, yyyy");

                    // Display profile picture or avatar emoji
                    if (!string.IsNullOrEmpty(profilePic) && System.IO.File.Exists(Server.MapPath(profilePic)))
                    {
                        imgProfilePic.ImageUrl = profilePic;
                        imgProfilePic.Visible = true;
                        litAvatar.Text = "";
                    }
                    else
                    {
                        imgProfilePic.Visible = false;
                        litAvatar.Text = GetAvatarEmoji(username);
                    }

                    // Populate edit form
                    txtUsername.Text = username;
                    txtEmail.Text = email;
                }
            }
            catch (SqlException ex)
            {
                // If ProfilePicture column doesn't exist, try without it
                if (ex.Message.Contains("ProfilePicture"))
                {
                    LoadUserProfileWithoutPicture();
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine($"LoadUserProfile error: {ex.Message}");
                    ShowError("Failed to load profile information.");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadUserProfile error: {ex.Message}");
                ShowError("Failed to load profile information.");
            }
        }

        private void LoadUserProfileWithoutPicture()
        {
            try
            {
                string query = @"SELECT Username, Email, CreatedDate 
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
                    DateTime joinedDate = Convert.ToDateTime(row["CreatedDate"]);

                    litUsername.Text = username;
                    litEmail.Text = email;
                    litJoinedDate.Text = joinedDate.ToString("MMMM dd, yyyy");

                    imgProfilePic.Visible = false;
                    litAvatar.Text = GetAvatarEmoji(username);

                    txtUsername.Text = username;
                    txtEmail.Text = email;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadUserProfileWithoutPicture error: {ex.Message}");
            }
        }

        private void LoadUserStats()
        {
            try
            {
                // Get current streak
                string streakQuery = "SELECT ISNULL(CurrentStreak, 0) FROM Users WHERE UserID = @UserID";
                SqlParameter[] streakParams = { new SqlParameter("@UserID", userId) };
                object streakResult = DBHelper.ExecuteScalar(streakQuery, streakParams);
                litCurrentStreak.Text = streakResult?.ToString() ?? "0";

                // Get quizzes taken count
                string quizQuery = "SELECT COUNT(*) FROM UserQuizResults WHERE UserID = @UserID";
                SqlParameter[] quizParams = { new SqlParameter("@UserID", userId) };
                object quizResult = DBHelper.ExecuteScalar(quizQuery, quizParams);
                litQuizzesTaken.Text = quizResult?.ToString() ?? "0";

                // Get badges earned
                string badgeQuery = "SELECT COUNT(*) FROM UserBadges WHERE UserID = @UserID";
                SqlParameter[] badgeParams = { new SqlParameter("@UserID", userId) };
                object badgeResult = DBHelper.ExecuteScalar(badgeQuery, badgeParams);
                litBadges.Text = badgeResult?.ToString() ?? "0";

                // Get total score
                string scoreQuery = "SELECT ISNULL(SUM(Score), 0) FROM UserQuizResults WHERE UserID = @UserID";
                SqlParameter[] scoreParams = { new SqlParameter("@UserID", userId) };
                object scoreResult = DBHelper.ExecuteScalar(scoreQuery, scoreParams);
                litTotalScore.Text = scoreResult?.ToString() ?? "0";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadUserStats error: {ex.Message}");
                // Use defaults
                litCurrentStreak.Text = "0";
                litQuizzesTaken.Text = "0";
                litBadges.Text = "0";
                litTotalScore.Text = "0";
            }
        }

        private void LoadUserProgress()
        {
            try
            {
                // Get countries explored
                string countriesQuery = @"SELECT COUNT(DISTINCT CountryID) 
                                         FROM UserProgress 
                                         WHERE UserID = @UserID AND Completed = 1";
                SqlParameter[] countriesParams = { new SqlParameter("@UserID", userId) };
                object countriesResult = DBHelper.ExecuteScalar(countriesQuery, countriesParams);
                int countriesExplored = countriesResult != null && countriesResult != DBNull.Value
                    ? Convert.ToInt32(countriesResult) : 0;

                // Get quizzes completed
                string quizzesQuery = "SELECT COUNT(*) FROM UserQuizResults WHERE UserID = @UserID";
                SqlParameter[] quizzesParams = { new SqlParameter("@UserID", userId) };
                object quizzesResult = DBHelper.ExecuteScalar(quizzesQuery, quizzesParams);
                int quizzesCompleted = quizzesResult != null && quizzesResult != DBNull.Value
                    ? Convert.ToInt32(quizzesResult) : 0;

                // Get badges earned
                string badgesQuery = "SELECT COUNT(*) FROM UserBadges WHERE UserID = @UserID";
                SqlParameter[] badgesParams = { new SqlParameter("@UserID", userId) };
                object badgesResult = DBHelper.ExecuteScalar(badgesQuery, badgesParams);
                int badgesEarned = badgesResult != null && badgesResult != DBNull.Value
                    ? Convert.ToInt32(badgesResult) : 0;

                // Get current streak
                string streakQuery = "SELECT ISNULL(CurrentStreak, 0) FROM Users WHERE UserID = @UserID";
                SqlParameter[] streakParams = { new SqlParameter("@UserID", userId) };
                object streakResult = DBHelper.ExecuteScalar(streakQuery, streakParams);
                int currentStreak = streakResult != null && streakResult != DBNull.Value
                    ? Convert.ToInt32(streakResult) : 0;

                // Get total number of countries in the database (for dynamic goal)
                int totalCountries = 0;
                try
                {
                    totalCountries = DBHelper.GetTotalCount("Countries");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"LoadUserProgress totalCountries error: {ex.Message}");
                    totalCountries = 195; 
                }
                if (totalCountries <= 0)
                {
                    totalCountries = 195; 
                }

                // Calculate overall progress
                int totalGoals = totalCountries + 50 + 8 + 30; 
                int completedGoals = countriesExplored + quizzesCompleted + badgesEarned + currentStreak;
                int overallPercent = (int)Math.Round((double)completedGoals / totalGoals * 100);

                // Update literals
                litOverallProgress.Text = overallPercent.ToString();
                litOverallGoals.Text = $"{completedGoals} of {totalGoals}";
                litCountriesCount.Text = countriesExplored.ToString();
                litQuizzesProgress.Text = quizzesCompleted.ToString();
                litBadgesProgress.Text = badgesEarned.ToString();
                litStreakProgress.Text = currentStreak.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadUserProgress error: {ex.Message}");
                // Set defaults
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

                string query = "SELECT BadgeName, EarnedDate FROM UserBadges WHERE UserID = @UserID";
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
            pnlEditForm.CssClass = pnlEditForm.CssClass.Contains("active")
                ? "edit-section"
                : "edit-section active";

            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";

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

        protected void btnUploadPicture_Click(object sender, EventArgs e)
        {
            try
            {
                if (fileProfilePic.HasFile)
                {
                    string fileExt = System.IO.Path.GetExtension(fileProfilePic.FileName).ToLower();
                    string[] allowedExt = { ".jpg", ".jpeg", ".png", ".gif" };

                    if (!allowedExt.Contains(fileExt))
                    {
                        ShowError("Please upload an image file (JPG, PNG, or GIF)");
                        return;
                    }

                    if (fileProfilePic.PostedFile.ContentLength > 5 * 1024 * 1024)
                    {
                        ShowError("Image size must be less than 5MB");
                        return;
                    }

                    string folderPath = Server.MapPath("~/Images/Profiles/");
                    if (!System.IO.Directory.Exists(folderPath))
                    {
                        System.IO.Directory.CreateDirectory(folderPath);
                    }

                    string fileName = $"user_{userId}_{DateTime.Now.Ticks}{fileExt}";
                    string filePath = System.IO.Path.Combine(folderPath, fileName);
                    string dbPath = $"~/Images/Profiles/{fileName}";

                    // Delete old profile picture
                    try
                    {
                        string oldPicQuery = "SELECT ProfilePicture FROM Users WHERE UserID = @UserID";
                        SqlParameter[] oldParams = { new SqlParameter("@UserID", userId) };
                        object oldPicResult = DBHelper.ExecuteScalar(oldPicQuery, oldParams);

                        if (oldPicResult != null && oldPicResult != DBNull.Value)
                        {
                            string oldPic = oldPicResult.ToString();
                            if (!string.IsNullOrEmpty(oldPic))
                            {
                                string oldPath = Server.MapPath(oldPic);
                                if (System.IO.File.Exists(oldPath))
                                {
                                    System.IO.File.Delete(oldPath);
                                }
                            }
                        }
                    }
                    catch { /* Ignore errors deleting old picture */ }

                    fileProfilePic.SaveAs(filePath);

                    string updateQuery = "UPDATE Users SET ProfilePicture = @ProfilePicture WHERE UserID = @UserID";
                    SqlParameter[] updateParams = {
                        new SqlParameter("@ProfilePicture", dbPath),
                        new SqlParameter("@UserID", userId)
                    };
                    DBHelper.ExecuteNonQuery(updateQuery, updateParams);

                    LoadUserProfile();
                    ShowSuccess("Profile picture updated successfully!");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"btnUploadPicture error: {ex.Message}");
                ShowError("An error occurred while uploading your profile picture. Please try again.");
            }
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
                string deleteBadges = "DELETE FROM UserBadges WHERE UserID = @UserID";
                DBHelper.ExecuteNonQuery(deleteBadges, new[] { new SqlParameter("@UserID", userId) });
            }
            catch { /* Table may not exist */ }

            try
            {
                string deleteQuizResults = "DELETE FROM UserQuizResults WHERE UserID = @UserID";
                DBHelper.ExecuteNonQuery(deleteQuizResults, new[] { new SqlParameter("@UserID", userId) });
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

            ScriptManager.RegisterStartupScript(this, GetType(), "scrollToTop",
                "window.scrollTo(0, 0);", true);
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = message;
            pnlSuccess.Visible = false;

            ScriptManager.RegisterStartupScript(this, GetType(), "scrollToTop",
                "window.scrollTo(0, 0);", true);
        }

        #endregion
    }
}