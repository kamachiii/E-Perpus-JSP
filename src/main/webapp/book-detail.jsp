<%@page import="java.util.List"%>
<%@page import="model.Book"%>
<%@page import="model.Review"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Book b = (Book) request.getAttribute("book");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    boolean isBookmarked = (Boolean) request.getAttribute("isBookmarked");
    
    double avgRating = 0;
    if(reviews != null && !reviews.isEmpty()){
        int sum = 0;
        for(Review r : reviews) sum += r.getRating();
        avgRating = (double) sum / reviews.size();
    }
    boolean hasReviewed = (Boolean) request.getAttribute("hasReviewed");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= b.getTitle() %> - Detail Buku</title>
    
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        .star-rating {
            display: inline-flex;
            flex-direction: row-reverse;
            gap: 5px;
        }

        .star-rating input[type="radio"] {
            display: none;
        }

        .star-rating label {
            font-size: 1.8rem;
            color: #e4e5e9;
            cursor: pointer;
            transition: color 0.2s ease-in-out;
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input[type="radio"]:checked ~ label {
            color: #ffc107; /* Warna Kuning Emas */
        }
        
        .star-rating input[type="radio"]:checked + label {
             animation: bounce 0.3s ease;
        }
        
        @keyframes bounce {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }
        
        .review-textarea {
            resize: none; 
            border-radius: 12px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
        }
        .review-textarea:focus {
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.15);
        }
    </style>
