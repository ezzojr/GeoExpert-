<%@ Page Title="Countries" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Countries.aspx.cs" Inherits="GeoExpert_Assignment.Pages.Countries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* ===== Layout & General ===== */
        h2 {
            text-align: center;
            font-size: 2.2rem;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .search-filter-bar {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 2rem;
            background: rgba(26, 26, 46, 0.6);
            padding: 1rem 1.5rem;
            border-radius: 16px;
            border: 1px solid rgba(79, 172, 254, 0.25);
            backdrop-filter: blur(10px);
            box-shadow: 0 0 20px rgba(79, 172, 254, 0.15);
        }

            .search-filter-bar .form-control,
            .search-filter-bar select {
                padding: 0.8rem 1rem;
                border-radius: 10px;
                border: 1px solid rgba(79, 172, 254, 0.3);
                background: rgba(255, 255, 255, 0.05);
                color: #fff;
                font-size: 1rem;
                transition: all 0.3s ease;
                min-width: 200px;
            }

                .search-filter-bar .form-control:focus,
                .search-filter-bar select:focus {
                    outline: none;
                    border-color: #4facfe;
                    box-shadow: 0 0 12px rgba(79, 172, 254, 0.4);
                }
                .search-filter-bar .form-control,
.search-filter-bar select {
    flex: 1;
    min-width: 250px;
    padding: 0.75rem 1rem;
    border-radius: 12px;
    border: 1px solid rgba(79, 172, 254, 0.3);
    background: rgba(255, 255, 255, 0.05); /* neon-glass effect */
    color: #fff; /* matches search box text */
    font-size: 1rem;
    transition: all 0.3s ease;
}

/* Focus / hover effects */
.search-filter-bar .form-control:focus,
.search-filter-bar select:focus,
.search-filter-bar select:hover {
    outline: none;
    border-color: #4facfe;
    box-shadow: 0 0 10px rgba(79, 172, 254, 0.3);
    color: #fff; /* keep text white on hover/focus */
}

/* Ensure dropdown options inherit same text color */
.search-filter-bar select option {
    background: rgba(26, 26, 46, 0.9); /* dark background consistent with theme */
    color: #fff; /* white text */
}

        .btn {
            padding: 0.6rem 1.2rem;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: #000;
            transition: all 0.3s ease;
        }

            .btn-primary:hover {
                box-shadow: 0 0 15px rgba(79, 172, 254, 0.5);
                transform: translateY(-2px);
            }

        /* ===== Country Cards ===== */
        .countries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            padding: 1rem;
        }

        .country-card {
            background: rgba(26, 26, 46, 0.8);
            border: 1px solid rgba(79, 172, 254, 0.2);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.4);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: center;
        }

            .country-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 30px rgba(79, 172, 254, 0.4);
            }

        .country-flag {
            width: 100%;
            height: 160px;
            overflow: hidden;
        }

            .country-flag img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

        .country-card:hover .country-flag img {
            transform: scale(1.08);
        }

        .country-info {
            padding: 1rem 1.2rem;
            animation: fadeIn 0.8s ease forwards;
        }

            .country-info h3 {
                margin-bottom: 0.5rem;
                background: linear-gradient(135deg, #4facfe, #00f2fe);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                font-weight: 700;
                font-size: 1.3rem;
            }

            .country-info p {
                color: #ccc;
                font-size: 0.95rem;
                margin-bottom: 0.4rem;
            }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ===== Pagination ===== */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.6rem;
            margin-top: 2rem;
        }

            .pagination-container .btn {
                padding: 0.5rem 0.9rem;
                border-radius: 8px;
                font-size: 1rem;
                color: #fff;
                background: rgba(255, 255, 255, 0.1);
                transition: all 0.3s ease;
            }

            .pagination-container .current {
                background: linear-gradient(135deg, #00f2fe, #4facfe);
                color: #000;
                font-weight: 700;
            }


    </style>

    <h2>Explore Countries</h2>

    <div class="search-filter-bar">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="Search by country..." />
        <asp:DropDownList ID="regionFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="btnSearchNFilter_Click">
            <asp:ListItem Text="All Regions" Value="" />
            <asp:ListItem Text="Africa" />
            <asp:ListItem Text="Asia" />
            <asp:ListItem Text="Europe" />
            <asp:ListItem Text="Oceania" />
            <asp:ListItem Text="North America" />
            <asp:ListItem Text="South America" />
        </asp:DropDownList>
        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearchNFilter_Click" />
    </div>

    <asp:Repeater ID="rptCountries" runat="server">
        <HeaderTemplate>
            <div class="countries-grid">
        </HeaderTemplate>
        <ItemTemplate>
            <div class="country-card">
                <div class="country-flag">
                    <img src='<%# ResolveUrl("~/Images/" + Eval("FlagImage")) %>' alt='<%# Eval("Name") %>' />
                </div>
                <div class="country-info">
                    <h3><%# Eval("Name") %></h3>
                    <p><strong>Food:</strong> <%# Eval("FoodName") %></p>
                    <p><em><%# Eval("FunFact") %></em></p>
                    <a href='CountryDetail.aspx?id=<%# Eval("CountryID") %>' class="btn btn-primary">Learn More</a>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>

    <div class="pagination-container">
        <asp:LinkButton ID="btnPrev" runat="server" Text="←" CssClass="btn" OnClick="btnPrev_Click" />
        <asp:Repeater ID="rptPagination" runat="server" OnItemCommand="rptPagination_ItemCommand">
            <ItemTemplate>
                <asp:LinkButton runat="server" CommandName="Page" CommandArgument='<%# Eval("PageNumber") %>'
                    Text='<%# Eval("PageNumber") %>' CssClass='<%# (bool)Eval("IsCurrent") ? "btn current" : "btn" %>' />
            </ItemTemplate>
        </asp:Repeater>
        <asp:LinkButton ID="btnNext" runat="server" Text="→" CssClass="btn" OnClick="btnNext_Click" />
    </div>
</asp:Content>
