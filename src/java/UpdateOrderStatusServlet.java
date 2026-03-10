import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin")==null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String orderId = request.getParameter("order_id");
        String status = request.getParameter("status");
        String email = request.getParameter("email");

        try{
            Connection con = Dbutil.getConnection();

            /* 🔒 CHECK CURRENT STATUS FIRST */
            PreparedStatement checkPs = con.prepareStatement(
                "SELECT status FROM orders WHERE order_id=?"
            );
            checkPs.setInt(1, Integer.parseInt(orderId));
            ResultSet checkRs = checkPs.executeQuery();

            if(checkRs.next()){
                String currentStatus = checkRs.getString("status");

                // Block if already Delivered or Cancelled
                if("DELIVERED".equals(currentStatus) || 
                   "CANCELLED".equals(currentStatus)){
                    con.close();
                    response.sendRedirect("AdminViewOrdersServlet");
                    return;
                }
            }

            /* ✅ UPDATE STATUS */
            PreparedStatement ps = con.prepareStatement(
                "UPDATE orders SET status=? WHERE order_id=?"
            );
            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(orderId));
            ps.executeUpdate();

            con.close();

            /* SEND EMAIL ONLY WHEN DELIVERED */
            if("DELIVERED".equals(status)){

                Connection con2 = Dbutil.getConnection();

                PreparedStatement ps2 = con2.prepareStatement(
                    "SELECT p.name, oi.quantity, oi.price " +
                    "FROM order_items oi " +
                    "JOIN products p ON oi.product_id = p.product_id " +
                    "WHERE oi.order_id = ?"
                );

                ps2.setInt(1, Integer.parseInt(orderId));
                ResultSet rs = ps2.executeQuery();

                StringBuilder productDetails = new StringBuilder();
                double totalAmount = 0;

                while(rs.next()){
                    String productName = rs.getString("name");
                    int qty = rs.getInt("quantity");
                    double price = rs.getDouble("price");

                    totalAmount += (price * qty);

                    productDetails.append("Product Name : ").append(productName).append("\n")
                                  .append("Quantity     : ").append(qty).append("\n")
                                  .append("Price        :  ").append(price).append("\n")
                                  .append("-----------------------------------\n");
                }

                con2.close();

                String message =
                        "Dear Customer,\n\n" +
                        "We are pleased to inform you that your order has been successfully delivered.\n\n" +
                        "Order ID : " + orderId + "\n\n" +
                        "Product Details:\n" +
                        "-----------------------------------\n" +
                        productDetails.toString() +
                        "\nTotal Amount : ₹ " + totalAmount + "\n\n" +
                        "We hope you enjoy your purchase and look forward to serving you again.\n" +
                        "Thank you for shopping with Beauty Hub Cosmetics.\n\n" +
                        "Warm Regards,\n" +
                        "Beauty Hub Cosmetics Team\n" +
                        "Customer Support: support@beautyhub.com";

                EmailUtil.sendSimpleMail(
                        email,
                        "Order Delivered Successfully - Beauty Hub Cosmetics",
                        message
                );
            }

            response.sendRedirect("AdminViewOrdersServlet");

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}