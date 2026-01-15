<%-- 
    Document   : loans
    Created on : Jan 7, 2026, 9:25:53 AM
    Author     : hengk
--%>

<%@page import="java.util.List"%>
<%@page import="model.Loan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestUri = request.getRequestURI();
    String contextPath = request.getContextPath();
    String currentPage = requestUri.substring(contextPath.length());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Loans - Admin Panel</title>
    
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    
    <style>
        .table-custom {
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .table-custom thead { background-color: #34495e; color: white; }
        .table-custom th { padding: 16px; font-weight: 600; border: none; }
        .table-custom td { padding: 16px; vertical-align: middle; border-bottom: 1px solid #edf2f7; background-color: white; }
        .table-custom tr:nth-child(even) td { background-color: #f8fafc; }
        .table-custom tr:hover td { background-color: #f1f4f8; }
        
        /* Status Badge Style */
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .status-borrowed { background-color: #fff3cd; color: #856404; }
        .status-returned { background-color: #d4edda; color: #155724; }
        
        .sidebar { height: 100vh; background-color: white; border-right: 1px solid #eee; position: sticky; top: 0; }
        .nav-link-admin { color: #7f8c8d; padding: 12px 20px; border-radius: 8px; margin-bottom: 4px; font-weight: 500; text-decoration: none; display: block; }
        .nav-link-admin:hover, .nav-link-admin.active { background-color: #ecf3fe; color: #0d6efd; }
    </style>
</head>
<body class="bg-light">

    <div class="d-flex">
        <%@include file="../includes/sidebar.jsp" %>

        <div class="flex-grow-1 p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                   <h2 class="h4 fw-bold">Loan Management</h2>
                   <p class="text-muted small">Monitor active loans and process returns.</p>
                </div>
                <a href="<%= request.getContextPath() %>/loans?action=list" class="btn btn-outline-primary btn-sm"><i class="fas fa-sync-alt me-2"></i>Refresh Data</a>
            </div>

            <div class="card border-0 shadow-sm p-0 rounded-4 overflow-hidden">
                <table class="table-custom mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Member Name</th>
                            <th>Book Title</th>
                            <th>Loan Date</th>
                            <th>Due Date</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Loan> loans = (List<Loan>) request.getAttribute("loanList");
                            
                            if (loans != null && !loans.isEmpty()) {
                                for (Loan l : loans) {
                                    boolean isBorrowed = "borrowed".equalsIgnoreCase(l.getStatus());
                        %>
                        <tr>
                            <td class="text-muted">#<%= l.getId() %></td>
                            <td class="fw-bold text-dark"><%= l.getMemberName() %></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <% if(l.getBookCover() != null) { %>
                                        <img src="<%= request.getContextPath() %>/uploads/<%= l.getBookCover() %>" class="rounded me-2" style="width: 30px; height: 40px; object-fit: cover;">
                                    <% } else { %>
                                        <i class="fas fa-book text-muted me-2"></i>
                                    <% } %>
                                    <%= l.getBookTitle() %>
                                </div>
                            </td>
                            <td><%= l.getLoanDate() %></td>
                            <td>
                                <% if(isBorrowed) { %>
                                    <span class="text-danger fw-bold"><%= l.getDueDate() %></span>
                                <% } else { %>
                                    <span class="text-muted"><%= l.getDueDate() %></span>
                                <% } %>
                            </td>
                            <td>
                                <% if(isBorrowed) { %>
                                    <span class="status-badge status-borrowed"><i class="fas fa-clock me-1"></i> Active</span>
                                <% } else { %>
                                    <span class="status-badge status-returned"><i class="fas fa-check-circle me-1"></i> Returned</span>
                                    <br><small class="text-muted" style="font-size: 0.75rem;">on <%= l.getReturnDate() %></small>
                                <% } %>
                            </td>
                            <td class="text-end">
                                <% if(isBorrowed) { %>
                                    <a href="<%= request.getContextPath() %>/loans?action=return&id=<%= l.getId() %>&book_id=<%= l.getBookId() %>" 
                                       class="btn btn-success btn-sm rounded-pill px-3"
                                       onclick="return confirm('Proses pengembalian buku ini?')">
                                        <i class="fas fa-undo-alt me-1"></i> Return
                                    </a>
                                <% } else { %>
                                    <button class="btn btn-secondary btn-sm rounded-pill px-3" disabled>Completed</button>
                                <% } %>
                            </td>
                        </tr>
                        <% 
                                } 
                            } else { 
                        %>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <img src="<%= request.getContextPath() %>/assets/images/empty.svg" style="width: 80px; opacity: 0.5;" class="mb-3 d-block mx-auto">
                                    Belum ada data peminjaman.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>