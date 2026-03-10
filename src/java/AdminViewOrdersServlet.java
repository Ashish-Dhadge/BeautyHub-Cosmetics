import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/AdminViewOrdersServlet")
public class AdminViewOrdersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin")==null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        List<Map<String,String>> orders = new ArrayList<>();

        try{
            Connection con = Dbutil.getConnection();

            String sql =
                "SELECT o.order_id, o.total_amount, o.payment_method, o.status, u.email " +
                "FROM orders o JOIN users u ON o.user_id=u.user_id " +
                "ORDER BY o.order_id DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String,String> o = new HashMap<>();
                o.put("order_id", rs.getString("order_id"));
                o.put("email", rs.getString("email"));
                o.put("total", rs.getString("total_amount"));
                o.put("payment", rs.getString("payment_method"));
                o.put("status", rs.getString("status"));
                orders.add(o);
            }

            con.close();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("adminViewOrders.jsp")
                   .forward(request, response);

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}