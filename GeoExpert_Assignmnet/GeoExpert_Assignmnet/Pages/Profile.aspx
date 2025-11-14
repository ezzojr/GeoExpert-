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
            display: none;
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

        .success-message.show, .error-message.show {
            display: block;
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

        .profile-avatar {
            width: 150px;
            height: 150px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            margin: 0 auto 1rem;
            box-shadow: 0 10px 40px rgba(79, 172, 254, 0.4);
            animation: float 6s ease-in-out infinite;
            position: relative;
            overflow: hidden;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .file-upload-hidden {
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
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .progress-item {
            margin-bottom: 2rem;
        }

        .progress-item:last-child {
            margin-bottom: 0;
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
            position: relative;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 10px;
            transition: width 1s ease-out;
            position: relative;
            overflow: hidden;
        }

        .progress-bar-fill::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            animation: shine 2s infinite;
        }

        @keyframes shine {
            0% { left: -100%; }
            100% { left: 100%; }
        }

        .progress-sublabel {
            color: #999;
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }

        .progress-bar-fill.countries {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .progress-bar-fill.quizzes {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .progress-bar-fill.badges {
            background: linear-gradient(135deg, #feca57 0%, #ff9ff3 100%);
        }

        .progress-bar-fill.streak {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }

        .progress-milestones {
            display: flex;
            justify-content: space-between;
            margin-top: 0.5rem;
            font-size: 0.75rem;
            color: #666;
        }

        .milestone {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .milestone.reached {
            color: #4facfe;
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
            box-shadow: 0 10px 30px rgba(79, 172, 254, 0.3);
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
            margin-bottom: 0.5rem;
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
            display: flex;
            align-items: center;
            gap: 0.75rem;
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

        .badge-item.locked:hover {
            transform: none;
        }

        .badge-icon {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }

        .badge-item.locked .badge-icon {
            filter: grayscale(1);
        }

        .badge-name {
            font-weight: 700;
            color: #4facfe;
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
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

        .no-badges-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
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

        .required {
            color: #ff4757;
        }

        .form-control {
            width: 100%;
            padding: 1rem;
            background: rgba(0, 0, 0, 0.3);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 12px;
            color: #fff;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
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
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #000;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(79, 172, 254, 0.5);
        }

        .btn-secondary {
            background: rgba(79, 172, 254, 0.1);
            color: #4facfe;
            border: 2px solid rgba(79, 172, 254, 0.3);
        }

        .btn-secondary:hover {
            background: rgba(79, 172, 254, 0.2);
            border-color: #4facfe;
        }

        .btn-danger {
            background: rgba(255, 71, 87, 0.1);
            color: #ff4757;
            border: 2px solid rgba(255, 71, 87, 0.3);
        }

        .btn-danger:hover {
            background: rgba(255, 71, 87, 0.2);
            border-color: #ff4757;
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .danger-zone p {
            color: #999;
            margin-bottom: 1.5rem;
            line-height: 1.6;
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

        .modal-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .modal-icon {
            font-size: 3rem;
        }

        .modal-title {
            font-size: 1.8rem;
            font-weight: 900;
            color: #ff4757;
        }

        .modal-body {
            color: #ccc;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .modal-footer {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .profile-header {
                padding: 2rem 1.5rem;
            }

            .edit-mode-toggle {
                position: static;
                margin-top: 1rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
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
                <asp:LinkButton ID="btnToggleEdit" runat="server" CssClass="btn btn-secondary" OnClick="btnToggleEdit_Click">
                    ✏️ Edit Profile
                </asp:LinkButton>
            </div>

            <div class="profile-avatar">
                <asp:Image ID="imgProfilePic" runat="server" Visible="false" AlternateText="Profile Picture" />
                <asp:Literal ID="litAvatar" runat="server" Text="👤"></asp:Literal>
            </div>

            <!-- Camera button OUTSIDE avatar -->
            <div style="text-align: center; margin-bottom: 1rem;">
                <button type="button" class="btn btn-secondary" style="font-size: 0.9rem; padding: 0.5rem 1rem;" 
                        onclick="document.getElementById('<%= fileProfilePic.ClientID %>').click();">
                    📷 Change Picture
                </button>
                <asp:FileUpload ID="fileProfilePic" runat="server" CssClass="file-upload-hidden" 
                               onchange="uploadProfilePicture();" accept="image/*" />
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

        <!-- Progress Section -->
        <div class="progress-section">
            <h2>📊 Your Learning Progress</h2>

            <!-- Overall Progress -->
            <div class="progress-item">
                <div class="progress-header">
                    <div class="progress-label">
                        Overall Progress
                    </div>
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
                <div class="progress-label">
                    🌍 Countries Explored
                </div>
                <div class="progress-percentage">
                    <asp:Literal ID="litCountriesCount" runat="server" Text="0"></asp:Literal>/50
                </div>
            </div>
            <div class="progress-bar-container">
                <div id="countriesProgressBar" runat="server" class="progress-bar-fill countries"></div>
            </div>
        </div>


            <!-- Quizzes Completed -->
                       <div class="progress-item">
                <div class="progress-header">
                    <div class="progress-label">
                        🎯 Quizzes Completed
                    </div>
                    <div class="progress-percentage">
                        <asp:Literal ID="litQuizzesProgress" runat="server" Text="0"></asp:Literal>/50
                    </div>
                </div>
                <div class="progress-bar-container">
                    <div id="quizzesProgressBar" runat="server" class="progress-bar-fill quizzes"></div>
                </div>
            </div>


            <!-- Badges Earned -->
                       <div class="progress-item">
                <div class="progress-header">
                    <div class="progress-label">
                        🏆 Badges Earned
                    </div>
                    <div class="progress-percentage">
                        <asp:Literal ID="litBadgesProgress" runat="server" Text="0"></asp:Literal>/8
                    </div>
                </div>
                <div class="progress-bar-container">
                    <div id="badgesProgressBar" runat="server" class="progress-bar-fill badges"></div>
                </div>
            </div>


            <!-- Current Streak -->
                    <div class="progress-item">
            <div class="progress-header">
                <div class="progress-label">
                    🔥 Current Streak
                </div>
                <div class="progress-percentage">
                    <asp:Literal ID="litStreakProgress" runat="server" Text="0"></asp:Literal>/30 days
                </div>
            </div>
            <div class="progress-bar-container">
                <div id="streakProgressBar" runat="server" class="progress-bar-fill streak"></div>
            </div>

            <div class="progress-milestones">
                <div class="milestone">
                    <span>7</span><span>🔥</span>
                </div>
                <div class="milestone">
                    <span>14</span><span>⚡</span>
                </div>
                <div class="milestone">
                    <span>21</span><span>💫</span>
                </div>
                <div class="milestone">
                    <span>30</span><span>🌟</span>
                </div>
            </div>
        </div>


        <!-- Stats Grid -->
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

        <!-- Achievements Section -->
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
                <div class="no-badges-icon">🏆</div>
                <h3>No badges yet!</h3>
                <p>Complete quizzes and explore countries to earn achievements</p>
            </asp:Panel>
        </div>

        <!-- Edit Profile Section -->
        <asp:Panel ID="pnlEditForm" runat="server" CssClass="edit-section">
            <h2 style="margin-bottom: 2rem; font-size: 2rem; font-weight: 900;">✏️ Edit Profile</h2>

            <div class="form-row">
                <div class="form-group">
                    <label>Username <span class="required">*</span></label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                                 placeholder="Enter username" MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                                              ControlToValidate="txtUsername"
                                              ErrorMessage="Username is required"
                                              CssClass="validation-message"
                                              Display="Dynamic"
                                              ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label>Email <span class="required">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                                 TextMode="Email" placeholder="Enter email" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                              ControlToValidate="txtEmail"
                                              ErrorMessage="Email is required"
                                              CssClass="validation-message"
                                              Display="Dynamic"
                                              ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
                </div>
            </div>

            <h3 style="margin: 2rem 0 1rem; color: #4facfe; font-size: 1.3rem;">🔒 Change Password (Optional)</h3>
            <p style="color: #999; margin-bottom: 1.5rem;">Leave blank if you don't want to change your password</p>

            <div class="form-row">
                <div class="form-group">
                    <label>Current Password</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" 
                                 TextMode="Password" placeholder="Enter current password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" 
                                 TextMode="Password" placeholder="Enter new password (6+ characters)" MaxLength="100"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revPassword" runat="server"
                                                   ControlToValidate="txtNewPassword"
                                                   ValidationExpression="^.{6,}$"
                                                   ErrorMessage="Password must be at least 6 characters"
                                                   CssClass="validation-message"
                                                   Display="Dynamic"
                                                   ValidationGroup="EditProfile"
                                                   Enabled="false"></asp:RegularExpressionValidator>
                </div>
            </div>

            <div class="form-group">
                <label>Confirm New Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" 
                             TextMode="Password" placeholder="Confirm new password" MaxLength="100"></asp:TextBox>
                <asp:CompareValidator ID="cvPassword" runat="server"
                                     ControlToValidate="txtConfirmPassword"
                                     ControlToCompare="txtNewPassword"
                                     ErrorMessage="Passwords do not match"
                                     CssClass="validation-message"
                                     Display="Dynamic"
                                     ValidationGroup="EditProfile"
                                     Enabled="false"></asp:CompareValidator>
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

        <!-- Hidden button for profile picture upload -->
        <asp:Button ID="btnUploadPicture" runat="server" OnClick="btnUploadPicture_Click" 
                   style="display:none;" CausesValidation="false" />

        <!-- Danger Zone -->
        <div class="danger-zone">
            <h3>⚠️ Danger Zone</h3>
            <p>
                Once you delete your account, there is no going back. All your data, including quizzes taken, 
                badges earned, and progress will be permanently deleted. This action cannot be undone.
            </p>
            <asp:Button ID="btnShowDeleteModal" runat="server" Text="🗑️ Delete My Account" 
                       CssClass="btn btn-danger" OnClientClick="showDeleteModal(); return false;" />
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <span class="modal-icon">⚠️</span>
                <h2 class="modal-title">Delete Account?</h2>
            </div>
            <div class="modal-body">
                <p><strong>Are you absolutely sure?</strong></p>
                <p>This will permanently delete your account and all associated data:</p>
                <ul style="margin: 1rem 0; padding-left: 1.5rem; color: #999;">
                    <li>Profile information</li>
                    <li>Quiz history and scores</li>
                    <li>Badges and achievements</li>
                    <li>Learning progress and streaks</li>
                </ul>
                <p style="color: #ff4757; font-weight: bold;">This action cannot be undone!</p>
                
                <div class="form-group" style="margin-top: 1.5rem;">
                    <label>Type your password to confirm:</label>
                    <asp:TextBox ID="txtDeleteConfirmPassword" runat="server" CssClass="form-control" 
                                 TextMode="Password" placeholder="Enter your password"></asp:TextBox>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="hideDeleteModal()">
                    Cancel
                </button>
                <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete My Account" 
                           CssClass="btn btn-danger" OnClick="btnConfirmDelete_Click" 
                           OnClientClick="return confirmDelete();" />
            </div>
        </div>
    </div>

    <script>
        // Upload profile picture
        function uploadProfilePicture() {
            const fileInput = document.getElementById('<%= fileProfilePic.ClientID %>');
            const file = fileInput.files[0];

            if (file) {
                if (!file.type.match('image.*')) {
                    alert('Please select an image file (JPG, PNG, GIF)');
                    return;
                }

                if (file.size > 5 * 1024 * 1024) {
                    alert('Image size must be less than 5MB');
                    return;
                }

                __doPostBack('<%= btnUploadPicture.UniqueID %>', '');
            }
        }

        // Delete modal functions
        function showDeleteModal() {
            document.getElementById('deleteModal').classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function hideDeleteModal() {
            document.getElementById('deleteModal').classList.remove('show');
            document.body.style.overflow = 'auto';
            document.getElementById('<%= txtDeleteConfirmPassword.ClientID %>').value = '';
        }

        function confirmDelete() {
            const password = document.getElementById('<%= txtDeleteConfirmPassword.ClientID %>').value;
            if (!password) {
                alert('Please enter your password to confirm deletion.');
                return false;
            }
            return confirm('Last chance! Are you really sure you want to delete your account? This cannot be undone!');
        }

        // Close modal on outside click
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) {
                hideDeleteModal();
            }
        });

        // Enable password validators
        document.getElementById('<%= txtNewPassword.ClientID %>').addEventListener('input', function() {
            const hasValue = this.value.length > 0;
            ValidatorEnable(document.getElementById('<%= revPassword.ClientID %>'), hasValue);
            ValidatorEnable(document.getElementById('<%= cvPassword.ClientID %>'), hasValue);
        });

        // Animate progress bars on page load
        window.addEventListener('load', function() {
            // Overall progress
            const overallPercent = parseInt('<%= litOverallProgress.Text %>') || 0;
            document.getElementById('overallProgressBar').style.width = overallPercent + '%';
            
            // Countries
            const countriesCount = parseInt('<%= litCountriesCount.Text %>') || 0;
            const countriesPercent = (countriesCount / 50) * 100;
            document.getElementById('countriesProgressBar').style.width = countriesPercent + '%';
            
            // Quizzes
            const quizzesCount = parseInt('<%= litQuizzesProgress.Text %>') || 0;
            const quizzesPercent = (quizzesCount / 50) * 100;
            document.getElementById('quizzesProgressBar').style.width = quizzesPercent + '%';
            
            // Badges
            const badgesCount = parseInt('<%= litBadgesProgress.Text %>') || 0;
            const badgesPercent = (badgesCount / 8) * 100;
            document.getElementById('badgesProgressBar').style.width = badgesPercent + '%';
            
            // Streak
            const streakDays = parseInt('<%= litStreakProgress.Text %>') || 0;
            const streakPercent = (streakDays / 30) * 100;
            document.getElementById('streakProgressBar').style.width = streakPercent + '%';

            // Highlight reached milestones
            const milestones = document.querySelectorAll('.milestone');
            milestones.forEach((milestone) => {
                const milestoneDay = parseInt(milestone.querySelector('span').textContent);
                if (streakDays >= milestoneDay) {
                    milestone.classList.add('reached');
                }
            });
        });
    </script>
</asp:Content>
