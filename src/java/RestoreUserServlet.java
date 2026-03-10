import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/RestoreUserServlet")
public class RestoreUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin")==null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String id = request.getParameter("id");

        try{
            Connection con = Dbutil.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET is_active=1 WHERE user_id=?"
            );
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            con.close();
            response.sendRedirect("ManageUsersServlet");

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}
