using System;
using System.Web;
using System.Web.UI;

namespace GeoExpert_Assignment
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // -Show username greeting if logged in
            if (Session["Username"] != null)
            {
                lblWelcome.Visible = true;
                lblWelcome.Text = "Welcome, " + Session["Username"].ToString() + "!";
            }
            else
            {
                if (lblWelcome != null)
                    lblWelcome.Visible = false;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear all session data
            Session.Clear();
            Session.Abandon();

            // Clear Remember Me cookies
            ExpireCookie("Username");
            ExpireCookie("Password");
            ExpireCookie("RememberMe");

            // Redirect to homepage
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
