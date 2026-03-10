import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import servlets.Dbutil;

@WebServlet("/AdminProductDetailsServlet")
public class AdminProductDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("id"));

        try{
            Connection con = Dbutil.getConnection();


            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM products WHERE product_id=?"
            );
            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                request.setAttribute("id", rs.getInt("product_id"));
                request.setAttribute("name", rs.getString("name"));
                request.setAttribute("brand", rs.getString("brand"));
                request.setAttribute("price", rs.getDouble("price"));
                request.setAttribute("quantity", rs.getInt("quantity"));
                request.setAttribute("image", rs.getString("image"));
                request.setAttribute("description", rs.getString("description"));
            } else {
                response.sendRedirect("AdminDashboardServlet");
                return;
            }

            con.close();
            request.getRequestDispatcher("adminProductDetails.jsp")
                   .forward(request, response);

        }catch(Exception e){
            throw new ServletException(e);
        }
    }
}
