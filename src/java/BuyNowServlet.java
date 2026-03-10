import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/BuyNowServlet")
public class BuyNowServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("loginRequired.jsp");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("product_id"));

        try {
            Connection con = Dbutil.getConnection();

            //  CLEAR CART
            PreparedStatement clear = con.prepareStatement(
                "DELETE FROM cart WHERE user_id=?"
            );
            clear.setInt(1, userId);
            clear.executeUpdate();

            //  ADD PRODUCT
            PreparedStatement insert = con.prepareStatement(
                "INSERT INTO cart(user_id, product_id, quantity) VALUES(?,?,1)"
            );
            insert.setInt(1, userId);
            insert.setInt(2, productId);
            insert.executeUpdate();

            con.close();

            //  GO DIRECTLY TO CHECKOUT
            response.sendRedirect("CheckoutPageServlet");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
