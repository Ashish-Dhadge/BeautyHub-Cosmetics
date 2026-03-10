package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;


@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if(userId == null){
            response.sendRedirect("login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("order_id"));
        Connection con = null;

        try{
            con = Dbutil.getConnection();
            con.setAutoCommit(false);

            /* VERIFY ORDER */
            PreparedStatement checkPs = con.prepareStatement(
                "SELECT status FROM orders WHERE order_id=? AND user_id=?"
            );
            checkPs.setInt(1, orderId);
            checkPs.setInt(2, userId);

            ResultSet crs = checkPs.executeQuery();
            if(!crs.next()){
                response.sendRedirect("MyOrdersServlet");
                return;
            }

            String status = crs.getString("status");

            if("DELIVERED".equals(status)){
                response.sendRedirect("MyOrdersServlet");
                return;
            }

            /* RESTORE PRODUCT STOCK */
            PreparedStatement itemPs = con.prepareStatement(
                "SELECT product_id, quantity FROM order_items WHERE order_id=?"
            );
            itemPs.setInt(1, orderId);

            ResultSet irs = itemPs.executeQuery();
            while(irs.next()){
                int productId = irs.getInt("product_id");
                int qty = irs.getInt("quantity");

                PreparedStatement restorePs = con.prepareStatement(
                    "UPDATE products SET quantity = quantity + ? WHERE product_id=?"
                );
                restorePs.setInt(1, qty);
                restorePs.setInt(2, productId);
                restorePs.executeUpdate();
            }

            /* UPDATE ORDER STATUS */
            PreparedStatement updatePs = con.prepareStatement(
                "UPDATE orders SET status='CANCELLED' WHERE order_id=?"
            );
            updatePs.setInt(1, orderId);
            updatePs.executeUpdate();

            con.commit();
            response.sendRedirect("MyOrdersServlet");

        } catch(Exception e){
            try{ if(con!=null) con.rollback(); }catch(Exception ex){}
            throw new ServletException(e);
        } finally {
            try{ if(con!=null) con.close(); }catch(Exception ex){}
        }
    }
}
