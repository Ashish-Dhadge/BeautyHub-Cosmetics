import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/InactiveProductServlet")
public class InactiveProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        List<Map<String,String>> products = new ArrayList<>();

        try{
            Connection con = Dbutil.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM products WHERE is_active = 0"
            );
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String,String> p = new HashMap<>();
                p.put("id", rs.getString("product_id"));
                p.put("name", rs.getString("name"));
                p.put("image", rs.getString("image"));
                products.add(p);
            }

            con.close();
            request.setAttribute("products", products);
            request.getRequestDispatcher("inactiveProducts.jsp")
                   .forward(request, response);

        } catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }
}
