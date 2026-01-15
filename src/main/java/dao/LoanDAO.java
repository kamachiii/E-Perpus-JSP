/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import util.KoneksiDB;
import model.Loan;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;

/**
 *
 * @author hengk
 */
public class LoanDAO {
    public boolean borrowBook(int userId, int bookId, int durationDays) {
        Connection c = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdateStock = null;

        try {
            c = KoneksiDB.getConnection();
            c.setAutoCommit(false);

            String sqlCheck = "SELECT stock FROM books WHERE id = ?";
            psCheck = c.prepareStatement(sqlCheck);
            psCheck.setInt(1, bookId);
            ResultSet rs = psCheck.executeQuery();
            
            if (rs.next()) {
                int currentStock = rs.getInt("stock");
                if (currentStock <= 0) {
                    return false;
                }
            } else {
                return false;
            }

            String sqlInsert = "INSERT INTO loans (user_id, book_id, loan_date, due_date, status) VALUES (?, ?, ?, ?, 'borrowed')";
            psInsert = c.prepareStatement(sqlInsert);
            
            LocalDate today = LocalDate.now();
            LocalDate dueDate = today.plusDays(durationDays);
            
            psInsert.setInt(1, userId);
            psInsert.setInt(2, bookId);
            psInsert.setDate(3, Date.valueOf(today));
            psInsert.setDate(4, Date.valueOf(dueDate));
            
            psInsert.executeUpdate();

            String sqlUpdate = "UPDATE books SET stock = stock - 1 WHERE id = ?";
            psUpdateStock = c.prepareStatement(sqlUpdate);
            psUpdateStock.setInt(1, bookId);
            psUpdateStock.executeUpdate();

            c.commit();
            return true;

        } catch (SQLException e) {
            if (c != null) try { c.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if (c != null) c.close(); } catch (SQLException e) {}
        }
    }

    public boolean returnBook(int loanId, int bookId) {
        Connection c = null;
        try {
            c = KoneksiDB.getConnection();
            c.setAutoCommit(false);

            String sqlLoan = "UPDATE loans SET return_date = ?, status = 'returned' WHERE id = ?";
            PreparedStatement psLoan = c.prepareStatement(sqlLoan);
            psLoan.setDate(1, Date.valueOf(LocalDate.now()));
            psLoan.setInt(2, loanId);
            psLoan.executeUpdate();

            String sqlStock = "UPDATE books SET stock = stock + 1 WHERE id = ?";
            PreparedStatement psStock = c.prepareStatement(sqlStock);
            psStock.setInt(1, bookId);
            psStock.executeUpdate();

            c.commit();
            return true;
        } catch (SQLException e) {
            if (c != null) try { c.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if (c != null) c.close(); } catch (SQLException e) {}
        }
    }

    public List<Loan> getAllLoans() {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, u.full_name, b.title, b.cover_image " +
                     "FROM loans l " +
                     "JOIN users u ON l.user_id = u.id " +
                     "JOIN books b ON l.book_id = b.id " +
                     "ORDER BY l.id DESC";
        
        try (Connection c = KoneksiDB.getConnection();
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery(sql)) {
            
            while(rs.next()) {
                Loan l = new Loan();
                l.setId(rs.getInt("id"));
                l.setUserId(rs.getInt("user_id"));
                l.setBookId(rs.getInt("book_id"));
                l.setLoanDate(rs.getDate("loan_date"));
                l.setDueDate(rs.getDate("due_date"));
                l.setReturnDate(rs.getDate("return_date"));
                l.setStatus(rs.getString("status"));
                l.setMemberName(rs.getString("full_name"));
                l.setBookTitle(rs.getString("title"));
                l.setBookCover(rs.getString("cover_image"));
                
                list.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Loan> getLoansByUser(int userId) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, b.title, b.cover_image FROM loans l " +
                     "JOIN books b ON l.book_id = b.id " +
                     "WHERE l.user_id = ? ORDER BY l.id DESC";
        
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                Loan l = new Loan();
                l.setId(rs.getInt("id"));
                l.setLoanDate(rs.getDate("loan_date"));
                l.setDueDate(rs.getDate("due_date"));
                l.setReturnDate(rs.getDate("return_date"));
                l.setStatus(rs.getString("status"));
                l.setBookTitle(rs.getString("title"));
                l.setBookCover(rs.getString("cover_image"));
                
                list.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Loan> getLoansByStatus(int userId, String status) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, b.title, b.cover_image FROM loans l " +
                     "JOIN books b ON l.book_id = b.id " +
                     "WHERE l.user_id = ? AND l.status = ? ORDER BY l.loan_date DESC";
        
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                Loan l = new Loan();
                l.setId(rs.getInt("id"));
                l.setUserId(rs.getInt("user_id"));
                l.setBookId(rs.getInt("book_id")); // Penting utk link detail
                l.setLoanDate(rs.getDate("loan_date"));
                l.setDueDate(rs.getDate("due_date"));
                l.setReturnDate(rs.getDate("return_date"));
                l.setStatus(rs.getString("status"));
                l.setBookTitle(rs.getString("title"));
                l.setBookCover(rs.getString("cover_image"));
                
                list.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int countActiveLoans() {
        String sql = "SELECT COUNT(*) FROM loans WHERE status = 'borrowed'";
        try (Connection c = KoneksiDB.getConnection();
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
