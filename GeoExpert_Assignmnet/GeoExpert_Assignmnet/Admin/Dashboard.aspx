<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="GeoExpert_Assignment.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Admin Dashboard 🛠️</h2>
    
    <!-- TODO: Member D - Display statistics and quick links -->
    
    <div class="admin-stats">
        <div class="stat-card">
            <h3><asp:Literal ID="litTotalUsers" runat="server"></asp:Literal></h3>
            <p>Total Users</p>
        </div>
        
        <div class="stat-card">
            <h3><asp:Literal ID="litTotalCountries" runat="server"></asp:Literal></h3>
            <p>Countries</p>
        </div>
        
        <div class="stat-card">
            <h3><asp:Literal ID="litTotalQuizzes" runat="server"></asp:Literal></h3>
            <p>Quizzes</p>
        </div>
        
        <div class="stat-card">
            <h3><asp:Literal ID="litTotalBadges" runat="server"></asp:Literal></h3>
            <p>Badges Awarded</p>
        </div>
    </div>
    
    <div class="admin-links">
        <h3>Quick Actions</h3>
        <a href="ManageCountries.aspx" class="btn btn-primary">Manage Countries</a>
        <a href="ManageQuizzes.aspx" class="btn btn-primary">Manage Quizzes</a>
        <a href="ManageUsers.aspx" class="btn btn-primary">Manage Users</a>
    </div>
</asp:Content>