<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>

    <style>
        /* Global Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            background: #fdf5e6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .card {
            width: 800px;
            height: 480px;
            background: #ffffff;
            border-radius: 20px;
            display: flex;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        }

        /* LEFT IMAGE */
        .left {
            flex: 1;
            background: #000;
        }

        .auth-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* RIGHT FORM */
        .right {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        h2 {
            color: #4e342e;
            font-size: 26px;
            margin-bottom: 6px;
        }

        p {
            color: #8d6e63;
            font-size: 14px;
            margin-bottom: 25px;
        }

        input {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 12px;
            border: 1px solid #efebe9;
            border-radius: 10px;
            background: #fafafa;
            outline: none;
            font-size: 14px;
            transition: 0.3s;
        }

        input:focus {
            background: #ffffff;
            border-color: #4e342e;
            box-shadow: 0 0 0 2px rgba(78, 52, 46, 0.1);
        }

        button {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 10px;
            background: #212121;
            color: white;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background: #424242;
        }

        .msg {
            margin-top: 10px;
            color: #d32f2f;
            text-align: center;
            font-size: 13px;
            min-height: 18px;
        }

        .bottom {
            margin-top: 20px;
            text-align: center;
            font-size: 13px;
            color: #795548;
        }

        .bottom a {
            color: #4e342e;
            font-weight: bold;
            text-decoration: none;
        }

        .bottom a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="card">

    <!-- LEFT IMAGE -->
    <div class="left">
        <!-- You can use a different admin image if you want -->
        <img src="images/login.jpg" class="auth-img" alt="Admin Panel">
    </div>

    <!-- RIGHT FORM -->
    <div class="right">
        <h2>Admin Sign In</h2>
        <p>Manage your Cosmetic Store</p>

        <form action="AdminLoginServlet" method="post">
            <input type="text" name="username" placeholder="Admin Username" required>
            <input type="password" name="password" placeholder="Admin Password" required>
            <button type="submit">Sign In</button>
        </form>

        <div class="msg">
            <%= request.getAttribute("msg") == null ? "" : request.getAttribute("msg") %>
        </div>

        <div class="bottom">
            Back to <a href="login.jsp">User Login</a>
        </div>
    </div>

</div>

</body>
</html>
