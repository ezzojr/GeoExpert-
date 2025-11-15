<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Profile Container */
        .profile-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        /* Messages */
        .success-message, .error-message {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
        }

        .success-message {
            background: rgba(46, 213, 115, 0.1);
            border: 2px solid #2ed573;
            color: #2ed573;
        }

        .error-message {
            background: rgba(255, 71, 87, 0.1);
            border: 2px solid #ff4757;
            color: #ff4757;
        }

        /* Profile Header */
        .profile-header {
            background: linear-gradient(135deg, rgba(79, 172, 254, 0.1) 0%, rgba(0, 242, 254, 0.05) 100%);
            border: 2px solid rgba(79, 172, 254, 0.3);
            border-radius: 24px;
            padding: 3rem;
            margin-bottom: 2rem;
            text-align: center;
            position: relative;
        }

        .edit-mode-toggle {
            position: absolute;
            top: 2rem;
            right: 2rem;
        }

        /* Profile Avatar with Upload */
        .profile-avatar-container {
            position: relative;
            width: 150px;
            margin: 0 auto 1rem;
        }

        .profile-avatar {
            width: 150px;
            height: 150px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            box-shadow: 0 10px 40px rgba(79, 172, 254, 0.4);
            animation: float 6s ease-in-out infinite;
            overflow: hidden;
            position: relative;
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .avatar-upload-btn {
            position: absolute;
            bottom: 0;
            right: 0;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #000;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            cursor: pointer;
            border: 3px solid #0a0a1a;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.5);
            transition: all 0.3s;
        }

        .avatar-upload-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(79, 172, 254, 0.7);
        }

        .file-input-hidden {
            display: none;
        }

        .profile-username {
            font-size: 2.5rem;
            font-weight: 900;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .profile-email {
            color: #999;
            font-size: 1.1rem;
            margin-bottom: 1rem;
        }

        .profile-joined {
            color: #666;
            font-size: 0.95rem;
        }

        /* Progress Section */
        .progress-section {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 24px;
            padding: 2.5rem;
            margin-bottom: 2rem;
        }

        .progress-section h2 {
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 2rem;
        }

        .progress-item {
            margin-bottom: 2rem;
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }

        .progress-label {
            font-size: 1.1rem;
            font-weight: 600;
            color: #fff;
        }

        .progress-percentage {
            font-size: 1.1rem;
            font-weight: 900;
            color: #4facfe;
        }

        .progress-bar-container {
            width: 100%;
            height: 20px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 10px;
            transition: width 1s ease-out;
        }

        .progress-sublabel {
            color: #999;
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s;
        }

        .stat-card:hover {
            border-color: #4facfe;
            transform: translateY(-5px);
        }

        .stat-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: 900;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: #999;
            font-size: 1rem;
        }

        /* Achievements Section */
        .achievements-section {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 24px;
            padding: 2.5rem;
            margin-bottom: 2rem;
        }

        .achievements-section h2 {
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 1.5rem;
        }

        .badges-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 1.5rem;
        }

        .badge-item {
            text-align: center;
            padding: 1.5rem 1rem;
            background: rgba(79, 172, 254, 0.05);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 16px;
            transition: all 0.3s;
        }

        .badge-item:hover {
            background: rgba(79, 172, 254, 0.1);
            border-color: #4facfe;
            transform: translateY(-5px);
        }

        .badge-item.locked {
            opacity: 0.4;
        }

        .badge-icon {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }

        .badge-name {
            font-weight: 700;
            color: #4facfe;
            font-size: 0.9rem;
        }

        .badge-item.locked .badge-name {
            color: #666;
        }

        .badge-date {
            font-size: 0.75rem;
            color: #999;
        }

        .no-badges {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        /* Edit Form */
        .edit-section {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 24px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            display: none;
        }

        .edit-section.active {
            display: block;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            color: #4facfe;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-control {
            width: 100%;
            padding: 1rem;
            background: rgba(0, 0, 0, 0.3);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 12px;
            color: #fff;
            font-size: 1rem;
        }

        .form-control:focus {
            outline: none;
            border-color: #4facfe;
        }

        .validation-message {
            color: #ff4757;
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }

        /* Buttons */
        .btn {
            padding: 1rem 2rem;
            border-radius: 12px;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #000;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: rgba(79, 172, 254, 0.1);
            color: #4facfe;
            border: 2px solid rgba(79, 172, 254, 0.3);
        }

        .btn-danger {
            background: rgba(255, 71, 87, 0.1);
            color: #ff4757;
            border: 2px solid rgba(255, 71, 87, 0.3);
        }

        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        /* Danger Zone */
        .danger-zone {
            background: linear-gradient(135deg, rgba(255, 71, 87, 0.05) 0%, rgba(255, 71, 87, 0.02) 100%);
            border: 2px solid rgba(255, 71, 87, 0.2);
            border-radius: 24px;
            padding: 2.5rem;
            margin-top: 2rem;
        }

        .danger-zone h3 {
            color: #ff4757;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            z-index: 10000;
            align-items: center;
            justify-content: center;
        }

        .modal.show {
            display: flex;
        }

        .modal-content {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.95) 0%, rgba(10, 10, 26, 0.95) 100%);
            border: 2px solid rgba(255, 71, 87, 0.3);
            border-radius: 24px;
            padding: 2.5rem;
            max-width: 500px;
            width: 90%;
        }

        .modal-title {
            font-size: 1.8rem;
            font-weight: 900;
            color: #ff4757;
            margin-bottom: 1.5rem;
        }

        .modal-body {
            color: #ccc;
            margin-bottom: 2rem;
        }

        .modal-footer {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }
    </style>

    <div class="profile-container">
        <!-- Success/Error Messages -->
        <asp:Panel ID="pnlSuccess" runat="server" CssClass="success-message" Visible="false">
            <strong>✓ Success!</strong>
            <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
        </asp:Panel>

        <asp:Panel ID="pnlError" runat="server" CssClass="error-message" Visible="false">
            <strong>✗ Error!</strong>
            <asp:Literal ID="litError" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- Profile Header -->
        <div class="profile-header">
            <div class="edit-mode-toggle">
                <asp:LinkButton ID="btnToggleEdit" runat="server" CssClass="btn btn-secondary" OnClick="btnToggleEdit_Click" CausesValidation="false">
                    ✏️ Edit Profile
                </asp:LinkButton>
            </div>

            <!-- Profile Avatar with Upload Button -->
            <div class="profile-avatar-container">
                <div class="profile-avatar">
                    <asp:Image ID="imgProfilePicture" runat="server" Visible="false" AlternateText="Profile Picture" />
                    <asp:Literal ID="litAvatar" runat="server" Text="👤"></asp:Literal>
                </div>
                <label for="<%= fuProfilePicture.ClientID %>" class="avatar-upload-btn" title="Upload Profile Picture">
                    📸
                </label>
                <asp:FileUpload ID="fuProfilePicture" runat="server" CssClass="file-input-hidden" 
                    onchange="uploadProfilePicture()" accept="image/*" />
            </div>

            <h1 class="profile-username">
                <asp:Literal ID="litUsername" runat="server"></asp:Literal>
            </h1>

            <p class="profile-email">
                ✉️ <asp:Literal ID="litEmail" runat="server"></asp:Literal>
            </p>

            <p class="profile-joined">
                📅 Member since <asp:Literal ID="litJoinedDate" runat="server"></asp:Literal>
            </p>
        </div>

        <!-- Hidden button for profile picture upload -->
        <asp:Button ID="btnUploadPicture" runat="server" OnClick="btnUploadPicture_Click" 
            Style="display:none;" CausesValidation="false" />

        <!-- Progress Section - Only for regular users -->
        <asp:Panel ID="pnlProgressSection" runat="server">
            <div class="progress-section">
                <h2>📊 Your Learning Progress</h2>

                <!-- Overall Progress -->
                <div class="progress-item">
                    <div class="progress-header">
                        <div class="progress-label">Overall Progress</div>
                        <div class="progress-percentage">
                            <asp:Literal ID="litOverallProgress" runat="server" Text="0"></asp:Literal>%
                        </div>
                    </div>
                    <div class="progress-bar-container">
                        <div id="overallProgressBar" runat="server" class="progress-bar-fill"></div>
                    </div>
                    <div class="progress-sublabel">
                        <asp:Literal ID="litOverallGoals" runat="server" Text="0 of 138"></asp:Literal> goals completed
                    </div>
                </div>

                <!-- Countries Explored -->
                <div class="progress-item">
                    <div class="progress-header">
                        <div class="progress-label">🌍 Countries Explored</div>
                        <div class="progress-percentage">
                            <asp:Literal ID="litCountriesCount" runat="server" Text="0"></asp:Literal>/50
                        </div>
                    </div>
                    <div class="progress-bar-container">
                        <div id="countriesProgressBar" runat="server" class="progress-bar-fill"></div>
                    </div>
                </div>

                <!-- Quizzes Completed -->
                <div class="progress-item">
                    <div class="progress-header">
                        <div class="progress-label">🎯 Quizzes Completed</div>
                        <div class="progress-percentage">
                            <asp:Literal ID="litQuizzesProgress" runat="server" Text="0"></asp:Literal>/50
                        </div>
                    </div>
                    <div class="progress-bar-container">
                        <div id="quizzesProgressBar" runat="server" class="progress-bar-fill"></div>
                    </div>
                </div>

                <!-- Badges Earned -->
                <div class="progress-item">
                    <div class="progress-header">
                        <div class="progress-label">🏆 Badges Earned</div>
                        <div class="progress-percentage">
                            <asp:Literal ID="litBadgesProgress" runat="server" Text="0"></asp:Literal>/8
                        </div>
                    </div>
                    <div class="progress-bar-container">
                        <div id="badgesProgressBar" runat="server" class="progress-bar-fill"></div>
                    </div>
                </div>

                <!-- Current Streak -->
                <div class="progress-item">
                    <div class="progress-header">
                        <div class="progress-label">🔥 Current Streak</div>
                        <div class="progress-percentage">
                            <asp:Literal ID="litStreakProgress" runat="server" Text="0"></asp:Literal>/30 days
                        </div>
                    </div>
                    <div class="progress-bar-container">
                        <div id="streakProgressBar" runat="server" class="progress-bar-fill"></div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Stats Grid - Only for regular users -->
        <asp:Panel ID="pnlStatsGrid" runat="server">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">🎯</div>
                    <div class="stat-value"><asp:Literal ID="litQuizzesTaken" runat="server" Text="0"></asp:Literal></div>
                    <div class="stat-label">Quizzes Taken</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">🔥</div>
                    <div class="stat-value"><asp:Literal ID="litCurrentStreak" runat="server" Text="0"></asp:Literal></div>
                    <div class="stat-label">Day Streak</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">🏆</div>
                    <div class="stat-value"><asp:Literal ID="litBadges" runat="server" Text="0"></asp:Literal></div>
                    <div class="stat-label">Badges Earned</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">⭐</div>
                    <div class="stat-value"><asp:Literal ID="litTotalScore" runat="server" Text="0"></asp:Literal></div>
                    <div class="stat-label">Total Points</div>
                </div>
            </div>
        </asp:Panel>

        <!-- Achievements Section - Only for regular users -->
        <asp:Panel ID="pnlAchievementsSection" runat="server">
            <div class="achievements-section">
                <h2>🏆 Achievements & Badges</h2>
                
                <asp:Panel ID="pnlBadges" runat="server">
                    <div class="badges-grid">
                        <asp:Repeater ID="rptBadges" runat="server">
                            <ItemTemplate>
                                <div class='<%# Convert.ToBoolean(Eval("IsEarned")) ? "badge-item" : "badge-item locked" %>'>
                                    <div class="badge-icon"><%# Eval("BadgeIcon") %></div>
                                    <div class="badge-name"><%# Eval("BadgeName") %></div>
                                    <div class="badge-date">
                                        <%# Convert.ToBoolean(Eval("IsEarned")) 
                                            ? Convert.ToDateTime(Eval("EarnedDate")).ToString("MMM dd, yyyy")
                                            : "Not earned yet" %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlNoBadges" runat="server" CssClass="no-badges" Visible="false">
                    <h3>No badges yet!</h3>
                    <p>Complete quizzes and explore countries to earn achievements</p>
                </asp:Panel>
            </div>
        </asp:Panel>

        <!-- Edit Profile Section -->
        <asp:Panel ID="pnlEditForm" runat="server" CssClass="edit-section">
            <h2>✏️ Edit Profile</h2>

            <div class="form-group">
                <label>Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername"
                    ErrorMessage="Username is required"
                    CssClass="validation-message"
                    Display="Dynamic"
                    ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label>Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                    TextMode="Email" MaxLength="100"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                    ControlToValidate="txtEmail"
                    ErrorMessage="Email is required"
                    CssClass="validation-message"
                    Display="Dynamic"
                    ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
            </div>

            <h3 style="margin: 2rem 0 1rem; color: #4facfe;">🔒 Change Password (Optional)</h3>

            <div class="form-group">
                <label>Current Password</label>
                <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" 
                    TextMode="Password"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>New Password</label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" 
                    TextMode="Password" MaxLength="100"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Confirm New Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" 
                    TextMode="Password" MaxLength="100"></asp:TextBox>
                <asp:CompareValidator ID="cvPassword" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtNewPassword"
                    ErrorMessage="Passwords do not match"
                    CssClass="validation-message"
                    Display="Dynamic"
                    ValidationGroup="EditProfile"></asp:CompareValidator>
            </div>

            <div class="button-group">
                <asp:Button ID="btnSaveChanges" runat="server" Text="💾 Save Changes" 
                    CssClass="btn btn-primary" OnClick="btnSaveChanges_Click" 
                    ValidationGroup="EditProfile" />
                <asp:Button ID="btnCancelEdit" runat="server" Text="✖️ Cancel" 
                    CssClass="btn btn-secondary" OnClick="btnCancelEdit_Click" 
                    CausesValidation="false" />
            </div>
        </asp:Panel>

        <!-- Danger Zone -->
        <div class="danger-zone">
            <h3>⚠️ Danger Zone</h3>
            <p>Once you delete your account, there is no going back. This action cannot be undone.</p>
            <asp:Button ID="btnShowDeleteModal" runat="server" Text="🗑️ Delete My Account" 
                CssClass="btn btn-danger" OnClientClick="showDeleteModal(); return false;" CausesValidation="false" />
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h2 class="modal-title">⚠️ Delete Account?</h2>
            <div class="modal-body">
                <p><strong>Are you absolutely sure?</strong></p>
                <p>This will permanently delete your account and all associated data. This action cannot be undone!</p>
                
                <div class="form-group" style="margin-top: 1.5rem;">
                    <label>Type your password to confirm:</label>
                    <asp:TextBox ID="txtDeleteConfirmPassword" runat="server" CssClass="form-control" 
                        TextMode="Password"></asp:TextBox>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="hideDeleteModal()">Cancel</button>
                <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete My Account" 
                    CssClass="btn btn-danger" OnClick="btnConfirmDelete_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <script>
        function showDeleteModal() {
            document.getElementById('deleteModal').classList.add('show');
            return false;
        }

        function hideDeleteModal() {
            document.getElementById('deleteModal').classList.remove('show');
            document.getElementById('<%= txtDeleteConfirmPassword.ClientID %>').value = '';
        }

        function uploadProfilePicture() {
            // Trigger the hidden button to upload picture
            document.getElementById('<%= btnUploadPicture.ClientID %>').click();
        }

        window.addEventListener('load', function () {
            try {
                // Overall progress
                const overallPercent = parseInt('<%= litOverallProgress.Text %>') || 0;
                const overallBar = document.getElementById('<%= overallProgressBar.ClientID %>');
                if (overallBar) overallBar.style.width = overallPercent + '%';

                // Countries
                const countriesCount = parseInt('<%= litCountriesCount.Text %>') || 0;
                const countriesBar = document.getElementById('<%= countriesProgressBar.ClientID %>');
                if (countriesBar) countriesBar.style.width = (countriesCount / 50 * 100) + '%';

                // Quizzes
                const quizzesCount = parseInt('<%= litQuizzesProgress.Text %>') || 0;
                const quizzesBar = document.getElementById('<%= quizzesProgressBar.ClientID %>');
                if (quizzesBar) quizzesBar.style.width = (quizzesCount / 50 * 100) + '%';

                // Badges
                const badgesCount = parseInt('<%= litBadgesProgress.Text %>') || 0;
                const badgesBar = document.getElementById('<%= badgesProgressBar.ClientID %>');
                if (badgesBar) badgesBar.style.width = (badgesCount / 8 * 100) + '%';

                // Streak
                const streakDays = parseInt('<%= litStreakProgress.Text %>') || 0;
                const streakBar = document.getElementById('<%= streakProgressBar.ClientID %>');
                if (streakBar) streakBar.style.width = (streakDays / 30 * 100) + '%';
            } catch (ex) {
                console.error('Progress bar error:', ex);
            }
        });
    </script>
</asp:Content>
