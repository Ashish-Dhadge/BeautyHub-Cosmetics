import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/ProductDetailsServlet")
public class ProductDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        

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
            }

            con.close();
            request.getRequestDispatcher("productDetails.jsp")
                   .forward(request, response);

        }catch(Exception e){
            throw new ServletException(e);
        }
    }
}
