<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Login</h2>
    
    <asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnLogin">

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
    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
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
        </asp:Panel>
<br />
<asp:Label ID="lblMessage" runat="server" ForeColor="Red" />

<p>Don't have an account? <a href="Register.aspx">Register here</a></p>
</asp:Content>