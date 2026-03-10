<%@ page import="java.util.*" %>
<%
    Integer orderId = (Integer) request.getAttribute("orderId");
    Double total = (Double) request.getAttribute("totalAmount");
    String payment = (String) request.getAttribute("paymentMethod");
    String productDetails = (String) request.getAttribute("productDetails");

    if(orderId == null){
        response.sendRedirect("ProductServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Invoice | Order Success</title>

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
body{
    font-family:'Segoe UI', Arial, sans-serif;
    background:#f4f7f6;
    padding:30px 0;
}

/* ===== SMALLER INVOICE CARD ===== */
.invoice{
    width:560px; /* ? MUCH SMALLER */
    margin:auto;
    background:white;
    border-radius:14px;
    box-shadow:0 10px 30px rgba(0,0,0,0.12);
    overflow:hidden;
}

/* ===== HEADER ===== */
.invoice-header{
    background:linear-gradient(135deg,#c2185b,#ad1457);
    color:white;
    padding:18px 22px; /* ? reduced */
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.invoice-header h2{
    margin:0;
    font-size:20px;
    font-weight:800;
}

.invoice-header .status{
    background:white;
    color:#2ecc71;
    padding:5px 14px;
    border-radius:20px;
    font-weight:800;
    font-size:11px;
}

/* ===== BODY ===== */
.invoice-body{
    padding:20px 24px; /* ? reduced */
}

.row{
    display:flex;
    justify-content:space-between;
    margin-bottom:10px;
    font-size:13px;
}

.label{
    font-weight:700;
    color:#555;
}

/* ===== PRODUCTS BOX (SMALL) ===== */
.products{
    margin-top:10px;
    background:#fafafa;
    border:1px solid #eee;
    border-radius:10px;
    padding:12px;
    white-space:pre-line;
    font-size:12.5px;
    line-height:1.5;
}

/* ===== TOTAL ===== */
.total-box{
    margin-top:16px;
    padding:14px;
    border-top:1.5px dashed #ddd;
    display:flex;
    justify-content:space-between;
    font-size:15px;
    font-weight:800;
}

/* ===== FOOTER ===== */
.invoice-footer{
    text-align:center;
    padding:18px;
    border-top:1px solid #eee;
}

/* BUTTON */
button{
    padding:10px 22px;
    background:linear-gradient(135deg,#c2185b,#ad1457);
    color:white;
    border:none;
    border-radius:8px;
    font-size:13px;
    font-weight:700;
    cursor:pointer;
    transition:0.3s;
}

button:hover{
    transform:translateY(-1px);
    box-shadow:0 6px 16px rgba(194,24,91,0.3);
}

/* ICON SPACING */
i.fa-solid{
    margin-right:6px;
}

/* PRINT FRIENDLY */
@media print{
    body{ background:white; padding:0; }
    .invoice{ box-shadow:none; width:100%; }
    button{ display:none; }
}
</style>
</head>

<body>

<div class="invoice">

    <!-- HEADER -->
    <div class="invoice-header">
        <h2>
            <i class="fa-solid fa-file-invoice"></i> Invoice
        </h2>
        <div class="status">
            <i class="fa-solid fa-circle-check"></i> PAID
        </div>
    </div>

    <!-- BODY -->
    <div class="invoice-body">

        <div class="row">
            <div class="label">
                <i class="fa-solid fa-hashtag"></i> Order ID
            </div>
            <div>#<%= orderId %></div>
        </div>

        <div class="row">
            <div class="label">
                <i class="fa-solid fa-wallet"></i> Payment
            </div>
            <div><%= payment %></div>
        </div>

        <div class="row">
            <div class="label">
                <i class="fa-solid fa-calendar-day"></i> Date
            </div>
            <div><%= new java.util.Date() %></div>
        </div>

        <div class="row" style="margin-top:14px;">
            <div class="label">
                <i class="fa-solid fa-box"></i> Items
            </div>
        </div>

        <!-- ? FIXED -->
        <div class="products">
            <%= productDetails.replace("?", "&#8377;") %>
        </div>

        <div class="total-box">
            <div>
                <i class="fa-solid fa-indian-rupee-sign"></i> Total
            </div>
            <div>
                <i class="fa-solid fa-indian-rupee-sign"></i> <%= total %>
            </div>
        </div>

    </div>

    <!-- FOOTER -->
    <div class="invoice-footer">
        <a href="ProductServlet">
            <button>
                <i class="fa-solid fa-store"></i> Continue Shopping
            </button>
        </a>
    </div>

</div>

</body>
</html>
