import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/RecommendationServlet")
public class RecommendationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if(userId == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String productId = request.getParameter("product_id");

        try{
            Connection con = Dbutil.getConnection();

            //  Get category of clicked product
            PreparedStatement ps = con.prepareStatement(
                "SELECT category_id FROM products WHERE product_id=?"
            );
            ps.setString(1, productId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                int categoryId = rs.getInt("category_id");

                //  Store category in session
                request.getSession().setAttribute("lastCategoryId", categoryId);
            }

            con.close();

            //  Redirect BACK to ProductServlet 
            response.sendRedirect("ProductServlet");

        }catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}
