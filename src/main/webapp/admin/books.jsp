<%@page import="java.util.List"%>
<%@page import="model.Book"%>
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
    <title>Admin Books - E-Library Scholar</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            box-shadow: 0 4px 6px rgba(0,0,0,0.05); /* Fixed shadow var */
        }
        .table-custom thead { background-color: #34495e; color: white; }
        .table-custom th { padding: 16px; font-weight: 600; border: none; }
        .table-custom td { padding: 16px; vertical-align: middle; border-bottom: 1px solid #edf2f7; background-color: white; }
        .table-custom tr:nth-child(even) td { background-color: #f8fafc; }
        .table-custom tr:hover td { background-color: #f1f4f8; }
        .btn-action { width: 32px; height: 32px; padding: 0; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; transition: all 0.2s; }
        .btn-edit { background-color: #f39c12; color: white; border: none; }
        .btn-edit:hover { background-color: #d35400; color: white; }
        .btn-delete { background-color: #e74c3c; color: white; border: none; }
        .btn-delete:hover { background-color: #c0392b; color: white; }
        .sidebar { height: 100vh; background-color: white; border-right: 1px solid #eee; position: sticky; top: 0; }
        .nav-link-admin { color: #7f8c8d; padding: 12px 20px; border-radius: 8px; margin-bottom: 4px; font-weight: 500; text-decoration: none; display: block; }
        .nav-link-admin:hover, .nav-link-admin.active { background-color: #ecf3fe; color: #0d6efd; } /* Fixed var color */
    </style>
</head>
<body class="bg-light">
    <div class="d-flex">
        <%@include file="../includes/sidebar.jsp" %>

        <div class="flex-grow-1 p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                   <h2 class="h4 fw-bold">Book Management</h2>
                   <p class="text-muted small">Manage your library collection.</p>
                </div>
                <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addBookModal"><i class="fas fa-plus me-2"></i> Add New Book</button>
            </div>

            <div class="card border-0 shadow-sm p-0 rounded-4 overflow-hidden">
                <table class="table-custom mb-0">
                    <thead>
                        <tr>
                            <th>#ID</th>
                            <th>Cover</th>
                            <th>Book Title</th>
                            <th>Author</th>
                            <th>Category</th>
                            <th>Stock</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Book> books = (List<Book>) request.getAttribute("listBooks");
                            if (books != null && !books.isEmpty()) {
                                for (Book b : books) {
                        %>
                        <tr>
                            <td class="text-muted">#<%=b.getId() %></td>
                            <td>
                                <% if(b.getCoverImage() != null && !b.getCoverImage().isEmpty()) { %>
                                    <img src="${pageContext.request.contextPath}/uploads/<%= b.getCoverImage() %>" 
                                        class="rounded shadow-sm" 
                                        style="width: 45px; height: 60px; object-fit: cover;"
                                        alt="<%= b.getTitle() %>">
                                <% } else { %>
                                    <div class="bg-light rounded d-flex align-items-center justify-content-center" style="width: 45px; height: 60px;">
                                        <i class="fas fa-book text-muted"></i>
                                    </div>
                                <% } %>
                            </td>
                            <td>
                                <div class="fw-bold" style="color: #2c3e50;"><%=b.getTitle() %></div>
                                <small class="text-muted"><%= b.getPublisher() %> (<%= b.getYear() %>)</small>
                            </td>
                            <td><%=b.getAuthor() %></td>
                            <td><span class="badge bg-light text-dark border"><%= b.getCategoryName() != null ? b.getCategoryName() : "General" %></span></td>
                            <td>
                                <% if(b.getStock() > 0) { %>
                                    <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill"><%= b.getStock() %> Available</span>
                                <% } else { %>
                                    <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill">Out of Stock</span>
                                <% } %>
                            </td>
                            <td class="text-end">
                                <button type="button" class="btn btn-action btn-edit me-1" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#editBookModal"
                                        data-id="<%= b.getId() %>"
                                        data-title="<%= b.getTitle() %>"
                                        data-author="<%= b.getAuthor() %>"
                                        data-publisher="<%= b.getPublisher() %>"
                                        data-year="<%= b.getYear() %>"
                                        data-stock="<%= b.getStock() %>"
                                        data-category="<%= b.getCategoryId() %>"
                                        data-cover="<%= b.getCoverImage() %>">
                                    <i class="fas fa-pen small"></i>
                                </button>

                                <button type="button" class="btn btn-action btn-delete" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#deleteModal"
                                        data-id="<%= b.getId() %>">
                                    <i class="fas fa-trash small"></i>
                                </button>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="7" class="text-center py-4">No books found. Please add a new book.</td>
                            </tr>
                        <% 
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!--Add Modal Book-->
    <div class="modal fade" id="addBookModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Add New Book</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/books" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Book Title</label>
                                    <input type="text" name="title" class="form-control" placeholder="e.g. Design Patterns" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Author</label>
                                    <input type="text" name="author" class="form-control" placeholder="e.g. Erich Gamma" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Publisher</label>
                                    <input type="text" name="publisher" class="form-control" placeholder="e.g. Pearson" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <label class="form-label small text-muted fw-bold">Year</label>
                                        <input type="number" name="year" class="form-control" placeholder="2024" required>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label small text-muted fw-bold">Stock</label>
                                        <input type="number" name="stock" class="form-control" placeholder="10" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Category</label>
                                    <select name="category_id" class="form-select">
                                        <option value="1">Technology</option>
                                        <option value="2">Fiction</option>
                                        <option value="3">History</option>
                                        <option value="4">Science</option>
                                        <option value="5">Self Help</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Cover Image</label>
                                    <input type="file" name="cover" class="form-control" accept="image/*">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Save Book</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Book Modal -->
    <div class="modal fade" id="editBookModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Edit Book</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/books" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editId">
                    <input type="hidden" name="old_cover" id="editOldCover"> <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Book Title</label>
                                    <input type="text" name="title" id="editTitle" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Author</label>
                                    <input type="text" name="author" id="editAuthor" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Publisher</label>
                                    <input type="text" name="publisher" id="editPublisher" class="form-control" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <label class="form-label small text-muted fw-bold">Year</label>
                                        <input type="number" name="year" id="editYear" class="form-control" required>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label small text-muted fw-bold">Stock</label>
                                        <input type="number" name="stock" id="editStock" class="form-control" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Category</label>
                                    <select name="category_id" id="editCategory" class="form-select">
                                        <option value="1">Technology</option>
                                        <option value="2">Fiction</option>
                                        <option value="3">History</option>
                                        <option value="4">Science</option>
                                        <option value="5">Self Help</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-muted fw-bold">Cover Image (Optional)</label>
                                    <input type="file" name="cover" class="form-control" accept="image/*">
                                    <small class="text-muted">Biarkan kosong jika tidak ingin mengganti cover.</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Update Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-body text-center p-4">
                    <div class="bg-danger bg-opacity-10 text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                        <i class="fas fa-trash-alt fa-lg"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Delete Book?</h5>
                    <p class="text-muted small mb-4">You are about to delete this item. This action cannot be undone.</p>
                    <div class="d-grid gap-2">
                        <a id="btnConfirmDelete" href="#" class="btn btn-danger rounded-pill">Yes, Delete</a>
                        <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/assets/js/admin.js"></script>
    <script>
        var editModal = document.getElementById('editBookModal');
        editModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            
            var id = button.getAttribute('data-id');
            var title = button.getAttribute('data-title');
            var author = button.getAttribute('data-author');
            var publisher = button.getAttribute('data-publisher');
            var year = button.getAttribute('data-year');
            var stock = button.getAttribute('data-stock');
            var category = button.getAttribute('data-category');
            var oldCover = button.getAttribute('data-cover');

            document.getElementById('editId').value = id;
            document.getElementById('editOldCover').value = oldCover;
            document.getElementById('editTitle').value = title;
            document.getElementById('editAuthor').value = author;
            document.getElementById('editPublisher').value = publisher;
            document.getElementById('editYear').value = year;
            document.getElementById('editStock').value = stock;
            document.getElementById('editCategory').value = category;
        });

        var deleteModal = document.getElementById('deleteModal');
        deleteModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');

            var confirmBtn = document.getElementById('btnConfirmDelete');
            confirmBtn.href = "${pageContext.request.contextPath}/books?action=delete&id=" + id;
        });
    </script>
</body>
</html>