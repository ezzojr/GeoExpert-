<%@ Page Title="Explore Countries" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Countries.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Countries" EnableViewState="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Hero Header Section */
        .countries-hero {
            background: linear-gradient(135deg, rgba(79, 172, 254, 0.1) 0%, rgba(0, 242, 254, 0.05) 100%);
            border: 2px solid rgba(79, 172, 254, 0.3);
            border-radius: 24px;
            padding: 3rem 2rem;
            margin-bottom: 3rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .countries-hero::before {
            content: '🌍';
            position: absolute;
            font-size: 20rem;
            opacity: 0.05;
            right: -50px;
            top: -80px;
            animation: float 6s ease-in-out infinite;
            z-index: 0;              /* ← ADD THIS */
            pointer-events: none;    /* ← ADD THIS */
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(5deg); }
        }

        .countries-hero h1 {
            font-size: 3.5rem;
            font-weight: 900;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
        }

        .countries-hero p {
            font-size: 1.3rem;
            color: #999;
            margin-bottom: 2rem;
            position: relative;
        }

        /* Search & Filter Section */
        .search-filter-container {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 3rem;
        }

        .search-box {
            position: relative;
            flex: 1;
            max-width: 400px;
        }

        .search-box input[type="text"] {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            background: rgba(26, 26, 46, 0.8);
            border: 2px solid rgba(79, 172, 254, 0.3);
            border-radius: 16px;
            color: #fff;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .search-box input[type="text"]:focus {
            outline: none;
            border-color: #4facfe;
            background: rgba(26, 26, 46, 0.95);
            box-shadow: 0 0 20px rgba(79, 172, 254, 0.3);
        }

        .search-box input[type="text"]::placeholder {
            color: #666;
        }

        .search-box::before {
            content: '🔍';
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2rem;
            pointer-events: none;
        }

        .filter-dropdown {
            position: relative;
            min-width: 200px;
        }

        .filter-dropdown select {
            width: 100%;
            padding: 1rem 2.5rem 1rem 1rem;
            background: rgba(26, 26, 46, 0.8);
            border: 2px solid rgba(79, 172, 254, 0.3);
            border-radius: 16px;
            color: #fff;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            appearance: none;
        }

        .filter-dropdown select:focus {
            outline: none;
            border-color: #4facfe;
            background: rgba(26, 26, 46, 0.95);
        }

        .filter-dropdown select option {
            background: #1a1a2e;
            color: #fff;
        }

        .filter-dropdown::after {
            content: '▼';
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #4facfe;
            pointer-events: none;
            font-size: 0.8rem;
        }

            .btn-search {
        padding: 1rem 2.5rem;
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        border: none;
        border-radius: 16px;
        color: #000;
        font-weight: bold;
        font-size: 1rem;
        cursor: pointer;
        transition: all 0.3s;
        box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
        position: relative;      /* ← ADD THIS */
        z-index: 100;           /* ← ADD THIS */
    }

        .btn-search:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 25px rgba(79, 172, 254, 0.5);
        }

        /* Stats Section */
        .countries-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 16px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: #4facfe;
            box-shadow: 0 10px 30px rgba(79, 172, 254, 0.3);
        }

        .stat-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 900;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: #999;
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        /* Countries Grid */
        .countries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .country-card {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 2px solid rgba(79, 172, 254, 0.2);
            border-radius: 24px;
            overflow: hidden;
            transition: all 0.3s;
            cursor: pointer;
            position: relative;
        }

        .country-card::before {
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

        .country-card:hover {
            transform: translateY(-10px);
            border-color: #4facfe;
            box-shadow: 0 15px 40px rgba(79, 172, 254, 0.4);
        }

        .country-card:hover::before {
            opacity: 1;
        }

        .country-flag-section {
            height: 180px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .country-flag-section::before {
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

        .flag-emoji {
            font-size: 6rem;
            filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
        }

        .country-content {
            padding: 1.5rem;
            position: relative;
        }

        .country-name {
            font-size: 1.75rem;
            font-weight: 900;
            margin-bottom: 0.75rem;
            color: #fff;
        }

        .country-region {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            background: rgba(79, 172, 254, 0.2);
            border: 1px solid rgba(79, 172, 254, 0.4);
            border-radius: 20px;
            color: #4facfe;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .country-info-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            color: #999;
            font-size: 0.95rem;
        }

        .country-info-row strong {
            color: #fff;
        }

        .country-fun-fact {
            background: rgba(79, 172, 254, 0.05);
            border-left: 3px solid #4facfe;
            padding: 0.75rem;
            margin-top: 1rem;
            border-radius: 8px;
            font-size: 0.9rem;
            color: #ccc;
            font-style: italic;
        }

        .learn-more-btn {
            display: inline-block;
            margin-top: 1rem;
            padding: 0.75rem 1.5rem;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #000;
            text-decoration: none;
            border-radius: 12px;
            font-weight: bold;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
        }

        .learn-more-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 172, 254, 0.5);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
            background: rgba(26, 26, 46, 0.5);
            border: 2px dashed rgba(79, 172, 254, 0.3);
            border-radius: 24px;
        }

        .empty-state-icon {
            font-size: 6rem;
            margin-bottom: 1.5rem;
            opacity: 0.3;
        }

        .empty-state h3 {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #999;
        }

        .empty-state p {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .countries-hero h1 {
                font-size: 2.5rem;
            }

            .countries-hero p {
                font-size: 1.1rem;
            }

            .search-filter-container {
                flex-direction: column;
            }

            .search-box, .filter-dropdown {
                max-width: 100%;
            }

            .countries-grid {
                grid-template-columns: 1fr;
            }

            .countries-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .countries-hero {
                padding: 2rem 1.5rem;
            }

            .countries-hero h1 {
                font-size: 2rem;
            }

            .country-flag-section {
                height: 140px;
            }

            .flag-emoji {
                font-size: 4rem;
            }
        }
    </style>

    <!-- Hero Section -->
    <div class="countries-hero">
        <h1>Explore Countries 🌍</h1>
        <p>Discover amazing facts, cultures, and traditions from around the world</p>
        
        <!-- Search & Filter -->
        <div class="search-filter-container">
            <div class="search-box">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by country name..."></asp:TextBox>
            </div>
            <div class="filter-dropdown">
                <asp:DropDownList ID="ddlRegion" runat="server">
                    <asp:ListItem Value="">All Regions</asp:ListItem>
                    <asp:ListItem Value="Asia">Asia</asp:ListItem>
                    <asp:ListItem Value="Europe">Europe</asp:ListItem>
                    <asp:ListItem Value="North America">North America</asp:ListItem>
                    <asp:ListItem Value="South America">South America</asp:ListItem>
                    <asp:ListItem Value="Africa">Africa</asp:ListItem>
                    <asp:ListItem Value="Oceania">Oceania</asp:ListItem>
                </asp:DropDownList>
            </div>
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-search" OnClick="btnSearch_Click" UseSubmitBehavior="true" />
        </div>
    </div>

    <!-- Stats Section -->
    <div class="countries-stats">
        <div class="stat-card">
            <div class="stat-icon">🌍</div>
            <div class="stat-number"><asp:Literal ID="litTotalCountries" runat="server" Text="0"></asp:Literal></div>
            <div class="stat-label">Countries</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">🗺️</div>
            <div class="stat-number"><asp:Literal ID="litTotalRegions" runat="server" Text="6"></asp:Literal></div>
            <div class="stat-label">Regions</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">🎯</div>
            <div class="stat-number"><asp:Literal ID="litTotalQuizzes" runat="server" Text="0"></asp:Literal></div>
            <div class="stat-label">Quizzes</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">👥</div>
            <div class="stat-number"><asp:Literal ID="litTotalViews" runat="server" Text="0"></asp:Literal></div>
            <div class="stat-label">Total Views</div>
        </div>
    </div>

    <!-- Countries Grid -->
    <asp:Panel ID="pnlCountries" runat="server">
        <asp:Repeater ID="rptCountries" runat="server">
            <HeaderTemplate>
                <div class="countries-grid">
            </HeaderTemplate>
            <ItemTemplate>
                <div class="country-card" onclick="window.location.href='CountryDetail.aspx?id=<%# Eval("CountryID") %>'">
                    <div class="country-flag-section">
                        <div class="flag-emoji"><%# GetFlagEmoji(Eval("Name").ToString()) %></div>
                    </div>
                    <div class="country-content">
                        <h3 class="country-name"><%# Eval("Name") %></h3>
                        <span class="country-region">📍 <%# Eval("Region") %></span>
                        
                        <div class="country-info-row">
                            <span>🍽️</span>
                            <strong>Food:</strong> <%# Eval("FoodName") %>
                        </div>
                        
                        <div class="country-fun-fact">
                            💡 <%# Eval("FunFact") %>
                        </div>
                        
                        <a href="CountryDetail.aspx?id=<%# Eval("CountryID") %>" class="learn-more-btn">
                            Learn More →
                        </a>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>

    <!-- Empty State -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
        <div class="empty-state-icon">🔍</div>
        <h3>No Countries Found</h3>
        <p>Try adjusting your search or filter to find what you're looking for.</p>
        <asp:Button ID="btnReset" runat="server" Text="Reset Search" CssClass="btn-search" OnClick="btnReset_Click" />
    </asp:Panel>

</asp:Content>