</head>
<body class="bg-light">
    <%@include file="includes/navbar.jsp" %>

    <div class="container py-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb bg-white p-3 rounded shadow-sm">
                <li class="breadcrumb-item"><a href="dashboard" class="text-decoration-none">Home</a></li>
                <li class="breadcrumb-item active fw-bold" aria-current="page"><%= b.getTitle() %></li>
            </ol>
        </nav>

        <div class="row g-5 mt-2">
            <div class="col-lg-4 col-md-5">
                <div class="card shadow-lg border-0 rounded-4 overflow-hidden position-relative">
                    <a href="bookmark?id=<%= b.getId() %>" class="position-absolute bg-white rounded-circle shadow-sm p-2 d-flex align-items-center justify-content-center text-decoration-none" style="top: 15px; right: 15px; width: 45px; height: 45px; z-index: 10;" title="Wishlist">
                         <% if(isBookmarked) { %>
                            <i class="fas fa-heart text-danger fa-lg"></i>
                        <% } else { %>
                            <i class="far fa-heart text-secondary fa-lg"></i>
                        <% } %>
                    </a>

                     <% if(b.getCoverImage() != null && !b.getCoverImage().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/uploads/<%= b.getCoverImage() %>" class="img-fluid w-100" alt="<%= b.getTitle() %>">
                    <% } else { %>
                        <div class="bg-light text-center py-5 d-flex align-items-center justify-content-center" style="height: 400px;">
                            <div class="text-muted">
                                <i class="fas fa-book fa-5x mb-3"></i><br>No Cover Available
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>

            <div class="col-lg-8 col-md-7">
                <div class="bg-white p-4 p-md-5 rounded-4 shadow-sm h-100">
                    <h1 class="fw-bold mb-2 display-6"><%= b.getTitle() %></h1>
                    <div class="mb-3 text-warning d-flex align-items-center">
                        <span class="me-2 fw-bold text-dark h5 mb-0"><%= String.format("%.1f", avgRating) %></span>
                        <i class="fas fa-star"></i>
                        <small class="text-muted ms-2">(<%= reviews != null ? reviews.size() : 0 %> Ulasan)</small>
                    </div>

                    <h5 class="text-muted mb-4 fst-italic">By <span class="fw-semibold text-dark"><%= b.getAuthor() %></span></h5>
                    
                    <div class="mb-4 d-flex flex-wrap gap-2">
                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill fs-6">
                            <i class="fas fa-layer-group me-1"></i> <%= b.getCategoryName() %>
                        </span>
                        <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill fs-6">
                            <i class="far fa-calendar-alt me-1"></i> <%= b.getYear() %>
                        </span>
                         <span class="badge bg-info bg-opacity-10 text-info px-3 py-2 rounded-pill fs-6">
                            <i class="far fa-building me-1"></i> <%= b.getPublisher() %>
                        </span>
                    </div>

                    <div class="card bg-light border-0 p-4 mb-5 rounded-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0">Ketersediaan</h5>
                             <% if (b.getStock() > 0) { %>
                                <span class="badge bg-success px-3 py-2 rounded-pill">Tersedia: <%= b.getStock() %> Buku</span>
                            <% } else { %>
                                <span class="badge bg-danger px-3 py-2 rounded-pill">Stok Habis</span>
                            <% } %>
                        </div>
                        
                        <form action="loans" method="post">
                            <input type="hidden" name="action" value="borrow">
                            <input type="hidden" name="book_id" value="<%= b.getId() %>">
                            <button type="submit" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold shadow-sm py-3" <%= b.getStock() > 0 ? "" : "disabled" %>>
                                <i class="fas fa-book-reader me-2 fa-lg"></i> <%= b.getStock() > 0 ? "PINJAM BUKU INI" : "STOK SEDANG KOSONG" %>
                            </button>
                        </form>
                    </div>

                    <hr class="my-5 text-muted opacity-25">

                    <h3 class="fw-bold mb-4"><i class="fas fa-star text-warning me-2"></i>Ulasan Pembaca</h3>

                    <% if (!hasReviewed) { %>

                        <div class="card bg-white border shadow-sm mb-5 rounded-4 overflow-hidden">
                            <div class="card-header bg-light border-bottom py-3">
                                 <h6 class="fw-bold mb-0"><i class="fas fa-pen-nib me-2"></i>Tulis Ulasan Anda</h6>
                            </div>
                            <div class="card-body p-4">
                                <form action="<%= request.getContextPath() %>/review" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="book_id" value="<%= b.getId() %>">

                                    <div class="mb-4 text-center">
                                        <p class="mb-2 fw-semibold text-muted small">Berikan rating Anda:</p>
                                        <div class="star-rating">
                                            <input type="radio" id="star5" name="rating" value="5" required /><label for="star5" title="5"><i class="fas fa-star"></i></label>
                                            <input type="radio" id="star4" name="rating" value="4" /><label for="star4" title="4"><i class="fas fa-star"></i></label>
                                            <input type="radio" id="star3" name="rating" value="3" /><label for="star3" title="3"><i class="fas fa-star"></i></label>
                                            <input type="radio" id="star2" name="rating" value="2" /><label for="star2" title="2"><i class="fas fa-star"></i></label>
                                            <input type="radio" id="star1" name="rating" value="1" /><label for="star1" title="1"><i class="fas fa-star"></i></label>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <textarea name="comment" class="form-control review-textarea p-3" rows="3" placeholder="Bagaimana pendapat Anda tentang buku ini?" required></textarea>
                                    </div>
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-dark rounded-pill fw-bold py-2">Kirim Ulasan</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                    <% } else { %>

                        <div class="alert alert-info border-0 shadow-sm rounded-4 mb-5 d-flex align-items-center" role="alert">
                            <div class="bg-white text-info rounded-circle d-flex align-items-center justify-content-center shadow-sm me-3" style="width: 40px; height: 40px;">
                                <i class="fas fa-check"></i>
                            </div>
                            <div>
                                <strong>Terima kasih!</strong> Anda sudah memberikan ulasan untuk buku ini. 
                                <br><small>Anda dapat mengubah ulasan Anda pada daftar di bawah.</small>
                            </div>
                        </div>

                    <% } %>

                    <div class="review-list mt-5">
                        <h5 class="fw-bold mb-4">Semua Ulasan (<%= reviews != null ? reviews.size() : 0 %>)</h5>
                        <% 
                        User currentUser = (User) session.getAttribute("currentUser");
                        int currentUserId = (currentUser != null) ? currentUser.getId() : 0;

                        if(reviews != null && !reviews.isEmpty()) { 
                            for(Review r : reviews) { 
                                boolean isMyReview = (r.getUserId() == currentUserId);
                        %>
                            <div class="d-flex mb-4 pb-4 border-bottom">
                                <div class="flex-shrink-0">
                                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold shadow-sm" style="width: 50px; height: 50px; font-size: 1.2rem;">
                                        <%= r.getUserName().charAt(0) %>
                                    </div>
                                </div>
                                <div class="flex-grow-1 ms-3 bg-light p-3 rounded-4 position-relative">

                                    <% if(isMyReview) { %>
                                    <div class="position-absolute top-0 end-0 p-3">
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-link text-muted p-0" type="button" data-bs-toggle="dropdown">
                                                <i class="fas fa-ellipsis-v"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm">
                                                <li>
                                                    <a class="dropdown-item small" href="#" 
                                                       data-bs-toggle="modal" 
                                                       data-bs-target="#editReviewModal"
                                                       data-id="<%= r.getId() %>"
                                                       data-rating="<%= r.getRating() %>"
                                                       data-comment="<%= r.getComment() %>">
                                                       <i class="fas fa-pen me-2 text-warning"></i> Edit
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item small text-danger" 
                                                       href="review?action=delete&id=<%= r.getId() %>&book_id=<%= b.getId() %>"
                                                       onclick="return confirm('Hapus ulasan ini?')">
                                                       <i class="fas fa-trash me-2"></i> Hapus
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <% } %>

                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h6 class="mb-0 fw-bold text-dark">
                                            <%= r.getUserName() %> 
                                            <% if(isMyReview) { %> <span class="badge bg-primary ms-2" style="font-size: 0.6rem;">ANDA</span> <% } %>
                                        </h6>
                                        <span class="small text-muted me-4"><%= r.getCreatedAt().toString().substring(0, 16) %></span>
                                    </div>

                                    <div class="text-warning small mb-2">
                                        <% for(int i=1; i<=5; i++) { 
                                             if(i <= r.getRating()) { %> <i class="fas fa-star"></i> <% } 
                                             else { %> <i class="far fa-star"></i> <% }
                                        } %>
                                        <span class="ms-2 text-muted fw-semibold">(<%= r.getRating() %>.0)</span>
                                    </div>

                                    <p class="mb-0 text-secondary" style="line-height: 1.6;"><%= r.getComment() %></p>
                                </div>
                            </div>
                        <% } } else { %>
                            <div class="text-center py-5 text-muted bg-light rounded-4">
                                <i class="far fa-comment-dots fa-3x mb-3 opacity-50"></i>
                                <p class="fst-italic mb-0">Belum ada ulasan.</p>
                            </div>
                        <% } %>
                    </div>

                    <div class="modal fade" id="editReviewModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg rounded-4">
                                <div class="modal-header border-0 pb-0">
                                    <h5 class="modal-title fw-bold">Edit Ulasan</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <form action="review" method="post">
                                        <input type="hidden" name="action" value="update"> <input type="hidden" name="book_id" value="<%= b.getId() %>">
                                        <input type="hidden" name="review_id" id="editReviewId">

                                        <div class="mb-3 text-center">
                                            <p class="mb-2 fw-semibold text-muted small">Ubah rating:</p>
                                            <div class="star-rating">
                                                <input type="radio" id="e-star5" name="rating" value="5" /><label for="e-star5"><i class="fas fa-star"></i></label>
                                                <input type="radio" id="e-star4" name="rating" value="4" /><label for="e-star4"><i class="fas fa-star"></i></label>
                                                <input type="radio" id="e-star3" name="rating" value="3" /><label for="e-star3"><i class="fas fa-star"></i></label>
                                                <input type="radio" id="e-star2" name="rating" value="2" /><label for="e-star2"><i class="fas fa-star"></i></label>
                                                <input type="radio" id="e-star1" name="rating" value="1" /><label for="e-star1"><i class="fas fa-star"></i></label>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-muted">Komentar:</label>
                                            <textarea name="comment" id="editComment" class="form-control review-textarea" rows="3" required></textarea>
                                        </div>

                                        <div class="d-grid">
                                            <button type="submit" class="btn btn-primary fw-bold rounded-pill">Simpan Perubahan</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@include file="includes/footer.jsp" %>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var editModal = document.getElementById('editReviewModal');
            editModal.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget;

                var id = button.getAttribute('data-id');
                var rating = button.getAttribute('data-rating');
                var comment = button.getAttribute('data-comment');

                document.getElementById('editReviewId').value = id;
                document.getElementById('editComment').value = comment;

                if(rating) {
                    document.getElementById('e-star' + rating).checked = true;
                }
            });
        });
    </script>
</body>
</html>