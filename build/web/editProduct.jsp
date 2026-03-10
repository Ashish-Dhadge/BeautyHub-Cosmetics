<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("admin")==null){
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Map<String,String>> categories =
        (List<Map<String,String>>)request.getAttribute("categories");

    int selectedCategory =
        (Integer)request.getAttribute("category_id");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
    <style>
        body{ font-family: Arial; background:#f5f5f5; }
        .box{
            width:450px;
            margin:40px auto;
            background:white;
            padding:25px;
            border-radius:10px;
            box-shadow:0 0 10px #ccc;
        }
        input, textarea, select{
            width:100%;
            padding:8px;
            margin:8px 0;
        }
        button{
            width:100%;
            padding:10px;
            background:#1976d2;
            color:white;
            border:none;
            border-radius:5px;
            cursor:pointer;
        }
        img{
            width:120px;
            display:block;
            margin:10px auto;
        }
        .msg{
            color:red;
            text-align:center;
            font-weight:bold;
            margin-bottom:10px;
        }
    </style>
</head>
<body>

<div class="box">
<h2>Edit Product</h2>

<!-- ? MESSAGE DISPLAY (ONLY ADDITION) -->
<%
    String msg = (String) request.getAttribute("msg");
    if(msg != null){
%>
    <div class="msg"><%= msg %></div>
<%
    }
%>

<form action="EditProductServlet" method="post" enctype="multipart/form-data">

    <input type="hidden" name="product_id"
           value="<%= request.getAttribute("product_id") %>">

    <input type="hidden" name="oldImage"
           value="<%= request.getAttribute("image") %>">

    <input type="text" name="name"
           value="<%= request.getAttribute("name") %>" required>

    <input type="text" name="brand"
           value="<%= request.getAttribute("brand") %>" required>

    <input type="number" name="price"
           value="<%= request.getAttribute("price") %>" required>

    <input type="number" name="quantity"
           value="<%= request.getAttribute("quantity") %>" required>

    <select name="category_id" required>
        <%
            for(Map<String,String> c : categories){
                int cid = Integer.parseInt(c.get("id"));
        %>
        <option value="<%= cid %>"
            <%= (cid == selectedCategory ? "selected" : "") %>>
            <%= c.get("name") %>
        </option>
        <%
            }
        %>
    </select>

    <textarea name="description"><%= request.getAttribute("description") %></textarea>

    <p>Current Image:</p>
    <img src="image?name=<%= request.getAttribute("image") %>">

    <input type="file" name="image">

    <button type="submit">Update Product</button>
</form>

</div>

</body>
</html>
