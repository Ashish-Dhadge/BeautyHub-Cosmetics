package servlets;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.nio.file.*;
import servlets.Dbutil;

@WebServlet("/EditProductServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class EditProductServlet extends HttpServlet {

    /* ================= LOAD EDIT PAGE ================= */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String id = request.getParameter("id");

        try (Connection con = Dbutil.getConnection()) {

            /* ===== PRODUCT ===== */
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM products WHERE product_id=?"
            );
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("product_id", rs.getInt("product_id"));
                request.setAttribute("name", rs.getString("name"));
                request.setAttribute("brand", rs.getString("brand"));
                request.setAttribute("price", rs.getDouble("price"));
                request.setAttribute("quantity", rs.getInt("quantity"));
                request.setAttribute("category_id", rs.getInt("category_id"));
                request.setAttribute("description", rs.getString("description"));
                request.setAttribute("image", rs.getString("image"));
            }

            /* ===== ACTIVE CATEGORIES ONLY ===== */
            List<Map<String, String>> categories = new ArrayList<>();
            Statement st = con.createStatement();
            ResultSet crs = st.executeQuery(
                "SELECT * FROM category WHERE is_active = 1"
            );

            while (crs.next()) {
                Map<String, String> c = new HashMap<>();
                c.put("id", crs.getString("category_id"));
                c.put("name", crs.getString("category_name"));
                categories.add(c);
            }

            request.setAttribute("categories", categories);
            request.getRequestDispatcher("editProduct.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /* ================= UPDATE PRODUCT ================= */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        try (Connection con = Dbutil.getConnection()) {

            int id = Integer.parseInt(request.getParameter("product_id"));
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int categoryId = Integer.parseInt(request.getParameter("category_id"));
            String description = request.getParameter("description");
            String oldImage = request.getParameter("oldImage");

            String finalImage = oldImage;

            /* ===== IMAGE UPLOAD ===== */
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {

                String uploadPath = getServletContext()
                        .getRealPath("/images/products");

                File dir = new File(uploadPath);
                if (!dir.exists()) dir.mkdirs();

                // ✅ delete old image if exists
                if (oldImage != null && !oldImage.isEmpty()) {
                    File oldFile = new File(uploadPath + File.separator + oldImage);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }

                String newImage = System.currentTimeMillis() + "_" +
                        Paths.get(imagePart.getSubmittedFileName())
                             .getFileName().toString();

                imagePart.write(uploadPath + File.separator + newImage);
                finalImage = newImage;
            }

            /* ===== CATEGORY STATUS CHECK ===== */
            PreparedStatement checkCat = con.prepareStatement(
                "SELECT is_active FROM category WHERE category_id=?"
            );
            checkCat.setInt(1, categoryId);
            ResultSet crs = checkCat.executeQuery();

            if (crs.next() && crs.getInt("is_active") == 0) {

                request.setAttribute("msg",
                        "Selected category is inactive. Please choose an active category.");

                List<Map<String, String>> categories = new ArrayList<>();
                Statement st = con.createStatement();
                ResultSet rs2 = st.executeQuery(
                    "SELECT * FROM category WHERE is_active=1"
                );

                while (rs2.next()) {
                    Map<String, String> c = new HashMap<>();
                    c.put("id", rs2.getString("category_id"));
                    c.put("name", rs2.getString("category_name"));
                    categories.add(c);
                }

                request.setAttribute("categories", categories);
                request.getRequestDispatcher("editProduct.jsp")
                       .forward(request, response);
                return;
            }

            /* ===== UPDATE PRODUCT ===== */
            PreparedStatement ps = con.prepareStatement(
                "UPDATE products SET name=?, brand=?, price=?, quantity=?, " +
                "category_id=?, image=?, description=? WHERE product_id=?"
            );

            ps.setString(1, name);
            ps.setString(2, brand);
            ps.setDouble(3, price);
            ps.setInt(4, quantity);
            ps.setInt(5, categoryId);
            ps.setString(6, finalImage);
            ps.setString(7, description);
            ps.setInt(8, id);

            ps.executeUpdate();

            response.sendRedirect("ViewProductServlet");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
