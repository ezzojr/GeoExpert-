<%@ Page Title="Manage Quizzes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageQuizzes.aspx.cs" Inherits="GeoExpert_Assignment.Admin.ManageQuizzes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .quiz-container {
            background-color: #1c1c1e;
            color: #f2f2f2;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.4);
            margin-bottom: 30px;
        }

        h2, h3, h4 {
            color: #f5f5f5;
        }

        label {
            color: #9ac9ff;
            font-weight: 600;
        }

        .form-control {
            background-color: #2a2a2d;
            border: 1px solid #444;
            color: #fff;
            border-radius: 8px;
            padding: 8px;
            width: 100%;
            margin-bottom: 10px;
        }

        .form-control:focus {
            border-color: #4ea3ff;
            outline: none;
            box-shadow: 0 0 8px #4ea3ff;
        }

        .btn {
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 600;
        }

        .btn-primary {
            background-color: #4ea3ff;
            border: none;
            color: #fff;
        }

        .btn-primary:hover {
            background-color: #007bff;
        }

        .btn-warning {
            background-color: #ffa500;
            border: none;
            color: #000;
        }

        .btn-warning:hover {
            background-color: #ff8c00;
        }

        .btn-secondary {
            background-color: #6c757d;
            border: none;
            color: #fff;
        }

        .btn-danger {
            background-color: #ff4d4d;
            border: none;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            color: #fff;
        }

        .data-table th {
            background-color: #2e2e31;
            padding: 10px;
            text-align: left;
            border-bottom: 2px solid #444;
        }

        .data-table td {
            background-color: #242426;
            padding: 10px;
            border-bottom: 1px solid #333;
        }

        .data-table tr:hover td {
            background-color: #2f2f32;
        }

        .check-label {
            color: #bdbdbd;
        }
    </style>

    <h2 class="mb-4">Manage Quizzes 📝</h2>

    <div class="quiz-container">
        <h3>Add New Quiz Question</h3>

        <div class="form-group">
            <label>Select Country:</label><br />
            <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control" />
        </div>

        <div class="form-group">
            <label>Question:</label><br />
            <asp:TextBox ID="txtQuestion" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" />
            <asp:RequiredFieldValidator ID="rfvQuestion" runat="server"
                ControlToValidate="txtQuestion" ErrorMessage="*Required" ForeColor="Red" />
        </div>

        <h4>Options (Add 4 options — multiple correct answers supported ✅)</h4>

        <div class="form-group">
            <label>Option 1:</label>
            <asp:TextBox ID="txtOption1" runat="server" CssClass="form-control" />
            <asp:CheckBox ID="chkCorrect1" runat="server" Text="Correct Answer" CssClass="check-label" />
        </div>

        <div class="form-group">
            <label>Option 2:</label>
            <asp:TextBox ID="txtOption2" runat="server" CssClass="form-control" />
            <asp:CheckBox ID="chkCorrect2" runat="server" Text="Correct Answer" CssClass="check-label" />
        </div>

        <div class="form-group">
            <label>Option 3:</label>
            <asp:TextBox ID="txtOption3" runat="server" CssClass="form-control" />
            <asp:CheckBox ID="chkCorrect3" runat="server" Text="Correct Answer" CssClass="check-label" />
        </div>

        <div class="form-group">
            <label>Option 4:</label>
            <asp:TextBox ID="txtOption4" runat="server" CssClass="form-control" />
            <asp:CheckBox ID="chkCorrect4" runat="server" Text="Correct Answer" CssClass="check-label" />
        </div>

        <asp:Button ID="btnAddQuiz" runat="server" Text="Add Quiz" CssClass="btn btn-primary mt-2" OnClick="btnAddQuiz_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary mt-2" OnClick="btnCancel_Click" CausesValidation="false" />
        <br />
        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" ForeColor="LightGreen"></asp:Label>
    </div>

    <h3>All Quizzes</h3>
    <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="False"
    CssClass="table" OnRowCommand="gvQuizzes_RowCommand">
    <Columns>
        <asp:BoundField DataField="QuizID" HeaderText="Quiz ID" />
        <asp:BoundField DataField="CountryName" HeaderText="Country" />
        <asp:BoundField DataField="Question" HeaderText="Question" />
        <asp:BoundField DataField="CreatedBy" HeaderText="Created By" />

        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:Button ID="btnEditQuiz" runat="server" Text="Edit"
                    CssClass="btn btn-warning"
                    CommandName="EditQuiz"
                    CommandArgument='<%# Eval("QuizID") %>'
                    CausesValidation="false" />

                <asp:Button ID="btnViewSolvers" runat="server" Text="View Solvers"
                    CssClass="btn btn-secondary"
                    CommandName="ViewSolvers"
                    CommandArgument='<%# Eval("QuizID") %>'
                    CausesValidation="false" />

                <asp:Button ID="btnDeleteQuiz" runat="server" Text="Delete"
                    CssClass="btn btn-danger"
                    CommandName="DeleteQuiz"
                    CommandArgument='<%# Eval("QuizID") %>'
                    OnClientClick="return confirm('Are you sure you want to delete this quiz?');"
                    CausesValidation="false" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

</asp:Content>