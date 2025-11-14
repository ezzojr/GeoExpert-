<%@ Page Title="View Quizzes" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ViewQuizzes.aspx.cs"
    Inherits="GeoExpert_Assignment.Admin.ViewQuizzes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="mb-4">All Quizzes 📝</h2>

    <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="False"
        CssClass="table table-dark table-striped" OnRowCommand="gvQuizzes_RowCommand">

        <Columns>
            <asp:BoundField DataField="QuizID" HeaderText="Quiz ID" />
            <asp:BoundField DataField="CountryName" HeaderText="Country" />
            <asp:BoundField DataField="Question" HeaderText="Question" />
            <asp:BoundField DataField="CreatedBy" HeaderText="Created By" />

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button 
                        ID="btnViewSolvers" 
                        runat="server" 
                        Text="View Solvers"
                        CssClass="btn btn-secondary"
                        CommandName="ViewSolvers"
                        CommandArgument='<%# Eval("QuizID") %>' />
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>

    </asp:GridView>

</asp:Content>
