<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Create Account</h2>

    <!-- =================== Registration Form =================== -->

    <div class="form-group">
        <label>Username:</label>
        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
            ControlToValidate="txtUsername" 
            ErrorMessage="Username is required" 
            ForeColor="Red">
        </asp:RequiredFieldValidator>
    </div>

    <div class="form-group">
        <label>Email:</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
            ControlToValidate="txtEmail" 
            ErrorMessage="Email is required" 
            ForeColor="Red">
        </asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="revEmail" runat="server" 
            ControlToValidate="txtEmail"
            ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
            ErrorMessage="Invalid email format"
            ForeColor="Red">
        </asp:RegularExpressionValidator>
    </div>

    <div class="form-group">
        <label>Password:</label>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
            ControlToValidate="txtPassword" 
            ErrorMessage="Password is required" 
            ForeColor="Red">
        </asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="revPassword" runat="server"
            ControlToValidate="txtPassword"
            ValidationExpression=".{6,}"
            ErrorMessage="Password must be at least 6 characters long."
            ForeColor="Red">
        </asp:RegularExpressionValidator>
        <small style="color:gray;">Password must be at least 6 characters long.</small>
    </div>

    <div class="form-group">
        <label>Confirm Password:</label>
        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
        <asp:CompareValidator ID="cvPassword" runat="server" 
            ControlToValidate="txtConfirmPassword"
            ControlToCompare="txtPassword"
            ErrorMessage="Passwords do not match"
            ForeColor="Red">
        </asp:CompareValidator>
    </div>

    <div class="form-group">
        <asp:CheckBox ID="chkShowPassword" runat="server" Text="Show Password" onclick="togglePassword()" />
    </div>

    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary" OnClick="btnRegister_Click" />
    <br /><br />
    <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>

    <p>Already have an account? <a href="Login.aspx">Login here</a></p>

    <!-- =================== JavaScript for Show Password =================== -->
    <script type="text/javascript">
        function togglePassword() {
            var pwd = document.getElementById('<%= txtPassword.ClientID %>');
            var confirm = document.getElementById('<%= txtConfirmPassword.ClientID %>');
            var show = document.getElementById('<%= chkShowPassword.ClientID %>');
            pwd.type = confirm.type = show.checked ? 'text' : 'password';
        }
    </script>

</asp:Content>
