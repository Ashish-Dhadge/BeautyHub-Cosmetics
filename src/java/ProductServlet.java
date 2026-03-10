import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import servlets.Dbutil;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");


        List<Map<String,String>> products = new ArrayList<>();
        List<Map<String,String>> categories = new ArrayList<>();
        List<Map<String,String>> recommended = new ArrayList<>();

        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String filter = request.getParameter("filter");

        try{
            Connection con = Dbutil.getConnection();

            /* ================= CART COUNT (KEPT - NO CHANGE) ================= */
            int cartCount = 0;
            if(userId != null){
                PreparedStatement cartPs = con.prepareStatement(
                    "SELECT COALESCE(SUM(quantity),0) FROM cart WHERE user_id=?"
                );
                cartPs.setInt(1, userId);
                ResultSet cartRs = cartPs.executeQuery();
                cartRs.next();
                cartCount = cartRs.getInt(1);
            }
            request.setAttribute("cartCount", cartCount);


            /* ================= CATEGORY LIST (KEPT - NO CHANGE) ================= */
            PreparedStatement catPs = con.prepareStatement("SELECT * FROM category");
            ResultSet catRs = catPs.executeQuery();
            while(catRs.next()){
                Map<String,String> c = new HashMap<>();
                c.put("id", catRs.getString("category_id"));
                c.put("name", catRs.getString("category_name"));
                categories.add(c);
            }
            request.setAttribute("categories", categories);

            /* ================= PRODUCT LIST (KEPT - NO CHANGE) ================= */
            String sql = "SELECT * FROM products WHERE is_active=1";
            List<Object> params = new ArrayList<>();

            // ADMIN-LIKE SEARCH LOGIC (STRICTLY PRESERVED)
            if("yes".equals(filter)){
                if(search != null && !search.trim().isEmpty()){
                    sql += " AND name LIKE ?";
                    params.add("%" + search + "%");
                }
                if(category != null && !"all".equals(category)){
                    sql += " AND category_id=?";
                    params.add(Integer.parseInt(category));
                }
            }

            PreparedStatement ps = con.prepareStatement(sql);
            for(int i=0;i<params.size();i++){
                ps.setObject(i+1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Map<String,String> p = new HashMap<>();
                p.put("id", rs.getString("product_id"));
                p.put("name", rs.getString("name"));
                p.put("brand", rs.getString("brand"));
                p.put("price", rs.getString("price"));
                p.put("quantity", rs.getString("quantity"));
                p.put("image", rs.getString("image"));
                products.add(p);
            }

            /* ================= RECOMMENDATIONS (KEPT - NO CHANGE) ================= */
            Integer lastCategoryId = (Integer) request.getSession().getAttribute("lastCategoryId");
            if(lastCategoryId != null){
                PreparedStatement recPs = con.prepareStatement(
                    "SELECT product_id, name, brand, price, quantity, image " +
                    "FROM products WHERE category_id=? AND is_active=1 ORDER BY product_id DESC LIMIT 4"
                );
                recPs.setInt(1, lastCategoryId);
                ResultSet recRs = recPs.executeQuery();
                while(recRs.next()){
                    Map<String,String> r = new HashMap<>();
                    r.put("id", recRs.getString("product_id"));
                    r.put("name", recRs.getString("name"));
                    r.put("brand", recRs.getString("brand"));
                    r.put("price", recRs.getString("price"));
                    r.put("quantity", recRs.getString("quantity"));
                    r.put("image", recRs.getString("image"));
                    recommended.add(r);
                }
            }

            /* ================= FINAL STEP (KEPT - NO CHANGE) ================= */
            request.setAttribute("products", products);
            request.setAttribute("recommendedProducts", recommended);
            con.close();
            request.getRequestDispatcher("userDashboard.jsp").forward(request, response);

        }catch(Exception e){
            // Error handling preserved
            request.setAttribute("msg", e.getMessage());
            request.getRequestDispatcher("userDashboard.jsp").forward(request, response);
        }
    }
}