<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("admin")==null){
        response.sendRedirect("adminLogin.jsp");
        return;
    }
    List<Map<String,String>> products = (List<Map<String,String>>)request.getAttribute("products");
    String msg = (String)request.getAttribute("msg");
    if(msg == null) msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Products | Unified View</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; margin: 0; padding: 20px; }
        .container { max-width: 1150px; margin: auto; background: white; padding: 25px; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        
        .header-flex { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; gap: 15px; }
        h2 { color: #c2185b; margin: 0; }

        .controls { display: flex; gap: 10px; align-items: center; }
        .search-box { position: relative; }
        .search-box input { padding: 8px 15px 8px 35px; border: 1px solid #ddd; border-radius: 20px; outline: none; width: 200px; }
        .search-box i { position: absolute; left: 12px; top: 10px; color: #888; }

        .filter-btn { background: #eee; border: none; padding: 8px 18px; border-radius: 20px; cursor: pointer; font-weight: 600; color: #555; }
        .filter-btn.active-filter { background: #c2185b; color: white; }

        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; color: #777; padding: 15px; font-size: 12px; text-transform: uppercase; border-bottom: 2px solid #eee; }
        td { padding: 12px; border-bottom: 1px solid #f1f1f1; text-align: center; }
        
        .row-disabled { background-color: #fdfdfd; opacity: 0.8; }
        img { width: 45px; height: 45px; object-fit: cover; border-radius: 5px; border: 1px solid #eee; }
        
        /* Status Badges */
        .badge { padding: 5px 14px; border-radius: 15px; font-size: 12px; font-weight: 800; display: inline-block; }
        .bg-active { background: #c6f6d5; color: #22543d; border: 1px solid #9ae6b4; }
        .bg-disabled { background: #fed7d7; color: #822727; border: 1px solid #feb2b2; }

        /* Action Buttons */
        .btn { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; color: white; text-decoration: none; margin: 0 2px; transition: 0.2s; }
        .edit { background: #3182ce; }
        .delete { background: #e53e3e; }

        /* ✅ DARKER RESTORE BUTTON (ARROW) */
        .restore { 
            background: #1b5e20 !important; /* Dark Forest Green */
            border: 2px solid #0a3d0e; 
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        .restore:hover { background: #003300 !important; transform: scale(1.1); }

        /* Back Button Logic */
        .back-btn-container { text-align: center; margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px; }
        .back-link { text-decoration: none; color: #4a2c2a; font-weight: bold; font-size: 16px; transition: 0.3s; }
        .back-link:hover { color: #c2185b; }
        
        /* ===== ADMIN HEADER (LIKE CATEGORY PAGE) ===== */
        .admin-header{
            background:white;
            padding:18px 5%;
            display:flex;
            align-items:center;
            justify-content:space-between;
            box-shadow:0 2px 10px rgba(0,0,0,0.05);
            margin-bottom:25px;
        }

        .back-link{
            text-decoration:none;
            color:#1976d2;
            font-weight:700;
            display:flex;
            align-items:center;
            gap:8px;
            transition:0.3s;
        }

        .back-link:hover{
            color:#c2185b;
        }

        
    </style>
</head>
<body>

<!-- ===== ADMIN HEADER (NEW - UI ONLY) ===== -->
<div class="admin-header">
    <a class="back-link" href="AdminDashboardServlet">
        <i class="fa-solid fa-arrow-left"></i> Dashboard
    </a>

    <h2 style="margin:0;">
        <i class="fa-solid fa-boxes-packing"></i> All Products
    </h2>

    <div style="width:100px;"></div>
</div>


<div class="container">
    <div class="header-flex">
        <h2><i class="fa-solid fa-boxes-packing"></i> All Products</h2>
        <div class="controls">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="searchInput" placeholder="Search..." onkeyup="filterTable()">
            </div>
            <button id="toggleBtn" class="filter-btn" onclick="toggleInactive()">
                <i class="fa-solid fa-eye-slash"></i> Hide Disabled
            </button>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Image</th>
                <th style="text-align: left;">Name</th>
                <th>Brand</th>
                <th>Price</th>
                <th>Qty</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody id="productTable">
        <% if(products != null) { 
            for(Map<String,String> p : products) { 
                boolean isActive = "1".equals(p.get("active"));
        %>
            <tr class="product-row <%= isActive ? "row-active" : "row-disabled" %>" data-status="<%= isActive ? "1" : "0" %>">
                <td><img src="images/products/<%= p.get("image") %>"></td>
                <td style="text-align: left; font-weight: 600;"><%= p.get("name") %></td>
                <td><%= p.get("brand") %></td>
                <td style="color: #c2185b; font-weight: 800;">₹<%= p.get("price") %></td>
                <td><%= p.get("quantity") %></td>
                <td>
                    <span class="badge <%= isActive ? "bg-active" : "bg-disabled" %>">
                        <%= isActive ? "Active" : "Inactive" %>
                    </span>
                </td>
                <td>
                    <div style="display: flex; justify-content: center;">
                        <% if(isActive) { %>
                            <a class="btn edit" href="EditProductServlet?id=<%= p.get("id") %>"><i class="fa-solid fa-pen"></i></a>
                            <a class="btn delete" href="DeleteProductServlet?id=<%= p.get("id") %>" onclick="return confirm('Delete this product?')"><i class="fa-solid fa-trash"></i></a>
                        <% } else { %>
                            <a class="btn restore" href="RestoreProductServlet?id=<%= p.get("id") %>" title="Restore Product">
                                <i class="fa-solid fa-rotate-left"></i>
                            </a>
                        <% } %>
                    </div>
                </td>
            </tr>
        <% } } %>
        </tbody>
    </table>
    
</div>

<script>
let showDisabled = true;
function toggleInactive() {
    showDisabled = !showDisabled;
    filterTable();
    const btn = document.getElementById('toggleBtn');
    btn.innerHTML = showDisabled ? '<i class="fa-solid fa-eye-slash"></i> Hide Disabled' : '<i class="fa-solid fa-eye"></i> Show All';
}

function filterTable() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('.product-row');
    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        const status = row.getAttribute('data-status');
        const matchesSearch = text.includes(searchTerm);
        const matchesToggle = showDisabled || status === "1";
        row.style.display = (matchesSearch && matchesToggle) ? "" : "none";
    });
}
</script>

</body>
</html>