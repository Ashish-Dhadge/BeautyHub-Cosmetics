import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/MyOrdersServlet")
public class MyOrdersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if(userId == null){
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String,String>> orders = new ArrayList<>();

        try{
            Connection con = Dbutil.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT order_id, total_amount, payment_method, order_date, status " +
                "FROM orders WHERE user_id=? ORDER BY order_id DESC"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String,String> o = new HashMap<>();
                o.put("order_id", rs.getString("order_id"));
                o.put("total", rs.getString("total_amount"));
                o.put("payment", rs.getString("payment_method"));
                o.put("date", rs.getString("order_date"));
                o.put("status", rs.getString("status"));
                orders.add(o);
            }

            con.close();

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("myOrders.jsp")
               .forward(request, response);
    }
}
