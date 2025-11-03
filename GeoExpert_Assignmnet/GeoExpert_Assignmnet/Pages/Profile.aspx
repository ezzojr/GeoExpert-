<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Profile 👤</h2>
    
    <!-- TODO: Member C - Display user info, badges, progress, streak -->
    
    <div class="profile-container">
        <div class="profile-info">
            <h3>Welcome, <asp:Literal ID="litUsername" runat="server"></asp:Literal>!</h3>
            <p>Email: <asp:Literal ID="litEmail" runat="server"></asp:Literal></p>
            <p>Current Streak: <asp:Literal ID="litStreak" runat="server"></asp:Literal> days 🔥</p>
            <p>Member since: <asp:Literal ID="litJoinDate" runat="server"></asp:Literal></p>
        </div>
        
        <div class="badges-section">
            <h3>My Badges 🏆</h3>
            <asp:Repeater ID="rptBadges" runat="server">
                <HeaderTemplate>
                    <div class="badges-grid">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="badge-card">
                        <h4><%# Eval("BadgeName") %></h4>
                        <p><%# Eval("BadgeDescription") %></p>
                        <small>Earned: <%# Eval("AwardedDate", "{0:MMM dd, yyyy}") %></small>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Label ID="lblNoBadges" runat="server" Text="No badges yet. Keep learning!" Visible="false"></asp:Label>
        </div>
        
        <div class="progress-section">
            <h3>Quiz History 📊</h3>
            <asp:GridView ID="gvProgress" runat="server" AutoGenerateColumns="False" CssClass="progress-table">
                <Columns>
                    <asp:BoundField DataField="CompletedDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                    <asp:BoundField DataField="Question" HeaderText="Quiz" />
                    <asp:BoundField DataField="Score" HeaderText="Score" />
                    <asp:BoundField DataField="TotalQuestions" HeaderText="Total" />
                </Columns>
            </asp:GridView>
        </div>
        
        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
    </div>
</asp:Content>