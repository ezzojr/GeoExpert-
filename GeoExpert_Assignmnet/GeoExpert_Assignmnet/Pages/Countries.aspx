<%@ Page Title="Countries" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Countries.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Countries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Explore Countries 🌍</h2>
    
    <!-- TODO: Member C - Display all countries with flags and basic info -->
    
    <asp:Repeater ID="rptCountries" runat="server" OnItemCommand="rptCountries_ItemCommand">
        <HeaderTemplate>
            <div class="countries-grid">
        </HeaderTemplate>
        <ItemTemplate>
            <div class="country-card">
                <h3><%# Eval("Name") %></h3>
                <p><strong>Food:</strong> <%# Eval("FoodName") %></p>
                <p><%# Eval("FunFact") %></p>
                <a href='CountryDetail.aspx?id=<%# Eval("CountryID") %>' class="btn btn-primary">Learn More</a>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            </div>
        </FooterTemplate>
    </asp:Repeater>
</asp:Content>