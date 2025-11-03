<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="GeoExpert_Assignment.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Manage Users 👥</h2>
    
    <!-- TODO: Member D - View and manage users -->
    
    <h3>All Registered Users</h3>
    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" 
                  CssClass="data-table" OnRowCommand="gvUsers_RowCommand">
        <Columns>
            <asp:BoundField DataField="UserID" HeaderText="ID" />
            <asp:BoundField DataField="Username" HeaderText="Username" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Role" HeaderText="Role" />
            <asp:BoundField DataField="CurrentStreak" HeaderText="Streak" />
            <asp:BoundField DataField="CreatedDate" HeaderText="Joined" DataFormatString="{0:MMM dd, yyyy}" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnDelete" runat="server" Text="Delete" 
                                CommandName="DeleteUser" 
                                CommandArgument='<%# Eval("UserID") %>' 
                                CssClass="btn btn-danger" 
                                OnClientClick="return confirm('Are you sure you want to delete this user?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    
    <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
</asp:Content>