<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("admin")==null){
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Category | Premium Admin</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        /* GLOBAL STYLES */
        body {
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: #f8f9fa;
            margin: 0;
            padding: 0;
            color: #444;
        }

        /* HEADER BAR (Consistent with other pages) */
        .admin-header {
            background: white;
            padding: 20px 5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 40px;
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

        /* FORM CARD */
        .container {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
            padding: 0 20px;
            box-sizing: border-box;
        }

        .card {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.06);
            border: 1px solid #edf2f7;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #555;
            font-size: 14px;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #eee;
            border-radius: 10px;
            font-size: 16px;
            box-sizing: border-box;
            transition: all 0.3s;
            outline: none;
        }

        input[type="text"]:focus {
            border-color: #c2185b;
            background: #fff9fb;
        }

        button {
            width: 100%;
            padding: 14px;
            background: #c2185b;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        button:hover {
            background: #a3154d;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(194, 24, 91, 0.3);
        }

        button:active {
            transform: translateY(0);
        }

    </style>
</head>
<body>

    <header class="admin-header">
        <a class="back-link" href="ManageCategoryServlet">
            <i class="fa-solid fa-arrow-left"></i> Categories
        </a>
        <h1 class="page-title"><i class="fa-solid fa-pen-to-square"></i> Edit Category</h1>
        <div style="width: 100px;"></div> 
    </header>

    <div class="container">
        <div class="card">
            <form action="UpdateCategoryServlet" method="post">
                <input type="hidden" name="id" value="<%= request.getAttribute("id") %>">

                <div class="form-group">
                    <label for="category_name">Category Name</label>
                    <input type="text" id="category_name" name="category_name"
                           value="<%= request.getAttribute("name") %>" 
                           placeholder="Enter new category name..." required>
                </div>

                <button type="submit">
                    <i class="fa-solid fa-cloud-arrow-up"></i> Update Category
                </button>
            </form>
        </div>
    </div>

</body>
</html>