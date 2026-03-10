import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if(userId == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String address = request.getParameter("address");

        try{
            Connection con = Dbutil.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET name=?, mobile=?, address=? WHERE user_id=?"
            );
            ps.setString(1, name);
            ps.setString(2, mobile);
            ps.setString(3, address);
            ps.setInt(4, userId);
            ps.executeUpdate();

            con.close();

            // update session name for navbar
            request.getSession().setAttribute("user_name", name);

            response.sendRedirect("UserProfileServlet");

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}
