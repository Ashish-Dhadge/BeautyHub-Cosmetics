import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/RemoveCartItemServlet")
public class RemoveCartItemServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String cartId = request.getParameter("id");

        try {
            Connection con = Dbutil.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM cart WHERE cart_id=? AND user_id=?"
            );
            ps.setString(1, cartId);
            ps.setInt(2, userId);
            ps.executeUpdate();

            con.close();
            response.sendRedirect("ViewCartServlet");

        } catch (Exception e) {
            throw new ServletException(e.getMessage());
        }
    }
}
