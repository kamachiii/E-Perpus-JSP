<%@page import="java.util.List"%>
<%@page import="model.Loan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<Loan> activeLoans = (List<Loan>) request.getAttribute("activeLoans");
    List<Loan> historyLoans = (List<Loan>) request.getAttribute("historyLoans");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Peminjaman Saya - E-Library</title>
    
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        .loan-card { transition: transform 0.2s; border: none; border-radius: 12px; }
        .loan-card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.08); }
        
        .book-thumb { width: 70px; height: 100px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        
        .nav-pills .nav-link { 
            border-radius: 50px; padding: 10px 25px; font-weight: 600; color: #6c757d; 
        }
        .nav-pills .nav-link.active { 
            background-color: var(--bs-primary); color: white; box-shadow: 0 4px 6px rgba(13, 110, 253, 0.2); 
        }
        
        /* Status Badges */
        .badge-due { background-color: #ffeeba; color: #856404; border: 1px solid #ffeeba; }
        .badge-overdue { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body class="bg-light">

    <%@include file="includes/navbar.jsp" %>

    <div class="bg-white border-bottom py-5 mb-4">
        <div class="container text-center">
            <h2 class="fw-bold mb-2">Aktivitas Peminjaman</h2>
            <p class="text-muted">Pantau buku yang sedang Anda baca dan riwayat sebelumnya.</p>
            
            <div class="d-flex justify-content-center mt-4">
                <ul class="nav nav-pills bg-light p-1 rounded-pill border" id="pills-tab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="pills-active-tab" data-bs-toggle="pill" data-bs-target="#pills-active" type="button" role="tab">
                            <i class="fas fa-book-reader me-2"></i>Sedang Dipinjam
                            <span class="badge bg-white text-primary ms-2 rounded-pill"><%= activeLoans != null ? activeLoans.size() : 0 %></span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="pills-history-tab" data-bs-toggle="pill" data-bs-target="#pills-history" type="button" role="tab">
                            <i class="fas fa-history me-2"></i>Riwayat Selesai
                        </button>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                
                <div class="tab-content" id="pills-tabContent">
                    
                    <div class="tab-pane fade show active" id="pills-active" role="tabpanel">
                        <% if (activeLoans != null && !activeLoans.isEmpty()) { 
                            for (Loan l : activeLoans) { %>
                            
                            <div class="card loan-card shadow-sm mb-3">
                                <div class="card-body p-4">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-shrink-0">
                                            <% if(l.getBookCover() != null && !l.getBookCover().isEmpty()) { %>
                                                <img src="${pageContext.request.contextPath}/uploads/<%= l.getBookCover() %>" class="book-thumb">
                                            <% } else { %>
                                                <div class="bg-light d-flex align-items-center justify-content-center book-thumb text-muted"><i class="fas fa-book fa-2x"></i></div>
                                            <% } %>
                                        </div>
                                        
                                        <div class="flex-grow-1 ms-4">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h5 class="fw-bold mb-1"><%= l.getBookTitle() %></h5>
                                                    <p class="text-muted small mb-2"><i class="far fa-calendar-check me-1"></i> Dipinjam: <%= l.getLoanDate() %></p>
                                                </div>
                                                <span class="badge badge-due px-3 py-2 rounded-pill">
                                                    <i class="fas fa-clock me-1"></i> Tenggat: <%= l.getDueDate() %>
                                                </span>
                                            </div>
                                            
                                            <hr class="my-2 border-light">
                                            
                                            <div class="d-flex justify-content-between align-items-center mt-2">
                                                <small class="text-muted">Harap kembalikan buku ke perpustakaan sebelum tanggal tenggat.</small>
                                                <a href="book-detail?id=<%= l.getBookId() %>" class="btn btn-sm btn-outline-primary rounded-pill fw-bold px-3">Lihat Buku</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                        <% } } else { %>
                            <div class="text-center py-5">
                                <img src="assets/images/empty.svg" width="120" class="mb-3 opacity-50">
                                <h5 class="text-muted">Tidak ada buku yang sedang dipinjam.</h5>
                                <a href="dashboard" class="btn btn-primary rounded-pill mt-3 px-4">Cari Buku Baru</a>
                            </div>
                        <% } %>
                    </div>

                    <div class="tab-pane fade" id="pills-history" role="tabpanel">
                        <% if (historyLoans != null && !historyLoans.isEmpty()) { 
                            for (Loan l : historyLoans) { %>
                            
                            <div class="card loan-card shadow-sm mb-3 border-start border-4 border-success">
                                <div class="card-body p-3">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-shrink-0">
                                            <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                                                <i class="fas fa-check fa-lg"></i>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1 ms-3">
                                            <h6 class="fw-bold mb-1"><%= l.getBookTitle() %></h6>
                                            <div class="small text-muted">
                                                <span class="me-3"><i class="fas fa-arrow-down text-success me-1"></i> Pinjam: <%= l.getLoanDate() %></span>
                                                <span><i class="fas fa-arrow-up text-primary me-1"></i> Kembali: <strong><%= l.getReturnDate() %></strong></span>
                                            </div>
                                        </div>
                                        <div class="ms-3">
                                            <a href="book-detail?id=<%= l.getBookId() %>" class="btn btn-sm btn-light rounded-circle" title="Beri Ulasan"><i class="fas fa-star text-warning"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                        <% } } else { %>
                            <div class="text-center py-5">
                                <h5 class="text-muted">Belum ada riwayat pengembalian.</h5>
                            </div>
                        <% } %>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>

    <%@include file="includes/footer.jsp" %>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>