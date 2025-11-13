<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .profile-hero {
            background: linear-gradient(135deg, rgba(79, 172, 254, 0.1) 0%, rgba(0, 242, 254, 0.05) 100%);
            border: 2px solid rgba(79, 172, 254, 0.3);
            border-radius: 24px;
            padding: 3rem 2rem;
            margin-bottom: 3rem;
            display: flex;
            align-items: center;
            gap: 2rem;
            position: relative;
            overflow: hidden;
        }

        .profile-hero::before {
            content: '👤';
            position: absolute;
            font-size: 15rem;
            opacity: 0.05;
            right: -50px;
            top: -50px;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            box-shadow: 0 10px 40px rgba(79, 172, 254, 0.4);
            flex-shrink: 0;
        }

        .profile-info {
            flex: 1;
            position: relative;
        }

        .profile-info h2 {
            font-size: 2.5rem;
            font-weight: 900;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .profile-meta {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }

        .profile-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #999;
            font-size: 1.1rem;
        }

        .profile-meta-item span {
            font-size: 1.3rem;
        }

        .profile-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-box {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .stat-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(79, 172, 254, 0.1) 0%, transparent 100%);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .stat-box:hover {
            transform: translateY(-5px);
            border-color: #4facfe;
            box-shadow: 0 10px 30px rgba(79, 172, 254, 0.3);
        }

        .stat-box:hover::before {
            opacity: 1;
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
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

        .section-title {
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title span {
            font-size: 2.2rem;
        }

        .badges-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .badge-card {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 2px solid;
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .badge-card.gold {
            border-color: gold;
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1) 0%, rgba(255, 165, 0, 0.05) 100%);
        }

        .badge-card.silver {
            border-color: silver;
            background: linear-gradient(135deg, rgba(192, 192, 192, 0.1) 0%, rgba(169, 169, 169, 0.05) 100%);
        }

        .badge-card.bronze {
            border-color: #cd7f32;
            background: linear-gradient(135deg, rgba(205, 127, 50, 0.1) 0%, rgba(184, 115, 51, 0.05) 100%);
        }

        .badge-card:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 15px 40px rgba(79, 172, 254, 0.3);
        }

        .badge-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .badge-card h4 {
            font-size: 1.3rem;
            margin-bottom: 0.5rem;
            color: #fff;
        }

        .badge-card p {
            color: #999;
            font-size: 0.95rem;
            margin-bottom: 1rem;
        }

        .badge-date {
            font-size: 0.85rem;
            color: #666;
            font-style: italic;
        }

        .no-badges {
            text-align: center;
            padding: 4rem 2rem;
            background: rgba(26, 26, 46, 0.5);
            border: 2px dashed rgba(79, 172, 254, 0.3);
            border-radius: 20px;
            margin-bottom: 3rem;
        }

        .no-badges-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .no-badges p {
            font-size: 1.2rem;
            color: #999;
            margin-bottom: 1.5rem;
        }

        .quiz-history-container {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.6) 0%, rgba(10, 10, 26, 0.6) 100%);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 3rem;
        }

        .quiz-history-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .quiz-filter {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 0.5rem 1rem;
            border: 1px solid rgba(79, 172, 254, 0.3);
            background: transparent;
            color: #999;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .filter-btn:hover, .filter-btn.active {
            background: rgba(79, 172, 254, 0.1);
            border-color: #4facfe;
            color: #4facfe;
        }

        .quiz-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 1rem;
        }

        .quiz-table thead tr {
            background: rgba(79, 172, 254, 0.1);
        }

        .quiz-table th {
            padding: 1rem;
            text-align: left;
            color: #4facfe;
            font-weight: 700;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .quiz-table th:first-child {
            border-radius: 12px 0 0 12px;
        }

        .quiz-table th:last-child {
            border-radius: 0 12px 12px 0;
        }

        .quiz-table tbody tr {
            background: rgba(26, 26, 46, 0.6);
            transition: all 0.3s;
        }

        .quiz-table tbody tr:hover {
            background: rgba(79, 172, 254, 0.1);
            transform: translateX(5px);
        }

        .quiz-table td {
            padding: 1.25rem 1rem;
            color: #ccc;
            border-top: 1px solid rgba(79, 172, 254, 0.1);
            border-bottom: 1px solid rgba(79, 172, 254, 0.1);
        }

        .quiz-table td:first-child {
            border-left: 1px solid rgba(79, 172, 254, 0.1);
            border-radius: 12px 0 0 12px;
        }

        .quiz-table td:last-child {
            border-right: 1px solid rgba(79, 172, 254, 0.1);
            border-radius: 0 12px 12px 0;
        }

        .score-badge {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .score-perfect {
            background: linear-gradient(135deg, #26de81 0%, #20bf6b 100%);
            color: #000;
        }

        .score-good {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #000;
        }

        .score-average {
            background: linear-gradient(135deg, #fed330 0%, #f7b731 100%);
            color: #000;
        }

        .score-low {
            background: linear-gradient(135deg, #fc5c65 0%, #eb3b5a 100%);
            color: #fff;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 3rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 1rem 2rem;
            border-radius: 12px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #000000;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(79, 172, 254, 0.5);
        }

        .btn-danger {
            background: linear-gradient(135deg, #fc5c65 0%, #eb3b5a 100%);
            color: #ffffff;
            box-shadow: 0 4px 15px rgba(252, 92, 101, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(252, 92, 101, 0.5);
        }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #666;
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }

        .streak-flame {
            display: inline-block;
            animation: flicker 1.5s ease-in-out infinite;
        }

        @keyframes flicker {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .profile-hero {
                flex-direction: column;
                text-align: center;
                padding: 2rem 1.5rem;
            }

            .profile-info h2 {
                font-size: 2rem;
            }

            .profile-meta {
                justify-content: center;
            }

            .profile-stats {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }

            .badges-grid {
                grid-template-columns: 1fr;
            }

            .quiz-history-header {
                flex-direction: column;
            }

            .quiz-table {
                font-size: 0.85rem;
            }

            .quiz-table th, .quiz-table td {
                padding: 0.75rem 0.5rem;
            }
        }
    </style>

    <!-- Profile Hero Section -->
    <div class="profile-hero">
        <div class="profile-avatar">👤</div>
        <div class="profile-info">
            <h2><asp:Literal ID="litUsername" runat="server"></asp:Literal></h2>
            <div class="profile-meta">
                <div class="profile-meta-item">
                    <span>📧</span>
                    <asp:Literal ID="litEmail" runat="server"></asp:Literal>
                </div>
                <div class="profile-meta-item">
                    <span class="streak-flame">🔥</span>
                    <strong><asp:Literal ID="litStreak" runat="server"></asp:Literal> Day Streak</strong>
                </div>
                <div class="profile-meta-item">
                    <span>📅</span>
                    Member since <asp:Literal ID="litJoinDate" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
    </div>

    <!-- Stats Dashboard -->
    <div class="profile-stats">
        <div class="stat-box">
            <div class="stat-icon">🎯</div>
            <div class="stat-value"><asp:Literal ID="litTotalQuizzes" runat="server" Text="0"></asp:Literal></div>
            <div class="stat-label">Quizzes Taken</div>
        </div>
        <div class="stat-box">
            <div class="stat-icon">⭐</div>
            <div class="stat-value"><asp:Literal ID="litAverageScore" runat="server" Text="0"></asp:Literal>%</div>
            <div class="stat-label">Average Score</div>
        </div>
        <div class="stat-box">
            <div class="stat-icon">🏆</div>
            <div class="stat-value"><asp:Literal ID="litTotalBadges" runat="server" Text="0"></asp:Literal></div>
            <div class="stat-label">Badges Earned</div>
        </div>
        <div class="stat-box">
            <div class="stat-icon">💯</div>
            <div class="stat-value"><asp:Literal ID="litPerfectScores" runat="server" Text="0"></asp:Literal></div>
            <div class="stat-label">Perfect Scores</div>
        </div>
    </div>

    <!-- Badges Section -->
    <h3 class="section-title"><span>🏆</span> My Achievements</h3>
    
    <asp:Panel ID="pnlNoBadges" runat="server" CssClass="no-badges" Visible="false">
        <div class="no-badges-icon">🎖️</div>
        <p>No badges earned yet!</p>
        <p style="font-size: 1rem; color: #666;">Complete quizzes and achieve perfect scores to earn badges.</p>
        <a href="Countries.aspx" class="btn btn-primary" style="margin-top: 1rem;">Start Learning</a>
    </asp:Panel>

    <asp:Repeater ID="rptBadges" runat="server">
        <HeaderTemplate>
            <div class="badges-grid">
        </HeaderTemplate>
        <ItemTemplate>
            <div class='badge-card <%# GetBadgeClass(Eval("BadgeName").ToString()) %>'>
                <div class="badge-icon"><%# GetBadgeIcon(Eval("BadgeName").ToString()) %></div>
                <h4><%# Eval("BadgeName") %></h4>
                <p><%# Eval("BadgeDescription") %></p>
                <div class="badge-date">Earned: <%# Eval("AwardedDate", "{0:MMM dd, yyyy}") %></div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            </div>
        </FooterTemplate>
    </asp:Repeater>

    <!-- Quiz History Section -->
    <h3 class="section-title"><span>📊</span> Quiz History</h3>
    
    <div class="quiz-history-container">
        <asp:GridView ID="gvProgress" runat="server" AutoGenerateColumns="False" CssClass="quiz-table" 
                      ShowHeader="true" GridLines="None" OnRowDataBound="gvProgress_RowDataBound">
            <Columns>
                <asp:BoundField DataField="CompletedDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                <asp:BoundField DataField="Question" HeaderText="Quiz Topic" />
                <asp:TemplateField HeaderText="Score">
                    <ItemTemplate>
                        <span class='score-badge <%# GetScoreClass(Eval("Score"), Eval("TotalQuestions")) %>'>
                            <%# Eval("Score") %>/<%# Eval("TotalQuestions") %> (<%# GetPercentage(Eval("Score"), Eval("TotalQuestions")) %>%)
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Performance">
                    <ItemTemplate>
                        <%# GetPerformanceEmoji(Eval("Score"), Eval("TotalQuestions")) %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="empty-state">
                    <div class="empty-state-icon">📝</div>
                    <p>No quiz history yet. Take your first quiz!</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <a href="Countries.aspx" class="btn btn-primary">
            <span>🌍</span> Explore More Countries
        </a>
        <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
    </div>
</asp:Content>
