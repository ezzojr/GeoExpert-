<%@ Page Title="Quiz" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Quiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .quiz-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .quiz-header {
            background: linear-gradient(135deg, rgba(79, 172, 254, 0.1) 0%, rgba(0, 242, 254, 0.1) 100%);
            border: 1px solid rgba(79, 172, 254, 0.3);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }

        .quiz-question {
            background: rgba(26, 26, 46, 0.6);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 1.5rem;
        }

        .quiz-question h4 {
            color: #4facfe;
            margin-bottom: 1.5rem;
            font-size: 1.25rem;
        }

        .quiz-options {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .quiz-options label {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: rgba(79, 172, 254, 0.05);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .quiz-options label:hover {
            background: rgba(79, 172, 254, 0.1);
            border-color: #4facfe;
        }

        .quiz-options input[type="radio"] {
            margin-right: 1rem;
            width: 20px;
            height: 20px;
        }

        .progress-indicator {
            text-align: center;
            color: #999;
            margin-bottom: 2rem;
            font-size: 1.1rem;
        }

        .cooldown-message {
            background: rgba(255, 193, 7, 0.1);
            border: 2px solid rgba(255, 193, 7, 0.5);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            color: #ffc107;
        }

        .cooldown-message h3 {
            margin-bottom: 1rem;
        }

        .submit-section {
            text-align: center;
            margin-top: 2rem;
        }
    </style>

    <div class="quiz-container">
        <h2>Quiz Time! 🎯</h2>

        <!-- Cooldown Message Panel -->
        <asp:Panel ID="pnlCooldown" runat="server" Visible="false" CssClass="cooldown-message">
            <h3>⏰ Quiz On Cooldown</h3>
            <p>You've already taken this quiz recently. You can retake it in:</p>
            <h2><asp:Literal ID="litCooldownTime" runat="server"></asp:Literal></h2>
            <br />
            <a href="Countries.aspx" class="btn btn-primary">Browse Other Countries</a>
        </asp:Panel>

        <!-- Quiz Header -->
        <asp:Panel ID="pnlQuizHeader" runat="server" Visible="false" CssClass="quiz-header">
            <h3><asp:Literal ID="litCountryName" runat="server"></asp:Literal> Quiz</h3>
            <div class="progress-indicator">
                <asp:Literal ID="litProgress" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <!-- Quiz Questions Panel -->
        <asp:Panel ID="pnlQuiz" runat="server" Visible="false">
            <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="quiz-question">
                        <h4><%# Container.ItemIndex + 1 %>. <%# Eval("Question") %></h4>
                        <asp:HiddenField ID="hfQuizID" runat="server" Value='<%# Eval("QuizID") %>' />
                        <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="quiz-options">
                        </asp:RadioButtonList>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="submit-section">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Quiz" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                <br /><br />
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>
            </div>
        </asp:Panel>

        <!-- No Quiz Available -->
        <asp:Panel ID="pnlNoQuiz" runat="server" Visible="false">
            <div class="alert alert-warning">
                <h3>No Quiz Available</h3>
                <p>There are no quiz questions for this country yet. Please check back later!</p>
                <br />
                <a href="Countries.aspx" class="btn btn-primary">Back to Countries</a>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
