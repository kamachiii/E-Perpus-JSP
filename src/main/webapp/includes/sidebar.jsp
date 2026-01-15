<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="sidebar bg-white border-end p-4 d-flex flex-column" style="width: 260px; min-height: 100vh;">
    <div class="d-flex align-items-center mb-5">
         <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 40px; height: 40px;">
            <i class="fas fa-shield-alt"></i>
         </div>
         <h5 class="fw-bold mb-0">Admin Panel</h5>
    </div>

    <nav class="nav flex-column flex-grow-1">
        <a class="nav-link-admin <%= currentPage.contains("dashboard") ? "active" : "" %>" href="dashboard">
            <i class="fas fa-home me-2"></i> Dashboard
        </a>
        <a class="nav-link-admin <%= currentPage.contains("books") ? "active" : "" %>" href="books">
            <i class="fas fa-book me-2"></i> Manage Books
        </a>
        <a class="nav-link-admin <%= currentPage.contains("categories") ? "active" : "" %>" href="categories">
            <i class="fas fa-layer-group me-2"></i> Categories
        </a>
        <a class="nav-link-admin <%= currentPage.contains("loans") ? "active" : "" %>" href="loans">
            <i class="fas fa-clipboard-list me-2"></i> Loan Requests
        </a>
        <a class="nav-link-admin <%= currentPage.contains("users") ? "active" : "" %>" href="users">
            <i class="fas fa-users me-2"></i> Users
        </a>
    </nav>

    <div class="mt-auto pt-5">
        <a href="<%= request.getContextPath() %>/auth?action=logout" class="nav-link-admin text-danger">
            <i class="fas fa-sign-out-alt me-2"></i> Logout
        </a>
    </div>
</div>