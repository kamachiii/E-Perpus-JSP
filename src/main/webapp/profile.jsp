<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    
    // Generate Inisial untuk Avatar
    String initial = user.getFullName().substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profil Saya - E-Library</title>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        .profile-header-bg {
            height: 150px;
            background: linear-gradient(135deg, var(--color-dominant) 0%, var(--color-accent) 100%);
            border-radius: 0 0 50% 50% / 20px;
        }
        .profile-avatar-lg {
            width: 120px;
            height: 120px;
            background-color: white;
            border: 5px solid white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3.5rem;
            color: var(--color-dominant);
            font-weight: bold;
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
            margin-top: -60px;
        }
    </style>
</head>
<body class="bg-light">

    <%@include file="includes/navbar.jsp" %>

    <div class="profile-header-bg"></div>

    <div class="container mb-5" style="margin-top: -40px;">
        <div class="row">
            
            <div class="col-lg-4 mb-4">
                <div class="card border-0 shadow-sm rounded-4 text-center h-100">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-center">
                            <div class="profile-avatar-lg"><%= initial %></div>
                        </div>
                        
                        <h4 class="fw-bold mt-3 mb-1"><%= user.getFullName() %></h4>
                        <p class="text-muted mb-3"><%= user.getRole().toUpperCase() %></p>
                        
                        <div class="d-flex justify-content-center gap-2 mb-4">
                            <span class="badge bg-light text-dark border"><i class="fas fa-envelope me-1"></i> <%= user.getUsername() %></span>
                        </div>
                        
                        <hr>
                        
                        <div class="text-start px-2">
                            <small class="text-muted fw-bold text-uppercase">Informasi Akun</small>
                            <div class="mt-3">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="bg-light p-2 rounded-circle me-3"><i class="fas fa-calendar-alt text-primary"></i></div>
                                    <div>
                                        <small class="d-block text-muted">Bergabung Sejak</small>
                                        <span class="fw-semibold">Januari 2026</span>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light p-2 rounded-circle me-3"><i class="fas fa-check-circle text-success"></i></div>
                                    <div>
                                        <small class="d-block text-muted">Status</small>
                                        <span class="fw-semibold text-success">Aktif</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                
                <% String msg = request.getParameter("msg");
                   if ("updated".equals(msg)) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert">
                        <i class="fas fa-check-circle me-2"></i> Profil berhasil diperbarui.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if ("pass_changed".equals(msg)) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert">
                        <i class="fas fa-check-circle me-2"></i> Password berhasil diubah. Silakan login ulang jika diperlukan.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <% String error = request.getParameter("error");
                   if ("wrong_pass".equals(error)) { %>
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i> Password lama salah!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-header bg-white border-bottom py-3">
                        <ul class="nav nav-pills card-header-pills" id="profileTab" role="tablist">
                            <li class="nav-item">
                                <button class="nav-link active rounded-pill px-4" id="edit-tab" data-bs-toggle="tab" data-bs-target="#edit" type="button">Edit Profil</button>
                            </li>
                            <li class="nav-item">
                                <button class="nav-link rounded-pill px-4" id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button">Ganti Password</button>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="card-body p-4">
                        <div class="tab-content" id="profileTabContent">
                            
                            <div class="tab-pane fade show active" id="edit" role="tabpanel">
                                <form action="auth" method="post">
                                    <input type="hidden" name="action" value="updateProfile">
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-muted">Username</label>
                                            <input type="text" class="form-control bg-light" value="<%= user.getUsername() %>" disabled>
                                            <small class="text-muted" style="font-size: 0.75rem;">Username tidak dapat diubah.</small>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-muted">Nama Lengkap</label>
                                            <input type="text" name="fullname" class="form-control" value="<%= user.getFullName() %>" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label class="form-label small fw-bold text-muted">Email</label>
                                        <input type="email" name="email" class="form-control" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" placeholder="Masukkan email Anda">
                                    </div>
                                    
                                    <div class="d-flex justify-content-end">
                                        <button type="submit" class="btn btn-primary px-4 rounded-pill fw-bold">Simpan Perubahan</button>
                                    </div>
                                </form>
                            </div>
                            
                            <div class="tab-pane fade" id="password" role="tabpanel">
                                <form action="auth" method="post">
                                    <input type="hidden" name="action" value="changePassword">
                                    
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-muted">Password Lama</label>
                                        <input type="password" name="old_password" class="form-control" required>
                                    </div>
                                    
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-muted">Password Baru</label>
                                            <input type="password" name="new_password" class="form-control" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-muted">Konfirmasi Password Baru</label>
                                            <input type="password" class="form-control" required>
                                        </div>
                                    </div>
                                    
                                    <div class="alert alert-warning border-0 d-flex align-items-center" role="alert">
                                        <i class="fas fa-shield-alt fa-2x me-3 opacity-50"></i>
                                        <small>Gunakan password yang kuat dengan kombinasi huruf, angka, dan simbol untuk keamanan akun Anda.</small>
                                    </div>
                                    
                                    <div class="d-flex justify-content-end">
                                        <button type="submit" class="btn btn-danger px-4 rounded-pill fw-bold">Ganti Password</button>
                                    </div>
                                </form>
                            </div>
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@include file="includes/footer.jsp" %>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>