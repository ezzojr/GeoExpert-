using System;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace GeoExpert_Assignment.Pages
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            // 1️⃣ Check if email exists
            string checkQuery = "SELECT UserID, Username FROM Users WHERE Email = @Email";
            SqlParameter[] checkParams = { new SqlParameter("@Email", email) };

            DataTable dt = DBHelper.ExecuteReader(checkQuery, checkParams);
            if (dt.Rows.Count == 0)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "No account found with this email.";
                return;
            }

            string username = dt.Rows[0]["Username"].ToString();

            // 2️⃣ Generate a temporary password
            string tempPassword = GenerateTemporaryPassword();

            // 3️⃣ Hash and update it in the DB
            string hashedPassword = HashPassword(tempPassword);
            string updateQuery = "UPDATE Users SET Password = @Password WHERE Email = @Email";
            SqlParameter[] updateParams = {
                new SqlParameter("@Password", hashedPassword),
                new SqlParameter("@Email", email)
            };

            int rows = DBHelper.ExecuteNonQuery(updateQuery, updateParams);

            if (rows > 0)
            {
                // 4️⃣ Send the new password via email
                bool sent = SendTemporaryPassword(email, username, tempPassword);

                if (sent)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = "A temporary password has been sent to your email. Please check your inbox.";
                }
                else
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Error sending email. Please try again later.";
                }
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Failed to reset password. Please try again.";
            }
        }

        // ✅ Send email with temporary password
        private bool SendTemporaryPassword(string email, string username, string tempPassword)
        {
            try
            {
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("youremail@gmail.com", "GeoExpert Support");
                mail.To.Add(email);
                mail.Subject = "GeoExpert - Temporary Password";
                mail.Body = $@"
                    Hi {username},<br/><br/>
                    You requested a password reset.<br/>
                    Your temporary password is: <b>{tempPassword}</b><br/><br/>
                    Please log in and change it immediately for security.<br/><br/>
                    Best regards,<br/>GeoExpert Team
                ";
                mail.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new NetworkCredential("ma0534320636@gmail.com", "otnxrgyhrycnifxw");
                smtp.EnableSsl = true;
                smtp.Send(mail);

                return true;
            }
            catch (Exception ex)
            {
                // Optional: log ex.Message for debugging
                return false;
            }
        }

        private string GenerateTemporaryPassword()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            Random random = new Random();
            char[] temp = new char[8];
            for (int i = 0; i < temp.Length; i++)
                temp[i] = chars[random.Next(chars.Length)];
            return new string(temp);
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                    builder.Append(b.ToString("x2"));
                return builder.ToString();
            }
        }
    }
}
