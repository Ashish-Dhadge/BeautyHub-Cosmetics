import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String paymentMethod = request.getParameter("payment");
        Connection con = null;

        try {
            con = Dbutil.getConnection();
            con.setAutoCommit(false);

            /* ===================== CALCULATE TOTAL ===================== */
            PreparedStatement totalPs = con.prepareStatement(
                "SELECT c.quantity, p.price " +
                "FROM cart c JOIN products p ON c.product_id = p.product_id " +
                "WHERE c.user_id = ?"
            );
            totalPs.setInt(1, userId);
            ResultSet totalRs = totalPs.executeQuery();

            double total = 0;
            while (totalRs.next()) {
                total += totalRs.getInt("quantity") * totalRs.getDouble("price");
            }

            if (total == 0) {
                response.sendRedirect("ViewCartServlet");
                return;
            }

            /* =====================  INSERT ORDER ===================== */
            PreparedStatement orderPs = con.prepareStatement(
                "INSERT INTO orders(user_id, total_amount, payment_method) VALUES (?,?,?)",
                Statement.RETURN_GENERATED_KEYS
            );
            orderPs.setInt(1, userId);
            orderPs.setDouble(2, total);
            orderPs.setString(3, paymentMethod);
            orderPs.executeUpdate();

            ResultSet keyRs = orderPs.getGeneratedKeys();
            keyRs.next();
            int orderId = keyRs.getInt(1);

            /* ===================== FETCH CART & PROCESS ITEMS ===================== */
            PreparedStatement cartPs = con.prepareStatement(
                "SELECT c.product_id, c.quantity, p.price, p.name " +
                "FROM cart c JOIN products p ON c.product_id = p.product_id " +
                "WHERE c.user_id = ?"
            );
            cartPs.setInt(1, userId);
            ResultSet rs = cartPs.executeQuery();

            StringBuilder productDetails = new StringBuilder();

            while (rs.next()) {
                int productId = rs.getInt("product_id");
                int qty = rs.getInt("quantity");
                double price = rs.getDouble("price");
                String productName = rs.getString("name");

                // Build email product details
                productDetails.append("Product: ").append(productName)
                              .append("\nQuantity: ").append(qty)
                              .append("\nPrice:  ").append(price)
                              .append("\n\n");

                // Insert order items
                PreparedStatement itemPs = con.prepareStatement(
                    "INSERT INTO order_items(order_id, product_id, quantity, price) VALUES (?,?,?,?)"
                );
                itemPs.setInt(1, orderId);
                itemPs.setInt(2, productId);
                itemPs.setInt(3, qty);
                itemPs.setDouble(4, price);
                itemPs.executeUpdate();

                // Update stock
                PreparedStatement stockPs = con.prepareStatement(
                    "UPDATE products SET quantity = quantity - ? WHERE product_id = ?"
                );
                stockPs.setInt(1, qty);
                stockPs.setInt(2, productId);
                stockPs.executeUpdate();
            }

            /* ===================== CLEAR CART ===================== */
            PreparedStatement clearPs = con.prepareStatement(
                "DELETE FROM cart WHERE user_id = ?"
            );
            clearPs.setInt(1, userId);
            clearPs.executeUpdate();

            con.commit();

            /* ===================== FETCH USER EMAIL ===================== */
            PreparedStatement userPs = con.prepareStatement(
                "SELECT email FROM users WHERE user_id = ?"
            );
            userPs.setInt(1, userId);
            ResultSet userRs = userPs.executeQuery();

            String userEmail = null;
            if (userRs.next()) {
                userEmail = userRs.getString("email");
            }

            /* ===================== SEND EMAIL ===================== */
            if (userEmail != null) {
                EmailUtil.sendOrderEmail(
                    userEmail,
                    orderId,
                    total,
                    productDetails.toString()
                );
            }

            /* ===================== SUCCESS PAGE ===================== */
            request.setAttribute("orderId", orderId);
            request.setAttribute("totalAmount", total);
            request.setAttribute("paymentMethod", paymentMethod);
            request.setAttribute("productDetails", productDetails.toString());

            request.getRequestDispatcher("orderSuccess.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            throw new ServletException(e.getMessage());
        }
    }
}
