<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Required</title>
    <style>
        /* Global Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            /* Matches the Dashboard cream background */
            background: #fdf5e6; 
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .box {
            background: #ffffff;
            width: 400px; 
            padding: 40px;
            border-radius: 20px; 
            text-align: center;
            /* Softer shadow for the new clean aesthetic */
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        }

        h2 {
            /* Matches dashboard dark brown text */
            color: #4e342e; 
            font-size: 26px;
            margin-bottom: 10px;
        }

        p {
            /* Matches dashboard secondary text color */
            color: #8d6e63;
            font-size: 15px;
            line-height: 1.5;
            margin-bottom: 30px;
        }

        .buttons {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .buttons a {
            display: block;
            padding: 14px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: 0.3s ease;
        }

        /* Matches the dark Dashboard buttons */
        .login {
            background: #212121;
            color: white;
        }

        .login:hover {
            background: #424242;
        }

        /* Subtle secondary button style */
        .register {
            background: #fafafa;
            color: #4e342e;
            border: 1px solid #efebe9;
        }

        .register:hover {
            background: #f5f5f5;
            border-color: #d7ccc8;
        }

        .browse {
            display: inline-block;
            margin-top: 20px;
            color: #795548;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }

        .browse:hover {
            color: #4e342e;
            text-decoration: underline;
        }
    </style>
</head>

<body>
    <div class="box">
        <h2>Login Required</h2>
        <p>Please login or create an account to continue shopping our premium cosmetics.</p>
        
        <div class="buttons">
            <a href="login.jsp" class="login">Sign In</a>
            <a href="register.jsp" class="register">Create Account</a>
        </div>

        <a href="ProductServlet" class="browse">Continue Browsing</a>
    </div>
</body>
</html>