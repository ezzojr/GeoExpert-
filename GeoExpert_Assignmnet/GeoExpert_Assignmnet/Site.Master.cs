using System;
using System.Web;
using System.Web.UI;

namespace GeoExpert_Assignment
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Handle login visibility
            bool isLoggedIn = Session["UserID"] != null;

            // UPDATED: Set visibility for logged in vs anonymous
            phLoggedIn.Visible = isLoggedIn;
            phAnonymous.Visible = !isLoggedIn;

            // ADDED: Control logo visibility based on login state
            phLogoLoggedIn.Visible = isLoggedIn;    // Show popup logo when logged in
            phLogoAnonymous.Visible = !isLoggedIn;  // Show normal logo when not logged in

            if (isLoggedIn)
            {
                // Show username greeting
                lblWelcome.Text = "Welcome, " + Session["Username"].ToString() + "!";

                // Show admin link if user is admin
                if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
                {
                    phAdmin.Visible = true;
                }
                else
                {
                    phAdmin.Visible = false;
                }
            }

            // Set active navigation item
            SetActiveNavigationItem();
        }

        private void SetActiveNavigationItem()
        {
            try
            {
                string currentPage = Request.Url.AbsolutePath.ToLower();

                // Clear all active states first
                if (Session["UserID"] != null)
                {
                    // For logged in users
                    RemoveActiveClass(navCountries);
                    RemoveActiveClass(navProfile);

                    if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
                    {
                        RemoveActiveClass(navAdmin);
                    }
                }
                else
                {
                    // For anonymous users
                    RemoveActiveClass(navHome);
                    RemoveActiveClass(navCountriesAnon);
                }
            if (Session["UserID"] != null)
            {
                phLoggedIn.Visible = true;
                phAnonymous.Visible = false;
                lblWelcome.Text = "👋 " + Session["Username"]?.ToString();

                // Show/hide role-specific links
                string role = Session["Role"]?.ToString();
                if (role == "Admin")
                {
                    if (Session["UserID"] == null)
                    {
                        AddActiveClass(navHome);
                    }
                    lnkAdminPanel.Visible = true;
                    lnkTeacherPanel.Visible = false;
                }
                else if (role == "Teacher")
                {
                    if (Session["UserID"] != null)
                    {
                        AddActiveClass(navCountries);
                    }
                    else
                    {
                        AddActiveClass(navCountriesAnon);
                    }
                }
                else if (currentPage.Contains("profile.aspx"))
                {
                    AddActiveClass(navProfile);
                }
                else if (currentPage.Contains("/admin/"))
                {
                    AddActiveClass(navAdmin);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"SetActiveNavigationItem error: {ex.Message}");
            }
        }

        private void AddActiveClass(HtmlAnchor link)
        {
            if (link != null)
            {
                string currentClass = link.Attributes["class"] ?? "";
                if (!currentClass.Contains("active"))
                    lnkAdminPanel.Visible = false;
                    lnkTeacherPanel.Visible = true;
                }
                else
                {
                    lnkAdminPanel.Visible = false;
                    lnkTeacherPanel.Visible = false;
                }
            }
            else
            {
                phLoggedIn.Visible = false;
                phAnonymous.Visible = true;
                lnkAdminPanel.Visible = false;
                lnkTeacherPanel.Visible = false;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            // Expire cookies
            ExpireCookie("Username");
            ExpireCookie("Password");
            ExpireCookie("RememberMe");

            Response.Redirect("~/Default.aspx");
        }

        private void ExpireCookie(string name)
        {
            if (Request.Cookies[name] != null)
            {
                HttpCookie cookie = new HttpCookie(name);
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }
        }
    }
}