/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.ReviewDAO;
import model.Review;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("currentUser");
        String action = request.getParameter("action");
        
        if (user != null && "delete".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("id"));
            int bookId = Integer.parseInt(request.getParameter("book_id"));

            ReviewDAO dao = new ReviewDAO();
            dao.deleteReview(reviewId, user.getId());
            
            response.sendRedirect("book-detail?id=" + bookId);
        } else {
            response.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        int bookId = Integer.parseInt(request.getParameter("book_id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");
        ReviewDAO dao = new ReviewDAO();

        if ("add".equals(action)) {
            if (dao.hasUserReviewed(user.getId(), bookId)) {
                response.sendRedirect("book-detail?id=" + bookId);
                return;
            }

            Review r = new Review();
            r.setUserId(user.getId());
            r.setBookId(bookId);
            r.setRating(rating);
            r.setComment(comment);
            dao.addReview(r);
            
        } else if ("update".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("review_id"));
            
            Review r = new Review();
            r.setId(reviewId);
            r.setUserId(user.getId());
            r.setRating(rating);
            r.setComment(comment);
            dao.updateReview(r);
        }

        response.sendRedirect("book-detail?id=" + bookId);
    }
}