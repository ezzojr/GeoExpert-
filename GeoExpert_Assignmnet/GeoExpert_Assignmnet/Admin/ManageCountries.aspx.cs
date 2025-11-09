using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Admin
{
    public partial class ManageCountries : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect non-admin users to login
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadCountries();
        }

        // Load all countries
        private void LoadCountries()
        {
            string query = "SELECT CountryID, Name, FlagImage, FoodName, FunFact, ViewCount FROM Countries ORDER BY Name";
            DataTable dt = DBHelper.ExecuteReader(query);
            gvCountries.DataSource = dt;
            gvCountries.DataBind();
        }

        // Add new country
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string query = @"INSERT INTO Countries 
                            (Name, FlagImage, FoodName, FoodDescription, CultureInfo, VideoURL, FunFact, ViewCount) 
                            VALUES (@Name, @Flag, @FoodName, @FoodDesc, @Culture, @Video, @Fact, 0)";

            SqlParameter[] parameters = {
                new SqlParameter("@Name", txtName.Text),
                new SqlParameter("@Flag", txtFlagImage.Text),
                new SqlParameter("@FoodName", txtFoodName.Text),
                new SqlParameter("@FoodDesc", txtFoodDesc.Text),
                new SqlParameter("@Culture", txtCulture.Text),
                new SqlParameter("@Video", txtVideoURL.Text),
                new SqlParameter("@Fact", txtFunFact.Text)
            };

            int result = DBHelper.ExecuteNonQuery(query, parameters);

            if (result > 0)
            {
                lblMessage.Text = "✅ Country added successfully!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                ClearFields();
                LoadCountries();
            }
            else
            {
                lblMessage.Text = "❌ Error adding country.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Edit / Delete button actions
        protected void gvCountries_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int countryId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCountry")
            {
                string query = "SELECT * FROM Countries WHERE CountryID = @CountryID";
                SqlParameter[] parameters = { new SqlParameter("@CountryID", countryId) };

                DataTable dt = DBHelper.ExecuteReader(query, parameters);
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    ViewState["EditCountryID"] = countryId;

                    txtName.Text = row["Name"].ToString();
                    txtFlagImage.Text = row["FlagImage"].ToString();
                    txtFoodName.Text = row["FoodName"].ToString();
                    txtFoodDesc.Text = row["FoodDescription"].ToString();
                    txtCulture.Text = row["CultureInfo"].ToString();
                    txtVideoURL.Text = row["VideoURL"].ToString();
                    txtFunFact.Text = row["FunFact"].ToString();

                    btnAdd.Visible = false;
                    btnUpdate.Visible = true;
                    btnCancel.Visible = true;
                    lblFormTitle.Text = "Edit Country ✏️";
                }
            }
            else if (e.CommandName == "DeleteCountry")
            {
                string query = "DELETE FROM Countries WHERE CountryID = @CountryID";
                SqlParameter[] parameters = { new SqlParameter("@CountryID", countryId) };

                int result = DBHelper.ExecuteNonQuery(query, parameters);

                if (result > 0)
                {
                    lblMessage.Text = "🗑️ Country deleted successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    LoadCountries();
                }
            }
        }

        // Update country info
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int countryId = Convert.ToInt32(ViewState["EditCountryID"]);

            string query = @"UPDATE Countries SET 
                            Name = @Name, 
                            FlagImage = @Flag, 
                            FoodName = @FoodName, 
                            FoodDescription = @FoodDesc, 
                            CultureInfo = @Culture, 
                            VideoURL = @Video, 
                            FunFact = @Fact 
                            WHERE CountryID = @CountryID";

            SqlParameter[] parameters = {
                new SqlParameter("@CountryID", countryId),
                new SqlParameter("@Name", txtName.Text),
                new SqlParameter("@Flag", txtFlagImage.Text),
                new SqlParameter("@FoodName", txtFoodName.Text),
                new SqlParameter("@FoodDesc", txtFoodDesc.Text),
                new SqlParameter("@Culture", txtCulture.Text),
                new SqlParameter("@Video", txtVideoURL.Text),
                new SqlParameter("@Fact", txtFunFact.Text)
            };

            int result = DBHelper.ExecuteNonQuery(query, parameters);

            if (result > 0)
            {
                lblMessage.Text = "✅ Country updated successfully!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                ClearFields();
                LoadCountries();

                btnAdd.Visible = true;
                btnUpdate.Visible = false;
                btnCancel.Visible = false;
                lblFormTitle.Text = "Add New Country";
            }
        }

        // Cancel editing
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearFields();
            btnAdd.Visible = true;
            btnUpdate.Visible = false;
            btnCancel.Visible = false;
            lblFormTitle.Text = "Add New Country";
        }

        // Clear form inputs
        private void ClearFields()
        {
            txtName.Text = "";
            txtFlagImage.Text = "";
            txtFoodName.Text = "";
            txtFoodDesc.Text = "";
            txtCulture.Text = "";
            txtVideoURL.Text = "";
            txtFunFact.Text = "";
        }
    }
}
