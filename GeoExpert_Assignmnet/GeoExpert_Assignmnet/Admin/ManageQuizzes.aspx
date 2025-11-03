<%@ Page Title="Manage Quizzes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageQuizzes.aspx.cs" Inherits="GeoExpert_Assignment.Admin.ManageQuizzes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Manage Quizzes 📝</h2>
    
    <!-- TODO: Member D - CRUD for quizzes and options -->
    
    <div class="add-section">
        <h3>Add New Quiz Question</h3>
        
        <div class="form-group">
            <label>Select Country:</label>
            <asp:DropDownList ID="ddlCountry" runat="server"></asp:DropDownList>
        </div>
        
        <div class="form-group">
            <label>Question:</label>
            <asp:TextBox ID="txtQuestion" runat="server" TextMode="MultiLine" Rows="2"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvQuestion" runat="server" 
                ControlToValidate="txtQuestion" 
                ErrorMessage="*Required" 
                ForeColor="Red">
            </asp:RequiredFieldValidator>
        </div>
        
        <h4>Options (Add 4 options, mark one as correct)</h4>
        
        <div class="form-group">
            <label>Option 1:</label>
            <asp:TextBox ID="txtOption1" runat="server"></asp:TextBox>
            <asp:CheckBox ID="chkCorrect1" runat="server" Text="Correct Answer" />
        </div>
        
        <div class="form-group">
            <label>Option 2:</label>
            <asp:TextBox ID="txtOption2" runat="server"></asp:TextBox>
            <asp:CheckBox ID="chkCorrect2" runat="server" Text="Correct Answer" />
        </div>
        
        <div class="form-group">
            <label>Option 3:</label>
            <asp:TextBox ID="txtOption3" runat="server"></asp:TextBox>
            <asp:CheckBox ID="chkCorrect3" runat="server" Text="Correct Answer" />
        </div>
        
        <div class="form-group">
            <label>Option 4:</label>
            <asp:TextBox ID="txtOption4" runat="server"></asp:TextBox>
            <asp:CheckBox ID="chkCorrect4" runat="server" Text="Correct Answer" />
        </div>
        
        <asp:Button ID="btnAddQuiz" runat="server" Text="Add Quiz" CssClass="btn btn-primary" OnClick="btnAddQuiz_Click" />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
    </div>
    
    <hr />
    
    <h3>All Quizzes</h3>
    <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="False" 
                  CssClass="data-table" OnRowCommand="gvQuizzes_RowCommand">
        <Columns>
            <asp:BoundField DataField="QuizID" HeaderText="ID" />
            <asp:BoundField DataField="CountryName" HeaderText="Country" />
            <asp:BoundField DataField="Question" HeaderText="Question" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnDelete" runat="server" Text="Delete" 
                                CommandName="DeleteQuiz" 
                                CommandArgument='<%# Eval("QuizID") %>' 
                                CssClass="btn btn-danger" 
                                OnClientClick="return confirm('Are you sure?');" CausesValidation="false" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>