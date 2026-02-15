<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="GeoExpert_Assignment.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .search-row { display:flex; justify-content:center; gap:10px; margin-bottom:20px; }
        .form-control { width:300px; padding:10px 14px; border-radius:8px; border:1px solid #ccc; font-size:15px; }
        .btn { border-radius:8px; padding:9px 16px; font-weight:600; cursor:pointer; }
        .btn-primary { background-color:#0078d7; color:#fff; border:none; }
        .btn-secondary { background-color:#ddd; color:#000; border:none; }
        .btn-danger { background-color:#ff4d4d; color:#fff; border:none; }
        .btn-warning { background-color:#ffa500; color:#000; border:none; }
        .data-table { width:100%; border-collapse:collapse; margin-top:10px; }
        .data-table th { text-align:left; padding:10px; border-bottom:2px solid #eee; }
        .data-table td { padding:10px; border-bottom:1px solid #f3f3f3; }

        /* Modal */
        .modal-backdrop { position:fixed; inset:0; background:rgba(0,0,0,0.6); display:none; justify-content:center; align-items:center; z-index:9999; }
        .modal-card { background:#141414; color:#fff; padding:20px; border-radius:10px; width:420px; box-shadow:0 8px 30px rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.03); }
        .modal-header { font-size:18px; margin-bottom:8px; }
        .modal-body { color:#ddd; margin-bottom:16px; }
        .modal-actions { display:flex; justify-content:flex-end; gap:8px; }
        .btn-cancel { background:#2b2b2b; color:#fff; border:1px solid #3a3a3a; padding:8px 12px; border-radius:8px; }
        .btn-confirm { background:#ff4d4d; color:#fff; border:none; padding:8px 12px; border-radius:8px; }
        
        .role-select {
            background-color: #2a2a2d;
            border: 1px solid #444;
            color: #fff;
            border-radius: 6px;
            padding: 6px;
            margin-right: 5px;
        }
    </style>

    <h2 style="text-align:center; margin-bottom:18px;">Manage Users 👥</h2>

    <!-- Search -->
    <div class="search-row">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="🔍 Search by username or email..." />
        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
        <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" />
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Style="display:block; text-align:center; margin-bottom:10px;"></asp:Label>

    <!-- Users Grid -->
    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="data-table" OnRowDataBound="gvUsers_RowDataBound">
        <Columns>
            <asp:BoundField DataField="UserID" HeaderText="ID" />
            <asp:BoundField DataField="Username" HeaderText="Username" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Role" HeaderText="Role" />
            <asp:BoundField DataField="CurrentStreak" HeaderText="Streak" />
            <asp:BoundField DataField="CreatedDate" HeaderText="Joined" DataFormatString="{0:MMM dd, yyyy}" />

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Panel ID="pnlActions" runat="server">
                        <select class="role-select" id="ddlRole_<%# Eval("UserID") %>">
                            <option value="">-- Change Role --</option>
                            <option value="User">User</option>
                            <option value="Teacher">Teacher</option>
                            <option value="Admin">Admin</option>
                        </select>
                        
                        <asp:Button runat="server" ID="btnChangeRole" CssClass="btn btn-warning"
                            Text="Change"
                            OnClientClick="handleChangeRole(this); return false;"
                            data-action="change-role"
                            data-userid='<%# Eval("UserID") %>'
                            data-username='<%# Eval("Username") %>'
                            data-currentrole='<%# Eval("Role") %>' />
                        
                        <asp:Button runat="server" ID="btnDeleteJS" CssClass="btn btn-danger"
                            Text="Delete"
                            OnClientClick="handleAction(this); return false;"
                            data-action="delete"
                            data-userid='<%# Eval("UserID") %>'
                            data-username='<%# Eval("Username") %>' />
                    </asp:Panel>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <!-- Hidden fields + hidden server buttons -->
    <asp:HiddenField ID="hfTargetUserId" runat="server" />
    <asp:HiddenField ID="hfTargetUsername" runat="server" />
    <asp:HiddenField ID="hfNewRole" runat="server" />
    <asp:Button ID="btnConfirmDelete" runat="server" Style="display:none" OnClick="btnConfirmDelete_Click" />
    <asp:Button ID="btnConfirmChangeRole" runat="server" Style="display:none" OnClick="btnConfirmChangeRole_Click" />

    <!-- Modal -->
    <div id="modalBackdrop" class="modal-backdrop">
        <div class="modal-card">
            <div class="modal-header" id="modalTitle">Confirm action</div>
            <div class="modal-body" id="modalBody">Are you sure?</div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                <button type="button" id="modalConfirmBtn" class="btn-confirm">Confirm</button>
            </div>
        </div>
    </div>

    <script>
        function handleAction(btn) {
            var action = btn.getAttribute('data-action');
            var userId = btn.getAttribute('data-userid');
            var username = btn.getAttribute('data-username');

            document.getElementById('<%= hfTargetUserId.ClientID %>').value = userId;
            document.getElementById('<%= hfTargetUsername.ClientID %>').value = username;

            if (action === 'delete') {
                openModal('Delete user', "Are you sure you want to delete user '" + username + "'? This cannot be undone.", function() {
                    document.getElementById('<%= btnConfirmDelete.ClientID %>').click();
                });
            }
        }

        function handleChangeRole(btn) {
            var userId = btn.getAttribute('data-userid');
            var username = btn.getAttribute('data-username');
            var currentRole = btn.getAttribute('data-currentrole');
            
            var dropdown = document.getElementById('ddlRole_' + userId);
            var newRole = dropdown.value;
            
            if (!newRole || newRole === '') {
                alert('Please select a role first!');
                return;
            }
            
            if (newRole === currentRole) {
                alert('User already has this role!');
                return;
            }

            document.getElementById('<%= hfTargetUserId.ClientID %>').value = userId;
            document.getElementById('<%= hfTargetUsername.ClientID %>').value = username;
            document.getElementById('<%= hfNewRole.ClientID %>').value = newRole;

            openModal('Change role', "Change role for '" + username + "' from " + currentRole + " to " + newRole + "?", function() {
                document.getElementById('<%= btnConfirmChangeRole.ClientID %>').click();
            });
        }

        function openModal(title, message, confirmCallback) {
            document.getElementById('modalTitle').innerText = title;
            document.getElementById('modalBody').innerText = message;
            var backdrop = document.getElementById('modalBackdrop');
            backdrop.style.display = 'flex';

            var confirmBtn = document.getElementById('modalConfirmBtn');
            var newBtn = confirmBtn.cloneNode(true);
            confirmBtn.parentNode.replaceChild(newBtn, confirmBtn);
            newBtn.addEventListener('click', function () {
                closeModal();
                confirmCallback();
            });
        }

        function closeModal() {
            document.getElementById('modalBackdrop').style.display = 'none';
        }
    </script>
</asp:Content>