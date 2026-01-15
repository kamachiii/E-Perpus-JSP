/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.BookmarkDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BookmarkServlet", urlPatterns = {"/bookmark"})
public class BookmarkServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if(user != null) {
            int bookId = Integer.parseInt(request.getParameter("id"));
            BookmarkDAO dao = new BookmarkDAO();
            dao.toggleBookmark(user.getId(), bookId);
        }
        // Redirect kembali ke halaman sebelumnya (Dashboard atau Detail)
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : "dashboard");
    }
}