<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Create Account</h2>
    
    <!-- TODO: Member C - Implement registration form with client & server validation -->
    
    <div class="form-group">
        <label>Username:</label>
        <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
            ControlToValidate="txtUsername" 
            ErrorMessage="Username is required" 
            ForeColor="Red">
        </asp:RequiredFieldValidator>
    </div>
    
    <div class="form-group">
        <label>Email:</label>
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"></asp:TextBox>
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
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
            ControlToValidate="txtPassword" 
            ErrorMessage="Password is required" 
            ForeColor="Red">
        </asp:RequiredFieldValidator>
    </div>
    
    <div class="form-group">
        <label>Confirm Password:</label>
        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
        <asp:CompareValidator ID="cvPassword" runat="server" 
            ControlToValidate="txtConfirmPassword"
            ControlToCompare="txtPassword"
            ErrorMessage="Passwords do not match"
            ForeColor="Red">
        </asp:CompareValidator>
    </div>
    
    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary" OnClick="btnRegister_Click" />
    <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
    
    <p>Already have an account? <a href="Login.aspx">Login here</a></p>
</asp:Content>