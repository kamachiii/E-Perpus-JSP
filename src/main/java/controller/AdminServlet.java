/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.BookDAO;
import dao.CategoryDAO;
import dao.LoanDAO;
import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminServlet", urlPatterns = {
    "/admin/dashboard", 
    "/admin/books", 
    "/admin/loans"
})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/admin/dashboard": {
                dao.UserDAO userDAO = new dao.UserDAO();
                dao.BookDAO bookDAO = new dao.BookDAO();
                dao.LoanDAO loanDAO = new dao.LoanDAO();
                
                int totalMembers = userDAO.countMembers();
                int totalBooks = bookDAO.countBooks();
                int activeLoans = loanDAO.countActiveLoans();
                
                request.setAttribute("totalMembers", totalMembers);
                request.setAttribute("totalBooks", totalBooks);
                request.setAttribute("activeLoans", activeLoans);
                
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                break;
            }

            case "/admin/books": {
                BookDAO bookDAO = new BookDAO();
                request.setAttribute("listBooks", bookDAO.getAllBooks());
                request.getRequestDispatcher("/admin/books.jsp").forward(request, response);
                break;
            }
            
            case "/admin/categories": {
                CategoryDAO catDAO = new CategoryDAO();
                request.setAttribute("categoryList", catDAO.getAllCategoriesWithCount());
                request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
                break;
            }

            case "/admin/loans": {
                LoanDAO loanDAO = new LoanDAO();
                request.setAttribute("loanList", loanDAO.getAllLoans());
                request.getRequestDispatcher("/admin/loans.jsp").forward(request, response);
                break;
            }
            
            default:
                response.sendError(404);
                break;
        }
    }
}