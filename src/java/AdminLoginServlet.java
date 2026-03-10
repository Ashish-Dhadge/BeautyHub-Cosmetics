import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = Dbutil.getConnection();


            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM admin WHERE username=? AND password=?"
            );
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                HttpSession session = request.getSession();
                session.setAttribute("admin", username);
                response.sendRedirect("AdminDashboardServlet");
            } else {
                request.setAttribute("msg", "Invalid admin credentials");
                request.getRequestDispatcher("adminLogin.jsp")
                       .forward(request, response);
            }

            con.close();

        } catch (Exception e) {
            request.setAttribute("msg", e.getMessage());
            request.getRequestDispatcher("adminLogin.jsp")
                   .forward(request, response);
        }
    }
}
