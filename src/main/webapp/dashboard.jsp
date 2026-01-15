<%@page import="java.util.List"%>
<%@page import="model.Book"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Book> books = (List<Book>) request.getAttribute("listBooks");
    List<Integer> likedIds = (List<Integer>) request.getAttribute("likedBookIds");
    
    String searchKeyword = request.getParameter("search");
    if (searchKeyword == null) searchKeyword = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - E-Library Scholar</title>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        .book-card { transition: transform 0.2s, box-shadow 0.2s; height: 100%; border: none; border-radius: 12px; overflow: hidden; }
        .book-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .book-cover-container { height: 280px; overflow: hidden; background-color: #f8f9fa; position: relative; display: flex; align-items: center; justify-content: center; }
        .book-cover { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s ease; }
        .book-card:hover .book-cover { transform: scale(1.05); }
        .badge-category { position: absolute; top: 10px; left: 10px; background: rgba(0,0,0,0.6); color: #fff; font-weight: 500; font-size: 0.75rem; padding: 4px 10px; border-radius: 20px; backdrop-filter: blur(2px); z-index: 5; }
        .wishlist-btn { position: absolute; top: 10px; right: 10px; background: white; border-radius: 50%; width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.15); z-index: 10; text-decoration: none; transition: transform 0.2s; }
        .wishlist-btn:hover { transform: scale(1.1); }
        .stock-badge { font-size: 0.8rem; margin-bottom: 0.5rem; display: inline-block; }
        .fade-in { animation: fadeIn 0.8s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-light">

    <%@include file="includes/navbar.jsp" %>

    <div class="bg-white border-bottom py-5 mb-5">
        <div class="container text-center">
            <h1 class="fw-bold text-dark mb-3">Temukan Buku Favoritmu</h1>
            <p class="text-muted lead mb-4">Jelajahi koleksi perpustakaan dan pinjam buku secara online.</p>
            
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <form action="dashboard" method="get">
                        <div class="input-group input-group-lg shadow-sm rounded-pill overflow-hidden">
                            <input type="text" name="search" class="form-control border-0 bg-light ps-4" 
                                   placeholder="Cari judul buku atau penulis..." 
                                   value="<%= searchKeyword %>">
                            <button class="btn btn-primary px-4" type="submit"><i class="fas fa-search"></i></button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="mt-4 d-flex justify-content-center flex-wrap gap-2">
                <a href="dashboard" class="btn btn-sm btn-outline-primary rounded-pill px-3">Semua</a>
                <a href="dashboard?category=1" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Teknologi</a>
                <a href="dashboard?category=2" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Fiksi</a>
                <a href="dashboard?category=3" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Sejarah</a>
                <a href="dashboard?category=4" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Sains</a>
                <a href="dashboard?category=5" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Self Help</a>
            </div>
        </div>
    </div>

    <div class="container">
        
        <% String error = request.getParameter("error");
           if ("stock".equals(error)) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i> <strong>Gagal!</strong> Stok buku habis atau sedang tidak tersedia.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% String msg = request.getParameter("msg");
           if ("success".equals(msg)) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i> <strong>Berhasil!</strong> Buku berhasil dipinjam. Silakan cek menu <a href="history" class="alert-link">Peminjaman Saya</a>.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (books != null && !books.isEmpty()) { %>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-5">
                <% for (Book b : books) {
                        boolean isAvailable = b.getStock() > 0;
                        boolean isLiked = likedIds != null && likedIds.contains(Integer.valueOf(b.getId()));
                %>
                <div class="col">
                    <div class="card book-card shadow-sm h-100 position-relative">
                        <a href="bookmark?id=<%= b.getId() %>" class="wishlist-btn" title="<%= isLiked ? "Hapus dari Wishlist" : "Tambah ke Wishlist" %>">
                            <% if(isLiked) { %> <i class="fas fa-heart text-danger fa-lg"></i> <% } else { %> <i class="far fa-heart text-secondary fa-lg"></i> <% } %>
                        </a>
                        <a href="book-detail?id=<%= b.getId() %>" class="book-cover-container text-decoration-none">
                            <% if (b.getCategoryName() != null) { %> <span class="badge-category"><%= b.getCategoryName() %></span> <% } %>
                            <% if(b.getCoverImage() != null && !b.getCoverImage().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/uploads/<%= b.getCoverImage() %>" class="book-cover" alt="<%= b.getTitle() %>">
                            <% } else { %>
                                <div class="text-muted text-center"><i class="fas fa-book fa-3x mb-2"></i><br>No Cover</div>
                            <% } %>
                        </a>
                        <div class="card-body d-flex flex-column pt-3">
                            <h5 class="card-title fw-bold mb-1 text-truncate" title="<%= b.getTitle() %>">
                                <a href="book-detail?id=<%= b.getId() %>" class="text-dark text-decoration-none"><%= b.getTitle() %></a>
                            </h5>
                            <p class="card-text text-muted small mb-2"><%= b.getAuthor() %></p>
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <small class="text-muted"><%= b.getYear() %></small>
                                    <% if (isAvailable) { %>
                                        <span class="badge bg-success bg-opacity-10 text-success stock-badge"><i class="fas fa-check-circle me-1"></i> Stok: <%= b.getStock() %></span>
                                    <% } else { %>
                                        <span class="badge bg-danger bg-opacity-10 text-danger stock-badge"><i class="fas fa-times-circle me-1"></i> Habis</span>
                                    <% } %>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="book-detail?id=<%= b.getId() %>" class="btn btn-outline-primary btn-sm w-50 fw-bold rounded-pill">Detail</a>
                                    <form action="loans" method="post" class="w-50">
                                        <input type="hidden" name="action" value="borrow">
                                        <input type="hidden" name="book_id" value="<%= b.getId() %>">
                                        <button type="submit" class="btn btn-primary btn-sm w-100 fw-bold rounded-pill" <%= isAvailable ? "" : "disabled" %>>
                                            <% if (isAvailable) { %> Pinjam <% } else { %> Habis <% } %>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="d-flex flex-column justify-content-center align-items-center py-5 my-5 text-center fade-in">
                <div class="bg-light rounded-circle p-4 mb-4 shadow-sm" style="width: 120px; height: 120px; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-search fa-4x text-muted opacity-50"></i>
                </div>
                
                <h3 class="fw-bold text-dark mb-2">Oops, buku tidak ditemukan!</h3>
                <p class="text-muted lead mb-4" style="max-width: 500px;">
                    <% if (searchKeyword != null && !searchKeyword.trim().isEmpty()) { %>
                        Sepertinya kami tidak dapat menemukan buku dengan kata kunci <strong>"<%= searchKeyword %>"</strong>.
                    <% } else { %>
                        Sepertinya belum ada buku di kategori ini.
                    <% } %>
                    Coba gunakan kata kunci lain atau jelajahi kategori kami.
                </p>
                
                <div class="d-flex gap-3">
                    <a href="dashboard" class="btn btn-primary px-4 py-2 rounded-pill shadow-sm fw-bold">
                        <i class="fas fa-sync-alt me-2"></i>Reset Pencarian
                    </a>
                    <a href="categories" class="btn btn-outline-secondary px-4 py-2 rounded-pill fw-bold">
                        <i class="fas fa-layer-group me-2"></i>Lihat Kategori
                    </a>
                </div>
            </div>
        <% } %>
    </div>

    <%@include file="includes/footer.jsp" %>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>