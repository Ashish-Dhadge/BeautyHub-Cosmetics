<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("admin")==null){
        response.sendRedirect("adminLogin.jsp");
        return;
    }
    
    // Get Categories from Request
    List<Map<String,String>> categories = (List<Map<String,String>>)request.getAttribute("categories");
    
    // Catch message from both redirect (parameter) and forward (attribute)
    String msg = (String)request.getAttribute("msg");
    if(msg == null || msg.trim().isEmpty()){
        msg = request.getParameter("msg");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Categories | Premium Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f8f9fa; margin: 0; }
        .admin-header { background: white; padding: 20px 5%; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .back-link { text-decoration: none; color: #1976d2; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .page-title { color: #c2185b; margin: 0; font-size: 24px; font-weight: 800; }
        .main-content { width: 90%; max-width: 900px; margin: 0 auto 50px; }

        /* ALERT BOX STYLE */
        .alert-area { margin-bottom: 25px; }
        .error-msg {
            background: #fff5f5; color: #c2185b; border: 1px solid #feb2b2;
            padding: 15px; border-radius: 12px; display: flex; align-items: center;
            gap: 12px; font-weight: 600; box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            animation: slideIn 0.3s ease-out;
        }
        @keyframes slideIn {
            from { transform: translateY(-10px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .add-card { background: white; padding: 20px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); margin-bottom: 30px; border: 1px solid #edf2f7; }
        .add-form { display: flex; gap: 15px; }
        .add-form input { flex: 1; padding: 12px; border: 2px solid #eee; border-radius: 10px; outline: none; }
        .add-btn { background: #c2185b; color: white; border: none; padding: 12px 25px; border-radius: 10px; font-weight: 700; cursor: pointer; }

        .card { background: white; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.06); overflow: hidden; border: 1px solid #edf2f7; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #fafafa; color: #718096; padding: 18px; font-size: 12px; text-transform: uppercase; border-bottom: 2px solid #f1f1f1; }
        td { padding: 15px 20px; border-bottom: 1px solid #f7f7f7; text-align: center; }

        .badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .status-active { background: #e6fffa; color: #2d3748; border: 1px solid #b2f5ea; }
        .status-deleted { background: #fff5f5; color: #c2185b; border: 1px solid #feb2b2; }

        .btn-group { display: flex; justify-content: center; gap: 8px; }
        .btn { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; color: white; text-decoration: none; transition: 0.3s; border: none; cursor: pointer;}
        .edit { background: #1976d2; }
        .delete { background: #c2185b; }
        .restore { background: #2ecc71; }
        .btn:hover { transform: translateY(-2px); filter: brightness(1.1); }
        .cat-name.inactive { color: #a0aec0; text-decoration: line-through; }
    </style>
</head>
<body>

    <header class="admin-header">
        <a class="back-link" href="AdminDashboardServlet"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
        <h1 class="page-title"><i class="fa-solid fa-layer-group"></i> Category Management</h1>
        <div style="width: 100px;"></div> 
    </header>

    <div class="main-content">
        
        <% if(msg != null && !msg.trim().isEmpty()) { %>
            <div class="alert-area" id="alertBox">
                <div class="error-msg">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span style="flex: 1;"><%= msg %></span>
                    <i class="fa-solid fa-xmark" style="cursor:pointer;" onclick="document.getElementById('alertBox').style.display='none'"></i>
                </div>
            </div>
        <% } %>

        <div class="add-card">
            <h3 style="margin-top:0; font-size: 14px; color: #718096;">Create New Category</h3>
            <form action="AddCategoryServlet" method="post" class="add-form">
                <input type="text" name="category_name" placeholder="Skin Care, Hair Care etc." required>
                <button type="submit" class="add-btn"><i class="fa-solid fa-plus"></i> Add</button>
            </form>
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th width="10%">ID</th>
                        <th width="40%">Category Name</th>
                        <th width="20%">Status</th>
                        <th width="30%">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                if(categories != null && !categories.isEmpty()){
                    for(Map<String,String> c : categories){
                        boolean isActive = "1".equals(c.get("status"));
                %>
                <tr>
                    <td><span style="font-family: monospace; font-weight: bold;">#<%= c.get("id") %></span></td>
                    <td>
                        <span class="cat-name <%= !isActive ? "inactive" : "" %>">
                            <%= c.get("name") %>
                        </span>
                    </td>
                    <td>
                        <% if(isActive) { %>
                            <span class="badge status-active">Active</span>
                        <% } else { %>
                            <span class="badge status-deleted">Deleted</span>
                        <% } %>
                    </td>
                    <td>
                        <div class="btn-group">
                            <% if(isActive) { %>
                                <a class="btn edit" href="EditCategoryServlet?id=<%= c.get("id") %>" title="Edit"><i class="fa-solid fa-pen"></i></a>
                                <a class="btn delete" href="DeleteCategoryServlet?id=<%= c.get("id") %>" title="Soft Delete" onclick="return confirm('Disable this category?')"><i class="fa-solid fa-trash"></i></a>
                            <% } else { %>
                                <a class="btn restore" href="RestoreCategoryServlet?id=<%= c.get("id") %>" title="Restore"><i class="fa-solid fa-rotate-left"></i></a>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="4" style="padding: 40px; color: #718096;">No categories found.</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>