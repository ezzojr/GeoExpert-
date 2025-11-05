<%@ Page Title="Countries" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Countries.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Countries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Explore Countries 🌍</h2>
    
    <!-- Searchbox -->
    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="Search by country name..." />
<asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
    
    <!-- Filter -->
    <asp:DropDownList ID="regionFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="regionFilter_SelectedIndexChanged" Height="17px" Width="180px">
    <asp:ListItem Text="All Regions" Value="" /> 
    <asp:ListItem Text="Africa" Value="Africa" />
    <asp:ListItem Text="Antarctica" Value="Antarctica" />
    <asp:ListItem Text="Asia" Value="Asia" />
    <asp:ListItem Text="Europe" Value="Europe" />
    <asp:ListItem Text="Oceania" Value="Oceania" />
 <asp:ListItem Text="North America" Value="North America" />
         <asp:ListItem Text="South America" Value="South America" />
</asp:DropDownList>

    <!-- Country display -->
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