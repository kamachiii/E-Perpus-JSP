/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.BookDAO;
import dao.LoanDAO;
import dao.BookmarkDAO;
import dao.CategoryDAO;
import dao.ReviewDAO;
import model.User;
import model.Book;
import model.Review;
import model.Loan;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@WebServlet(name = "MemberServlet", urlPatterns = {
    "/dashboard", 
    "/history", 
    "/profile",
    "/book-detail",
    "/wishlist",
    "/categories"
})
public class MemberServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        if ("admin".equals(user.getRole())) {
            response.sendRedirect("admin/dashboard");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/dashboard":
                showDashboard(request, response, user);
                break;
                
            case "/book-detail":
                showBookDetail(request, response, user);
                break;

            case "/history":
                LoanDAO loanDAO = new LoanDAO();
                List<Loan> activeLoans = loanDAO.getLoansByStatus(user.getId(), "borrowed");
                List<Loan> historyLoans = loanDAO.getLoansByStatus(user.getId(), "returned");
                
                request.setAttribute("activeLoans", activeLoans);
                request.setAttribute("historyLoans", historyLoans);
                
                request.getRequestDispatcher("history.jsp").forward(request, response);
                break;
                
            case "/categories":
                CategoryDAO catDAO = new CategoryDAO();
                List<Map<String, Object>> categories = catDAO.getAllCategoriesWithCount();
                
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("categories.jsp").forward(request, response);
                break;
                
            case "/wishlist":
                BookmarkDAO bookmarkDAO = new BookmarkDAO();
                List<Book> wishlist = bookmarkDAO.getBookmarkedBooks(user.getId());
                
                request.setAttribute("wishlist", wishlist);
                request.getRequestDispatcher("wishlist.jsp").forward(request, response);
                break;

            case "/profile":
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                break;

            default:
                response.sendError(404);
                break;
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        BookDAO bookDAO = new BookDAO();
        BookmarkDAO bookmarkDAO = new BookmarkDAO();
        List<Book> books;
        
        String search = request.getParameter("search");
        String catId = request.getParameter("category");

        if (search != null && !search.isEmpty()) {
            books = bookDAO.searchBooks(search);
        } else if (catId != null && !catId.isEmpty()) {
            books = bookDAO.getBooksByCategory(Integer.parseInt(catId));
        } else {
            books = bookDAO.getAllBooks();
        }

        List<Integer> likedBookIds = bookmarkDAO.getUserBookmarkedIds(user.getId());

        request.setAttribute("listBooks", books);
        request.setAttribute("likedBookIds", likedBookIds);
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    private void showBookDetail(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int bookId = Integer.parseInt(request.getParameter("id"));
        
        BookDAO bookDAO = new BookDAO();
        ReviewDAO reviewDAO = new ReviewDAO();
        BookmarkDAO bookmarkDAO = new BookmarkDAO();

        Book book = bookDAO.getBookById(bookId);
        List<Review> reviews = reviewDAO.getReviewsByBook(bookId);
        boolean isBookmarked = bookmarkDAO.isBookmarked(user.getId(), bookId);
        
        boolean hasReviewed = reviewDAO.hasUserReviewed(user.getId(), bookId);

        request.setAttribute("book", book);
        request.setAttribute("reviews", reviews);
        request.setAttribute("isBookmarked", isBookmarked);
        request.setAttribute("hasReviewed", hasReviewed);
        
        request.getRequestDispatcher("book-detail.jsp").forward(request, response);
    }
}