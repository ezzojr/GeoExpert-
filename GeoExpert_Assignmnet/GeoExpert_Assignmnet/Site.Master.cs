using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;

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

                // Set active based on current page
                if (currentPage.EndsWith("default.aspx") ||
                    currentPage == "/" ||
                    currentPage.EndsWith("/geoexpert_assignment/") ||
                    currentPage.EndsWith("/geoexpert_assignment"))
                {
                    if (Session["UserID"] == null)
                    {
                        AddActiveClass(navHome);
                    }
                }
                else if (currentPage.Contains("countries.aspx") ||
                         currentPage.Contains("countrydetail.aspx"))
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
                {
                    link.Attributes["class"] = (currentClass + " active").Trim();
                }
            }
        }

        private void RemoveActiveClass(HtmlAnchor link)
        {
            if (link != null && link.Attributes["class"] != null)
            {
                link.Attributes["class"] = link.Attributes["class"]
                    .Replace("active", "")
                    .Trim();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

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