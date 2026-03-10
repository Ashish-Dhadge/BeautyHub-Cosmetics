import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/CheckoutPageServlet")
public class CheckoutPageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if(userId == null){
            response.sendRedirect("login.jsp");
            return;
        }

        double total = 0;

        try{
            Connection con = Dbutil.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT c.quantity, p.price FROM cart c " +
                "JOIN products p ON c.product_id=p.product_id " +
                "WHERE c.user_id=?"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                total += rs.getInt("quantity") * rs.getDouble("price");
            }

            con.close();

            request.setAttribute("totalAmount", total);
            request.getRequestDispatcher("checkout.jsp")
                   .forward(request, response);

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}
