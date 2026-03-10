import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/ViewCartServlet")
public class ViewCartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("loginRequired.jsp");
            return;
        }

        List<Map<String,String>> cart = new ArrayList<>();

        try {
            Connection con = Dbutil.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT c.cart_id, p.name, p.price, p.image, c.quantity " +
                "FROM cart c JOIN products p ON c.product_id = p.product_id " +
                "WHERE c.user_id=?"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String,String> item = new HashMap<>();
                item.put("cart_id", rs.getString("cart_id"));
                item.put("name", rs.getString("name"));
                item.put("price", rs.getString("price"));
                item.put("image", rs.getString("image"));
                item.put("quantity", rs.getString("quantity"));
                cart.add(item);
            }

            con.close();
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e.getMessage());
        }
    }
}
