package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UserServlet", urlPatterns = {"/admin/users"})
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect("../login");
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            // Mencegah admin menghapus dirinya sendiri (opsional logic)
            if (id != currentUser.getId()) {
                dao.deleteUser(id);
            }
            response.sendRedirect("users"); // Refresh halaman
            return;
        }

        List<User> userList = dao.getAllMembers();
        request.setAttribute("userList", userList);
        
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
}