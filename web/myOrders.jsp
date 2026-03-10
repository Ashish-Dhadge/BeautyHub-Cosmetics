<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    if(session.getAttribute("user_id")==null){
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String,String>> orders =
        (List<Map<String,String>>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body{
            font-family:Arial;
            background:#f5f5f5;
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
        }
        th,td{
            padding:12px;
            border:1px solid #ccc;
            text-align:center;
        }
        th{
            background:#c2185b;
            color:white;
        }
        tr:hover{
            background:#f9f9f9;
        }

        /* CANCEL BUTTON */
        .cancel-btn{
            padding:6px 12px;
            background:#c2185b;
            color:white;
            border:none;
            border-radius:5px;
            font-weight:bold;
            cursor:pointer;
        }
        .cancel-btn:hover{
            background:#ad1457;
        }

        .disabled{
            color:#999;
            font-weight:bold;
        }

        .back{
            text-align:center;
            margin-bottom:30px;
        }
        .back a{
            text-decoration:none;
            color:#c2185b;
            font-weight:bold;
            font-size:16px;
        }
        .back a i{
            margin-right:6px;
        }
    </style>
</head>

<body>

<h2>My Orders</h2>

<table>
<tr>
    <th>Order ID</th>
    <th>Order Date</th>
    <th>Payment</th>
    <th>Total Amount</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
if(orders != null && !orders.isEmpty()){
    for(Map<String,String> o : orders){
%>
<tr>
    <td>#<%= o.get("order_id") %></td>
    <td><%= o.get("date") %></td>
    <td><%= o.get("payment") %></td>

    <td>&#8377; <%= o.get("total") %></td>

    <td>
        <% if("PLACED".equals(o.get("status"))){ %>
            <span style="color:orange;font-weight:bold;">PLACED</span>
        <% } else if("SHIPPED".equals(o.get("status"))){ %>
            <span style="color:#1976d2;font-weight:bold;">SHIPPED</span>
        <% } else if("CANCELLED".equals(o.get("status"))){ %>
            <span style="color:#c2185b;font-weight:bold;">CANCELLED</span>
        <% } else { %>
            <span style="color:green;font-weight:bold;">DELIVERED</span>
        <% } %>
    </td>

    <!-- ✅ ACTION COLUMN -->
    <td>
        <% if("PLACED".equals(o.get("status")) || "SHIPPED".equals(o.get("status"))){ %>
            <form action="CancelOrderServlet" method="post" style="margin:0;">
                <input type="hidden" name="order_id" value="<%= o.get("order_id") %>">
                <button class="cancel-btn"
                        onclick="return confirm('Are you sure you want to cancel this order?');">
                    Cancel
                </button>
            </form>
        <% } else { %>
            <span class="disabled">Not Allowed</span>
        <% } %>
    </td>
</tr>
<%
    }
} else {
%>
<tr>
    <td colspan="6">No orders found</td>
</tr>
<%
}
%>

</table>

<div class="back">
    <a href="ProductServlet">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>
</div>

</body>
</html>
