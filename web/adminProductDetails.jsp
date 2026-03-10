<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("adminLogin.jsp");
    return;
}
if(request.getAttribute("id")==null){
    response.sendRedirect("AdminDashboardServlet");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Product Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
    body { margin: 0; font-family: 'Segoe UI', Arial, sans-serif; background: #f5f5f5; }
    .container {
        width: 70%; max-width: 900px; margin: 60px auto;
        background: white; padding: 40px; border-radius: 20px;
        box-shadow: 0 15px 40px rgba(0,0,0,0.1);
    }
    .back-btn {
        display: inline-flex; align-items: center; margin-bottom: 25px;
        text-decoration: none; color: #1976d2; font-weight: bold; gap: 8px;
    }
    .product-wrapper { display: flex; gap: 50px; align-items: center; }
    .product-image img {
        width: 350px; height: 350px; object-fit: contain;
        background: #fdfdfd; border-radius: 15px; padding: 20px;
        border: 1px solid #f0f0f0;
    }
    .details h2 { margin: 0; color: #333; font-size: 32px; font-weight: 800; }
    .brand { color: #777; font-size: 18px; margin-top: 5px; }
    .price { color: #c2185b; font-size: 30px; font-weight: 800; margin: 20px 0; }
    .stock { font-size: 16px; margin-bottom: 15px; }
    .description { color: #555; line-height: 1.8; margin-bottom: 30px; }
    
    .btn {
        display: inline-flex; align-items: center; gap: 10px;
        padding: 12px 30px; border-radius: 8px; color: white;
        text-decoration: none; font-weight: bold; transition: 0.3s;
    }
    .edit { background: #1976d2; }
    .delete { background: #c2185b; }
    .btn:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
</style>
</head>
<body>

<div class="container">
    <a href="AdminDashboardServlet" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>

    <div class="product-wrapper">
        <div class="product-image">
            <img src="images/products/<%= request.getAttribute("image") %>">
        </div>


        <div class="details">
            <h2><%= request.getAttribute("name") %></h2>
            <div class="brand"><b>Brand:</b> <%= request.getAttribute("brand") %></div>
            <div class="price">₹ <%= request.getAttribute("price") %></div>
            <div class="stock"><b>Stock:</b> <span style="color:<%= Integer.parseInt(request.getAttribute("quantity").toString()) > 0 ? "green":"red" %>"><%= request.getAttribute("quantity") %> units</span></div>
            <p class="description"><%= request.getAttribute("description") %></p>

            <div style="display:flex; gap:10px;">
                <a href="EditProductServlet?id=<%= request.getAttribute("id") %>" class="btn edit">
                    <i class="fa-solid fa-pen"></i> Edit
                </a>

                <a href="DeleteProductServlet?id=<%= request.getAttribute("id") %>" 
                   class="btn delete" onclick="return confirm('Delete this product?')">
                    <i class="fa-solid fa-trash"></i> Delete
                </a>
            </div>
        </div>
    </div>
</div>

</body>
</html>