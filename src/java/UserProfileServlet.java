import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if(userId == null){
            response.sendRedirect("login.jsp");
            return;
        }

        Map<String,String> user = new HashMap<>();

        try{
            Connection con = Dbutil.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT name, email, mobile, address FROM users WHERE user_id=?"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                user.put("name", rs.getString("name"));
                user.put("email", rs.getString("email"));
                user.put("mobile", rs.getString("mobile"));
                user.put("address", rs.getString("address"));
            }

            con.close();

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("userProfile.jsp")
               .forward(request, response);
    }
}
