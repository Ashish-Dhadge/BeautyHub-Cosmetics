import java.io.*;
import java.sql.*;
import java.net.URLEncoder;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/DeleteCategoryServlet")
public class DeleteCategoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if(session.getAttribute("admin") == null){
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String id = request.getParameter("id");
        Connection con = null;

        try {
            con = Dbutil.getConnection();

            // ✅ THE LOGIC: Check for ACTIVE products only.
            // If a product is is_active=0, we ignore it.
            String checkSQL = "SELECT COUNT(*) FROM products WHERE category_id = ? AND is_active = 1";
            PreparedStatement checkPs = con.prepareStatement(checkSQL);
            checkPs.setInt(1, Integer.parseInt(id));
            ResultSet rs = checkPs.executeQuery();
            
            int activeProductCount = 0;
            if(rs.next()) {
                activeProductCount = rs.getInt(1);
            }

            if (activeProductCount > 0) {
                // Block deletion because there are still live products visible to users
                String alertMsg = "Cannot disable. Category still contains " + activeProductCount + " ACTIVE products.";
                response.sendRedirect("ManageCategoryServlet?msg=" + URLEncoder.encode(alertMsg, "UTF-8"));
            } else {
                // SUCCESS: Either no products exist, or all existing products are already "Soft Deleted"
                String updateSQL = "UPDATE category SET is_active = 0 WHERE category_id = ?";
                PreparedStatement ps = con.prepareStatement(updateSQL);
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
                
                response.sendRedirect("ManageCategoryServlet");
            }

        } catch(Exception e) {
            response.sendRedirect("ManageCategoryServlet?msg=" + URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
        } finally {
            try { if(con != null) con.close(); } catch(SQLException se) { se.printStackTrace(); }
        }
    }
}