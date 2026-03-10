package RegisterServlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String mobile = request.getParameter("mobile");
        String address = request.getParameter("address");

        try {
            Connection con = Dbutil.getConnection();


            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,password,mobile,address) VALUES(?,?,?,?,?)"
            );

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, mobile);
            ps.setString(5, address);

            ps.executeUpdate();
            con.close();

            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace(); // console
            request.setAttribute("msg", "Error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
}

    }
}
