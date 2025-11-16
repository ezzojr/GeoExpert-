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
                // Get country ID from query string
                if (Request.QueryString["id"] != null)
                {
                    if (int.TryParse(Request.QueryString["id"], out countryId))
                    {
                        LoadCountryDetails();
                        UpdateViewCount();
                        LoadRelatedCountries();
                    }
                    else
                    {
                        Response.Redirect("Countries.aspx");
                    }
                }
                else
                {
                    Response.Redirect("Countries.aspx");
                }
            }
        }

        private void LoadCountryDetails()
        {
            try
            {
                string query = @"SELECT CountryID, Name, FlagImage, FoodName, FoodDescription, 
                                       CultureInfo, FunFact, VideoURL, Region, ViewCount 
                                FROM Countries 
                                WHERE CountryID = @CountryID";

                SqlParameter[] parameters = {
                    new SqlParameter("@CountryID", countryId)
                };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];

                    // Basic Info
                    string countryName = row["Name"].ToString();
                    litCountryName.Text = countryName;
                    litBreadcrumb.Text = countryName;

                    // Flag (image if available, else emoji)
                    string flagPath = row["FlagImage"] != DBNull.Value ? row["FlagImage"].ToString() : null;

                    if (!string.IsNullOrEmpty(flagPath))
                    {
                        string resolved = ResolveUrl(flagPath);
                        litFlag.Text = $"<img src='{resolved}' alt='{countryName} flag' class='country-flag-detail' />";
                    }
                    else
                    {
                        litFlag.Text = GetFlagEmoji(countryName);
                    }

                    // Region
                    string region = row["Region"].ToString();
                    litRegion.Text = region;
                    litRelatedRegion.Text = region;

                    // Views
                    int views = row["ViewCount"] != DBNull.Value ? Convert.ToInt32(row["ViewCount"]) : 0;
                    litViews.Text = views.ToString();
                    litViewCount.Text = views.ToString();

                    // Food
                    litFoodName.Text = row["FoodName"].ToString();
                    litFoodDesc.Text = row["FoodDescription"].ToString();

                    // Culture
                    litCulture.Text = row["CultureInfo"].ToString();

                    // Fun Fact
                    litFunFact.Text = row["FunFact"].ToString();

                    // Video
                    string videoURL = row["VideoURL"].ToString();
                    if (!string.IsNullOrEmpty(videoURL))
                    {
                        // Convert YouTube URL to embed format
                        string embedURL = ConvertToEmbedURL(videoURL);
                        litVideo.Text = $"<iframe src=\"{embedURL}\" allowfullscreen></iframe>";
                        pnlVideo.Visible = true;
                        pnlNoVideo.Visible = false;
                    }
                    else
                    {
                        pnlVideo.Visible = false;
                        pnlNoVideo.Visible = true;
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
                    Response.Redirect("Countries.aspx");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadCountryDetails error: {ex.Message}");
                Response.Redirect("Countries.aspx");
            }
        }

        private void LoadQuizCount()
        {
            try
            {
                string query = "SELECT COUNT(*) FROM Quizzes WHERE CountryID = @CountryID";
                SqlParameter[] parameters = {
                    new SqlParameter("@CountryID", countryId)
                };

                object result = DBHelper.ExecuteScalar(query, parameters);
                int quizCount = result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
                litQuizCount.Text = quizCount.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadQuizCount error: {ex.Message}");
                litQuizCount.Text = "0";
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
            try
            {
                // Get 3 other countries from the same region
                string query = @"SELECT TOP 3 CountryID, Name, FoodName 
                                FROM Countries 
                                WHERE Region = (SELECT Region FROM Countries WHERE CountryID = @CountryID) 
                                AND CountryID != @CountryID 
                                ORDER BY NEWID()"; // Random order

                SqlParameter[] parameters = {
                    new SqlParameter("@CountryID", countryId)
                };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);

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

                // If already embed URL, return as is
                if (url.Contains("youtube.com/embed/"))
                    return url;

                // Convert youtube.com/watch?v=VIDEO_ID to youtube.com/embed/VIDEO_ID
                if (url.Contains("youtube.com/watch?v="))
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
