<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("user_id")==null){
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String,String>> cart =
        (List<Map<String,String>>) request.getAttribute("cart");

    List<Map<String,String>> recommended =
        (List<Map<String,String>>) request.getAttribute("recommendedProducts");
%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>My Cart</title>

<!-- FONT AWESOME -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
body{
    font-family: Arial;
    background:#f5f5f5;
}

/* ICON SPACING */
i.fa-solid{
    margin-right:6px;
}

h2{
    text-align:center;
    color:#c2185b;
    margin-top:30px;
}

table{
    width:85%;
    margin:30px auto;
    border-collapse:collapse;
    background:white;
    box-shadow:0 0 10px #ccc;
}

th,td{
    padding:12px;
    border:1px solid #ddd;
    text-align:center;
}

th{
    background:#c2185b;
    color:white;
}

img.product-img{
    width:70px;
    height:70px;
    object-fit:cover;
    border-radius:5px;
}

a.remove{
    color:#1976d2;
    text-decoration:none;
    font-weight:bold;
}

.total-row th{
    background:#c2185b;
    color:white;
    font-size:16px;
}

.cart-actions{
    display:flex;
    justify-content:center;
    gap:30px;
    margin:30px 0 50px;
}

.cart-actions button{
    padding:12px 25px;
    background:#c2185b;
    color:white;
    border:none;
    border-radius:5px;
    font-size:15px;
    cursor:pointer;
}

.cart-actions button:hover{
    background:#a3154d;
}

.empty{
    text-align:center;
    color:red;
    font-weight:bold;
}

/* BACK LINK */
.back{
    text-align:center;
    margin-bottom:40px;
}
.back a{
    text-decoration:none;
    color:#1976d2;
    font-weight:bold;
}
.back a:hover{
    text-decoration:underline;
}

/* ===== Recommended Products ===== */
.products{
    display:flex;
    flex-wrap:wrap;
    justify-content:center;
    margin:20px;
}
.card{
    background:white;
    width:220px;
    margin:15px;
    padding:15px;
    border-radius:10px;
    box-shadow:0 4px 10px rgba(0,0,0,0.15);
    text-align:center;
}
.card img{
    width:140px;
    height:140px;
    object-fit:contain;
}
.price{
    color:#c2185b;
    font-weight:bold;
}
.cart-btn{
    width:100%;
    padding:8px;
    background:#c2185b;
    color:white;
    border:none;
    border-radius:5px;
    cursor:pointer;
}

/* ? RUPEE SYMBOL (UNICODE SAFE) */
.price::before,
.total::before{
    content:"\20B9 ";
    font-weight:bold;
}

td button{
    padding:4px 8px;
    border:none;
    background:#c2185b;
    color:white;
    border-radius:4px;
    cursor:pointer;
}
td button:hover{
    background:#a3154d;
}

</style>
</head>

<body>

<h2>My Cart</h2>

<%
double grandTotal = 0;
if(cart != null && !cart.isEmpty()){
%>

<table>
<tr>
    <th>Image</th>
    <th>Name</th>
    <th>Price</th>
    <th>Qty</th>
    <th>Total</th>
    <th>Action</th>
</tr>

<%
    for(Map<String,String> item : cart){
        int qty = Integer.parseInt(item.get("quantity"));
        double price = Double.parseDouble(item.get("price"));
        double total = qty * price;
        grandTotal += total;
%>
<tr>
    <td><img src="images/products/<%= item.get("image") %>" class="product-img"></td>
    <td><%= item.get("name") %></td>
    <td class="price"><%= price %></td>

    <td>
    <form action="UpdateCartQuantityServlet" method="post" style="display:inline;">
        <input type="hidden" name="cart_id" value="<%= item.get("cart_id") %>">
        <input type="hidden" name="action" value="decrease">
        <button type="submit">-</button>
    </form>

    <strong style="margin:0 8px;"><%= qty %></strong>

    <form action="UpdateCartQuantityServlet" method="post" style="display:inline;">
        <input type="hidden" name="cart_id" value="<%= item.get("cart_id") %>">
        <input type="hidden" name="action" value="increase">
        <button type="submit">+</button>
    </form>
    </td>

    <td class="total"><%= total %></td>
    <td>
        <a class="remove"
           href="RemoveCartItemServlet?id=<%= item.get("cart_id") %>">
           Remove
        </a>
    </td>
</tr>
<% } %>

<tr class="total-row">
    <th colspan="4">Grand Total</th>
    <th colspan="2" class="total"><%= grandTotal %></th>
</tr>
</table>

<div class="cart-actions">
    <form action="CheckoutPageServlet" method="get">
        <button type="submit">Proceed to Checkout</button>
    </form>

    <a href="ProductServlet">
        <button type="button">Browse More Products</button>
    </a>
</div>

<% } else { %>
    <p class="empty">Your cart is empty.</p>
<% } %>

<!-- ================= RECOMMENDED PRODUCTS ================= -->
<% if(recommended != null && !recommended.isEmpty()){ %>
<h2>Recommended For You</h2>

<div class="products">
<%
    for(Map<String,String> p : recommended){
%>
    <div class="card">
        <img src="images/products/<%= p.get("image") %>">
        <h4><%= p.get("name") %></h4>
        <p class="price"><%= p.get("price") %></p>

        <form action="AddToCartServlet" method="post">
            <input type="hidden" name="product_id" value="<%= p.get("id") %>">
            <button class="cart-btn">Add to Cart</button>
        </form>
    </div>
<% } %>
</div>
<% } %>

<div class="back">
    <a href="ProductServlet">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>
</div>

</body>
</html>
