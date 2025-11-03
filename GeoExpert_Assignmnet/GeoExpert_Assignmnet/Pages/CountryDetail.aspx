<%@ Page Title="Country Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CountryDetail.aspx.cs" Inherits="GeoExpert_Assignment.Pages.CountryDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2><asp:Literal ID="litCountryName" runat="server"></asp:Literal></h2>
    
    <!-- TODO: Member C - Display detailed country info: flag, food, culture, video -->
    
    <div class="country-detail">
        <div class="section">
            <h3>National Food</h3>
            <p><strong><asp:Literal ID="litFoodName" runat="server"></asp:Literal></strong></p>
            <p><asp:Literal ID="litFoodDesc" runat="server"></asp:Literal></p>
        </div>
        
        <div class="section">
            <h3>Culture & Traditions</h3>
            <p><asp:Literal ID="litCulture" runat="server"></asp:Literal></p>
        </div>
        
        <div class="section">
            <h3>Fun Fact</h3>
            <p><asp:Literal ID="litFunFact" runat="server"></asp:Literal></p>
        </div>
        
        <div class="section">
            <h3>Learn More (Video)</h3>
            <asp:Literal ID="litVideo" runat="server"></asp:Literal>
        </div>
        
        <a href='Quiz.aspx?countryid=<%=Request.QueryString["id"] %>' class="btn btn-primary">Take Quiz on this Country</a>
    </div>
</asp:Content>