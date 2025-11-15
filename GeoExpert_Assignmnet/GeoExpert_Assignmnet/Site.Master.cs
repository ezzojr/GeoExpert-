using System;
using System.Web;
using System.Web.UI;

namespace GeoExpert_Assignment
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                phLoggedIn.Visible = true;
                phAnonymous.Visible = false;
                lblWelcome.Text = "👋 " + Session["Username"]?.ToString();

                // Show/hide role-specific links
                string role = Session["Role"]?.ToString();
                if (role == "Admin")
                {
                    lnkAdminPanel.Visible = true;
                    lnkTeacherPanel.Visible = false;
                }
                else if (role == "Teacher")
                {
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