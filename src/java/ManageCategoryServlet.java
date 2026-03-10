package servlets;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;


@WebServlet("/ManageCategoryServlet")
public class ManageCategoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Session Check
        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        // 2. Catch message from the URL (Redirects)
        String msg = request.getParameter("msg");
        request.setAttribute("msg", msg);

        List<Map<String,String>> categories = new ArrayList<>();

        try {
            Connection con = Dbutil.getConnection();

            // Fetching all records (Active and Inactive)
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM category");

            while(rs.next()){
                Map<String,String> c = new HashMap<>();
                c.put("id", rs.getString("category_id"));
                c.put("name", rs.getString("category_name"));
                c.put("status", rs.getString("is_active")); // 1 = Active, 0 = Inactive
                categories.add(c);
            }
            con.close();

            // 3. Forward data and message to JSP
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("manageCategory.jsp").forward(request, response);

        } catch(Exception e) {
            // Forward database errors as well
            request.setAttribute("msg", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("manageCategory.jsp").forward(request, response);
        }
    }
}