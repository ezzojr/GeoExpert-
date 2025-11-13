using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GeoExpert_Assignment.Pages
{
    public partial class Countries : Page
    {       
        private int pageSizeDefault = 2;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCountries();
            }
        }

        private void LoadCountries(int pageNumber = 1, int pageSize = 2, string searchQuery = "", string region = "")
        {
          
            string query = "SELECT CountryID, Name, FoodName, FunFact, FlagImage FROM Countries WHERE 1 = 1";

            List<SqlParameter> parameters = new List<SqlParameter>();

            // Search
            if (!string.IsNullOrWhiteSpace(searchQuery))
            {
                query += " AND Name LIKE @Search";

                parameters.Add(new SqlParameter("@Search", "%" + searchQuery + "%"));
            }

            // Filter
            if (!string.IsNullOrWhiteSpace(region))
            {
                query += " AND Region = @Region";

                parameters.Add( new SqlParameter("@Region", region ));
            }

            // Offset
            int offset = (pageNumber - 1) * pageSize;
            query += " ORDER BY Name OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";
            parameters.Add(new SqlParameter("@Offset", offset));
            parameters.Add(new SqlParameter("@PageSize", pageSize));

            DataTable countries = DBHelper.ExecuteReader(query, parameters.ToArray());
            rptCountries.DataSource = countries;
            rptCountries.DataBind();
            
            GeneratePagination(pageNumber, pageSize, searchQuery, region);
        }

        protected void btnSearchNFilter_Click(object sender, EventArgs e)
        {
            LoadCountries(1, pageSizeDefault, txtSearch.Text.Trim(), regionFilter.SelectedValue);
        }

        private void GeneratePagination( int currentPage, int pageSize, string searchQuery, string region)
        {
            //get total of countries
            string query = "SELECT COUNT(*) FROM Countries WHERE 1 = 1";

            List<SqlParameter> parameters = new List<SqlParameter>();

            // Search
            if (!string.IsNullOrWhiteSpace(searchQuery))
            {
                query += " AND Name LIKE @Search";

                parameters.Add(new SqlParameter("@Search", "%" + searchQuery + "%"));
            }

            // Filter
            if (!string.IsNullOrWhiteSpace(region))
            {
                query += " AND Region = @Region";

                parameters.Add(new SqlParameter("@Region", region));
            }


            int totalCount = Convert.ToInt32(DBHelper.ExecuteScalar(query, parameters.ToArray()));

            ViewState["CurrentPage"] = currentPage;
            ViewState["TotalCount"] = totalCount;

            int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

            List<object> pages = new List<object>();
            for (int i = 1; i <= totalPages; i++)
            {
                pages.Add(new { PageNumber = i, IsCurrent = (i == currentPage) });
            }

            rptPagination.DataSource = pages;
            rptPagination.DataBind();

            btnPrev.Enabled = currentPage > 1;
            btnNext.Enabled = currentPage < totalPages;
        }

        protected void rptPagination_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Page")
            {
                int page = Convert.ToInt32(e.CommandArgument);
                LoadCountries(page, pageSizeDefault, txtSearch.Text, regionFilter.SelectedValue);
            }
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            int currentPage = (int)(ViewState["CurrentPage"] ?? 1);
            if (currentPage > 1)
                LoadCountries(currentPage - 1, pageSizeDefault, txtSearch.Text, regionFilter.SelectedValue);
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            int currentPage = (int)(ViewState["CurrentPage"] ?? 1);
            int totalCount = (int)(ViewState["TotalCount"] ?? 0);
            int totalPages = (int)Math.Ceiling((double)totalCount / pageSizeDefault);

            if (currentPage < totalPages)
                LoadCountries(currentPage + 1, pageSizeDefault, txtSearch.Text, regionFilter.SelectedValue);
        }
        protected void rptCountries_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {

        }
    }
}