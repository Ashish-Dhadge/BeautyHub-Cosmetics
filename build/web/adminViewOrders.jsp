<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("admin")==null){
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String,String>> orders =
        (List<Map<String,String>>)request.getAttribute("orders");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Orders | Management</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
            color: #333;
        }

        h2 {
            text-align: center;
            color: #c2185b;
            font-weight: 800;
            font-size: 28px;
            margin-bottom: 30px;
        }

        .back-link {
            display: inline-block;
            margin: 10px 0 25px 2.5%;
            color: #1976d2;
            font-weight: bold;
            text-decoration: none;
            transition: 0.3s;
        }

        .back-link:hover {
            color: #c2185b;
            transform: translateX(-5px);
        }

        .table-container {
            width: 95%;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #c2185b;
            color: white;
            padding: 18px 10px;
            font-size: 14px;
            text-transform: uppercase;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            text-align: center;
            font-size: 15px;
        }

        tr:hover {
            background-color: #fff9fb;
        }

        select {
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid #ddd;
            background: #fafafa;
            cursor: pointer;
        }

        button {
            padding: 8px 16px;
            background: #1976d2;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        button:disabled {
            background: #aaa;
            cursor: not-allowed;
        }

        .total {
            color: #c2185b;
            font-weight: 800;
        }
        .total::before {
            content: "₹ ";
        }

        .order-id-badge {
            background: #f0f0f0;
            padding: 4px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-weight: bold;
        }

        .status-cancelled{
            color:#c2185b;
            font-weight:800;
        }
    </style>
</head>

<body>

<a href="AdminDashboardServlet" class="back-link">
    <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
</a>

<h2><i class="fa-solid fa-clipboard-list"></i> Customer Orders</h2>

<div class="table-container">
<table>
<thead>
<tr>
    <th>Order ID</th>
    <th>User Email</th>
    <th>Total amount</th>
    <th>Payment Method</th>
    <th>Current Status</th>
    <th>Action</th>
</tr>
</thead>
<tbody>

<%
if(orders != null){
    for(Map<String,String> o : orders){
        boolean isLocked = "CANCELLED".equals(o.get("status")) || 
                           "DELIVERED".equals(o.get("status"));
%>
<tr>
    <td><span class="order-id-badge">#<%= o.get("order_id") %></span></td>
    <td><%= o.get("email") %></td>
    <td class="total"><%= o.get("total") %></td>
    <td><%= o.get("payment") %></td>

    <form action="UpdateOrderStatusServlet" method="post">
        <td>
            <select name="status" <%= isLocked ? "disabled" : "" %>>
                <option <%= "PLACED".equals(o.get("status"))?"selected":"" %>>PLACED</option>
                <option <%= "SHIPPED".equals(o.get("status"))?"selected":"" %>>SHIPPED</option>
                <option <%= "DELIVERED".equals(o.get("status"))?"selected":"" %>>DELIVERED</option>
                <option <%= "CANCELLED".equals(o.get("status"))?"selected":"" %>>CANCELLED</option>
            </select>
        </td>
        <td>
            <input type="hidden" name="order_id" value="<%= o.get("order_id") %>">
            <input type="hidden" name="email" value="<%= o.get("email") %>">
            <button type="submit" <%= isLocked ? "disabled" : "" %>>
                Update
            </button>
        </td>
    </form>
</tr>
<%
    }
}
%>

</tbody>
</table>
</div>

</body>
</html>