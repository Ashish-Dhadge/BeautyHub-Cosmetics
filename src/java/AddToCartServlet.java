import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("loginRequired.jsp");
            return;
        }

        String productId = request.getParameter("product_id");

        try {
            Connection con = Dbutil.getConnection();


            /*  GET PRODUCT CATEGORY FOR RECOMMENDATION */
            PreparedStatement catPs = con.prepareStatement(
                "SELECT category_id FROM products WHERE product_id=?"
            );
            catPs.setInt(1, Integer.parseInt(productId));
            ResultSet catRs = catPs.executeQuery();

            if(catRs.next()){
                request.getSession().setAttribute(
                    "lastCategoryId",
                    catRs.getInt("category_id")
                );
            }

            /*  ADD / UPDATE CART */
            PreparedStatement check = con.prepareStatement(
                "SELECT quantity FROM cart WHERE user_id=? AND product_id=?"
            );
            check.setInt(1, userId);
            check.setInt(2, Integer.parseInt(productId));
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                PreparedStatement update = con.prepareStatement(
                    "UPDATE cart SET quantity = quantity + 1 WHERE user_id=? AND product_id=?"
                );
                update.setInt(1, userId);
                update.setInt(2, Integer.parseInt(productId));
                update.executeUpdate();
            } else {
                PreparedStatement insert = con.prepareStatement(
                    "INSERT INTO cart(user_id, product_id, quantity) VALUES(?,?,1)"
                );
                insert.setInt(1, userId);
                insert.setInt(2, Integer.parseInt(productId));
                insert.executeUpdate();
            }

            con.close();

            response.sendRedirect("ProductServlet");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
