<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cosmetic Store</title>
    <style>
        body{
            font-family: Arial;
            background: linear-gradient(to right, #fbd3e9, #bb377d);
            margin: 0;
            padding: 0;
        }
        .container{
            width: 400px;
            margin: 100px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
        }
        h2{
            color: #bb377d;
        }
        a{
            display: block;
            margin: 15px;
            padding: 10px;
            background: #bb377d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a:hover{
            background: #922b63;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Welcome to Cosmetic Store</h2>
    <a href="login.jsp">User Login</a>
    <a href="register.jsp">User Register</a>
    <a href="adminLogin.jsp">Admin Login</a>
</div>

</body>
</html>
