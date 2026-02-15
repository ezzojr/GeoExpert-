using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Admin
{
    public partial class ManageCountries : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Allow both Admin and Teacher
            if (Session["Role"] == null ||
                (Session["Role"].ToString() != "Admin" && Session["Role"].ToString() != "Teacher"))
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
            try
            {
                string query = "SELECT CountryID, Name, FlagImage, FoodName, FunFact, ViewCount FROM Countries ORDER BY Name";
                DataTable dt = DBHelper.ExecuteReader(query);
                gvCountries.DataSource = dt;
                gvCountries.DataBind();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error loading countries: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Handle image upload and return path
        private string UploadFlagImage()
        {
            if (fuFlagImage.HasFile)
            {
                try
                {
                    // Validate file type
                    string fileExtension = Path.GetExtension(fuFlagImage.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };

                    if (Array.IndexOf(allowedExtensions, fileExtension) == -1)
                    {
                        lblMessage.Text = "❌ Only image files (JPG, PNG, GIF) are allowed.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        return null;
                    }

                    // Validate file size (5MB max)
                    if (fuFlagImage.PostedFile.ContentLength > 5242880)
                    {
                        lblMessage.Text = "❌ File size must be less than 5MB.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        return null;
                    }

                    // Create uploads folder if it doesn't exist
                    string uploadsFolder = Server.MapPath("~/Uploads/Flags/");
                    if (!Directory.Exists(uploadsFolder))
                    {
                        Directory.CreateDirectory(uploadsFolder);
                    }

                    // Generate unique filename
                    string fileName = Guid.NewGuid().ToString() + fileExtension;
                    string filePath = Path.Combine(uploadsFolder, fileName);

                    // Save file
                    fuFlagImage.SaveAs(filePath);

                    // Return relative path for database
                    return "~/Uploads/Flags/" + fileName;
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "❌ Error uploading file: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return null;
                }
            }

            return null;
        }

        // Add new country
        // Add new country
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            try
            {
                string flagImagePath = UploadFlagImage();

                // If no image uploaded, require it
                if (string.IsNullOrEmpty(flagImagePath))
                {
                    lblMessage.Text = "❌ Please upload a flag image.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                string query = @"INSERT INTO Countries 
                        (Name, FlagImage, FoodName, FoodDescription, CultureInfo, VideoURL, FunFact, ViewCount) 
                        VALUES (@Name, @Flag, @FoodName, @FoodDesc, @Culture, @Video, @Fact, 0)";

                SqlParameter[] parameters = {
            new SqlParameter("@Name", string.IsNullOrEmpty(txtName.Text) ? (object)DBNull.Value : txtName.Text),
            new SqlParameter("@Flag", flagImagePath),
            new SqlParameter("@FoodName", string.IsNullOrEmpty(txtFoodName.Text) ? (object)DBNull.Value : txtFoodName.Text),
            new SqlParameter("@FoodDesc", string.IsNullOrEmpty(txtFoodDesc.Text) ? (object)DBNull.Value : txtFoodDesc.Text),
            new SqlParameter("@Culture", string.IsNullOrEmpty(txtCulture.Text) ? (object)DBNull.Value : txtCulture.Text),
            new SqlParameter("@Video", string.IsNullOrEmpty(txtVideoURL.Text) ? (object)DBNull.Value : txtVideoURL.Text),
            new SqlParameter("@Fact", string.IsNullOrEmpty(txtFunFact.Text) ? (object)DBNull.Value : txtFunFact.Text)
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
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error: " + ex.Message + "<br/>Stack: " + ex.StackTrace;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Edit / Delete button actions
        protected void gvCountries_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
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
                        txtFoodName.Text = row["FoodName"].ToString();
                        txtFoodDesc.Text = row["FoodDescription"].ToString();
                        txtCulture.Text = row["CultureInfo"].ToString();
                        txtVideoURL.Text = row["VideoURL"].ToString();
                        txtFunFact.Text = row["FunFact"].ToString();

                        // Store existing flag path
                        string existingFlag = row["FlagImage"].ToString();
                        hfExistingFlagPath.Value = existingFlag;

                        // Show preview of existing flag
                        if (!string.IsNullOrEmpty(existingFlag))
                        {
                            imgPreview.ImageUrl = ResolveUrl(existingFlag);
                            imgPreview.Visible = true;
                        }

                        btnAdd.Visible = false;
                        btnUpdate.Visible = true;
                        btnCancel.Visible = true;
                        lblFormTitle.Text = "Edit Country ✏️";
                    }
                }
                else if (e.CommandName == "DeleteCountry")
                {
                    // Get flag path before deleting
                    string getFlagQuery = "SELECT FlagImage FROM Countries WHERE CountryID = @CountryID";
                    SqlParameter[] getParams = { new SqlParameter("@CountryID", countryId) };
                    object flagPath = DBHelper.ExecuteScalar(getFlagQuery, getParams);

                    string query = "DELETE FROM Countries WHERE CountryID = @CountryID";
                    SqlParameter[] parameters = { new SqlParameter("@CountryID", countryId) };

                    int result = DBHelper.ExecuteNonQuery(query, parameters);

                    if (result > 0)
                    {
                        // Delete the flag image file if it exists
                        if (flagPath != null && !string.IsNullOrEmpty(flagPath.ToString()))
                        {
                            DeleteFlagImage(flagPath.ToString());
                        }

                        lblMessage.Text = "🗑️ Country deleted successfully!";
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        LoadCountries();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Update country info
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                int countryId = Convert.ToInt32(ViewState["EditCountryID"]);

                // Check if new image uploaded, otherwise keep existing
                string flagImagePath = UploadFlagImage();
                if (string.IsNullOrEmpty(flagImagePath))
                {
                    flagImagePath = hfExistingFlagPath.Value; // Keep existing image
                }
                else
                {
                    // Delete old image if new one uploaded
                    DeleteFlagImage(hfExistingFlagPath.Value);
                }

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
                    new SqlParameter("@Name", string.IsNullOrEmpty(txtName.Text) ? (object)DBNull.Value : txtName.Text),
                    new SqlParameter("@Flag", flagImagePath),
                    new SqlParameter("@FoodName", string.IsNullOrEmpty(txtFoodName.Text) ? (object)DBNull.Value : txtFoodName.Text),
                    new SqlParameter("@FoodDesc", string.IsNullOrEmpty(txtFoodDesc.Text) ? (object)DBNull.Value : txtFoodDesc.Text),
                    new SqlParameter("@Culture", string.IsNullOrEmpty(txtCulture.Text) ? (object)DBNull.Value : txtCulture.Text),
                    new SqlParameter("@Video", string.IsNullOrEmpty(txtVideoURL.Text) ? (object)DBNull.Value : txtVideoURL.Text),
                    new SqlParameter("@Fact", string.IsNullOrEmpty(txtFunFact.Text) ? (object)DBNull.Value : txtFunFact.Text)
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
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error: " + ex.Message + " | " + ex.StackTrace;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Delete flag image file from server
        private void DeleteFlagImage(string flagPath)
        {
            try
            {
                if (!string.IsNullOrEmpty(flagPath) && flagPath.StartsWith("~/Uploads/"))
                {
                    string physicalPath = Server.MapPath(flagPath);
                    if (File.Exists(physicalPath))
                    {
                        File.Delete(physicalPath);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't show to user
                System.Diagnostics.Debug.WriteLine("Error deleting flag image: " + ex.Message);
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
            txtFoodName.Text = "";
            txtFoodDesc.Text = "";
            txtCulture.Text = "";
            txtVideoURL.Text = "";
            txtFunFact.Text = "";
            hfExistingFlagPath.Value = "";
            imgPreview.Visible = false;
        }
    }
}