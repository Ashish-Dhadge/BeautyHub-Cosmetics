import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin session check
        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String id = request.getParameter("id");

        try {
            Connection con = Dbutil.getConnection();

            /* ✅ SOFT DELETE: mark product inactive */
            PreparedStatement ps = con.prepareStatement(
                "UPDATE products SET is_active = 0 WHERE product_id=?"
            );
            ps.setString(1, id);
            ps.executeUpdate();

            con.close();

            response.sendRedirect("ViewProductServlet");

        } catch (Exception e) {
            request.setAttribute("msg", e.getMessage());
            request.getRequestDispatcher("ViewProductServlet")
                   .forward(request, response);
        }
    }
}
