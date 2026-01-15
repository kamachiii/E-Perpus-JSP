/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.BookDAO;
import model.Book;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;

/**
 *
 * @author hengk
 */
@WebServlet(name = "BookServlet", urlPatterns = {"/books"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class BookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if ("list".equals(action)) {
            listBooks(request, response);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            BookDAO dao = new BookDAO();
            dao.deleteBook(id);
            response.sendRedirect("books");
        }
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
        BookDAO dao = new BookDAO();
        
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        int year = Integer.parseInt(request.getParameter("year"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));

        Book b = new Book();
        b.setTitle(title);
        b.setAuthor(author);
        b.setPublisher(publisher);
        b.setYear(year);
        b.setStock(stock);
        b.setCategoryId(categoryId);

        Part filePart = request.getPart("cover");
        
        if ("add".equals(action)) {
            int newId = dao.addBook(b); 
            
            if (newId > 0) {
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = saveFile(filePart, request, newId, title, publisher, year);
                    
                    dao.updateCoverImage(newId, fileName);
                }
            }
            
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String oldCover = request.getParameter("old_cover");
            
            if (filePart != null && filePart.getSize() > 0) {
                
                if (oldCover != null && !oldCover.isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File oldFile = new File(uploadPath + File.separator + oldCover);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                
                String fileName = saveFile(filePart, request, id, title, publisher, year);
                b.setCoverImage(fileName);
                
            } else {
                b.setCoverImage(oldCover);
            }
            
            b.setId(id);
            
            dao.updateBook(b);
        }
        
        response.sendRedirect("books");
    }

    private String saveFile(Part filePart, HttpServletRequest request, int id, String title, String publisher, int year) throws IOException {
        String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        int i = originalName.lastIndexOf('.');
        if (i > 0) {
            extension = originalName.substring(i);
        }

        String safeTitle = sanitizeString(title);
        String safePublisher = sanitizeString(publisher);

        String newFileName = id + "-" + safeTitle + "-" + safePublisher + "-" + year + extension;

        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        filePart.write(uploadPath + File.separator + newFileName);
        
        return newFileName;
    }

    private String sanitizeString(String input) {
        if (input == null) return "";
        return input.trim().replaceAll("\\s+", "-").replaceAll("[^a-zA-Z0-9-]", "");
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookDAO dao = new BookDAO();
        List<Book> books = dao.getAllBooks();
        request.setAttribute("listBooks", books);
        request.getRequestDispatcher("admin/books.jsp").forward(request, response);
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        int year = Integer.parseInt(request.getParameter("year"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));

        Part filePart = request.getPart("cover");
        String fileName = null;
        
        if (filePart != null && filePart.getSize() > 0) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            filePart.write(uploadPath + File.separator + fileName);
        }

        Book b = new Book();
        b.setTitle(title);
        b.setAuthor(author);
        b.setPublisher(publisher);
        b.setYear(year);
        b.setStock(stock);
        b.setCategoryId(categoryId);
        b.setCoverImage(fileName);

        BookDAO dao = new BookDAO();
        dao.insertBook(b);

        response.sendRedirect("books"); 
    }
    
    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        int year = Integer.parseInt(request.getParameter("year"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String oldCover = request.getParameter("old_cover");

        Part filePart = request.getPart("cover");
        String fileName = oldCover;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + java.io.File.separator + "uploads";
            filePart.write(uploadPath + java.io.File.separator + fileName);
        }

        Book b = new Book();
        b.setId(id);
        b.setTitle(title);
        b.setAuthor(author);
        b.setPublisher(publisher);
        b.setYear(year);
        b.setStock(stock);
        b.setCategoryId(categoryId);
        b.setCoverImage(fileName); 

        BookDAO dao = new BookDAO();
        dao.updateBook(b);

        response.sendRedirect("books");
    }
}