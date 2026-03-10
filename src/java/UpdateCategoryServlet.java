package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;


@WebServlet("/UpdateCategoryServlet")
public class UpdateCategoryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin session check
        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String id = request.getParameter("id");
        String name = request.getParameter("category_name");

        try {
            Connection con = Dbutil.getConnection();

            // PRESERVED LOGIC: Update the category name for the specific ID
            // We use a PreparedStatement to prevent SQL Injection
            PreparedStatement ps = con.prepareStatement(
                "UPDATE category SET category_name=? WHERE category_id=?"
            );
            ps.setString(1, name);
            ps.setInt(2, Integer.parseInt(id));
            
            ps.executeUpdate();
            con.close();

            // Success redirect
            response.sendRedirect("ManageCategoryServlet");

        } catch(Exception e) {
            // If something goes wrong, send the error back to the manage page
            request.setAttribute("msg", "Update failed: " + e.getMessage());
            request.getRequestDispatcher("ManageCategoryServlet").forward(request, response);
        }
    }
}