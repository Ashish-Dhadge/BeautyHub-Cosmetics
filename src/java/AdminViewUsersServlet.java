import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/AdminViewUsersServlet")
public class AdminViewUsersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        List<Map<String,String>> users = new ArrayList<>();

        try{
            Connection con = Dbutil.getConnection();

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT user_id, name, email, mobile FROM users"
            );

            while(rs.next()){
                Map<String,String> u = new HashMap<>();
                u.put("id", rs.getString("user_id"));
                u.put("name", rs.getString("name"));
                u.put("email", rs.getString("email"));
                u.put("mobile", rs.getString("mobile"));
                users.add(u);
            }

            con.close();

            request.setAttribute("users", users);
            request.getRequestDispatcher("adminViewUsers.jsp")
                   .forward(request, response);

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}
    