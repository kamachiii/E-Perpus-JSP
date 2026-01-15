<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestUri = request.getRequestURI();
    String contextPath = request.getContextPath();
    String currentPage = requestUri.substring(contextPath.length());
    
    List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("categoryList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - Admin</title>
    
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body class="bg-light">

    <div class="d-flex">
        <%@include file="../includes/sidebar.jsp" %>

        <div class="flex-grow-1 p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="h4 fw-bold">Manage Categories</h2>
                <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <i class="fas fa-plus me-2"></i>Add Category
                </button>
            </div>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="p-3 border-0">ID</th>
                                <th class="p-3 border-0">Category Name</th>
                                <th class="p-3 border-0 text-center">Total Books</th>
                                <th class="p-3 border-0 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (categories != null && !categories.isEmpty()) {
                                for (Map<String, Object> cat : categories) {
                            %>
                            <tr>
                                <td class="p-3 text-muted">#<%= cat.get("id") %></td>
                                <td class="p-3 fw-bold"><%= cat.get("name") %></td>
                                <td class="p-3 text-center">
                                    <span class="badge bg-info bg-opacity-10 text-info rounded-pill px-3">
                                        <%= cat.get("count") %> Books
                                    </span>
                                </td>
                                <td class="p-3 text-end">
                                    <button class="btn btn-sm btn-light text-primary me-1" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editCategoryModal"
                                            data-id="<%= cat.get("id") %>"
                                            data-name="<%= cat.get("name") %>">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                    <a href="categories?action=delete&id=<%= cat.get("id") %>" 
                                       class="btn btn-sm btn-light text-danger"
                                       onclick="return confirm('Hapus kategori ini? Buku yang ada di kategori ini mungkin akan kehilangan kategorinya.')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% 
                                }
                            } else { 
                            %>
                            <tr>
                                <td colspan="4" class="text-center py-5 text-muted">Belum ada kategori.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addCategoryModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">New Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="categories" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label small text-muted fw-bold">Name</label>
                            <input type="text" name="name" class="form-control" required placeholder="e.g. Technology">
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Create</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editCategoryModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Edit Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="categories" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label small text-muted fw-bold">Name</label>
                            <input type="text" name="name" id="editName" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        var editModal = document.getElementById('editCategoryModal');
        editModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            var name = button.getAttribute('data-name');
            
            document.getElementById('editId').value = id;
            document.getElementById('editName').value = name;
        });
    </script>
</body>
</html>