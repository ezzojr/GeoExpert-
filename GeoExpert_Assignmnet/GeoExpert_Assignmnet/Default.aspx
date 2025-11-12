<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GeoExpert_Assignment.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>GeoExpert - Explore the World 🌍</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #0a0a1a 0%, #1a1a2e 100%);
            color: #ffffff;
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Animated background */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            opacity: 0.1;
        }

            .bg-animation::before {
                content: '🌍🗺️🏔️🏖️🌆🗼🎭🍕🍣🌮';
                position: absolute;
                font-size: 3rem;
                white-space: nowrap;
                animation: scroll 30s linear infinite;
            }

        @keyframes scroll {
            0% {
                transform: translateX(100%);
            }

            100% {
                transform: translateX(-100%);
            }
        }

        /* Header */
        .header {
            background: rgba(0, 0, 0, 0.95);
            border-bottom: 1px solid rgba(79, 172, 254, 0.3);
            box-shadow: 0 4px 20px rgba(79, 172, 254, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(10px);
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }

        .logo-icon {
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.4);
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }

            50% {
                transform: translateY(-10px);
            }
        }

        .logo-text {
            font-size: 1.75rem;
            font-weight: 900;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav-link {
            color: #999;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            position: relative;
        }

            .nav-link::after {
                content: '';
                position: absolute;
                bottom: -5px;
                left: 0;
                width: 0;
                height: 2px;
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                transition: width 0.3s;
            }

            .nav-link:hover {
                color: #4facfe;
            }

                .nav-link:hover::after {
                    width: 100%;
                }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 1rem;
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

        .btn-secondary {
            color: #4facfe;
            border: 2px solid rgba(79, 172, 254, 0.5);
            background: transparent;
        }

            .btn-secondary:hover {
                background: rgba(79, 172, 254, 0.1);
                border-color: #4facfe;
            }

        /* Hero Section */
        .hero {
            max-width: 1200px;
            margin: 0 auto;
            padding: 5rem 2rem;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
        }

        .hero-content h1 {
            font-size: 4rem;
            font-weight: 900;
            line-height: 1.1;
            margin-bottom: 1.5rem;
        }

        .hero-content .highlight {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-content .globe-emoji {
            display: inline-block;
            animation: spin 4s linear infinite;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

        .hero-content p {
            font-size: 1.35rem;
            color: #999;
            margin-bottom: 2.5rem;
            line-height: 1.8;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .hero-image {
            position: relative;
            height: 500px;
        }

        .globe-container {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(79, 172, 254, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 8rem;
            position: relative;
            overflow: hidden;
        }

            .globe-container::before {
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
            0% {
                left: -100%;
            }

            100% {
                left: 100%;
            }
        }

        .floating-country {
            position: absolute;
            font-size: 2.5rem;
            animation: float-around 8s ease-in-out infinite;
        }

        .country-1 {
            top: 10%;
            right: -10%;
            animation-delay: 0s;
        }

        .country-2 {
            bottom: 10%;
            left: -10%;
            animation-delay: 2s;
        }

        .country-3 {
            top: 50%;
            right: -15%;
            animation-delay: 4s;
        }

        .country-4 {
            bottom: 30%;
            right: -5%;
            animation-delay: 6s;
        }

        @keyframes float-around {
            0%, 100% {
                transform: translate(0, 0) rotate(0deg);
            }

            25% {
                transform: translate(10px, -20px) rotate(10deg);
            }

            50% {
                transform: translate(-10px, -10px) rotate(-10deg);
            }

            75% {
                transform: translate(15px, 10px) rotate(5deg);
            }
        }

        /* Stats Section */
        .stats {
            max-width: 1200px;
            margin: 0 auto;
            padding: 3rem 2rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
        }

        .stat-card {
            text-align: center;
            padding: 2rem;
            background: rgba(79, 172, 254, 0.05);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 16px;
            transition: all 0.3s;
        }

            .stat-card:hover {
                transform: translateY(-5px);
                background: rgba(79, 172, 254, 0.1);
                border-color: #4facfe;
            }

        .stat-number {
            font-size: 3rem;
            font-weight: 900;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: #999;
            margin-top: 0.5rem;
            font-size: 1.1rem;
        }

        /* Features Section */
        .features {
            background: rgba(0, 0, 0, 0.5);
            padding: 5rem 2rem;
            border-top: 1px solid rgba(79, 172, 254, 0.2);
            border-bottom: 1px solid rgba(79, 172, 254, 0.2);
        }

        .features-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .features h2 {
            font-size: 3.5rem;
            font-weight: 900;
            text-align: center;
            margin-bottom: 1rem;
        }

        .features-subtitle {
            text-align: center;
            color: #999;
            font-size: 1.25rem;
            margin-bottom: 4rem;
        }

        /* Countries Showcase */
        .countries-showcase {
            max-width: 1200px;
            margin: 5rem auto;
            padding: 0 2rem;
        }

            .countries-showcase h2 {
                font-size: 3.5rem;
                font-weight: 900;
                text-align: center;
                margin-bottom: 1rem;
            }

        .countries-showcase-subtitle {
            text-align: center;
            color: #999;
            font-size: 1.25rem;
            margin-bottom: 3rem;
        }

        .countries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .country-card {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.8) 0%, rgba(10, 10, 26, 0.8) 100%);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s;
            cursor: pointer;
        }

            .country-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(79, 172, 254, 0.3);
                border-color: #4facfe;
            }

        .country-flag {
            width: 100%;
            height: 150px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 5rem;
        }

        .country-info {
            padding: 1.5rem;
        }

            .country-info h3 {
                font-size: 1.5rem;
                margin-bottom: 0.5rem;
            }

            .country-info p {
                color: #999;
                font-size: 0.95rem;
            }

        /* Responsive */
        @media (max-width: 968px) {
            .nav {
                display: none;
            }

            .hero {
                grid-template-columns: 1fr;
                padding: 3rem 2rem;
            }

            .hero-content h1 {
                font-size: 2.5rem;
            }

            .hero-image {
                height: 400px;
            }

            .globe-container {
                font-size: 5rem;
            }
        }

        @media (max-width: 640px) {
            .hero-content h1 {
                font-size: 2rem;
            }

            .stat-number {
                font-size: 2rem;
            }
        }
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
                <h1>Explore the <span class="globe-emoji">🌍</span><br />
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
                <div class="stat-number">
                    <asp:Label ID="lblCountries" runat="server" Text="0" />
                </div>
                <div class="stat-label">Countries to Explore</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <asp:Label ID="lblQuizzes" runat="server" Text="0" />
                </div>
                <div class="stat-label">Fun Quizzes</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <asp:Label ID="lblUsers" runat="server" Text="0" />
                </div>
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
                                <img src='<%# ResolveUrl("~/Images/" + Eval("FlagImage")) %>'
                                    alt='<%# Eval("Name") %>'
                                    style="width: 100px; height: 60px;" />
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
