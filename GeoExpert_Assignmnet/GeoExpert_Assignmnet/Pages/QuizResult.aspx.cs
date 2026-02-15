using System;
using System.Collections.Generic;
using System.Runtime.Remoting.Messaging;
using System.Web.UI;

namespace GeoExpert_Assignment.Pages
{
    public partial class QuizResult : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadResults();
            }
        }

        private void LoadResults()
        {
            if (Session["QuizScore"] != null && Session["QuizTotal"] != null)
            {
                int score = Convert.ToInt32(Session["QuizScore"]);
                int total = Convert.ToInt32(Session["QuizTotal"]);
                List<QuizReviewItem> reviewItems = Session["QuizReview"] as List<QuizReviewItem>;

                litScore.Text = score.ToString();
                litTotal.Text = total.ToString();

                int percentage = total > 0 ? (int)((double)score / total * 100) : 0;
                litPercentage.Text = percentage.ToString();

                // Performance message
                if (percentage == 100)
                    litMessage.Text = "Perfect! You're a geography master! 🌟";
                else if (percentage >= 80)
                    litMessage.Text = "Excellent work! You really know your stuff! 🎉";
                else if (percentage >= 60)
                    litMessage.Text = "Good job! Keep learning! 👍";
                else if (percentage >= 40)
                    litMessage.Text = "Not bad! Review and try again! 📚";
                else
                    litMessage.Text = "Keep practicing! You'll get better! 💪";

                // Show badge if perfect score
                if (score == total && total > 0)
                {
                    pnlBadge.Visible = true;
                }

                // Display review
                if (reviewItems != null && reviewItems.Count > 0)
                {
                    rptReview.DataSource = reviewItems;
                    rptReview.DataBind();
                }

                // Clear session
                Session.Remove("QuizScore");
                Session.Remove("QuizTotal");
                Session.Remove("QuizReview");
            }
            else
            {
                Response.Redirect("Countries.aspx");
            }
        }
    }
}