<%@ Page Title="Manage Countries" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ManageCountries.aspx.cs"
    Inherits="GeoExpert_Assignment.Admin.ManageCountries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  
    <h2>Manage Countries 🌍</h2>

    <!-- Add / Update Section -->
    <div class="add-section">
        <h3><asp:Label ID="lblFormTitle" runat="server" Text="Add New Country"></asp:Label></h3>
        
        <div class="form-group">
            <label>Country Name:</label>
            <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvName" runat="server"
                ControlToValidate="txtName" ErrorMessage="*Required" ForeColor="Red"></asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
    <label>Country Region:</label>
    <asp:TextBox ID="txtRegion" runat="server"></asp:TextBox>
</div>

<div class="form-group">
    <label>Flag Image:</label>

    <!-- The visible button -->
    <button type="button" class="btn btn-primary" onclick="document.getElementById('<%= fuFlagImage.ClientID %>').click();">
        Choose File
    </button>

    <!-- The hidden file input -->
    <asp:FileUpload ID="fuFlagImage" runat="server" Style="display:none;" />

    <!-- Display the selected file name -->
    <span id="file-name" style="margin-left:10px; font-style:italic;"></span>

    <!-- Existing flag preview -->
    <asp:Image ID="imgCurrentFlag" runat="server" Width="100"
               Visible="false" Style="margin-top:10px; display:block;" />
</div>

        <div class="form-group">
            <label>Food Name:</label>
            <asp:TextBox ID="txtFoodName" runat="server"></asp:TextBox>
        </div>

        <div class="form-group">
            <label>Food Description:</label>
            <asp:TextBox ID="txtFoodDesc" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>

        <div class="form-group">
            <label>Culture Info:</label>
            <asp:TextBox ID="txtCulture" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>

        <div class="form-group">
            <label>Video URL:</label>
            <asp:TextBox ID="txtVideoURL" runat="server"></asp:TextBox>
        </div>

        <div class="form-group">
            <label>Fun Fact:</label>
            <asp:TextBox ID="txtFunFact" runat="server"></asp:TextBox>
        </div>

        <asp:Button ID="btnAdd" runat="server" Text="Add Country"
            CssClass="btn btn-primary" OnClick="btnAdd_Click" />
        <asp:Button ID="btnUpdate" runat="server" Text="Update Country"
            CssClass="btn btn-primary" Visible="false" OnClick="btnUpdate_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel"
            CssClass="btn" Visible="false" OnClick="btnCancel_Click" />
        <br />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
    </div>

    <hr />

    <!-- GridView Display -->
    <h3>All Countries</h3>
    <asp:GridView ID="gvCountries" runat="server" AutoGenerateColumns="False"
        CssClass="data-table" OnRowCommand="gvCountries_RowCommand">
        <Columns>
            <asp:BoundField DataField="CountryID" HeaderText="ID" />
            <asp:BoundField DataField="Name" HeaderText="Country" />
            <asp:BoundField DataField="Region" HeaderText="Region" />
            <asp:ImageField DataImageUrlField="FlagImage" HeaderText="Flag" ControlStyle-Width="60" />
            <asp:BoundField DataField="FoodName" HeaderText="Food" />
            <asp:BoundField DataField="FunFact" HeaderText="Fun Fact" />
            <asp:BoundField DataField="ViewCount" HeaderText="Views" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" Text="Edit"
                        CommandName="EditCountry" CommandArgument='<%# Eval("CountryID") %>'
                        CssClass="btn btn-primary" CausesValidation="false" />
                    <asp:Button ID="btnDelete" runat="server" Text="Delete"
                        CommandName="DeleteCountry" CommandArgument='<%# Eval("CountryID") %>'
                        CssClass="btn btn-danger"
                        OnClientClick="return confirm(&quot;Are you sure you want to delete this country?&quot;);"
                        CausesValidation="false" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <style>
        #<%= lblMessage.ClientID %> { transition: opacity 1s; }
        </style>

    <script>
        setTimeout(() => {
            const msg = document.getElementById('<%= lblMessage.ClientID %>');
            if (msg) msg.style.opacity = 0;
        }, 3000);

        document.addEventListener("DOMContentLoaded", function () {

            var fileInput = document.getElementById("<%= fuFlagImage.ClientID %>");
    var fileNameDisplay = document.getElementById("file-name");

    // SAFETY CHECK
    if (!fileInput) return;

    fileInput.addEventListener("change", function () {
        if (fileInput.files.length > 0) {
            fileNameDisplay.textContent = fileInput.files[0].name;
        }
    });

});
    </script>

</asp:Content>
