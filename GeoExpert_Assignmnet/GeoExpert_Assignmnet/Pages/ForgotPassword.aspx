<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs"
    Inherits="GeoExpert_Assignment.Pages.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="max-width:500px; margin:auto; background-color:rgba(26,26,46,0.8); 
                padding:2rem; border-radius:16px; box-shadow:0 8px 25px rgba(0,0,0,0.3);">
        <h2 style="color:#4facfe;">Forgot Password</h2>
        <p>Enter your registered email address below. A temporary password will be sent to your inbox.</p>

        <div class="form-group" style="margin-top:1rem;">
            <label style="display:block; margin-bottom:0.5rem;">Email:</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                         style="width:100%; padding:0.5rem; border-radius:8px; border:1px solid #4facfe;"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                ErrorMessage="Email is required" ForeColor="Red"></asp:RequiredFieldValidator>
        </div>

        <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password"
                    CssClass="btn btn-primary"
                    style="margin-top:1rem; width:100%; padding:0.75rem; border-radius:10px;
                           background:linear-gradient(135deg,#4facfe 0%,#00f2fe 100%); color:#000;"
                    OnClick="btnResetPassword_Click" />
        <br /><br />

        <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
    </div>
</asp:Content>
