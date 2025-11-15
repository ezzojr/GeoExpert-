<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="GeoExpert_Assignment.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .admin-container {
            padding: 2rem;
        }

        .dashboard-title {
            font-size: 2rem;
            font-weight: 800;
            color: #4facfe;
            margin-bottom: 1.5rem;
        }

        .admin-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: linear-gradient(135deg, rgba(79,172,254,0.15), rgba(0,242,254,0.1));
            border: 1px solid rgba(79,172,254,0.3);
            border-radius: 20px;
            text-align: center;
            padding: 1.5rem;
            box-shadow: 0 8px 24px rgba(79,172,254,0.1);
        }

        .stat-card h3 {
            font-size: 2rem;
            color: #00f2fe;
            font-weight: 700;
        }

        .stat-card p {
            color: #ccc;
            margin-top: 0.25rem;
        }

        h3.section-title {
            margin-top: 3rem;
            color: #4facfe;
            font-weight: 700;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .table th, .table td {
            padding: 0.75rem;
            border-bottom: 1px solid rgba(79,172,254,0.2);
        }

        .table th {
            color: #4facfe;
            font-weight: 600;
        }

        .table tr:hover {
            background-color: rgba(79,172,254,0.05);
        }

        .admin-links {
            margin-top: 2rem;
            text-align: center;
        }

        .admin-links a {
            display: inline-block;
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: #000;
            font-weight: 600;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            text-decoration: none;
            margin: 0.5rem;
            transition: all 0.3s;
        }

        .admin-links a:hover {
            transform: translateY(-3px);
            opacity: 0.9;
        }
    </style>

    <div class="admin-container">
        <h1 class="dashboard-title">Admin Dashboard 🛠️</h1>

        <div class="admin-stats">
            <div class="stat-card">
                <h3><asp:Literal ID="litTotalUsers" runat="server"></asp:Literal></h3>
                <p>Total Users</p>
            </div>
            <div class="stat-card">
                <h3><asp:Literal ID="litTotalCountries" runat="server"></asp:Literal></h3>
                <p>Total Countries</p>
            </div>
            <div class="stat-card">
                <h3><asp:Literal ID="litTotalQuizzes" runat="server"></asp:Literal></h3>
                <p>Total Quizzes</p>
            </div>
            <div class="stat-card">
                <h3><asp:Literal ID="litTotalBadges" runat="server"></asp:Literal></h3>
                <p>Badges Awarded</p>
            </div>
        </div>

        <h3 class="section-title">📊 Recent Quiz Activity</h3>
        <asp:GridView ID="gvRecentActivity" runat="server" AutoGenerateColumns="False" CssClass="table">
            <Columns>
                <asp:BoundField DataField="Username" HeaderText="User" />
                <asp:BoundField DataField="QuizName" HeaderText="Quiz" />
                <asp:BoundField DataField="Score" HeaderText="Score" />
                <asp:BoundField DataField="TotalQuestions" HeaderText="Total Questions" />
                <asp:BoundField DataField="CompletedDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
            </Columns>
        </asp:GridView>

        <h3 class="section-title">🌍 Top 5 Most Viewed Countries</h3>
        <asp:GridView ID="gvTopCountries" runat="server" AutoGenerateColumns="False" CssClass="table">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Country" />
                <asp:BoundField DataField="ViewCount" HeaderText="Views" />
            </Columns>
        </asp:GridView>

        <div class="admin-links">
            <h3>⚙️ Quick Actions</h3>
            
            <a href="ViewQuizzes.aspx">View Quizzes</a>
            <a href="ManageUsers.aspx">Manage Users</a>
        </div>
    </div>
</asp:Content>
