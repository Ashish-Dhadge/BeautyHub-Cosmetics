package servlets;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;


@WebServlet("/AddCategoryServlet")
public class AddCategoryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String categoryName = request.getParameter("category_name");

        try {
            Connection con = Dbutil.getConnection();


            // Check if name already exists to prevent duplicates
            PreparedStatement checkPs = con.prepareStatement("SELECT COUNT(*) FROM category WHERE category_name=?");
            checkPs.setString(1, categoryName);
            ResultSet rs = checkPs.executeQuery();
            rs.next();

            if(rs.getInt(1) == 0){
                PreparedStatement ps = con.prepareStatement("INSERT INTO category(category_name, is_active) VALUES(?, 1)");
                ps.setString(1, categoryName);
                ps.executeUpdate();
            }

            con.close();
            response.sendRedirect("ManageCategoryServlet");

        } catch(Exception e) {
            throw new ServletException(e.getMessage());
        }
    }
}