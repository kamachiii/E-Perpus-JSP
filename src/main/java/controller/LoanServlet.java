/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.LoanDAO;
import model.User;
import model.Loan;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoanServlet", urlPatterns = {"/loans"})
public class LoanServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        LoanDAO dao = new LoanDAO();

        if (action == null || "list".equals(action)) {
            if ("admin".equals(currentUser.getRole())) {
                List<Loan> loans = dao.getAllLoans();
                request.setAttribute("loanList", loans);
                request.getRequestDispatcher("admin/loans.jsp").forward(request, response);
            } else {
                // Tampilan Member (TAB VIEW)
                List<Loan> activeLoans = dao.getLoansByStatus(currentUser.getId(), "borrowed");
                List<Loan> historyLoans = dao.getLoansByStatus(currentUser.getId(), "returned");
                
                request.setAttribute("activeLoans", activeLoans);
                request.setAttribute("historyLoans", historyLoans);
                request.getRequestDispatcher("loans.jsp").forward(request, response);
            }
        } 
        else if ("return".equals(action)) {
            // Logic Return (Admin Only)
            if ("admin".equals(currentUser.getRole())) {
                int loanId = Integer.parseInt(request.getParameter("id"));
                int bookId = Integer.parseInt(request.getParameter("book_id"));
                
                dao.returnBook(loanId, bookId);
                response.sendRedirect("loans?action=list");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser != null && "borrow".equals(action)) {
            int bookId = Integer.parseInt(request.getParameter("book_id"));
            int duration = 7;
            
            LoanDAO dao = new LoanDAO();
            boolean success = dao.borrowBook(currentUser.getId(), bookId, duration);
            
            if (success) {
                response.sendRedirect("loans?msg=success"); 
            } else {
                response.sendRedirect("dashboard?error=stock");
            }
        } else {
            response.sendRedirect("login");
        }
    }
}