/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import util.KoneksiDB;
import model.Book;
import java.sql.*;

/**
 *
 * @author hengk
 */
public class BookDAO {
    public List<Book> getAllBooks() {
        List<Book> listBooks = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name " +
                         "FROM books b " +
                         "LEFT JOIN categories c ON b.category_id = c.id " +
                         "ORDER BY b.id DESC";

        try (Connection c = KoneksiDB.getConnection();
                 Statement s = c.createStatement();
                 ResultSet rs = s.executeQuery(sql)) {

                while (rs.next()) {
                    Book b = new Book();
                    b.setId(rs.getInt("id"));
                    b.setTitle(rs.getString("title"));
                    b.setAuthor(rs.getString("author"));
                    b.setPublisher(rs.getString("publisher"));
                    b.setYear(rs.getInt("year"));
                    b.setStock(rs.getInt("stock"));
                    b.setCoverImage(rs.getString("cover_image"));
                    b.setCategoryId(rs.getInt("category_id"));
                    b.setCategoryName(rs.getString("category_name"));

                    listBooks.add(b);
                }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listBooks;
    }
    
    public boolean insertBook(Book b) {
        String sql = "INSERT INTO books (title, author, publisher, year, stock, category_id, cover_image) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setString(3, b.getPublisher());
            ps.setInt(4, b.getYear());
            ps.setInt(5, b.getStock());
            ps.setInt(6, b.getCategoryId());
            ps.setString(7, b.getCoverImage());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateBook(Book b) {
        String sql = "UPDATE books SET title=?, author=?, publisher=?, year=?, stock=?, category_id=?, cover_image=? WHERE id=?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setString(3, b.getPublisher());
            ps.setInt(4, b.getYear());
            ps.setInt(5, b.getStock());
            ps.setInt(6, b.getCategoryId());
            ps.setString(7, b.getCoverImage());
            ps.setInt(8, b.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBook(int id) {
        String sql = "DELETE FROM books WHERE id=?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Book> searchBooks(String keyword) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE b.title ILIKE ? OR b.author ILIKE ?"; // ILIKE = Case Insensitive (PostgreSQL)
        
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                list.add(mapRowToBook(rs)); // Gunakan helper method mapRowToBook
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Book> getBooksByCategory(int catId) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE b.category_id = ?";
        
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, catId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                list.add(mapRowToBook(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    
    public Book getBookById(int id) {
        Book b = null;
        String sql = "SELECT b.*, c.name as category_name FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id WHERE b.id = ?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                b = mapRowToBook(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return b;
    }

    private Book mapRowToBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setPublisher(rs.getString("publisher"));
        b.setYear(rs.getInt("year"));
        b.setStock(rs.getInt("stock"));
        b.setCoverImage(rs.getString("cover_image"));
        b.setCategoryId(rs.getInt("category_id"));
        b.setCategoryName(rs.getString("category_name"));
        return b;
    }
    
    public int countBooks() {
        String sql = "SELECT COUNT(*) FROM books";
        try (Connection c = KoneksiDB.getConnection();
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
    
    public int addBook(Book b) {
        String sql = "INSERT INTO books (title, author, publisher, year, stock, category_id, cover_image) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;

        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setString(3, b.getPublisher());
            ps.setInt(4, b.getYear());
            ps.setInt(5, b.getStock());
            ps.setInt(6, b.getCategoryId());
            ps.setString(7, b.getCoverImage());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    public void updateCoverImage(int bookId, String newFileName) {
        String sql = "UPDATE books SET cover_image = ? WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newFileName);
            ps.setInt(2, bookId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
