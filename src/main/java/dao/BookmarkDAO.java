/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import util.KoneksiDB;
import model.Book;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookmarkDAO {
    
    public boolean toggleBookmark(int userId, int bookId) {
        if (isBookmarked(userId, bookId)) {
            return removeBookmark(userId, bookId);
        } else {
            return addBookmark(userId, bookId);
        }
    }

    public boolean isBookmarked(int userId, int bookId) {
        String sql = "SELECT 1 FROM bookmarks WHERE user_id = ? AND book_id = ?";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private boolean addBookmark(int userId, int bookId) {
        String sql = "INSERT INTO bookmarks (user_id, book_id) VALUES (?, ?)";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    private boolean removeBookmark(int userId, int bookId) {
        String sql = "DELETE FROM bookmarks WHERE user_id = ? AND book_id = ?";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
    
    public List<Integer> getUserBookmarkedIds(int userId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT book_id FROM bookmarks WHERE user_id = ?";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) list.add(rs.getInt("book_id"));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    
    public List<Book> getBookmarkedBooks(int userId) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name, bm.created_at as marked_at " +
                     "FROM books b " +
                     "JOIN bookmarks bm ON b.id = bm.book_id " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE bm.user_id = ? " +
                     "ORDER BY bm.created_at DESC";

        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
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
                
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}