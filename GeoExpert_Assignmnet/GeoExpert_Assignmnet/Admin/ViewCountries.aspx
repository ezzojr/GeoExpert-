<%@ Page Title="View Countries" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ViewCountries.aspx.cs"
    Inherits="GeoExpert_Assignment.Admin.ViewCountries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="mb-4">All Countries 🌍</h2>

    <asp:GridView ID="gvCountries" runat="server" AutoGenerateColumns="False"
        CssClass="table table-dark table-striped">
        <Columns>
            <asp:BoundField DataField="CountryID" HeaderText="Country ID" />
            <asp:BoundField DataField="Name" HeaderText="Country Name" />
            <asp:BoundField DataField="Description" HeaderText="Description" />
        </Columns>
    </asp:GridView>

</asp:Content>
