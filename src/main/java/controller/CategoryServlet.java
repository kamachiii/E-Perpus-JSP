package controller;

import dao.CategoryDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/admin/categories"})
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login");
            return;
        }

        String action = request.getParameter("action");
        CategoryDAO dao = new CategoryDAO();

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteCategory(id);
            response.sendRedirect("categories");
            return;
        }

        List<Map<String, Object>> data = dao.getAllCategoriesWithCount();
        request.setAttribute("categoryList", data);
        request.getRequestDispatcher("categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login");
            return;
        }

        String action = request.getParameter("action");
        String name = request.getParameter("name");
        CategoryDAO dao = new CategoryDAO();

        if ("add".equals(action)) {
            dao.addCategory(name);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.updateCategory(id, name);
        }
        
        response.sendRedirect("categories");
    }
}