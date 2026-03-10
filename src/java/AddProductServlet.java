package servlets;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.nio.file.*;

@WebServlet("/AddProductServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,   // 1MB
    maxFileSize = 1024 * 1024 * 10,        // 10MB
    maxRequestSize = 1024 * 1024 * 50      // 50MB
)
public class AddProductServlet extends HttpServlet {

    /* ===================== LOAD ADD PRODUCT PAGE ===================== */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        List<Map<String, String>> categories = new ArrayList<>();

        try (Connection con = Dbutil.getConnection()) {

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT category_id, category_name FROM category WHERE is_active = 1"
            );

            while (rs.next()) {
                Map<String, String> c = new HashMap<>();
                c.put("id", rs.getString("category_id"));
                c.put("name", rs.getString("category_name"));
                categories.add(c);
            }

            request.setAttribute("categories", categories);
            request.getRequestDispatcher("addProduct.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /* ===================== SAVE PRODUCT ===================== */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        Connection con = null;

        try {
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int categoryId = Integer.parseInt(request.getParameter("category_id"));
            String description = request.getParameter("description");

            con = Dbutil.getConnection();

            PreparedStatement checkCat = con.prepareStatement(
                "SELECT is_active FROM category WHERE category_id = ?"
            );
            checkCat.setInt(1, categoryId);
            ResultSet crs = checkCat.executeQuery();

            if (crs.next() && crs.getInt("is_active") == 0) {
                request.setAttribute("msg", "Selected category is inactive.");
                request.getRequestDispatcher("addProduct.jsp").forward(request, response);
                return;
            }

            /* ================= IMAGE UPLOAD ================= */
            String uploadPath = getServletContext().getRealPath("/images/products");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            Part imagePart = request.getPart("image");
            String originalFileName = Paths.get(imagePart.getSubmittedFileName())
                                           .getFileName().toString();

            String imageName = System.currentTimeMillis() + "_" + originalFileName;
            imagePart.write(uploadPath + File.separator + imageName);

            /* ================= DB INSERT ================= */
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO products (name, brand, price, quantity, category_id, image, description) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)"
            );

            ps.setString(1, name);
            ps.setString(2, brand);
            ps.setDouble(3, price);
            ps.setInt(4, quantity);
            ps.setInt(5, categoryId);
            ps.setString(6, imageName);
            ps.setString(7, description);

            ps.executeUpdate();

            response.sendRedirect("ViewProductServlet");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", e.getMessage());
            request.getRequestDispatcher("addProduct.jsp").forward(request, response);
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
