<%-- 
    Document   : register.jsp
    Created on : Jan 6, 2026, 8:16:18 AM
    Author     : hengk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - E-Library Scholar</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        /* Specific Styles for Login Page */
        body.login-body {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            /* Subtle pattern or gradient */
            background: linear-gradient(135deg, #f4f6f9 0%, #eef2f3 100%);
        }

        .login-card {
            width: 100%;
            max-width: 700px;
            padding: 2rem;
        }

        .login-logo {
            width: 60px;
            height: 60px;
            background-color: var(--color-dominant);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            margin: 0 auto 1.5rem;
            box-shadow: 0 10px 20px rgba(44, 62, 80, 0.2);
        }
    </style>
</head>
<body class="login-body">
    <div class="card card-custom login-card text-center">
        <div class="card-body p-4">
            <div class="login-logo">
                <i class="fas fa-user-plus"></i> </div>
            <h4 class="mb-1 fw-bold">Create Account</h4>
            <p class="text-muted mb-4 small">Join E-Library Scholar Today</p>

            <% 
                String error = request.getParameter("error");
                if ("failed".equals(error)) { 
            %>
                <div class="alert alert-danger small p-2">Registrasi gagal! Username mungkin sudah digunakan.</div>
            <% } %>

            <form id="registerForm" action="auth" method="post">
                <input type="hidden" name="action" value="register">
                <div class="row">
                    <div class="col mb-3 text-start">
                        <label for="fullname" class="form-label small fw-bold text-muted ms-3">Full Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-transparent border-0 position-absolute" style="z-index: 10; left: 10px; top: 10px;">
                                <i class="fas fa-user text-muted"></i>
                            </span>
                            <input type="text" name="fullname" class="form-control form-control-custom ps-5" id="fullname" placeholder="e.g. John Doe" required>
                        </div>
                    </div>
                    <div class="col mb-3 text-start">
                        <label for="username" class="form-label small fw-bold text-muted ms-3">Username</label>
                        <div class="input-group">
                            <span class="input-group-text bg-transparent border-0 position-absolute" style="z-index: 10; left: 10px; top: 10px;">
                                <i class="fas fa-user text-muted"></i>
                            </span>
                            <input type="text" name="username" class="form-control form-control-custom ps-5" id="username" placeholder="Enter your ID" required>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col mb-3 text-start">
                        <label for="email" class="form-label small fw-bold text-muted ms-3">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-transparent border-0 position-absolute" style="z-index: 10; left: 10px; top: 10px;">
                                <i class="fas fa-user text-muted"></i>
                            </span>
                            <input type="text" name="email" class="form-control form-control-custom ps-5" id="email" placeholder="student@university.ac.id" required>
                        </div>
                    </div>
                    <div class="col mb-4 text-start">
                        <label for="password" class="form-label small fw-bold text-muted ms-3">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-transparent border-0 position-absolute" style="z-index: 10; left: 10px; top: 10px;">
                                <i class="fas fa-lock text-muted"></i>
                            </span>
                            <input type="password" name="password" class="form-control form-control-custom ps-5" id="password" placeholder="Enter password" required>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary-custom w-100 mb-3 shadow">
                    Sign Up
                </button>

                <div class="text-center">
                    <a href="login" class="text-decoration-none fw-bold" style="color: var(--color-accent);">Sign In</a>
                </div>
            </form>
        </div>
    </div>

    <script src="assets/js/bootstrap.bundle.min.js "></script>
</body>
</html>
