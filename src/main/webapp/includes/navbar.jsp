<%@page import="model.User" %>

<%
    User navUser = (User) session.getAttribute("currentUser");
    
    if (navUser == null) {
        response.sendRedirect("login");
        return;
    };

    String requestUri = request.getRequestURI();
    String contextPath = request.getContextPath();
    String currentPage = requestUri.substring(contextPath.length());
    
    String nama = navUser.getFullName();
    String[] kata = nama.toUpperCase().split(" ");

    String inisial = (kata.length >= 2) ? (kata[0].charAt(0) + "" + kata[1].charAt(0)) : kata[0].charAt(0) + "";
%>

<nav class="navbar navbar-expand-lg navbar-dark navbar-floating sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="dashboard">
            <div class="bg-white text-dominant rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px; font-size: 16px;">
                <i class="fas fa-book-open"></i>
            </div>
            <span>E-Library</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link <%= currentPage.contains("dashboard") ? "active" : "" %>" href="dashboard"><i class="fas fa-home me-1"></i> Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= currentPage.contains("categories") ? "active" : "" %>" href="categories"><i class="fas fa-layer-group me-1"></i> Categories</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= currentPage.contains("loans") ? "active" : "" %>" href="loans"><i class="fas fa-book-open-reader me-1"></i> My Loans</a>
                </li>
            </ul>
            <div class="d-flex align-items-center dropdown">
                <div class="profile-dropdown-btn dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="profile-avatar"><%= inisial %></div>
                    <span class="small fw-semibold"><%= nama %></span>
                </div>
                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-4 mt-2 p-2">
                    <li><a class="dropdown-item rounded-3 small py-2" href="profile"><i class="fas fa-user-circle me-2 text-muted"></i>Profile</a></li>
                    <li><a class="dropdown-item rounded-3 small py-2" href="wishlist"><i class="fas fa-heart me-2 text-muted"></i>Wishlist</a></li>
                    <li><hr class="dropdown-divider my-1"></li>
                    <li><a class="dropdown-item rounded-3 small py-2 text-danger" href="logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>