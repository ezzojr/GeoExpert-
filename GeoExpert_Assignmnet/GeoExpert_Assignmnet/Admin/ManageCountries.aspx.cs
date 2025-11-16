using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebGrease.Activities;

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
            string query = "SELECT CountryID, Name, FlagImage, FoodName, FunFact, Region, ViewCount FROM Countries ORDER BY Name";
            DataTable dt = DBHelper.ExecuteReader(query);
            gvCountries.DataSource = dt;
            gvCountries.DataBind();
        }

        // Add new country
        protected void btnAdd_Click(object sender, EventArgs e)
        {

            string flagPath = null;

            if (fuFlagImage.HasFile)
            {
                string fileName = Guid.NewGuid() + Path.GetExtension(fuFlagImage.FileName);
                flagPath = "/Assets/Flags/" + fileName;

                string physicalPath = Server.MapPath(flagPath);
                string folder = Path.GetDirectoryName(physicalPath);

                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                fuFlagImage.SaveAs(physicalPath);
            }

            string query = @"INSERT INTO Countries 
                            (Name, FlagImage, FoodName, FoodDescription, CultureInfo, VideoURL, FunFact, Region, ViewCount) 
                            VALUES (@Name, @Flag, @FoodName, @FoodDesc, @Culture, @Video, @Fact, @Region, 0)";

            SqlParameter[] parameters = {
                new SqlParameter("@Name", txtName.Text),
                new SqlParameter("@Flag", (object)flagPath ?? DBNull.Value),
                new SqlParameter("@FoodName", txtFoodName.Text),
                new SqlParameter("@FoodDesc", txtFoodDesc.Text),
                new SqlParameter("@Culture", txtCulture.Text),
                new SqlParameter("@Video", txtVideoURL.Text),
                new SqlParameter("@Fact", txtFunFact.Text),
              new SqlParameter("@Region", ddlRegion.SelectedValue)
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
        protected void btnUploadPicture_Click(object sender, EventArgs e)
        {
            try
            {
                if (fuFlagImage.HasFile)
                {
                    string fileExt = System.IO.Path.GetExtension(fuFlagImage.FileName);
                    string[] allowedExt = { ".jpg", ".jpeg", ".png" };

                    if (!allowedExt.Contains(fileExt))
                    {
                        ShowError("Please upload an image file (JPG, PNG, or GIF)");
                        return;
                    }

                    string folderPath = Server.MapPath("~/Assets/Flags/");
                    if (!System.IO.Directory.Exists(folderPath))
                    {
                        System.IO.Directory.CreateDirectory(folderPath);
                    }

                    string fileName = $"{fuFlagImage.FileName}{fileExt}";
                    string filePath = System.IO.Path.Combine(folderPath, fileName);
                    string dbPath = $"~/Assets/Flags/{fileName}";

                    //// Delete old profile picture
                    //try
                    //{
                    //    string oldPicQuery = "SELECT ProfilePicture FROM Users WHERE UserID = @UserID";
                    //    SqlParameter[] oldParams = { new SqlParameter("@UserID", userId) };
                    //    object oldPicResult = DBHelper.ExecuteScalar(oldPicQuery, oldParams);

                    //    if (oldPicResult != null && oldPicResult != DBNull.Value)
                    //    {
                    //        string oldPic = oldPicResult.ToString();
                    //        if (!string.IsNullOrEmpty(oldPic))
                    //        {
                    //            string oldPath = Server.MapPath(oldPic);
                    //            if (System.IO.File.Exists(oldPath))
                    //            {
                    //                System.IO.File.Delete(oldPath);
                    //            }
                    //        }
                    //    }
                    //}
                    //catch { /* Ignore errors deleting old picture */ }

                    fuFlagImage.SaveAs(filePath);

                   
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"btnUploadPicture error: {ex.Message}");
                ShowError("An error occurred while uploading your profile picture. Please try again.");
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
                    imgCurrentFlag.ImageUrl = row["FlagImage"].ToString();
                    imgCurrentFlag.Visible = true;
                    txtFoodName.Text = row["FoodName"].ToString();
                    txtFoodDesc.Text = row["FoodDescription"].ToString();
                    txtCulture.Text = row["CultureInfo"].ToString();
                    txtVideoURL.Text = row["VideoURL"].ToString();
                    txtFunFact.Text = row["FunFact"].ToString();
                    ddlRegion.SelectedValue = row["Region"].ToString();

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

            string flagPath = null;
            string oldFlagPath = GetCurrentFlagPath(countryId);

            if (fuFlagImage.HasFile)
            {
                if (!string.IsNullOrEmpty(oldFlagPath))
                {
                    string oldPhysical = Server.MapPath(oldFlagPath);
                    if (File.Exists(oldPhysical)) File.Delete(oldPhysical);
                }

                string fileName = Guid.NewGuid() + Path.GetExtension(fuFlagImage.FileName);
                flagPath = "/Assets/Flags/" + fileName;

                string physicalPath = Server.MapPath(flagPath);
                string folder = Path.GetDirectoryName(physicalPath);

                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                fuFlagImage.SaveAs(physicalPath);
            }
            else
            {
                flagPath = oldFlagPath;
            }



            string query = @"UPDATE Countries SET 
                            Name = @Name,
                            FlagImage = @Flag, 
                            FoodName = @FoodName, 
                            FoodDescription = @FoodDesc, 
                            CultureInfo = @Culture, 
                            VideoURL = @Video, 
                            FunFact = @Fact, 
                            Region = @Region 
                            WHERE CountryID = @CountryID";

            SqlParameter[] parameters = {
                new SqlParameter("@CountryID", countryId),
                new SqlParameter("@Name", txtName.Text),
                new SqlParameter("@Flag", (object)flagPath ?? DBNull.Value),
                new SqlParameter("@FoodName", txtFoodName.Text),
                new SqlParameter("@FoodDesc", txtFoodDesc.Text),
                new SqlParameter("@Culture", txtCulture.Text),
                new SqlParameter("@Video", txtVideoURL.Text),
                new SqlParameter("@Fact", txtFunFact.Text),
                new SqlParameter("@Region", ddlRegion.SelectedValue)
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
            imgCurrentFlag.Visible = false;
            txtFoodName.Text = "";
            txtFoodDesc.Text = "";
            txtCulture.Text = "";
            txtVideoURL.Text = "";
            txtFunFact.Text = "";
            ddlRegion.SelectedIndex = 0;
        }
        private string GetCurrentFlagPath(int id)
        {
            string query = "SELECT FlagImage FROM Countries WHERE CountryID = @ID";
            SqlParameter[] p = { new SqlParameter("@ID", id) };

            DataTable dt = DBHelper.ExecuteReader(query, p);
            if (dt.Rows.Count > 0)
                return dt.Rows[0]["FlagImage"].ToString();

            return null;
        }
        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = message;
            pnlSuccess.Visible = false;

            ScriptManager.RegisterStartupScript(this, GetType(), "scrollToTop",
                "window.scrollTo(0, 0);", true);
        }
    }
}
