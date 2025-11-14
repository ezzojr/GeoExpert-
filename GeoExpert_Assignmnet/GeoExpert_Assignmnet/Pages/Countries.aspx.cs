using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace GeoExpert_Assignment.Pages
{
    public partial class Countries : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine($"=== PAGE LOAD === IsPostBack: {IsPostBack}");

            if (!IsPostBack)
            {
                LoadCountries();
                LoadStats();
            }
        }

        private void LoadCountries(string searchTerm = "", string region = "")
        {
            try
            {
                // Base query
                string query = "SELECT CountryID, Name, FoodName, FunFact, Region FROM Countries WHERE 1=1";
                List<SqlParameter> parameters = new List<SqlParameter>();

                // Debug output
                System.Diagnostics.Debug.WriteLine($"Search Term: '{searchTerm}'");
                System.Diagnostics.Debug.WriteLine($"Region: '{region}'");

                // Add search filter
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " AND Name LIKE @Search";
                    parameters.Add(new SqlParameter("@Search", "%" + searchTerm + "%"));
                    System.Diagnostics.Debug.WriteLine("Added search filter");
                }

                // Add region filter
                if (!string.IsNullOrEmpty(region))
                {
                    query += " AND Region = @Region";
                    parameters.Add(new SqlParameter("@Region", region));
                    System.Diagnostics.Debug.WriteLine("Added region filter");
                }

                query += " ORDER BY Name";
                System.Diagnostics.Debug.WriteLine($"Final Query: {query}");

                DataTable dt = DBHelper.ExecuteReader(query, parameters.Count > 0 ? parameters.ToArray() : null);
                System.Diagnostics.Debug.WriteLine($"Rows returned: {dt.Rows.Count}");

                if (dt.Rows.Count > 0)
                {
                    rptCountries.DataSource = dt;
                    rptCountries.DataBind();
                    pnlCountries.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlCountries.Visible = false;
                    pnlEmpty.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadCountries error: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack trace: {ex.StackTrace}");
                pnlCountries.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        private void LoadStats()
        {
            try
            {
                // Total countries
                string countQuery = "SELECT COUNT(*) FROM Countries";
                object countResult = DBHelper.ExecuteScalar(countQuery, null);
                int totalCountries = countResult != null && countResult != DBNull.Value ? Convert.ToInt32(countResult) : 0;
                litTotalCountries.Text = totalCountries.ToString();

                // Total quizzes
                string quizQuery = "SELECT COUNT(*) FROM Quizzes";
                object quizResult = DBHelper.ExecuteScalar(quizQuery, null);
                int totalQuizzes = quizResult != null && quizResult != DBNull.Value ? Convert.ToInt32(quizResult) : 0;
                litTotalQuizzes.Text = totalQuizzes.ToString();

                // Total views
                string viewQuery = "SELECT ISNULL(SUM(ViewCount), 0) FROM Countries";
                object viewResult = DBHelper.ExecuteScalar(viewQuery, null);
                int totalViews = viewResult != null && viewResult != DBNull.Value ? Convert.ToInt32(viewResult) : 0;
                litTotalViews.Text = totalViews.ToString();

                litTotalRegions.Text = "6";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LoadStats error: {ex.Message}");
                litTotalCountries.Text = "0";
                litTotalQuizzes.Text = "0";
                litTotalViews.Text = "0";
                litTotalRegions.Text = "6";
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== SEARCH BUTTON CLICKED ===");
                System.Diagnostics.Debug.WriteLine($"txtSearch control null? {txtSearch == null}");
                System.Diagnostics.Debug.WriteLine($"ddlRegion control null? {ddlRegion == null}");

                string searchTerm = txtSearch != null ? txtSearch.Text.Trim() : "";
                string region = ddlRegion != null ? ddlRegion.SelectedValue : "";

                System.Diagnostics.Debug.WriteLine($"Search term from textbox: '{searchTerm}'");
                System.Diagnostics.Debug.WriteLine($"Region from dropdown: '{region}'");
                System.Diagnostics.Debug.WriteLine($"Dropdown SelectedIndex: {ddlRegion.SelectedIndex}");
                System.Diagnostics.Debug.WriteLine($"Dropdown Items Count: {ddlRegion.Items.Count}");

                // SHOW ALERT TO USER
                ClientScript.RegisterStartupScript(this.GetType(), "searchAlert",
                    $"alert('Search: [{searchTerm}]\\nRegion: [{region}]\\nSelected Index: {ddlRegion.SelectedIndex}');", true);

                LoadCountries(searchTerm, region);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"btnSearch_Click error: {ex.Message}");
                ClientScript.RegisterStartupScript(this.GetType(), "errorAlert",
                    $"alert('Error: {ex.Message}');", true);
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            try
            {
                txtSearch.Text = "";
                ddlRegion.SelectedIndex = 0;
                LoadCountries();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"btnReset_Click error: {ex.Message}");
            }
        }

        protected string GetFlagEmoji(string countryName)
        {
            if (string.IsNullOrEmpty(countryName))
                return "🌍";

            var flagMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                {"Japan", "🇯🇵"},
                {"China", "🇨🇳"},
                {"India", "🇮🇳"},
                {"South Korea", "🇰🇷"},
                {"Thailand", "🇹🇭"},
                {"Vietnam", "🇻🇳"},
                {"Indonesia", "🇮🇩"},
                {"Malaysia", "🇲🇾"},
                {"Singapore", "🇸🇬"},
                {"Philippines", "🇵🇭"},
                {"France", "🇫🇷"},
                {"Italy", "🇮🇹"},
                {"Spain", "🇪🇸"},
                {"Germany", "🇩🇪"},
                {"United Kingdom", "🇬🇧"},
                {"Greece", "🇬🇷"},
                {"Portugal", "🇵🇹"},
                {"Netherlands", "🇳🇱"},
                {"United States", "🇺🇸"},
                {"Canada", "🇨🇦"},
                {"Mexico", "🇲🇽"},
                {"Brazil", "🇧🇷"},
                {"Argentina", "🇦🇷"},
                {"Chile", "🇨🇱"},
                {"Peru", "🇵🇪"},
                {"Colombia", "🇨🇴"},
                {"Egypt", "🇪🇬"},
                {"South Africa", "🇿🇦"},
                {"Morocco", "🇲🇦"},
                {"Kenya", "🇰🇪"},
                {"Nigeria", "🇳🇬"},
                {"Australia", "🇦🇺"},
                {"New Zealand", "🇳🇿"}
            };

            return flagMap.ContainsKey(countryName) ? flagMap[countryName] : "🌍";
        }
    }
}
