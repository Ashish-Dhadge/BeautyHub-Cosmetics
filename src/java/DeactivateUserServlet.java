import java.io.*;
import java.sql.*;
import java.net.URLEncoder;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/DeactivateUserServlet")
public class DeactivateUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin")==null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String userId = request.getParameter("id");

        try{
            Connection con = Dbutil.getConnection();

            // 🔒 CHECK PENDING ORDERS
            PreparedStatement check = con.prepareStatement(
                "SELECT COUNT(*) FROM orders WHERE user_id=? AND status IN ('PLACED','SHIPPED')"
            );
            check.setInt(1, Integer.parseInt(userId));
            ResultSet rs = check.executeQuery();
            rs.next();

            if(rs.getInt(1) > 0){
                con.close();
                response.sendRedirect(
                    "ManageUsersServlet?msg=" +
                    URLEncoder.encode("Cannot deactivate user. Pending orders exist.", "UTF-8")
                );
                return;
            }

            // ✅ SAFE TO DEACTIVATE
            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET is_active=0 WHERE user_id=?"
            );
            ps.setInt(1, Integer.parseInt(userId));
            ps.executeUpdate();

            con.close();
            response.sendRedirect("ManageUsersServlet");

        }catch(Exception e){
            response.sendRedirect(
                "ManageUsersServlet?msg=" +
                URLEncoder.encode("Error: "+e.getMessage(),"UTF-8")
            );
        }
    }
}
