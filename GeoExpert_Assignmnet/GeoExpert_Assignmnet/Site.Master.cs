using System;
using System.Web.UI;

namespace GeoExpert_Assignment
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // You can add logic here to show/hide nav items based on login status
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear all session data
            Session.Clear();
            Session.Abandon();

            // Redirect to homepage
            Response.Redirect("~/Default.aspx");
        }
    }
}