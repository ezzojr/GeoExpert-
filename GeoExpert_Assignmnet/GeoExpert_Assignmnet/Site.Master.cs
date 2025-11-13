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
            phLoggedIn.Visible = isLoggedIn;
            phAnonymous.Visible = !isLoggedIn;
            phHomeLink.Visible = !isLoggedIn;

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
                RemoveActiveClass(navHome);
                RemoveActiveClass(navCountries);
                RemoveActiveClass(navQuizzes);

                if (Session["UserID"] != null)
                {
                    RemoveActiveClass(navProfile);

                    if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
                    {
                        RemoveActiveClass(navAdmin);
                    }
                }

                // Set active based on current page
                if (currentPage.EndsWith("default.aspx") ||
                    currentPage == "/" ||
                    currentPage.EndsWith("/geoexpert_assignment/") ||
                    currentPage.EndsWith("/geoexpert_assignment"))
                {
                    AddActiveClass(navHome);
                }
                else if (currentPage.Contains("countries.aspx") ||
                         currentPage.Contains("countrydetail.aspx"))
                {
                    AddActiveClass(navCountries);
                }
                else if (currentPage.Contains("quiz"))
                {
                    AddActiveClass(navQuizzes);
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