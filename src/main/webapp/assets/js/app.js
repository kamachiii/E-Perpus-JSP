/**
 * Modern Minimalist Scholar - Main Application Logic
 * Simulates backend features using LocalStorage and DOM manipulation.
 */

document.addEventListener('DOMContentLoaded', () => {
    // Initialize Tooltips/Popovers if installed (Bootstrap)
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    });

    // Handle Search on Dashboard
    const searchInput = document.querySelector('input[placeholder="Search books..."]');
    if (searchInput) {
        searchInput.addEventListener('keyup', (e) => {
            const term = e.target.value.toLowerCase();
            const cards = document.querySelectorAll('.col'); // Assuming .col contains the card

            cards.forEach(card => {
                const title = card.querySelector('.card-title')?.innerText.toLowerCase() || '';
                const author = card.querySelector('.card-text')?.innerText.toLowerCase() || '';

                if (title.includes(term) || author.includes(term)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }

    // Handle "Borrow" Buttons
    // Note: In a real app, we'd use IDs. Here we'll scrape the DOM for demo purposes.
    const borrowButtons = document.querySelectorAll('.btn-primary-custom, .stretched-link');
    // We only attach to specific "Borrow Now" buttons or details links?
    // Actually, let's target specific "Borrow" buttons if they exist, or links to details.

    // Let's implement a specific "Add to Loans" function mockup
    window.mockBorrow = (title, author) => {
        // Simple mock data object
        const newLoan = {
            title: title,
            author: author,
            dueDate: 'Jan 05, 2026',
            daysLeft: 7,
            status: 'Active',
            progress: 100
        };

        let loans = JSON.parse(localStorage.getItem('loans')) || [];
        loans.push(newLoan);
        localStorage.setItem('loans', JSON.stringify(loans));

        showToast(`Successfully borrowed "${title}"!`);
    };

    // Render Loans if on loans page
    const loansContainer = document.getElementById('loans-container');
    if (loansContainer) {
        renderLoans();
    }
});

// Toast Notification Logic
function showToast(message) {
    // Create toast container if not exists
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        document.body.appendChild(toastContainer);
    }

    const toastHtml = `
        <div class="toast align-items-center text-white bg-success border-0 show" role="alert">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i> ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    `;

    const toastEl = document.createElement('div');
    toastEl.innerHTML = toastHtml;
    toastContainer.appendChild(toastEl.firstElementChild);

    // Auto remove
    setTimeout(() => {
        const t = toastContainer.querySelector('.toast');
        if(t) t.remove();
    }, 3000);
}

// Render Loans from LocalStorage (or Mock Data if empty)
function renderLoans() {
    const container = document.getElementById('loans-container');
    if (!container) return; // Not on loans page

    let loans = JSON.parse(localStorage.getItem('loans'));

    // Seed initial data if empty for demo purposes
    if (!loans || loans.length === 0) {
        loans = [
            { title: "Atomic Habits", author: "James Clear", dueDate: "Dec 30, 2025", daysLeft: 2, status: "Due Soon", type: "warning", progress: 80 },
            { title: "Refactoring", author: "Martin Fowler", dueDate: "Jan 15, 2026", daysLeft: 14, status: "Active", type: "success", progress: 20 },
            { title: "Thinking, Fast and Slow", author: "Daniel Kahneman", dueDate: "Dec 20, 2025", daysLeft: -8, status: "Overdue", type: "danger", progress: 100, fine: "Rp 16.000" }
        ];
        localStorage.setItem('loans', JSON.stringify(loans));
    }

    container.innerHTML = ''; // Clear static HTML

    loans.forEach((loan, index) => {
        let badgeClass = loan.type === 'danger' ? 'bg-danger text-white' :
                         loan.type === 'warning' ? 'bg-warning text-dark bg-opacity-25 border border-warning' :
                         'bg-success bg-opacity-10 text-success border border-success';

        // Handle Overdue specific logic
        let timeLeftHtml = `<span class="text-${loan.type} fw-bold">${loan.daysLeft > 0 ? loan.daysLeft + ' Days Left' : 'Late by ' + Math.abs(loan.daysLeft) + ' Days'}</span>`;
        let fineHtml = loan.fine ? `
            <div class="mt-3 text-center small">
                <span class="text-danger fw-bold">Fine: ${loan.fine}</span>
                <br>
                <button class="btn btn-sm btn-danger w-100 mt-1 rounded-pill" onclick="returnBook(${index})">Pay & Return</button>
            </div>` : `
            <button class="btn btn-sm btn-outline-primary w-100 mt-3 rounded-pill" onclick="returnBook(${index})">Return Book</button>
            `;

        const html = `
        <div class="col-md-6 col-lg-4">
            <div class="card card-custom h-100 p-3 ${loan.type === 'danger' ? 'border-danger border-1' : ''}">
                <div class="d-flex gap-3">
                    <div class="bg-light rounded d-flex align-items-center justify-content-center flex-shrink-0" style="width: 80px; height: 110px;">
                        <i class="fas fa-book fa-2x text-muted"></i>
                    </div>
                    <div class="flex-grow-1">
                        <h6 class="fw-bold mb-1"${loan.title}</h6>
                        <small class="text-muted d-block mb-2">${loan.author}</small>
                        <span class="badge ${badgeClass} rounded-pill px-2">${loan.status}</span>
                    </div>
                </div>
                <div class="mt-3">
                    <div class="d-flex justify-content-between small mb-1">
                        <span class="text-muted">Due Date: <strong>${loan.dueDate}</strong></span>
                        ${timeLeftHtml}
                    </div>
                    <div class="progress" style="height: 6px; border-radius: 10px;">
                        <div class="progress-bar bg-${loan.type}" role="progressbar" style="width: ${loan.progress}%"></div>
                    </div>
                    ${fineHtml}
                </div>
            </div>
        </div>
        `;
        container.innerHTML += html;
    });
}

function returnBook(index) {
    let loans = JSON.parse(localStorage.getItem('loans'));
    loans.splice(index, 1);
    localStorage.setItem('loans', JSON.stringify(loans));
    renderLoans();
    showToast("Book returned successfully!");
}
