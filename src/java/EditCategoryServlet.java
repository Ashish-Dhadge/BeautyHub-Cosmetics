import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/EditCategoryServlet")
public class EditCategoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String id = request.getParameter("id");

        try{
            Connection con = Dbutil.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM category WHERE category_id=?"
            );
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                request.setAttribute("id", rs.getInt("category_id"));
                request.setAttribute("name", rs.getString("category_name"));
            }

            con.close();

            request.getRequestDispatcher("editCategory.jsp")
                   .forward(request, response);

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}
