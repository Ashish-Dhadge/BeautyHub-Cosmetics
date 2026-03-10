<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("user_id")==null){
        response.sendRedirect("login.jsp");
        return;
    }

    Map<String,String> user =
        (Map<String,String>) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>

    <!-- ? Font Awesome Icons -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body{
            font-family: Arial, sans-serif;
            background:#f5f5f5;
            margin:0;
            padding:0;
        }

        .box{
            width:450px;
            margin:40px auto;
            background:white;
            padding:25px;
            border-radius:10px;
            box-shadow:0 0 10px #ccc;
        }

        h2{
            text-align:center;
            color:#c2185b;
            margin-bottom:20px;
        }

        label{
            font-weight:bold;
            display:block;
            margin-top:10px;
        }

        input, textarea{
            width:100%;
            padding:8px;
            margin-top:6px;
            border:1px solid #ccc;
            border-radius:5px;
            font-size:14px;
        }

        textarea{
            resize:none;
            height:80px;
        }

        button{
            width:100%;
            padding:10px;
            background:#c2185b;
            color:white;
            border:none;
            border-radius:5px;
            cursor:pointer;
            font-size:15px;
            margin-top:15px;
        }

        button:hover{
            background:#a3154c;
        }

        /* ===== BACK TO DASHBOARD ===== */
        .back{
            text-align:center;
            margin-top:18px;
        }

        .back a{
            color:#c2185b;
            text-decoration:none;
            font-weight:bold;
            font-size:14px;
            display:inline-flex;
            align-items:center;
            gap:6px;
        }

        .back a i{
            font-size:16px;
        }

        .back a:hover{
            text-decoration:underline;
        }
    </style>
</head>
<body>

<div class="box">
    <h2>My Profile</h2>

    <form action="UpdateProfileServlet" method="post">

        <label>Name</label>
        <input type="text" name="name"
               value="<%= user.get("name") %>" required>

        <label>Email</label>
        <input type="text"
               value="<%= user.get("email") %>" readonly>

        <label>Mobile</label>
        <input type="text" name="mobile"
               value="<%= user.get("mobile") %>" required>

        <label>Address</label>
        <textarea name="address"><%= user.get("address") %></textarea>

        <button type="submit">Update Profile</button>
    </form>

    <div class="back">
        <a href="ProductServlet">
            <i class="fa-solid fa-arrow-left"></i>
            Back to Dashboard
        </a>
    </div>
</div>

</body>
</html>
