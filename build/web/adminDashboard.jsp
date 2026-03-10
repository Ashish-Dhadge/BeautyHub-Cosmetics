<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("admin")==null){
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <meta charset="UTF-8">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        /* =========================================================
           1. GLOBAL & BODY STYLES
           ========================================================= */
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f5f5f5;
            line-height: 1.6;
        }

        i.fa-solid {
            margin-right: 8px;
        }

        /* =========================================================
           2. HERO SECTION
           ========================================================= */
        .hero {
            height: 320px;
            background: url("images/hero.jpg") center/cover no-repeat;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        .hero-content {
            position: absolute;
            bottom: 50px;
            left: 60px;
            z-index: 2;
        }

        .hero-content h1 {
            font-size: 42px;
            color: #4a2c2a;
            margin: 0;
            font-weight: 800;
        }

        .hero-content p {
            font-size: 18px;
            color: #6d4c41;
            margin-top: 10px;
        }

        /* =========================================================
           3. NAVBAR (ADMIN)
           ========================================================= */
        .navbar {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(8px);
            padding: 20px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .nav-left {
            font-size: 22px;
            font-weight: bold;
            color: #4a2c2a;
            letter-spacing: 1px;
        }

        .nav-right {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .nav-right a {
            color: #3e2723;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            padding: 8px 12px;
            border-radius: 6px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.4);
        }

        .nav-right a:hover {
            background: #c2185b;
            color: white;
            transform: translateY(-2px);
        }

        /* =========================================================
           4. PRODUCT GRID & CARDS
           ========================================================= */
        .products {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 40px 20px;
            gap: 25px;
        }

        .card {
            background: white;
            width: 250px;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .card img {
            width: 180px;
            height: 180px;
            object-fit: contain;
            margin-bottom: 15px;
        }

        .card h4 {
            margin: 10px 0 5px;
            color: #333;
        }

        .card p {
            margin: 5px 0;
            color: #777;
            font-size: 14px;
        }

        .price {
            color: #c2185b;
            font-size: 1.2rem;
            font-weight: 800;
            margin: 10px 0;
        }

        .price::before {
            content: "\20B9 ";
        }

        /* =========================================================
           5. FOOTER
           ========================================================= */
        .footer {
            background: #1a1a1a;
            color: #bbb;
            padding: 50px 10% 20px;
            margin-top: 60px;
        }

        .footer-container {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 30px;
        }

        .footer h3 {
            color: white;
            margin-bottom: 20px;
        }

        .footer-bottom {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #333;
            font-size: 14px;
        }
    </style>
</head>

<body>

<div class="hero">

    <div class="navbar">
        <div class="nav-left">
            <i class="fa-solid fa-user-shield"></i> Admin Dashboard
        </div>

        <div class="nav-right">
            <a href="AddProductServlet"><i class="fa-solid fa-plus"></i>Add Product</a>
            <a href="ManageUsersServlet"><i class="fa-solid fa-users"></i>Users</a>
            <a href="ViewProductServlet"><i class="fa-solid fa-box"></i>Products</a>
            <a href="ManageCategoryServlet"><i class="fa-solid fa-layer-group"></i>Categories</a>
            <a href="AdminViewOrdersServlet"><i class="fa-solid fa-clipboard-list"></i>Orders</a>
            <a href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i>Logout</a>
        </div>
    </div>

    <div class="hero-content">
        <h1>Welcome Admin</h1>
        <p>Manage your premium cosmetic inventory and customer orders.</p>
    </div>

</div>

<div class="products">
<%
    List<Map<String,String>> products = (List<Map<String,String>>)request.getAttribute("products");

    if(products != null){
        for(Map<String,String> p : products){
%>
    <div class="card">
        <a href="AdminProductDetailsServlet?id=<%= p.get("id") %>"
           style="text-decoration:none;color:inherit;display:block;">

            <img src="images/products/<%= p.get("image") %>">

            <h4><%= p.get("name") %></h4>
            <p><%= p.get("brand") %></p>
            <p class="price"><%= p.get("price") %></p>
        </a>
    </div>

<%
        }
    }
%>
</div>

<div class="footer">
    <div class="footer-container">
        <div>
            <h3>Admin Panel</h3>
            <p>Cosmetic Store Management System v2.0</p>
        </div>
        
    </div>
    <div class="footer-bottom">© 2025 Cosmetic Store | Secure Admin Access</div>
</div>

</body>
</html>