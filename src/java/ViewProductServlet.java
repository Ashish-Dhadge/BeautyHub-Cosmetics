package servlets;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;


@WebServlet("/ViewProductServlet")
public class ViewProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        List<Map<String,String>> products = new ArrayList<>();
        List<String> categoryList = new ArrayList<>();

        try {
            Connection con = Dbutil.getConnection();

            // 1. Fetch Categories for the dropdown filter
            Statement stCat = con.createStatement();
            ResultSet rsCat = stCat.executeQuery("SELECT category_name FROM category WHERE is_active = 1");
            while(rsCat.next()){
                categoryList.add(rsCat.getString("category_name"));
            }

            // 2. Fetch All Products with Category Names
            String sql = "SELECT p.*, c.category_name FROM products p " +
                         "LEFT JOIN category c ON p.category_id = c.category_id";
            
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while(rs.next()){
                Map<String,String> p = new HashMap<>();
                p.put("id", rs.getString("product_id"));
                p.put("name", rs.getString("name"));
                p.put("brand", rs.getString("brand"));
                p.put("price", rs.getString("price"));
                p.put("quantity", rs.getString("quantity"));
                p.put("image", rs.getString("image"));
                p.put("category", rs.getString("category_name"));
                p.put("active", rs.getString("is_active"));
                products.add(p);
            }
            con.close();

            request.setAttribute("products", products);
            request.setAttribute("categoryList", categoryList);
            request.getRequestDispatcher("viewProducts.jsp").forward(request, response);

        } catch(Exception e) {
            throw new ServletException(e);
        }
    }
}