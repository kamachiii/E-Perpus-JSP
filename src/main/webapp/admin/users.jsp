<%@page import="java.util.List"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestUri = request.getRequestURI();
    String contextPath = request.getContextPath();
    String currentPage = requestUri.substring(contextPath.length());
    
    List<User> users = (List<User>) request.getAttribute("userList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin</title>
    
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body class="bg-light">

    <div class="d-flex">
        <%@include file="../includes/sidebar.jsp" %>

        <div class="flex-grow-1 p-4 p-md-5">
            <h2 class="fw-bold mb-4">Member Management</h2>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="card-header bg-white py-3 border-bottom">
                    <h6 class="mb-0 fw-bold text-muted">Daftar Anggota Terdaftar</h6>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="p-3 border-0">ID</th>
                                <th class="p-3 border-0">Nama Lengkap</th>
                                <th class="p-3 border-0">Username / Email</th>
                                <th class="p-3 border-0">Role</th>
                                <th class="p-3 border-0 text-end">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (users != null && !users.isEmpty()) {
                                for (User u : users) {
                            %>
                            <tr>
                                <td class="p-3 text-muted">#<%= u.getId() %></td>
                                <td class="p-3">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 35px; height: 35px; font-size: 0.9rem;">
                                            <%= u.getFullName().substring(0,1).toUpperCase() %>
                                        </div>
                                        <span class="fw-bold"><%= u.getFullName() %></span>
                                    </div>
                                </td>
                                <td class="p-3">
                                    <div class="small text-dark fw-semibold"><%= u.getUsername() %></div>
                                    <div class="small text-muted"><%= u.getEmail() %></div>
                                </td>
                                <td class="p-3">
                                    <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 rounded-pill text-uppercase" style="font-size: 0.7rem;">
                                        <%= u.getRole() %>
                                    </span>
                                </td>
                                <td class="p-3 text-end">
                                    <a href="users?action=delete&id=<%= u.getId() %>" 
                                       class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                       onclick="return confirm('Yakin ingin menghapus user ini? Semua data peminjaman terkait juga akan terhapus.')">
                                        <i class="fas fa-trash-alt me-1"></i> Hapus
                                    </a>
                                </td>
                            </tr>
                            <% 
                                } 
                            } else { 
                            %>
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    <img src="<%= request.getContextPath() %>/assets/images/empty.svg" width="100" class="mb-3 opacity-50"><br>
                                    Belum ada member yang terdaftar.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>