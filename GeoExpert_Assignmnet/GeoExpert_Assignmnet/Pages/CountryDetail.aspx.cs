using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Pages
{
    public partial class CountryDetail : Page
    {
        private int countryId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check user role and show/hide quiz button
                CheckUserRole();

                if (Request.QueryString["id"] != null)
                {
                    int countryId;
                    if (int.TryParse(Request.QueryString["id"], out countryId))
                    {
                        // Increment view count
                        string updateQuery = "UPDATE Countries SET ViewCount = ISNULL(ViewCount, 0) + 1 WHERE CountryID = @CountryID";
                        SqlParameter[] param = { new SqlParameter("@CountryID", countryId) };
                        DBHelper.ExecuteNonQuery(updateQuery, param);

                        LoadCountryDetails();
                    }
                    else
                    {
                        Response.Redirect("~/Pages/Countries.aspx");
                    }

                    // Quiz Count
                    LoadQuizCount();

                    // Quiz Button
                    btnTakeQuiz.NavigateUrl = $"Quiz.aspx?countryid={countryId}";

                    // Set page title
                    Page.Title = $"{countryName} - GeoExpert";
                }
                else
                {
                    Response.Redirect("~/Pages/Countries.aspx");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadCountryDetails error: {ex.Message}");
                Response.Redirect("Countries.aspx");
            }
        }

        private void CheckUserRole()
        {
            // Only show quiz button for regular users, not Admin/Teacher
            if (Session["Role"] != null)
            {
                string role = Session["Role"].ToString();

                // Only Users can take quizzes
                if (role == "User")
                {
                    pnlQuizButton.Visible = true;
                }
                else
                {
                    pnlQuizButton.Visible = false;
                }
            }
            else
            {
                // Not logged in - hide quiz button
                pnlQuizButton.Visible = false;
            }
        }

        private void UpdateViewCount()
        {
            try
            {
                string query = "UPDATE Countries SET ViewCount = ISNULL(ViewCount, 0) + 1 WHERE CountryID = @CountryID";
                SqlParameter[] parameters = {
                    new SqlParameter("@CountryID", countryId)
                };

                DBHelper.ExecuteNonQuery(query, parameters);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"UpdateViewCount error: {ex.Message}");
                // Don't crash page if view count update fails
            }
        }

        private void LoadRelatedCountries()
        {
            if (Request.QueryString["id"] != null)
            {
                // Get 3 other countries from the same region
                string query = @"SELECT TOP 3 CountryID, Name, FoodName 
                                FROM Countries 
                                WHERE Region = (SELECT Region FROM Countries WHERE CountryID = @CountryID) 
                                AND CountryID != @CountryID 
                                ORDER BY NEWID()"; // Random order

                string query = "SELECT * FROM Countries WHERE CountryID = @CountryID";
                SqlParameter[] selectParams = { new SqlParameter("@CountryID", countryId) };
                DataTable dt = DBHelper.ExecuteReader(query, selectParams);

                if (dt.Rows.Count > 0)
                {
                    rptRelated.DataSource = dt;
                    rptRelated.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadRelatedCountries error: {ex.Message}");
            }
        }

        private string ConvertToEmbedURL(string url)
        {
            try
            {
                if (string.IsNullOrEmpty(url))
                    return "";

                litCountryName.Text = row["Name"].ToString();
                litFoodName.Text = row["FoodName"].ToString();
                litFoodDesc.Text = row["FoodDescription"].ToString();
                litCulture.Text = row["CultureInfo"].ToString();
                litFunFact.Text = row["FunFact"].ToString();

                string videoUrl = row["VideoURL"].ToString();
                if (!string.IsNullOrEmpty(videoUrl))
                {
                    string videoId = url.Split(new[] { "v=" }, StringSplitOptions.None)[1];
                    if (videoId.Contains("&"))
                        videoId = videoId.Split('&')[0];
                    return $"https://www.youtube.com/embed/{videoId}";
                }

                // Convert youtu.be/VIDEO_ID to youtube.com/embed/VIDEO_ID
                if (url.Contains("youtu.be/"))
                {
                    string videoId = url.Split(new[] { "youtu.be/" }, StringSplitOptions.None)[1];
                    if (videoId.Contains("?"))
                        videoId = videoId.Split('?')[0];
                    return $"https://www.youtube.com/embed/{videoId}";
                }

                return url;
            }
            catch
            {
                return url;
            }
        }

        // Helper method to get flag emoji
        protected string GetFlagEmoji(string countryName)
        {
            if (string.IsNullOrEmpty(countryName))
                return "🌍";

            var flagMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                // Asia
                {"Japan", "🇯🇵"},
                {"China", "🇨🇳"},
                {"India", "🇮🇳"},
                {"South Korea", "🇰🇷"},
                {"Korea", "🇰🇷"},
                {"Thailand", "🇹🇭"},
                {"Vietnam", "🇻🇳"},
                {"Indonesia", "🇮🇩"},
                {"Malaysia", "🇲🇾"},
                {"Singapore", "🇸🇬"},
                {"Philippines", "🇵🇭"},
                {"Pakistan", "🇵🇰"},
                {"Bangladesh", "🇧🇩"},
                
                // Europe
                {"France", "🇫🇷"},
                {"Italy", "🇮🇹"},
                {"Spain", "🇪🇸"},
                {"Germany", "🇩🇪"},
                {"United Kingdom", "🇬🇧"},
                {"UK", "🇬🇧"},
                {"Greece", "🇬🇷"},
                {"Portugal", "🇵🇹"},
                {"Netherlands", "🇳🇱"},
                {"Belgium", "🇧🇪"},
                {"Switzerland", "🇨🇭"},
                {"Austria", "🇦🇹"},
                {"Sweden", "🇸🇪"},
                {"Norway", "🇳🇴"},
                {"Denmark", "🇩🇰"},
                {"Finland", "🇫🇮"},
                {"Poland", "🇵🇱"},
                {"Turkey", "🇹🇷"},
                {"Russia", "🇷🇺"},
                
                // North America
                {"United States", "🇺🇸"},
                {"USA", "🇺🇸"},
                {"America", "🇺🇸"},
                {"Canada", "🇨🇦"},
                {"Mexico", "🇲🇽"},
                
                // South America
                {"Brazil", "🇧🇷"},
                {"Argentina", "🇦🇷"},
                {"Chile", "🇨🇱"},
                {"Peru", "🇵🇪"},
                {"Colombia", "🇨🇴"},
                
                // Africa
                {"Egypt", "🇪🇬"},
                {"South Africa", "🇿🇦"},
                {"Morocco", "🇲🇦"},
                {"Kenya", "🇰🇪"},
                {"Nigeria", "🇳🇬"},
                
                // Oceania
                {"Australia", "🇦🇺"},
                {"New Zealand", "🇳🇿"}
            };

            return flagMap.ContainsKey(countryName) ? flagMap[countryName] : "🌍";
        }
    }
}
