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
<title>Manage Users</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
body{
    font-family:'Segoe UI', Arial, sans-serif;
    background:#f5f5f5;
    margin:0;
}

/* ===== HEADER ===== */
.header{
    background:white;
    padding:20px 5%;
    display:flex;
    align-items:center;
    justify-content:space-between;
    box-shadow:0 6px 20px rgba(0,0,0,0.08);
}

/* Back link (same style as other pages) */
.back-link{
    text-decoration:none;
    color:#1976d2;
    font-weight:700;
    display:flex;
    align-items:center;
    gap:8px;
    transition:0.3s;
}
.back-link:hover{
    color:#c2185b;
}

.header h2{
    margin:0;
    font-size:28px;
    font-weight:800;
    background: linear-gradient(90deg, #c2185b, #1976d2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

/* ===== MESSAGE ===== */
.msg{
    text-align:center;
    color:#c2185b;
    font-weight:bold;
    margin:20px;
}

/* ===== TABLE WRAPPER ===== */
.table-wrap{
    width:90%;
    margin:30px auto;
    background:white;
    border-radius:16px;
    box-shadow:0 12px 40px rgba(0,0,0,0.10);
    overflow:hidden;
}

/* ===== TABLE ===== */
table{
    width:100%;
    border-collapse:collapse;
}

th{
    padding:16px;
    background:#fafafa;
    color:#666;
    font-size:13px;
    text-transform:uppercase;
    border-bottom:2px solid #eee;
}

td{
    padding:15px;
    border-bottom:1px solid #f1f1f1;
    text-align:center;
    font-size:14px;
}

tr:hover{
    background:#fafafa;
}

/* ===== STATUS BADGES ===== */
.status-active{
    background:#e6fff5;
    color:#0f9d58;
    padding:6px 14px;
    border-radius:20px;
    font-size:12px;
    font-weight:700;
}
.status-inactive{
    background:#ffecec;
    color:#c2185b;
    padding:6px 14px;
    border-radius:20px;
    font-size:12px;
    font-weight:700;
}

/* ===== ACTION BUTTONS ===== */
.action{
    padding:8px 16px;
    border-radius:8px;
    color:white;
    text-decoration:none;
    font-size:13px;
    font-weight:600;
    display:inline-block;
    transition:0.3s;
}

.deactivate{
    background:linear-gradient(135deg,#c2185b,#ad1457);
}
.restore{
    background:linear-gradient(135deg,#2ecc71,#27ae60);
}

.action:hover{
    transform:translateY(-2px);
    opacity:0.9;
}
</style>
</head>

<body>

<!-- ===== HEADER WITH BACK LINK ===== -->
<div class="header">
    <a class="back-link" href="AdminDashboardServlet">
        <i class="fa-solid fa-arrow-left"></i> Dashboard
    </a>

    <h2><i class="fa-solid fa-users"></i> Manage Users</h2>

    <div style="width:120px;"></div>
</div>

<div class="msg">
    <%= request.getAttribute("msg")==null?"":request.getAttribute("msg") %>
</div>

<div class="table-wrap">
<table>
<tr>
    <th>Name</th>
    <th>Email</th>
    <th>Mobile</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
List<Map<String,String>> users=(List<Map<String,String>>)request.getAttribute("users");
if(users!=null){
for(Map<String,String> u:users){
%>
<tr>
    <td><%=u.get("name")%></td>
    <td><%=u.get("email")%></td>
    <td><%=u.get("mobile")%></td>
    <td>
        <% if("1".equals(u.get("status"))){ %>
            <span class="status-active">ACTIVE</span>
        <% } else { %>
            <span class="status-inactive">INACTIVE</span>
        <% } %>
    </td>
    <td>
        <% if("1".equals(u.get("status"))){ %>
            <a class="action deactivate"
               href="DeactivateUserServlet?id=<%=u.get("id")%>"
               onclick="return confirm('Deactivate this user?')">
               Deactivate
            </a>
        <% } else { %>
            <a class="action restore"
               href="RestoreUserServlet?id=<%=u.get("id")%>"
               onclick="return confirm('Restore this user?')">
               Restore
            </a>
        <% } %>
    </td>
</tr>
<% } } %>

</table>
</div>

</body>
</html>
