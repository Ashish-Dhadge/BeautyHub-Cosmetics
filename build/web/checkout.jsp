<%
    if(session.getAttribute("user_id")==null){
        response.sendRedirect("login.jsp");
        return;
    }

    double total = request.getAttribute("totalAmount") == null 
                   ? 0 
                   : (double) request.getAttribute("totalAmount");

    String upiId = "dhadgeashish@okhdfcbank";
    String name = "Ashish Dhadge";

    String upiUrl = "upi://pay?pa=" + upiId +
                    "&pn=" + name +
                    "&am=" + total +
                    "&cu=INR";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout</title>

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
body{
    font-family:'Segoe UI', Arial, sans-serif;
    background:#f4f7f6;
    margin:0;
    padding:40px 0;
}

/* ===== MAIN CARD (ADMIN STYLE) ===== */
.box{
    width:540px;
    margin:auto;
    background:white;
    padding:30px;
    border-radius:16px;
    box-shadow:0 10px 40px rgba(0,0,0,0.08);
}

/* ===== HEADER ===== */
h2{
    text-align:center;
    font-size:26px;
    font-weight:800;
    margin-bottom:20px;
    background:linear-gradient(90deg,#c2185b,#1976d2);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
}

.total-box{
    text-align:center;
    font-size:20px;
    font-weight:800;
    color:#333;
    margin-bottom:25px;
}

/* ===== PAYMENT SECTIONS ===== */
.payment{
    padding:18px;
    border:1px solid #eee;
    border-radius:12px;
    margin-bottom:15px;
    transition:0.3s;
}

.payment:hover{
    box-shadow:0 4px 15px rgba(0,0,0,0.05);
}

.payment b{
    font-size:15px;
}

.qr{
    text-align:center;
}

.qr img{
    width:170px;
    margin-top:12px;
}

/* ===== INPUTS ===== */
input[type=text],
input[type=password]{
    width:100%;
    padding:10px;
    margin-top:8px;
    border:1px solid #ddd;
    border-radius:8px;
    outline:none;
    font-size:14px;
}

input:focus{
    border-color:#c2185b;
}

/* ===== ERROR ===== */
.error{
    color:#c2185b;
    font-size:13px;
    margin-top:8px;
}

/* ===== BUTTON ===== */
button{
    width:100%;
    padding:14px;
    margin-top:25px;
    background:linear-gradient(135deg,#c2185b,#ad1457);
    color:white;
    border:none;
    border-radius:10px;
    font-size:16px;
    font-weight:700;
    cursor:pointer;
    transition:0.3s;
}

button:hover{
    transform:translateY(-1px);
    box-shadow:0 8px 20px rgba(194,24,91,0.3);
}

button:disabled{
    background:#aaa;
    box-shadow:none;
    cursor:not-allowed;
}

/* ===== BACK LINK ===== */
.back{
    text-align:center;
    margin-top:25px;
}
.back a{
    color:#333;
    text-decoration:none;
    font-weight:700;
}
.back a:hover{
    color:#c2185b;
    text-decoration:underline;
}

/* ===== RUPEE ===== */
.amount::before{
    content:"\20B9 ";
    font-weight:bold;
}
</style>
</head>

<body>

<div class="box">

<h2><i class="fa-solid fa-credit-card"></i> Checkout</h2>

<div class="total-box amount"><%= total %></div>

<form action="CheckoutServlet" method="post" onsubmit="return validatePayment()">

    <!-- COD -->
    <div class="payment">
        <input type="radio" name="payment" value="CASH_ON_DELIVERY">
        <b> Cash on Delivery</b>
    </div>

    <!-- QR -->
    <div class="payment qr">
        <input type="radio" name="payment" value="QR_PAYMENT">
        <b> Pay Online (UPI)</b><br>
        <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=<%= upiUrl %>">
        <p class="amount"><%= total %></p>
    </div>

    <!-- CARD -->
    <div class="payment">
        <input type="radio" name="payment" value="DEBIT_CARD">
        <b> Debit Card</b>

        <input type="text"
               id="cardNumber"
               placeholder="Card Number (16 digits)"
               maxlength="16"
               inputmode="numeric"
               oninput="restrictCard(this)">

        <input type="text"
               id="expiry"
               placeholder="Expiry (MM/YY)"
               maxlength="5"
               inputmode="numeric"
               oninput="restrictExpiry(this)">

        <input type="password"
               id="cvv"
               placeholder="CVV"
               maxlength="3"
               inputmode="numeric"
               oninput="restrictCVV(this)">

        <div id="cardError" class="error"></div>
    </div>

    <button type="submit" <%= total==0 ? "disabled" : "" %>>
        Confirm & Place Order
    </button>
</form>

<div class="back">
    <a href="ProductServlet">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>
</div>

</div>

<script>
function restrictCard(input){
    input.value = input.value.replace(/\D/g, '');
    if(input.value.length > 16){
        input.value = input.value.slice(0,16);
    }
}

function restrictCVV(input){
    input.value = input.value.replace(/\D/g, '');
    if(input.value.length > 3){
        input.value = input.value.slice(0,3);
    }
}

function restrictExpiry(input){
    let val = input.value.replace(/\D/g, '');

    if(val.length >= 3){
        val = val.substring(0,2) + '/' + val.substring(2,4);
    }
    input.value = val.substring(0,5);
}

function validatePayment(){

    const payments = document.getElementsByName("payment");
    let selected = null;

    for(let p of payments){
        if(p.checked){
            selected = p.value;
            break;
        }
    }

    if(!selected){
        alert("Please select a payment method");
        return false;
    }

    if(selected === "DEBIT_CARD"){

        const card = document.getElementById("cardNumber").value.trim();
        const expiry = document.getElementById("expiry").value.trim();
        const cvv = document.getElementById("cvv").value.trim();
        const err = document.getElementById("cardError");

        err.innerHTML = "";

        if(card === "" || card.length !== 16){
            err.innerHTML = "Card number must be exactly 16 digits";
            return false;
        }

        if(expiry === "" || !/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry)){
            err.innerHTML = "Expiry must be MM/YY format";
            return false;
        }

        if(cvv === "" || cvv.length !== 3){
            err.innerHTML = "CVV must be exactly 3 digits";
            return false;
        }
    }

    return true;
}
</script>

</body>
</html>