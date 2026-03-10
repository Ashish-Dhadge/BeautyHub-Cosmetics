<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("admin")==null){
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String,String>> users =
        (List<Map<String,String>>)request.getAttribute("users");
    int userCount = (users != null) ? users.size() : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users | Premium Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        /* =========================================================
           1. GLOBAL STYLES
           ========================================================= */
        body {
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: #f8f9fa;
            margin: 0;
            padding: 0;
            color: #444;
        }

        /* =========================================================
           2. HEADER & NAV
           ========================================================= */
        .admin-header {
            background: white;
            padding: 20px 5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .back-link {
            text-decoration: none;
            color: #1976d2;
            font-weight: 700;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }

        .back-link:hover {
            color: #c2185b;
            transform: translateX(-3px);
        }

        .page-title {
            color: #c2185b;
            margin: 0;
            font-size: 24px;
            font-weight: 800;
        }

        /* =========================================================
           3. SUMMARY STATS
           ========================================================= */
        .stats-bar {
            width: 90%;
            margin: 0 auto 25px;
            display: flex;
            gap: 20px;
        }

        .stat-card {
            background: white;
            padding: 15px 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 5px solid #c2185b;
        }

        .stat-card i {
            font-size: 24px;
            color: #c2185b;
        }

        .stat-info h3 {
            margin: 0;
            font-size: 18px;
            color: #333;
        }

        .stat-info p {
            margin: 0;
            font-size: 13px;
            color: #888;
        }

        /* =========================================================
           4. TABLE STYLING
           ========================================================= */
        .table-wrapper {
            width: 90%;
            margin: 0 auto 50px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.06);
            overflow: hidden;
            border: 1px solid #edf2f7;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #fafafa;
            color: #718096;
            padding: 20px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            text-align: center;
            border-bottom: 2px solid #f1f1f1;
        }

        td {
            padding: 18px 20px;
            border-bottom: 1px solid #f7f7f7;
            text-align: center;
            font-size: 15px;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover {
            background-color: #fdf2f7;
        }

        /* Styled Components */
        .user-id {
            background: #f1f5f9;
            color: #475569;
            padding: 4px 10px;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-weight: bold;
            font-size: 13px;
        }

        .user-name {
            font-weight: 700;
            color: #2d3748;
        }

        .email-link {
            color: #1976d2;
            text-decoration: none;
        }

        .phone-text {
            color: #666;
            font-weight: 500;
        }

        .empty-state {
            padding: 50px;
            text-align: center;
            color: #a0aec0;
        }
    </style>
</head>
<body>

    <header class="admin-header">
        <a class="back-link" href="AdminDashboardServlet">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
        <h1 class="page-title"><i class="fa-solid fa-users-viewfinder"></i> User Management</h1>
        <div style="width: 100px;"></div> </header>

    <div class="stats-bar">
        <div class="stat-card">
            <i class="fa-solid fa-user-check"></i>
            <div class="stat-info">
                <h3><%= userCount %></h3>
                <p>Total Customers</p>
            </div>
        </div>
    </div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer Name</th>
                    <th>Email Address</th>
                    <th>Contact Number</th>
                </tr>
            </thead>
            <tbody>
            <%
                if(users != null && !users.isEmpty()){
                    for(Map<String,String> u : users){
            %>
            <tr>
                <td><span class="user-id">#<%= u.get("id") %></span></td>
                <td><span class="user-name"><%= u.get("name") %></span></td>
                <td><a href="mailto:<%= u.get("email") %>" class="email-link"><%= u.get("email") %></a></td>
                <td><span class="phone-text"><%= u.get("mobile") %></span></td>
            </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="4" class="empty-state">
                        <i class="fa-solid fa-user-slash" style="font-size: 40px; margin-bottom: 15px; display: block;"></i>
                        No registered users found in the database.
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

</body>
</html>