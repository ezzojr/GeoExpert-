<%@ Page Title="Quiz" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Quiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Quiz Time! 🎯</h2>
    
    <!-- TODO: Member D - Implement quiz functionality -->
    <!-- Display questions, collect answers, calculate score, save to database -->
    
    <asp:Panel ID="pnlQuiz" runat="server" Visible="true">
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
        
        <asp:Button ID="btnSubmit" runat="server" Text="Submit Quiz" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
    </asp:Panel>
    
    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="quiz-results">
            <h3>Quiz Results</h3>
            <p>Your Score: <asp:Literal ID="litScore" runat="server"></asp:Literal></p>
            <p>Total Questions: <asp:Literal ID="litTotal" runat="server"></asp:Literal></p>
            <asp:Literal ID="litBadge" runat="server"></asp:Literal>
            <br /><br />
            <a href="Countries.aspx" class="btn btn-primary">Back to Countries</a>
            <a href="Profile.aspx" class="btn btn-primary">View Profile</a>
        </div>
    </asp:Panel>
</asp:Content>