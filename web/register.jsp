<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <style>
        /* Global Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            /* Matches the soft cream background of the Dashboard */
            background: #fdf5e6; 
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .card {
            width: 800px; 
            height: 550px; /* Slightly taller for the extra fields */
            background: #ffffff;
            border-radius: 20px;
            display: flex;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        }

        /* LEFT SIDE - IMAGE */
        .left {
            flex: 1;
            height: 100%;
            background-color: #000;
        }

        .auth-img {
            width: 100%;
            height: 100%;
            object-fit: cover; 
            display: block;
        }

        /* RIGHT SIDE - FORM */
        .right {
            flex: 1;
            padding: 30px 45px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        h2 {
            /* Dashboard dark brown accent */
            color: #4e342e; 
            font-size: 24px;
            margin-bottom: 5px;
        }

        p {
            /* Dashboard secondary text color */
            color: #8d6e63;
            font-size: 14px;
            margin-bottom: 15px;
        }

        form {
            width: 100%;
        }

        input, textarea {
            width: 100%;
            padding: 10px 15px;
            margin-bottom: 10px;
            border: 1px solid #efebe9;
            border-radius: 10px;
            background: #fafafa;
            outline: none;
            font-size: 13px;
            font-family: inherit;
            transition: 0.3s;
        }

        textarea {
            height: 60px;
            resize: none;
        }

        input:focus, textarea:focus {
            background: #ffffff;
            border-color: #4e342e;
            box-shadow: 0 0 0 2px rgba(78, 52, 46, 0.1);
        }

        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 10px;
            /* Dashboard black/dark grey button color */
            background: #212121; 
            color: white;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 5px;
            transition: background 0.3s ease;
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
            margin-top: 15px;
            text-align: center;
            font-size: 13px;
            color: #795548;
        }

        .bottom a {
            color: #4e342e;
            text-decoration: none;
            font-weight: bold;
        }

        .bottom a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="card">
    <div class="left">
        <img src="images/login.jpg" class="auth-img" alt="Registration Background">
    </div>

    <div class="right">
        <h2>Create Your Account</h2>
        <p>Join our Cosmetic Store community</p>

        <form action="RegisterServlet" method="post">
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="text" name="mobile" placeholder="Mobile">
            <textarea name="address" placeholder="Address"></textarea>
            <button type="submit">Register</button>
        </form>

        <div class="msg">
            <%= (request.getAttribute("msg") == null) ? "" : request.getAttribute("msg") %>
        </div>

        <div class="bottom">
            Already have an account? <a href="login.jsp">Login</a>
        </div>
    </div>
</div>

</body>
</html>