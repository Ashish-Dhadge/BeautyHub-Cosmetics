package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;


@WebServlet("/RestoreCategoryServlet")
public class RestoreCategoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String id = request.getParameter("id");

        try {
            Connection con = Dbutil.getConnection();

            // Logic: Set status back to 1 (Active)
            PreparedStatement ps = con.prepareStatement("UPDATE category SET is_active = 1 WHERE category_id=?");
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            con.close();
            response.sendRedirect("ManageCategoryServlet");

        } catch(Exception e) {
            throw new ServletException(e.getMessage());
        }
    }
}