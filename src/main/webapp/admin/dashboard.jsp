<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer totalMembers = (Integer) request.getAttribute("totalMembers");
    Integer totalBooks = (Integer) request.getAttribute("totalBooks");
    Integer activeLoans = (Integer) request.getAttribute("activeLoans");
    
    if(totalMembers == null) totalMembers = 0;
    if(totalBooks == null) totalBooks = 0;
    if(activeLoans == null) activeLoans = 0;
    
    String requestUri = request.getRequestURI();
    String contextPath = request.getContextPath();
    String currentPage = requestUri.substring(contextPath.length());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - E-Library</title>
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    
    <style>
        .stat-card {
            border: none;
            border-radius: 15px;
            transition: transform 0.3s;
            overflow: hidden;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stat-icon {
            font-size: 2.5rem;
            opacity: 0.3;
            position: absolute;
            right: 20px;
            bottom: 20px;
        }
        .bg-gradient-primary { background: linear-gradient(45deg, #4e73df, #224abe); color: white; }
        .bg-gradient-success { background: linear-gradient(45deg, #1cc88a, #13855c); color: white; }
        .bg-gradient-warning { background: linear-gradient(45deg, #f6c23e, #dda20a); color: white; }
        .bg-gradient-info    { background: linear-gradient(45deg, #36b9cc, #258391); color: white; }
    </style>
</head>
<body class="bg-light">

    <div class="d-flex">
        <%@include file="../includes/sidebar.jsp" %>

        <div class="flex-grow-1 p-4 p-md-5">
            <h2 class="fw-bold mb-4 text-dark">Dashboard Overview</h2>
            
            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="card stat-card bg-gradient-primary h-100">
                        <div class="card-body p-4 position-relative">
                            <h5 class="card-title text-uppercase fw-bold mb-0" style="font-size: 0.8rem; letter-spacing: 1px;">Total Buku</h5>
                            <h2 class="mt-2 mb-0 fw-bold"><%= totalBooks %></h2>
                            <i class="fas fa-book stat-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card stat-card bg-gradient-warning h-100">
                        <div class="card-body p-4 position-relative">
                            <h5 class="card-title text-uppercase fw-bold mb-0" style="font-size: 0.8rem; letter-spacing: 1px;">Sedang Dipinjam</h5>
                            <h2 class="mt-2 mb-0 fw-bold"><%= activeLoans %></h2>
                            <i class="fas fa-book-reader stat-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card stat-card bg-gradient-success h-100">
                        <div class="card-body p-4 position-relative">
                            <h5 class="card-title text-uppercase fw-bold mb-0" style="font-size: 0.8rem; letter-spacing: 1px;">Anggota Terdaftar</h5>
                            <h2 class="mt-2 mb-0 fw-bold"><%= totalMembers %></h2>
                            <i class="fas fa-users stat-icon"></i>
                        </div>
                    </div>
                </div>
            </div>

            <h5 class="fw-bold mb-3 text-secondary">Aksi Cepat</h5>
            <div class="row g-3">
                <div class="col-md-3">
                    <a href="books" class="btn btn-white border w-100 p-3 text-start shadow-sm d-flex align-items-center">
                        <div class="bg-primary bg-opacity-10 text-primary rounded p-2 me-3"><i class="fas fa-plus"></i></div>
                        <span class="fw-semibold">Tambah Buku</span>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="loans?action=list" class="btn btn-white border w-100 p-3 text-start shadow-sm d-flex align-items-center">
                        <div class="bg-warning bg-opacity-10 text-warning rounded p-2 me-3"><i class="fas fa-undo"></i></div>
                        <span class="fw-semibold">Proses Pengembalian</span>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="categories" class="btn btn-white border w-100 p-3 text-start shadow-sm d-flex align-items-center">
                        <div class="bg-info bg-opacity-10 text-info rounded p-2 me-3"><i class="fas fa-tags"></i></div>
                        <span class="fw-semibold">Kelola Kategori</span>
                    </a>
                </div>
            </div>

        </div>
    </div>

    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>