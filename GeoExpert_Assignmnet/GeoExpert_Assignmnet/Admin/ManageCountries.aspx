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
            <label>Flag Image:</label>
            <asp:FileUpload ID="fuFlagImage" runat="server" CssClass="form-control" accept="image/*" />
            <small style="color: #888;">Upload flag image (JPG, PNG, GIF) - Max 5MB</small>
            <br />
            <asp:Image ID="imgPreview" runat="server" Width="100" Height="60" Visible="false"
                       style="margin-top: 10px; border: 1px solid #ddd;" />
            <asp:HiddenField ID="hfExistingFlagPath" runat="server" />
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
            CssClass="btn" Visible="false" OnClick="btnCancel_Click" CausesValidation="false" />

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

            <asp:TemplateField HeaderText="Flag">
                <ItemTemplate>
                    <img src='<%# ResolveUrl(Eval("FlagImage").ToString()) %>' alt="Flag" width="50" height="30" />
                </ItemTemplate>
            </asp:TemplateField>

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
                        OnClientClick="return confirm('Are you sure you want to delete this country?');"
                        CausesValidation="false" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <!-- Fade out message -->
    <script>
        setTimeout(() => {
            const msg = document.getElementById('<%= lblMessage.ClientID %>');
            if (msg) msg.style.opacity = 0;
        }, 3000);
    </script>

    <!-- Back Button -->
    <div style="margin-top: 2rem; text-align: center;">
        <asp:HyperLink ID="lnkBackToDashboard" runat="server"
            NavigateUrl="~/Admin/Dashboard.aspx"
            CssClass="btn btn-secondary"
            style="display: inline-block; padding: 1rem 2rem; background: rgba(79,172,254,0.1);
                   color: #4facfe; border: 2px solid rgba(79,172,254,0.3);
                   border-radius: 12px; text-decoration: none; font-weight: bold;">
            ← Back to Dashboard
        </asp:HyperLink>
    </div>

</asp:Content>
