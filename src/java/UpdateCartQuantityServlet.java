import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/UpdateCartQuantityServlet")
public class UpdateCartQuantityServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cartId = request.getParameter("cart_id");
        String action = request.getParameter("action");

        try {
            Connection con = Dbutil.getConnection();

            if ("increase".equals(action)) {

                PreparedStatement ps = con.prepareStatement(
                    "UPDATE cart SET quantity = quantity + 1 WHERE cart_id=?"
                );
                ps.setInt(1, Integer.parseInt(cartId));
                ps.executeUpdate();

            } else if ("decrease".equals(action)) {

                PreparedStatement check = con.prepareStatement(
                    "SELECT quantity FROM cart WHERE cart_id=?"
                );
                check.setInt(1, Integer.parseInt(cartId));
                ResultSet rs = check.executeQuery();

                if (rs.next()) {
                    int qty = rs.getInt("quantity");

                    if (qty > 1) {
                        PreparedStatement ps = con.prepareStatement(
                            "UPDATE cart SET quantity = quantity - 1 WHERE cart_id=?"
                        );
                        ps.setInt(1, Integer.parseInt(cartId));
                        ps.executeUpdate();
                    } else {
                        PreparedStatement delete = con.prepareStatement(
                            "DELETE FROM cart WHERE cart_id=?"
                        );
                        delete.setInt(1, Integer.parseInt(cartId));
                        delete.executeUpdate();
                    }
                }
            }

            con.close();

            response.sendRedirect("ViewCartServlet");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}