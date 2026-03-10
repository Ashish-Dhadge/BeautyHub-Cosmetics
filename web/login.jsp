<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
    /* Global Reset */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        height: 100vh;
        /* Matches the soft cream/yellowish background of the Dashboard */
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

    /* LEFT SIDE - IMAGE */
    .left {
        flex: 1;
        height: 100%;
        background-color: #000; /* Black background to match the cosmetic brush image */
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
        padding: 40px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    h2 {
        /* Matches the dark brown text "Discover Your Beauty" */
        color: #4e342e; 
        font-size: 26px;
        margin-bottom: 6px;
    }

    p {
        color: #8d6e63;
        font-size: 14px;
        margin-bottom: 25px;
    }

    form {
        width: 100%;
    }

    input {
        width: 100%;
        padding: 12px 15px;
        margin-bottom: 12px;
        border: 1px solid #efebe9;
        border-radius: 10px;
        /* Soft off-white to match dashboard search bar area */
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
        margin-top: 5px;
        border: none;
        border-radius: 10px;
        /* Matches the dark button/header accent color from Dashboard */
        background: #212121; 
        color: white;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
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
        margin-top: 20px;
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
        <img src="images/login.jpg" class="auth-img" alt="Cosmetic Products">
    </div>

    <div class="right">
        <h2>Let's sign you in</h2>
        <p>Welcome back to your Cosmetic Store</p>

        <form action="LoginServlet" method="post">
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Sign In</button>
        </form>

        <div class="msg">
            <%= (request.getAttribute("msg") == null) ? "" : request.getAttribute("msg") %>
        </div>

        <div class="bottom">
            Don't have an account? <a href="register.jsp">Register</a>
        </div>
    </div>

</div>

</body>
</html>