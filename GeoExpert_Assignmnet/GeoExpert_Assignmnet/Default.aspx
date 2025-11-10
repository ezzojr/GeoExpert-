<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GeoExpert_Assignment.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>GeoExpert - Explore the World 🌍</title>

    <style>
        /* All your existing CSS (unchanged) */
        /* Keep everything as you have it */
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Animated Background -->
        <div class="bg-animation"></div>

        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <a href="Default.aspx" class="logo">
                    <div class="logo-icon">🌍</div>
                    <span class="logo-text">GeoExpert</span>
                </a>
                <nav class="nav">
                    <a href="Pages/Countries.aspx" class="nav-link">Countries</a>
                    <a href="Pages/Quiz.aspx" class="nav-link">Quizzes</a>
                    <a href="#features" class="nav-link">Features</a>
                    <a href="Pages/Login.aspx" class="btn btn-secondary">Sign In</a>
                    <a href="Pages/Register.aspx" class="btn btn-primary">Get Started</a>
                </nav>
            </div>
        </header>

        <!-- Hero Section -->
        <section class="hero">
            <div class="hero-content">
                <h1>
                    Explore the <span class="globe-emoji">🌍</span><br />
                    <span class="highlight">World</span> Like Never Before
                </h1>
                <p>
                    Discover countries, cultures, foods, and traditions through interactive quizzes and engaging content. Learn, play, and unlock badges!
                </p>
                <div class="hero-buttons">
                    <a href="Pages/Register.aspx" class="btn btn-primary">Start Your Journey</a>
                    <a href="Pages/Countries.aspx" class="btn btn-secondary">Explore Countries</a>
                </div>
            </div>
            <div class="hero-image">
                <div class="globe-container">🗺️</div>
                <div class="floating-country country-1">🗼</div>
                <div class="floating-country country-2">🍕</div>
                <div class="floating-country country-3">🗽</div>
                <div class="floating-country country-4">🍣</div>
            </div>
        </section>

        <!-- Stats Section (Dynamic) -->
        <section class="stats">
            <div class="stat-card">
                <div class="stat-number"><asp:Label ID="lblCountries" runat="server" Text="0" /></div>
                <div class="stat-label">Countries to Explore</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><asp:Label ID="lblQuizzes" runat="server" Text="0" /></div>
                <div class="stat-label">Fun Quizzes</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><asp:Label ID="lblUsers" runat="server" Text="0" /></div>
                <div class="stat-label">Active Learners</div>
            </div>
        </section>

        <!-- Features Section -->
        <section id="features" class="features">
            <div class="features-container">
                <h2>Why Learn With GeoExpert?</h2>
                <p class="features-subtitle">Everything you need to become a geography master</p>
                <!-- Your existing feature cards stay exactly the same -->
            </div>
        </section>

        <!-- Countries Showcase (Dynamic) -->
        <section class="countries-showcase">
            <h2>Featured Countries</h2>
            <p class="countries-showcase-subtitle">Start exploring these amazing destinations</p>
            <div class="countries-grid">
                <asp:Repeater ID="rptCountries" runat="server">
                    <ItemTemplate>
                        <div class="country-card">
                            <div class="country-flag">
                                <img src='<%# Eval("FlagImage") %>' alt='<%# Eval("Name") %>' style="width:100px;height:60px;" />
                            </div>
                            <div class="country-info">
                                <h3><%# Eval("Name") %></h3>
                                <p>Views: <%# Eval("ViewCount") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </section>

        <!-- CTA + Footer (unchanged) -->
        <!-- Keep your existing CTA and Footer here -->

    </form>
</body>
</html>
