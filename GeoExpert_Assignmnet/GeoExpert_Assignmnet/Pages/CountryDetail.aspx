<%@ Page Title="Country Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CountryDetail.aspx.cs" Inherits="GeoExpert_Assignment.Pages.CountryDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Hero Section with Flag */
        .country-hero {
            background: linear-gradient(135deg, rgba(79, 172, 254, 0.1) 0%, rgba(0, 242, 254, 0.05) 100%);
            border: 2px solid rgba(79, 172, 254, 0.3);
            border-radius: 24px;
            padding: 3rem;
            margin-bottom: 3rem;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 3rem;
        }

        .country-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at top right, rgba(79, 172, 254, 0.1) 0%, transparent 70%);
            z-index: 0;
            pointer-events: none;
        }

        .hero-flag {
            width: 200px;
            height: 200px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 8rem;
            box-shadow: 0 20px 60px rgba(79, 172, 254, 0.4);
            flex-shrink: 0;
            position: relative;
            z-index: 1;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }

        .hero-flag::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            animation: shine 3s infinite;
        }

        @keyframes shine {
            0% { left: -100%; }
            100% { left: 100%; }
        }

        .hero-content {
            flex: 1;
            position: relative;
            z-index: 1;
        }

        .hero-content h1 {
            font-size: 4rem;
            font-weight: 900;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-badges {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: rgba(79, 172, 254, 0.2);
            border: 1px solid rgba(79, 172, 254, 0.4);
            border-radius: 20px;
            color: #4facfe;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .badge-icon {
            font-size: 1.2rem;
        }

        /* Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }

        /* Info Cards */
        .info-card {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 24px;
            padding: 2rem;
            margin-bottom: 2rem;
            transition: all 0.3s;
        }

        .info-card:hover {
            border-color: #4facfe;
            box-shadow: 0 10px 30px rgba(79, 172, 254, 0.3);
            transform: translateY(-5px);
        }

        .info-card h2 {
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: #fff;
        }

        .info-card h2::before {
            font-size: 2.5rem;
        }

        .info-card h2.food::before { content: '🍽️'; }
        .info-card h2.culture::before { content: '🎭'; }
        .info-card h2.funfact::before { content: '💡'; }
        .info-card h2.stats::before { content: '📊'; }
        .info-card h2.video::before { content: '🎬'; }

        .info-card p {
            color: #ccc;
            font-size: 1.1rem;
            line-height: 1.8;
        }

        .food-name {
            font-size: 1.5rem;
            font-weight: bold;
            color: #4facfe;
            margin-bottom: 1rem;
        }

        /* Fun Fact Box */
        .funfact-box {
            background: linear-gradient(135deg, rgba(79, 172, 254, 0.1) 0%, rgba(0, 242, 254, 0.05) 100%);
            border-left: 4px solid #4facfe;
            padding: 1.5rem;
            border-radius: 12px;
            font-size: 1.2rem;
            color: #fff;
            font-style: italic;
            position: relative;
        }

        .funfact-box::before {
            content: '"';
            font-size: 4rem;
            color: rgba(79, 172, 254, 0.3);
            position: absolute;
            top: -10px;
            left: 10px;
        }

        /* Video Section */
        .video-container {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
            height: 0;
            overflow: hidden;
            border-radius: 16px;
            background: #000;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
        }

        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
            border-radius: 16px;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .stat-item {
            background: rgba(79, 172, 254, 0.05);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            transition: all 0.3s;
        }

        .stat-item:hover {
            background: rgba(79, 172, 254, 0.1);
            border-color: #4facfe;
        }

        .stat-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 900;
            color: #4facfe;
            margin-bottom: 0.25rem;
        }

        .stat-label {
            color: #999;
            font-size: 0.9rem;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 2rem;
        }

        .btn {
            padding: 1rem 2rem;
            border-radius: 16px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #000;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(79, 172, 254, 0.6);
        }

        .btn-secondary {
            background: rgba(26, 26, 46, 0.8);
            color: #4facfe;
            border: 2px solid rgba(79, 172, 254, 0.5);
        }

        .btn-secondary:hover {
            background: rgba(79, 172, 254, 0.1);
            border-color: #4facfe;
        }

        /* Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        /* Related Countries */
        .related-countries {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 24px;
            padding: 2rem;
        }

        .related-countries h3 {
            font-size: 1.5rem;
            font-weight: 900;
            margin-bottom: 1.5rem;
            color: #4facfe;
        }

        .related-country-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: rgba(79, 172, 254, 0.05);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 12px;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: inherit;
        }

        .related-country-item:hover {
            background: rgba(79, 172, 254, 0.1);
            border-color: #4facfe;
            transform: translateX(5px);
        }

        .related-flag {
            font-size: 2.5rem;
            flex-shrink: 0;
        }

        .related-info h4 {
            font-size: 1.1rem;
            font-weight: bold;
            color: #fff;
            margin-bottom: 0.25rem;
        }

        .related-info p {
            color: #999;
            font-size: 0.9rem;
        }

        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            color: #999;
            font-size: 0.95rem;
        }

        .breadcrumb a {
            color: #4facfe;
            text-decoration: none;
            transition: color 0.3s;
        }

        .breadcrumb a:hover {
            color: #00f2fe;
        }

        .breadcrumb span {
            color: #666;
        }

        /* Responsive */
        @media (max-width: 968px) {
            .content-grid {
                grid-template-columns: 1fr;
            }

            .country-hero {
                flex-direction: column;
                text-align: center;
                padding: 2rem;
            }

            .hero-content h1 {
                font-size: 2.5rem;
            }

            .hero-flag {
                width: 150px;
                height: 150px;
                font-size: 6rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 640px) {
            .hero-content h1 {
                font-size: 2rem;
            }

            .hero-flag {
                width: 120px;
                height: 120px;
                font-size: 4rem;
            }

            .info-card {
                padding: 1.5rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>

    <!-- Breadcrumb -->
    <div class="breadcrumb">
        <a href="~/Default.aspx" runat="server">🏠 Home</a>
        <span>›</span>
        <a href="Countries.aspx">Countries</a>
        <span>›</span>
        <strong><asp:Literal ID="litBreadcrumb" runat="server"></asp:Literal></strong>
    </div>

    <!-- Hero Section -->
    <div class="country-hero">
        <div class="hero-flag">
            <asp:Literal ID="litFlag" runat="server"></asp:Literal>
        </div>
        <div class="hero-content">
            <h1><asp:Literal ID="litCountryName" runat="server"></asp:Literal></h1>
            <div class="hero-badges">
                <span class="badge">
                    <span class="badge-icon">📍</span>
                    <asp:Literal ID="litRegion" runat="server"></asp:Literal>
                </span>
                <span class="badge">
                    <span class="badge-icon">👁️</span>
                    <asp:Literal ID="litViews" runat="server"></asp:Literal> Views
                </span>
            </div>
        </div>
    </div>

    <!-- Content Grid -->
    <div class="content-grid">
        <!-- Main Content -->
        <div class="main-content">
            <!-- Traditional Food Card -->
            <div class="info-card">
                <h2 class="food">Traditional Food</h2>
                <div class="food-name">🍽️ <asp:Literal ID="litFoodName" runat="server"></asp:Literal></div>
                <p><asp:Literal ID="litFoodDesc" runat="server"></asp:Literal></p>
            </div>

            <!-- Culture & Traditions Card -->
            <div class="info-card">
                <h2 class="culture">Culture & Traditions</h2>
                <p><asp:Literal ID="litCulture" runat="server"></asp:Literal></p>
            </div>

            <!-- Fun Fact Card -->
            <div class="info-card">
                <h2 class="funfact">Fun Fact</h2>
                <div class="funfact-box">
                    <asp:Literal ID="litFunFact" runat="server"></asp:Literal>
                </div>
            </div>

            <!-- Video Section -->
            <div class="info-card">
                <h2 class="video">Learn More (Video)</h2>
                <asp:Panel ID="pnlVideo" runat="server">
                    <div class="video-container">
                        <asp:Literal ID="litVideo" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlNoVideo" runat="server" Visible="false">
                    <p style="text-align: center; color: #666; padding: 2rem;">📹 No video available for this country yet.</p>
                </asp:Panel>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="sidebar">
            <!-- Quick Stats -->
            <div class="info-card">
                <h2 class="stats">Quick Stats</h2>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-icon">🎯</div>
                        <div class="stat-value"><asp:Literal ID="litQuizCount" runat="server" Text="0"></asp:Literal></div>
                        <div class="stat-label">Quizzes</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-icon">👁️</div>
                        <div class="stat-value"><asp:Literal ID="litViewCount" runat="server" Text="0"></asp:Literal></div>
                        <div class="stat-label">Views</div>
                    </div>
                </div>
            </div>

            <!-- Related Countries -->
            <div class="related-countries">
                <h3>🌍 More from <asp:Literal ID="litRelatedRegion" runat="server"></asp:Literal></h3>
                <asp:Repeater ID="rptRelated" runat="server">
                    <ItemTemplate>
                        <a href="CountryDetail.aspx?id=<%# Eval("CountryID") %>" class="related-country-item">
                            <div class="related-flag"><%# GetFlagEmoji(Eval("Name").ToString()) %></div>
                            <div class="related-info">
                                <h4><%# Eval("Name") %></h4>
                                <p><%# Eval("FoodName") %></p>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <!-- Quiz Button - Only visible for regular users -->
    <asp:Panel ID="pnlQuizButton" runat="server" Visible="false">
        <div class="action-buttons">
            <asp:HyperLink ID="btnTakeQuiz" runat="server" CssClass="btn btn-primary">
                🎯 Take Quiz on this Country
            </asp:HyperLink>
            <a href="Countries.aspx" class="btn btn-secondary">
                ← Back to Countries
            </a>
        </div>
    </asp:Panel>

</asp:Content>