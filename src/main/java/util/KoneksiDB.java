/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author hengk
 */
public class KoneksiDB {
    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://localhost:5432/dbperpus";
            String user = "postgres";
            String pass = "083806"; // password kalian jangan lupa ubahh
            
            return DriverManager.getConnection(url, user, pass);
        } catch(Exception e) {
            System.out.println("Koneksi gagal " + e.getMessage());
            return null;
        }
    }
    
}
