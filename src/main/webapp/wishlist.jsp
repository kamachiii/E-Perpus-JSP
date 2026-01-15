<%@page import="java.util.List"%>
<%@page import="model.Book"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Cek Login
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login");
        return;
    }
    
    // Ambil data dari Servlet
    List<Book> wishlist = (List<Book>) request.getAttribute("wishlist");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wishlist Saya - E-Library</title>
    
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        .book-card {
            transition: transform 0.2s;
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }
        .book-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .book-cover-container {
            height: 250px;
            overflow: hidden;
            background-color: #f8f9fa;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .book-cover { width: 100%; height: 100%; object-fit: cover; }
        
        /* Tombol Hapus (Sampah) di pojok */
        .remove-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255, 255, 255, 0.9);
            color: #dc3545;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            transition: all 0.2s;
            z-index: 10;
        }
        .remove-btn:hover { background: #dc3545; color: white; transform: scale(1.1); }
    </style>
</head>
<body class="bg-light">

    <%@include file="includes/navbar.jsp" %>

    <div class="bg-white border-bottom py-4 mb-4">
        <div class="container">
            <h2 class="fw-bold mb-0"><i class="fas fa-heart text-danger me-2"></i>Wishlist Saya</h2>
            <p class="text-muted small mb-0">Koleksi buku yang ingin Anda baca nanti.</p>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
            <% 
            if (wishlist != null && !wishlist.isEmpty()) {
                for (Book b : wishlist) {
                    boolean isAvailable = b.getStock() > 0;
            %>
            <div class="col">
                <div class="card book-card shadow-sm h-100 position-relative">
                    
                    <a href="bookmark?id=<%= b.getId() %>" class="remove-btn" title="Hapus dari Wishlist" onclick="return confirm('Hapus buku ini dari wishlist?')">
                        <i class="fas fa-trash-alt"></i>
                    </a>

                    <a href="book-detail?id=<%= b.getId() %>" class="book-cover-container">
                         <% if(b.getCoverImage() != null && !b.getCoverImage().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/uploads/<%= b.getCoverImage() %>" class="book-cover" alt="<%= b.getTitle() %>">
                        <% } else { %>
                            <div class="text-muted text-center"><i class="fas fa-book fa-3x"></i></div>
                        <% } %>
                    </a>

                    <div class="card-body d-flex flex-column">
                        <h6 class="card-title fw-bold text-truncate"><%= b.getTitle() %></h6>
                        <p class="text-muted small mb-2"><%= b.getAuthor() %></p>
                        
                        <div class="mt-auto">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="badge bg-light text-dark border"><%= b.getCategoryName() %></span>
                                <% if (isAvailable) { %>
                                    <span class="text-success small fw-bold"><i class="fas fa-check"></i> Tersedia</span>
                                <% } else { %>
                                    <span class="text-danger small fw-bold"><i class="fas fa-times"></i> Habis</span>
                                <% } %>
                            </div>

                            <div class="d-grid gap-2">
                                <a href="book-detail?id=<%= b.getId() %>" class="btn btn-outline-primary btn-sm rounded-pill">Lihat Detail</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <% 
                } 
            } else { 
            %>
                <div class="col-12 text-center py-5">
                    <img src="assets/images/empty.svg" alt="Empty" style="width: 150px; opacity: 0.5;" class="mb-3">
                    <h5 class="text-muted">Wishlist Anda masih kosong.</h5>
                    <a href="dashboard" class="btn btn-primary rounded-pill px-4 mt-2">Cari Buku</a>
                </div>
            <% } %>
        </div>
    </div>

    <%@include file="includes/footer.jsp" %>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>