<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="QuizResult.aspx.cs" Inherits="GeoExpert_Assignment.Pages.QuizResult" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .quiz-results-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .score-display {
            text-align: center;
            padding: 3rem 2rem;
            background: linear-gradient(135deg, rgba(79, 172, 254, 0.1) 0%, rgba(0, 242, 254, 0.05) 100%);
            border: 2px solid rgba(79, 172, 254, 0.3);
            border-radius: 24px;
            margin-bottom: 2rem;
        }
        .score-circle {
            width: 200px;
            height: 200px;
            margin: 0 auto 2rem;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            font-weight: 900;
            color: #000;
            box-shadow: 0 10px 40px rgba(79, 172, 254, 0.4);
        }
        .question-item {
            background: rgba(26, 26, 46, 0.8);
            border-left: 4px solid;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 1rem;
        }
        .question-item.correct { border-left-color: #26de81; }
        .question-item.incorrect { border-left-color: #fc5c65; }
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 3rem;
            flex-wrap: wrap;
        }
    </style>

    <div class="quiz-results-container">
        <h2>Quiz Results 🎯</h2>
        
        <div class="score-display">
            <div class="score-circle">
                <asp:Literal ID="litPercentage" runat="server"></asp:Literal>%
            </div>
            <h3>You scored <asp:Literal ID="litScore" runat="server"></asp:Literal> out of <asp:Literal ID="litTotal" runat="server"></asp:Literal></h3>
            <p style="font-size: 1.5rem; color: #4facfe; margin-top: 1rem;">
                <asp:Literal ID="litMessage" runat="server"></asp:Literal>
            </p>
        </div>
        
        <asp:Panel ID="pnlBadge" runat="server" Visible="false" 
                   style="background: linear-gradient(135deg, rgba(255, 215, 0, 0.2) 0%, rgba(255, 165, 0, 0.1) 100%);
                          border: 2px solid gold; border-radius: 24px; padding: 2rem; text-align: center; margin-bottom: 2rem;">
            <h3>🏆 Badge Earned!</h3>
            <div style="font-size: 3rem; margin: 1rem 0;">💯</div>
            <p style="font-size: 1.2rem;">Perfect Score!</p>
        </asp:Panel>
        
        <div class="question-review">
            <h3 style="font-size: 1.75rem; margin-bottom: 1.5rem; color: #4facfe;">Question Review</h3>
            <asp:Repeater ID="rptReview" runat="server">
                <ItemTemplate>
                    <div class='question-item <%# (bool)Eval("IsCorrect") ? "correct" : "incorrect" %>'>
                        <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                            <span style="font-size: 1.5rem;"><%# (bool)Eval("IsCorrect") ? "✅" : "❌" %></span>
                            <h4 style="margin: 0;">Question <%# Container.ItemIndex + 1 %></h4>
                        </div>
                        <p style="font-size: 1.1rem; color: #fff; margin-bottom: 0.75rem;"><%# Eval("Question") %></p>
                        <p style="margin: 0.5rem 0; color: #ccc;"><strong>Your answer:</strong> <%# Eval("UserAnswer") %></p>
                        <%# !(bool)Eval("IsCorrect") ? "<p style='color: #26de81; margin: 0.5rem 0;'><strong>Correct answer:</strong> " + Eval("CorrectAnswer") + "</p>" : "" %>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <div class="action-buttons">
            <a href="Countries.aspx" class="btn btn-secondary">Back to Countries</a>
            <a href="Profile.aspx" class="btn btn-primary">View Profile</a>
        </div>
    </div>
</asp:Content>