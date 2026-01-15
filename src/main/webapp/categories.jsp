<%-- 
    Document   : categories
    Created on : Jan 6, 2026, 12:58:58 PM
    Author     : hengk
--%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Cek Login
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login");
        return;
    }
    
    // Ambil data kategori
    List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kategori Buku - E-Library</title>
    
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        .category-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            border-radius: 15px;
            overflow: hidden;
            text-decoration: none;
            color: inherit;
            display: block;
            height: 100%;
        }
        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            color: var(--bs-primary);
        }
        
        .cat-icon-wrapper {
            height: 120px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #6c757d;
            transition: all 0.3s ease;
        }
        .category-card:hover .cat-icon-wrapper {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: var(--bs-primary);
        }
    </style>
</head>
<body class="bg-light">

    <%@include file="includes/navbar.jsp" %>

    <div class="bg-white border-bottom py-5 mb-5">
        <div class="container text-center">
            <h1 class="fw-bold text-dark mb-2">Jelajahi Kategori</h1>
            <p class="text-muted lead">Temukan buku berdasarkan topik yang Anda minati.</p>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
            
            <% 
            if (categories != null && !categories.isEmpty()) {
                for (Map<String, Object> cat : categories) {
                    int id = (int) cat.get("id");
                    String name = (String) cat.get("name");
                    int count = (int) cat.get("count");
                    
                    // Tentukan ikon berdasarkan nama kategori (Opsional, biar cantik)
                    String icon = "fa-book";
                    if (name.toLowerCase().contains("tech")) icon = "fa-laptop-code";
                    else if (name.toLowerCase().contains("fiksi")) icon = "fa-dragon";
                    else if (name.toLowerCase().contains("sejarah")) icon = "fa-landmark";
                    else if (name.toLowerCase().contains("sains")) icon = "fa-flask";
                    else if (name.toLowerCase().contains("self")) icon = "fa-brain";
            %>
            <div class="col">
                <a href="dashboard?category=<%= id %>" class="card category-card shadow-sm">
                    <div class="cat-icon-wrapper">
                        <i class="fas <%= icon %>"></i>
                    </div>
                    <div class="card-body text-center p-4">
                        <h5 class="fw-bold mb-1"><%= name %></h5>
                        <p class="text-muted small mb-0"><%= count %> Buku Tersedia</p>
                    </div>
                </a>
            </div>
            <% 
                }
            } else { 
            %>
                <div class="col-12 text-center py-5">
                    <h5 class="text-muted">Belum ada kategori yang tersedia.</h5>
                </div>
            <% } %>
            
        </div>
    </div>

    <%@include file="includes/footer.jsp" %>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>