<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Login</h2>

    <div class="form-group">
        <label>Username:</label>
        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
            ControlToValidate="txtUsername"
            ErrorMessage="Username is required"
            ForeColor="Red" />
    </div>

    <div class="form-group">
        <label>Password:</label>
        <!-- Password input with toggle -->
        <div style="position: relative;">
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                         CssClass="form-control"
                         style="width:100%; padding-right:50px;"></asp:TextBox>

            <!-- 👁️ Show/Hide button -->
            <button type="button" id="btnTogglePassword"
                    onclick="togglePassword()"
                    style="position:absolute; right:10px; top:50%; transform:translateY(-50%);
                           background:none; border:none; color:#4facfe; font-weight:bold; cursor:pointer;">
                Show
            </button>
        </div>

        <p><a href="ForgotPassword.aspx">Forgot your password?</a></p>
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
            ControlToValidate="txtPassword"
            ErrorMessage="Password is required"
            ForeColor="Red" />
    </div>

    <div class="form-check">
        <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
        <label class="form-check-label" for="chkRemember">Remember me</label>
    </div>

    <asp:Button ID="btnLogin" runat="server" Text="Login"
        CssClass="btn btn-primary" OnClick="btnLogin_Click" />
    <br />
    <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />

    <p>Don't have an account? <a href="Register.aspx">Register here</a></p>

    <!-- 👇 JavaScript for toggle -->
    <script type="text/javascript">
        function togglePassword() {
            var passwordBox = document.getElementById('<%= txtPassword.ClientID %>');
            var toggleBtn = document.getElementById('btnTogglePassword');

            if (passwordBox.type === 'password') {
                passwordBox.type = 'text';
                toggleBtn.textContent = 'Hide';
            } else {
                passwordBox.type = 'password';
                toggleBtn.textContent = 'Show';
            }
        }
    </script>
</asp:Content>
