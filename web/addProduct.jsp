<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("admin")==null){
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String,String>> categories =
        (List<Map<String,String>>)request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Product | Admin</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        /* =========================================================
           1. GLOBAL STYLES
           ========================================================= */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
            color: #333;
        }

        /* =========================================================
           2. THE FORM BOX (MODERN CARD)
           ========================================================= */
        .box {
            width: 500px;
            margin: 40px auto;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #c2185b;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        /* =========================================================
           3. FORM ELEMENTS
           ========================================================= */
        label {
            font-weight: 600;
            font-size: 14px;
            color: #555;
            display: block;
            margin-bottom: 5px;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box; 
            transition: all 0.3s ease;
            background: #fafafa;
        }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #c2185b;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(194, 24, 91, 0.1);
        }

        textarea {
            resize: none;
            height: 100px;
        }

        /* =========================================================
           4. BUTTON & MESSAGES
           ========================================================= */
        button {
            width: 100%;
            padding: 14px;
            background: #c2185b;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(194, 24, 91, 0.2);
            margin-top: 10px;
        }

        button:hover {
            background: #9c134a;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(194, 24, 91, 0.3);
        }

        .msg {
            text-align:center;
            margin-top:20px;
            color:#2e7d32;
            font-weight:bold;
            padding: 10px;
            border-radius: 5px;
            background: #e8f5e9;
            display: <%= (request.getAttribute("msg") == null || request.getAttribute("msg").toString().isEmpty()) ? "none" : "block" %>;
        }

        /* =========================================================
           5. NAVIGATION
           ========================================================= */
        a.back-btn {
            display: block;
            text-align: center;
            margin-top: 25px;
            text-decoration: none;
            color: #666;
            font-weight: 600;
            font-size: 14px;
            transition: color 0.3s;
        }

        a.back-btn:hover {
            color: #c2185b;
        }

        
        input[type="file"] {
            padding: 8px;
            background: #fff;
            border: 1px dashed #ccc;
        }
    </style>
</head>
<body>

<div class="box">
    <h2><i class="fa-solid fa-square-plus"></i> Add New Product</h2>

    <form action="AddProductServlet" method="post" enctype="multipart/form-data">

        <label>Product Name</label>
        <input type="text" name="name" placeholder="Enter product title" required>

        <div style="display: flex; gap: 15px;">
            <div style="flex: 1;">
                <label>Brand</label>
                <input type="text" name="brand" placeholder="Brand name" required>
            </div>
            <div style="flex: 1;">
                <label>Price (₹)</label>
                <input type="number" name="price" placeholder="0.00" required>
            </div>
        </div>

        <div style="display: flex; gap: 15px;">
            <div style="flex: 1;">
                <label>Quantity</label>
                <input type="number" name="quantity" placeholder="Stock amount" required>
            </div>
            <div style="flex: 1;">
                <label>Category</label>
                <select name="category_id" required>
                    <option value="">-- Select --</option>
                    <%
                        if(categories != null){
                            for(Map<String,String> c : categories){
                    %>
                        <option value="<%= c.get("id") %>">
                            <%= c.get("name") %>
                        </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
        </div>

        <label>Description</label>
        <textarea name="description" placeholder="Describe the product details..."></textarea>

        <label>Product Image</label>
        <input type="file" name="image" required>

        <button type="submit">Upload Product</button>
    </form>

    <div class="msg">
        <%= request.getAttribute("msg")==null?"":request.getAttribute("msg") %>
    </div>

    <a href="AdminDashboardServlet" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>
</div>

</body>
</html>