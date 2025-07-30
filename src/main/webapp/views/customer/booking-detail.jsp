<%@ page import="Model.Booking" %>
<%@ page import="Model.Constant.BookingStatus" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.List" %>
<%@ page import="Dao.BookingDao" %>
<%@ page import="Util.BookingUtil" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Booking Detail</title>
    <%@ include file="../common/reservation/head.jsp" %>
</head>
<body>

<%@ include file="../common/reservation/header.jsp" %>

<main class="bg_gray">
    <div class="container margin_60_40">
        <div class="main_title center">
            <span><em></em></span>
            <h2>Booking Details</h2>
            <p>Full information of your reservation</p>
        </div>

        <%
            Booking booking = new BookingDao().getById(Long.parseLong(request.getParameter("id")));
            if (booking != null) {
        %>
        <% if (booking.getStatus() == BookingStatus.WAITING_FINAL_PAYMENT || booking.getStatus() == BookingStatus.DEPOSITED) {%>
        <button class="btn btn-success m-1" data-bs-toggle="modal" data-bs-target="#foodModal" id="btnOpenFoodModal">Gọi thêm món</button>
        <% } %>
        <% if (booking.getStatus() == BookingStatus.WAITING_FINAL_PAYMENT || booking.getStatus() == BookingStatus.BOOKED) {%>
        <a href="<%=request.getContextPath()%>/get-vnpay-url?id=<%=booking.getId()%>">
            <button class="btn btn-success">Thanh toán</button>
        </a>
        <% } %>

        <div class="card shadow p-4 rounded-4 mb-4">
            <h5 class="fw-bold">Booking ID: <%= booking.getId() %></h5>
            <p><strong>Status:</strong> <span class="badge bg-info"><%= booking.getStatus() %></span></p>
            <p><strong>Table:</strong> <%= booking.getTable() != null ? booking.getTable().getNumber() : "N/A" %></p>
            <p><strong>Start:</strong> <%= booking.getStartTime() %></p>
            <p><strong>End:</strong> <%= booking.getEndTime() %></p>
            <p><strong>Note:</strong> <%= booking.getNote() %></p>
            <p><strong>Prepaid:</strong> <%= booking.getPrePaidFee() %> VND</p>
            <p><strong>Total:</strong> <%= booking.getAmount() %> VND</p>
        </div>

        <div class="card shadow p-4 rounded-4 mb-4">
            <h6 class="fw-semibold text-primary">Payments</h6>
            <%
                List<Model.Payment> payments = booking.getPayments();
                if (payments != null && !payments.isEmpty()) {
                    for (Model.Payment payment : payments) {
            %>
            <div class="border rounded p-2 mb-3">
                <p><strong>Type:</strong> <%= payment.getType() %></p>
                <p><strong>Amount:</strong> <%= payment.getAmount() %> VND</p>
                <p><strong>Bank:</strong> <%= payment.getBankCode() %></p>
                <p><strong>Status:</strong>
                    <span class="badge bg-<%= "SUCCESS".equals(payment.getTransactionStatus().toString()) ? "success" : "secondary" %>">
                        <%= payment.getTransactionStatus() %>
                    </span>
                </p>
                <p><strong>Paid At:</strong> <%= payment.getPaid_at() %></p>
            </div>
            <%  }
            } else { %>
            <p class="text-muted">No payments found.</p>
            <% } %>
        </div>

        <div class="card shadow p-4 rounded-4 mb-4">
            <h6 class="fw-semibold text-success">Order Details</h6>
            <ul class="list-group list-group-flush">
                <%
                    List<Model.BookingDetail> details = booking.getBookingDetails();
                    if (details != null && !details.isEmpty()) {
                        for (Model.BookingDetail detail : details) {
                %>
                <li class="list-group-item d-flex justify-content-between">
                    <div><%= detail.getFood().getName() %> x<%= detail.getQuantity() %></div>
                    <div><%= detail.getPrice() %>VND</div>
                </li>
                <% }
                } else { %>
                <li class="list-group-item text-muted">No food items.</li>
                <% } %>
            </ul>
        </div>

        <%-- Nút Review --%>
        <% if ((booking.getStatus() == BookingStatus.PAID || booking.getStatus() == BookingStatus.DEPOSITED) && booking.getEndTime().isBefore(LocalDateTime.now())) { %>
        <a href="<%= request.getContextPath() %>/customer/review?bookingId=<%= booking.getId() %>" class="btn btn-success me-2">Write Review</a>
        <% } %>

        <a href="<%= request.getContextPath() %>/customer/bookings" class="btn btn-outline-secondary">Back to Bookings</a>

        <% } else { %>
        <div class="alert alert-danger text-center rounded-4">Booking not found.</div>
        <% } %>

    </div>
    <div class="modal fade" id="foodModal" tabindex="-1" aria-labelledby="foodModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="foodModalLabel">Gọi thêm món</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <form action="<%= request.getContextPath() %>/customer/add-food-to-booking" method="post" id="formAddFoods">
                    <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                    <div class="modal-body">
                        <div class="row" id="foodList"></div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <div id="foodSummary" class="fw-bold">Đã chọn 0 món - Tạm tính: 0 đ</div>
                        <button type="submit" class="btn btn-primary">Xác nhận gọi món</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </form>

            </div>
        </div>
    </div>

