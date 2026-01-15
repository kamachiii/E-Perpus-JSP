package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth", "/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            if ("/login".equals(path) || "/register".equals(path)) {
                User user = (User) session.getAttribute("currentUser");
                if ("admin".equals(user.getRole())) {
                    response.sendRedirect("admin/dashboard");
                } else {
                    response.sendRedirect("dashboard");
                }
                return;
            }
        }

        switch (path) {
            case "/login":
                request.getRequestDispatcher("login.jsp").forward(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("register.jsp").forward(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect("login");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("login".equals(action)) {
            User user = userDAO.login(request.getParameter("username"), request.getParameter("password"));
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                
                // Redirect ke URL Servlet (Bukan JSP)
                if ("admin".equals(user.getRole())) {
                    response.sendRedirect("admin/dashboard"); 
                } else {
                    response.sendRedirect("dashboard");
                }
            } else {
                response.sendRedirect("login?error=invalid");
            }
        } else if ("register".equals(action)) {
            User newUser = new User();
            newUser.setFullName(request.getParameter("fullname"));
            newUser.setEmail(request.getParameter("email"));
            newUser.setUsername(request.getParameter("username"));
            newUser.setPassword(request.getParameter("password"));
            newUser.setRole("member");

            if(userDAO.register(newUser)) {
                response.sendRedirect("login?msg=registered");
            } else {
                response.sendRedirect("register?error=failed");
            }
        } else if ("updateProfile".equals(action)) {
             // ... (kode update profile sama, pastikan redirectnya ke 'profile') ...
             // response.sendRedirect("profile?msg=updated");
        }
        // ... dst
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect("login"); // URL Bersih
    }
}