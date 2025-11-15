<%@ Page Title="View Solvers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewSolvers.aspx.cs" Inherits="GeoExpert_Assignment.Teacher.ViewSolvers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .solvers-container {
            padding: 2rem;
        }

        h2 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #4facfe;
            margin-bottom: 1rem;
        }

        .back-link {
            display: inline-block;
            color: #00f2fe;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .data-table th, .data-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid rgba(79,172,254,0.2);
            text-align: left;
        }

        .data-table th {
            color: #4facfe;
            font-weight: 600;
        }

        .data-table tr:hover {
            background-color: rgba(79,172,254,0.05);
        }

        .empty-message {
            color: #aaa;
            font-style: italic;
            margin-top: 1rem;
        }
    </style>

    <div class="solvers-container">
        <a href="ManageQuizzes.aspx" class="back-link">← Back to Manage Quizzes</a>

        <h2>Quiz Solvers 🧠</h2>
        <asp:Literal ID="litQuizTitle" runat="server"></asp:Literal>

        <asp:GridView ID="gvSolvers" runat="server" AutoGenerateColumns="False" CssClass="data-table">
            <Columns>
                <asp:BoundField DataField="Username" HeaderText="Student Name" />
                <asp:BoundField DataField="Score" HeaderText="Score" />
                <asp:BoundField DataField="TotalQuestions" HeaderText="Total Questions" />
                <asp:BoundField DataField="Percentage" HeaderText="Percentage" DataFormatString="{0:0.0}%" />
                <asp:BoundField DataField="CompletedDate" HeaderText="Date Completed" DataFormatString="{0:MMM dd, yyyy}" />
            </Columns>
        </asp:GridView>

        <asp:Label ID="lblMessage" runat="server" CssClass="empty-message"></asp:Label>
    </div>
</asp:Content>
