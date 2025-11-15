<%@ Page Title="Teacher Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TeacherDashboard.aspx.cs" Inherits="GeoExpert_Assignment.Teacher.TeacherDashboard" %>

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
        <h1 class="dashboard-title">Teacher Dashboard 🍎</h1>

        <div class="admin-stats">
            <div class="stat-card">
                <h3><asp:Literal ID="litMyQuizzes" runat="server"></asp:Literal></h3>
                <p>Total Quizzes Created</p>
            </div>
            <div class="stat-card">
                <h3><asp:Literal ID="litCountriesCovered" runat="server"></asp:Literal></h3>
                <p>Countries Covered</p>
            </div>
            <div class="stat-card">
                <h3><asp:Literal ID="litAvgQuestions" runat="server"></asp:Literal></h3>
                <p>Average Questions per Quiz</p>
            </div>
            <div class="stat-card">
                <h3><asp:Literal ID="litRecentQuiz" runat="server"></asp:Literal></h3>
                <p>Most Recent Quiz</p>
            </div>
        </div>

        <h3 class="section-title">📘 Recent Quizzes You Created</h3>
        <asp:GridView ID="gvMyQuizzes" runat="server" AutoGenerateColumns="False" CssClass="table">
            <Columns>
                <asp:BoundField DataField="QuizID" HeaderText="ID" />
                <asp:BoundField DataField="CountryName" HeaderText="Country" />
                <asp:BoundField DataField="Question" HeaderText="Question" />
                <asp:BoundField DataField="CreatedDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
            </Columns>
        </asp:GridView>

        <div class="admin-links">
            <h3>🚀 Quick Actions</h3>
            <a href="../Admin/ManageQuizzes.aspx">Manage My Quizzes</a>
            <a href="../Admin/ManageCountries.aspx">Manage Countries</a>
            <a href="../Pages/UpdateProfile.aspx">Edit Profile</a>
        </div>
    </div>
</asp:Content>
