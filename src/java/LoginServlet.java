import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
           Connection con = Dbutil.getConnection();

            PreparedStatement checkUser = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
            );
            checkUser.setString(1, email);
            checkUser.setString(2, password);

            ResultSet rs = checkUser.executeQuery();

            if(rs.next()){

                if(rs.getInt("is_active") == 0){
                    request.setAttribute(
                        "msg",
                        "Your account has been deactivated. Please contact support."
                    );
                    request.getRequestDispatcher("login.jsp")
                           .forward(request, response);
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("user_name", rs.getString("name"));

                response.sendRedirect("ProductServlet");

            } else {
                request.setAttribute("msg", "Invalid email or password");
                request.getRequestDispatcher("login.jsp")
                       .forward(request, response);
            }

            con.close();

        } catch (Exception e) {
            request.setAttribute("msg", e.getMessage());
            request.getRequestDispatcher("login.jsp")
                   .forward(request, response);
        }
    }
}