</main>

<%@ include file="../common/reservation/footer.jsp" %>
<%@ include file="../common/reservation/js.jsp" %>
<script>
    const foodModal = document.getElementById('foodModal');

    foodModal.addEventListener('shown.bs.modal', function () {
        const modalBody = foodModal.querySelector('.modal-body');
        modalBody.style.maxHeight = '80vh';
        modalBody.style.overflowY = 'auto';
    });
    document.addEventListener("DOMContentLoaded", function () {
        const contextPath = '<%= request.getContextPath() %>';
        const restaurantId = '<%=booking.getTable().getRestaurant().getId()%>'; // hoặc bạn lấy từ booking.getTable().getRestaurant().getId() nếu cần động

        const foodList = document.getElementById("foodList");
        const foodSummary = document.getElementById("foodSummary");

        function updateSummary() {
            let totalQuantity = 0;
            let totalPrice = 0;
            document.querySelectorAll(".food-quantity").forEach(group => {
                const qty = parseInt(group.querySelector(".quantity-input").value);
                const price = parseInt(group.dataset.price);
                if (qty > 0) {
                    totalQuantity += qty;
                    totalPrice += qty * price;
                }
            });
            foodSummary.textContent = `Đã chọn \${totalQuantity} món - Tạm tính: \${totalPrice.toLocaleString("vi-VN")} đ`;
        }

        function attachEvents() {
            document.querySelectorAll(".btn-decrease").forEach(btn => {
                btn.addEventListener("click", () => {
                    const input = btn.parentElement.querySelector(".quantity-input");
                    input.value = Math.max(0, parseInt(input.value) - 1);
                    updateSummary();
                });
            });
            document.querySelectorAll(".btn-increase").forEach(btn => {
                btn.addEventListener("click", () => {
                    const input = btn.parentElement.querySelector(".quantity-input");
                    input.value = parseInt(input.value) + 1;
                    updateSummary();
                });
            });
            document.querySelectorAll(".quantity-input").forEach(input => {
                input.addEventListener("input", () => {
                    if (parseInt(input.value) < 0) input.value = 0;
                    updateSummary();
                });
            });
        }

        document.getElementById("btnOpenFoodModal").addEventListener("click", function () {
            foodList.innerHTML = "<div class='text-center'>Đang tải món ăn...</div>";
            fetch(`\${contextPath}/api/get-foods-of-restaurant?id=\${restaurantId}`)
                .then(res => res.json())
                .then(data => {
                    foodList.innerHTML = "";
                    data.forEach(food => {
                        const categories = food.categories ? food.categories.map(cat => `<span class="badge bg-secondary me-1">\${cat.name}</span>`).join('') : '';
                        const item =
                            "<div class='col-md-6 mb-4'>" +
                            "<div class='card h-100'>" +
                            "<img src='" + food.image + "' class='card-img-top' style='max-height: 180px; object-fit: cover' alt='" + food.name + "'>" +
                            "<div class='card-body'>" +
                            "<h5 class='card-title'>" + food.name + "</h5>" +
                            "<p class='card-text'>" + food.description + "</p>" +
                            "<div class='mb-2'>" + categories + "</div>" +
                            "<p class='fw-bold text-danger'>" + food.price.toLocaleString("vi-VN") + " đ</p>" +
                            "<div class='input-group food-quantity' data-price='" + food.price + "' data-food-id='" + food.id + "'>" +
                            "<input type='hidden' name='foodIds' value='" + food.id + "'>" +
                            "<button class='btn btn-outline-secondary btn-decrease' type='button'>-</button>" +
                            "<input type='number' class='form-control text-center quantity-input' value='0' min='0' name='quantities'>" +
                            "<button class='btn btn-outline-secondary btn-increase' type='button'>+</button>" +
                            "</div>" +
                            "</div>" +
                            "</div>" +
                            "</div>";
                        foodList.insertAdjacentHTML("beforeend", item);
                    });
                    attachEvents();
                    updateSummary();
                })
                .catch(err => {
                    foodList.innerHTML = "<div class='text-danger text-center'>Lỗi khi tải món ăn.</div>";
                    console.error(err);
                });
        });
    });
</script>

</body>
</html>
