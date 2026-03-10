<!DOCTYPE html>
<html>
<head>
<title>Product Details</title>

<style>
body{
    margin:0;
    font-family: Arial, sans-serif;
    background:#f5f5f5;
}

/* ===== MAIN CONTAINER ===== */
.container{
    width:80%;
    margin:40px auto;
    background:#fff;
    padding:30px;
    border-radius:12px;
    box-shadow:0 6px 20px rgba(0,0,0,0.15);
}

/* ===== BACK BUTTON ===== */
.back-btn{
    display:inline-block;
    margin-bottom:20px;
    text-decoration:none;
    color:#1976d2;
    font-weight:bold;
}
.back-btn:hover{
    text-decoration:underline;
}

/* ===== PRODUCT LAYOUT ===== */
.product-wrapper{
    display:flex;
    gap:40px;
    align-items:flex-start;
}

/* ===== IMAGE ===== */
.product-image{
    flex:1;
    text-align:center;
}
.product-image img{
    width:300px;
    height:300px;
    object-fit:contain;
    border:1px solid #eee;
    border-radius:10px;
    padding:10px;
}

/* ===== DETAILS ===== */
.product-details{
    flex:2;
}
.product-details h2{
    margin-top:0;
    font-size:28px;
    color:#333;
}
.brand{
    color:#777;
    margin-bottom:10px;
}
.price{
    color:#c2185b;
    font-size:26px;
    font-weight:bold;
    margin:15px 0;
}

/* ===== DESCRIPTION ===== */
.description-title{
    margin-top:25px;
    font-size:20px;
    color:#444;
}
.description{
    line-height:1.6;
    color:#555;
}

/* ===== BUTTONS ===== */
.action-buttons{
    margin-top:25px;
}
.action-buttons form{
    display:inline-block;
    margin-right:15px;
}
button{
    padding:12px 28px;
    border:none;
    border-radius:6px;
    font-size:15px;
    color:white;
    cursor:pointer;
}
.cart{
    background:#c2185b;
}
.cart:hover{
    background:#ad1457;
}
.buy{
    background:#1976d2;
}
.buy:hover{
    background:#125ea8;
}

/* ===== STOCK ===== */
.out-stock{
    color:red;
    font-weight:bold;
    margin-top:20px;
}
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

</head>
<body>

<div class="container">

    <!-- BACK TO DASHBOARD -->
    <a href="ProductServlet" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>


    <div class="product-wrapper">

        <!-- IMAGE -->
        <div class="product-image">
            <img src="images/products/<%= request.getAttribute("image") %>">
        </div>

        <!-- DETAILS -->
        <div class="product-details">
            <h2><%= request.getAttribute("name") %></h2>
            <div class="brand">Brand: <b><%= request.getAttribute("brand") %></b></div>
           <div class="price">&#8377; <%= request.getAttribute("price") %></div>



            <div class="description-title">Description</div>
            <div class="description">
                <%= request.getAttribute("description") %>
            </div>

            <% if((int)request.getAttribute("quantity") > 0){ %>
            <div class="action-buttons">

                <form action="AddToCartServlet" method="post">
                    <input type="hidden" name="product_id" value="<%= request.getAttribute("id") %>">
                    <button class="cart">Add to Cart</button>
                </form>

                <form action="BuyNowServlet" method="post">
                    <input type="hidden" name="product_id" value="<%= request.getAttribute("id") %>">
                    <button class="buy">Buy Now</button>
                </form>

            </div>
            <% } else { %>
                <div class="out-stock">Out of Stock</div>
            <% } %>

        </div>
    </div>
</div>

</body>
</html>
