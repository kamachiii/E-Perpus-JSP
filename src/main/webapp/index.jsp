<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // LOGIC: Jika user sudah login, jangan tampilkan landing page,
    // langsung lempar ke Dashboard.
    User user = (User) session.getAttribute("currentUser");
    if (user != null) {
        if ("admin".equals(user.getRole())) {
            response.sendRedirect("admin/dashboard");
        } else {
            response.sendRedirect("dashboard");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Selamat Datang - E-Library Scholar</title>
    
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        /* Hero Section Style */
        .hero-section {
            background: linear-gradient(135deg, var(--color-dominant) 0%, var(--color-accent) 100%);
            color: white;
            padding: 100px 0;
            border-radius: 0 0 50px 50px;
            position: relative;
            overflow: hidden;
        }
        
        /* Hiasan background abstrak */
        .hero-shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        .shape-1 { width: 300px; height: 300px; top: -100px; left: -50px; }
        .shape-2 { width: 200px; height: 200px; bottom: 50px; right: 10%; }
        
        .feature-card {
            border: none;
            border-radius: 15px;
            transition: transform 0.3s;
            height: 100%;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .feature-icon {
            width: 70px;
            height: 70px;
            background-color: var(--color-accent);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark absolute-top" style="background: var(--color-dominant);">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center fw-bold" href="#">
                <div class="bg-white text-primary rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 35px; height: 35px;">
                    <i class="fas fa-book-open"></i>
                </div>
                E-Library
            </a>
            <div class="ms-auto">
                <a href="login" class="btn btn-outline-light rounded-pill px-4 me-2">Masuk</a>
                <a href="register" class="btn btn-light text-primary rounded-pill px-4 fw-bold">Daftar</a>
            </div>
        </div>
    </nav>

    <section class="hero-section text-center">
        <div class="hero-shape shape-1"></div>
        <div class="hero-shape shape-2"></div>
        
        <div class="container position-relative z-1">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <h1 class="display-4 fw-bold mb-3">Perpustakaan Digital Masa Depan</h1>
                    <p class="lead mb-5 opacity-75">
                        Akses ribuan koleksi buku, jurnal, dan referensi akademik kapan saja dan di mana saja. Tingkatkan wawasanmu dengan E-Library Scholar.
                    </p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="register" class="btn btn-light text-primary btn-lg rounded-pill px-5 fw-bold shadow-sm">
                            Mulai Sekarang <i class="fas fa-arrow-right ms-2"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5 mb-5" style="margin-top: -50px;">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card feature-card shadow p-4 text-center">
                        <div class="d-flex justify-content-center">
                            <div class="feature-icon bg-primary bg-opacity-10 text-primary">
                                <i class="fas fa-book"></i>
                            </div>
                        </div>
                        <h5 class="fw-bold">Koleksi Lengkap</h5>
                        <p class="text-muted small">Ribuan judul buku dari berbagai kategori tersedia untuk menunjang kebutuhan belajar Anda.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card feature-card shadow p-4 text-center">
                        <div class="d-flex justify-content-center">
                            <div class="feature-icon bg-success bg-opacity-10 text-success">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                        <h5 class="fw-bold">Akses 24/7</h5>
                        <p class="text-muted small">Tidak ada batasan waktu. Pinjam dan baca buku favorit Anda kapan saja sesuai keinginan.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card feature-card shadow p-4 text-center">
                        <div class="d-flex justify-content-center">
                            <div class="feature-icon bg-warning bg-opacity-10 text-warning">
                                <i class="fas fa-mobile-alt"></i>
                            </div>
                        </div>
                        <h5 class="fw-bold">Mudah & Cepat</h5>
                        <p class="text-muted small">Antarmuka yang ramah pengguna memudahkan Anda dalam mencari dan meminjam buku.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5 bg-white">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 mb-4 mb-md-0">
                    <img src="assets/images/empty.svg" class="img-fluid w-75 d-block mx-auto" alt="Illustration">
                </div>
                <div class="col-md-6">
                    <h2 class="fw-bold mb-3">Bergabunglah dengan Komunitas Kami</h2>
                    <p class="text-muted mb-4">
                        Dapatkan akses eksklusif ke fitur-fitur premium seperti Wishlist, Riwayat Peminjaman, dan Ulasan Buku. Gratis untuk semua mahasiswa.
                    </p>
                    <ul class="list-unstyled mb-4">
                        <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i> Peminjaman Online</li>
                        <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i> Update Buku Terbaru</li>
                        <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i> Komunitas Pembaca Aktif</li>
                    </ul>
                    <a href="login" class="btn btn-primary rounded-pill px-4">Login ke Akun</a>
                </div>
            </div>
        </div>
    </section>

    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <div class="mb-3">
                <i class="fas fa-book-open fa-2x"></i>
            </div>
            <p class="small opacity-75 mb-0">&copy; 2026 E-Library Scholar. Developed with <i class="fas fa-heart text-danger"></i> for Education.</p>
        </div>
    </footer>

    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>