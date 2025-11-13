<%@ Page Title="Country Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CountryDetail.aspx.cs" Inherits="GeoExpert_Assignment.Pages.CountryDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .country-detail {
            max-width: 900px;
            margin: 3rem auto;
            background: rgba(26, 26, 46, 0.8);
            padding: 2rem;
            border-radius: 20px;
            border: 1px solid rgba(79, 172, 254, 0.3);
            box-shadow: 0 0 30px rgba(79, 172, 254, 0.2);
            backdrop-filter: blur(8px);
            animation: fadeIn 0.8s ease forwards;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .flag-banner {
            position: relative;
            height: 300px;
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 2rem;
        }

            .flag-banner img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                filter: brightness(0.9);
            }

        .flag-overlay {
            position: absolute;
            bottom: 1.5rem;
            left: 50%;
            transform: translateX(-50%);
            width: 80%;
            background: linear-gradient(135deg, rgba(20, 25, 50, 0.85), rgba(10, 15, 35, 0.85));
            border: 1px solid rgba(79, 172, 254, 0.25);
            border-radius: 12px;
            padding: 0.8rem 1rem;
            backdrop-filter: blur(6px);
            text-align: center;
            box-shadow: 0 0 20px rgba(79, 172, 254, 0.15);
            transition: all 0.3s ease;
        }

            .flag-overlay h2 {
                font-size: 2.4rem;
                font-weight: 800;
                background: linear-gradient(135deg, #4facfe, #00f2fe);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                text-shadow: 0 0 10px rgba(79, 172, 254, 0.25);
                margin: 0;
                letter-spacing: 1px;
            }


        .section {
            margin-bottom: 2rem;
            background: rgba(255,255,255,0.05);
            padding: 1.5rem;
            border-radius: 14px;
            border: 1px solid rgba(79, 172, 254, 0.2);
        }

            .section h3 {
                background: linear-gradient(135deg, #4facfe, #00f2fe);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                margin-bottom: 1rem;
            }

            .section p {
                color: #ccc;
                line-height: 1.7;
            }

        iframe {
            border-radius: 10px;
            margin-top: 0.5rem;
        }

        .btn-primary {
            display: inline-block;
            padding: 0.8rem 1.5rem;
            margin-top: 1rem;
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            border-radius: 12px;
            color: #000;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

            .btn-primary:hover {
                transform: translateY(-3px);
                box-shadow: 0 0 15px rgba(79, 172, 254, 0.5);
            }
    </style>

    <div class="country-detail">
        <div class="flag-banner">
            <asp:Image ID="imgFlag" runat="server" />
            <div class="flag-overlay">
                <h2>
                    <asp:Literal ID="litCountryName" runat="server"></asp:Literal></h2>
            </div>
        </div>

        <div class="section">
            <h3>National Food</h3>
            <p>
                <strong>
                    <asp:Literal ID="litFoodName" runat="server"></asp:Literal></strong>
            </p>
            <p>
                <asp:Literal ID="litFoodDesc" runat="server"></asp:Literal>
            </p>
        </div>

        <div class="section">
            <h3>Culture & Traditions</h3>
            <p>
                <asp:Literal ID="litCulture" runat="server"></asp:Literal>
            </p>
        </div>

        <div class="section">
            <h3>Fun Fact</h3>
            <p>
                <asp:Literal ID="litFunFact" runat="server"></asp:Literal>
            </p>
        </div>

        <div class="section">
            <h3>Learn More (Video)</h3>
            <asp:Literal ID="litVideo" runat="server"></asp:Literal>
        </div>

        <a href='Quiz.aspx?countryid=<%=Request.QueryString["id"] %>' class="btn-primary">Take Quiz on this Country</a>
    </div>
</asp:Content>
