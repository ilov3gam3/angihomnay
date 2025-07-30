<%@ page import="java.util.List" %>
<%@ page import="Model.Constant.BookingStatus" %>
<%@ page import="java.time.LocalDateTime" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">


<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:43 GMT -->
<head>
  <title>Foores - Single Restaurant Version</title>
  <%@include file="../common/reservation/head.jsp"%>
</head>

<body>

<div id="preloader">
  <div data-loader="circle-side"></div>
</div><!-- /Page Preload -->

<%@include file="../common/reservation/header.jsp"%>
<!-- /header -->

<main class="bg_gray">
  <div class="container margin_60_40">
    <div class="main_title center">
      <span><em></em></span>
      <h2>Your Bookings</h2>
      <p>Check your current and past reservations.</p>
    </div>
    <div class="text-center mb-4">
      <div class="btn-group" role="group" aria-label="Booking filters">
        <button type="button" class="btn btn-outline-primary filter-btn active" data-filter="ALL">Tất cả</button>
        <button type="button" class="btn btn-outline-primary filter-btn" data-filter="BOOKED">Đã đặt (chưa thanh toán)</button>
        <button type="button" class="btn btn-outline-primary filter-btn" data-filter="DEPOSITED">Đã thanh toán cọc</button>
        <button type="button" class="btn btn-outline-primary filter-btn" data-filter="ONGOING">Đang diễn ra</button>
        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="WAITING_FINAL_PAYMENT">Chờ thanh toán</button>
        <button type="button" class="btn btn-outline-danger filter-btn" data-filter="PAID">Đã thanh toán</button>
        <button type="button" class="btn btn-outline-success filter-btn" data-filter="CANCELED">Đã hủy</button>
        <button type="button" class="btn btn-outline-success filter-btn" data-filter="NO_SHOW">Không xuất hiện</button>
      </div>
    </div>
    <div class="row">
      <%
        List<Model.Booking> bookings = (List<Model.Booking>) request.getAttribute("bookings");
        if (bookings != null && !bookings.isEmpty()) {
          for (Model.Booking booking : bookings) {
            String status;
            //&& booking.getStartTime().isBefore(LocalDateTime.now()) && booking.getEndTime().isAfter(LocalDateTime.now())
            if ((booking.getStatus() == BookingStatus.DEPOSITED || booking.getStatus() == BookingStatus.WAITING_FINAL_PAYMENT) && booking.getStartTime().isBefore(LocalDateTime.now()) && booking.getEndTime().isAfter(LocalDateTime.now())){
              status = booking.getStatus() + ",ONGOING";
            } else {
              status = booking.getStatus().toString();
            }
      %>
      <div class="col-lg-12 mb-4 booking-item" data-status="<%=status%>" >
        <div class="box_booking">
          <div class="card shadow p-4 rounded-4">
            <div class="d-flex justify-content-between">
              <div>
                <% if (booking.getStatus() == BookingStatus.BOOKED || booking.getStatus() == BookingStatus.WAITING_FINAL_PAYMENT) { %>
                <a href="<%=request.getContextPath()%>/get-vnpay-url?id=<%=booking.getId()%>">
                  <button class="btn btn-success">Thanh toán</button>
                </a>
                <% } %>
                <% if (booking.getStatus() == BookingStatus.BOOKED){%>
                <a href="<%=request.getContextPath()%>/restaurant/cancel?id=<%=booking.getId()%>">
                  <button class="btn btn-danger">Hủy bàn</button>
                </a>
                <%}%>
                <% if (booking.getStatus() == BookingStatus.DEPOSITED  && booking.getStartTime().isAfter(LocalDateTime.now().plusMinutes(30))){%>
                <a href="<%=request.getContextPath()%>/restaurant/no-show?id=<%=booking.getId()%>">
                  <button class="btn btn-danger">Không tới</button>
                </a>
                <%}%>
                <a href="<%=request.getContextPath()%>/views/customer/booking-detail.jsp?id=<%=booking.getId()%>">
                  <h5 class="fw-bold mb-2">Booking ID: <%= booking.getId() %></h5>
                  <h5 class="fw-bold mb-2">Người đặt: <%= booking.getCustomer().getLastName() + " " + booking.getCustomer().getFirstName() %></h5>
                </a>
                <p class="mb-1"><strong>Status:</strong> <span class="badge bg-info"><%= booking.getStatus() %></span></p>
                <p class="mb-1"><strong>Table:</strong> <%= booking.getTable() != null ? booking.getTable().getNumber() : "N/A" %></p>
                <p class="mb-1"><strong>Start:</strong> <%= booking.getStartTime() %></p>
                <p class="mb-1"><strong>End:</strong> <%= booking.getEndTime() %></p>
                <p class="mb-1"><strong>Note:</strong> <%= booking.getNote() %></p>
              </div>
              <div class="text-end">
                <p class="mb-1"><strong>Prepaid:</strong> <%= booking.getPrePaidFee() %> VND</p>
                <p class="mb-1"><strong>Total:</strong> <%= booking.getAmount() %> VND</p>
              </div>
            </div>

            <hr>

            <h6 class="fw-semibold text-primary">Payments</h6>
            <%
              List<Model.Payment> payments = booking.getPayments();
              if (payments != null && !payments.isEmpty()) {
                for (Model.Payment payment : payments) {
            %>
            <div class="border rounded p-2 mb-2">
              <p class="mb-1"><strong>Type:</strong> <%= payment.getType() %></p>
              <p class="mb-1"><strong>Amount:</strong> <%= payment.getAmount() %>VND</p>
              <p class="mb-1"><strong>Bank:</strong> <%= payment.getBankCode() %></p>
              <p class="mb-1"><strong>Status:</strong>
                <span class="badge bg-<%= "SUCCESS".equals(payment.getTransactionStatus().toString()) ? "success" : "secondary" %>">
                                    <%= payment.getTransactionStatus() %>
                                </span>
              </p>
              <p class="mb-0"><strong>Paid At:</strong> <%= payment.getPaid_at() %></p>
            </div>
            <%
              }
            } else {
            %>
            <p class="text-muted">No payments found.</p>
            <% } %>

            <hr>

            <h6 class="fw-semibold text-success">Order Details</h6>
            <ul class="list-group list-group-flush">
              <%
                List<BookingDetail> details = booking.getBookingDetails();
                if (details != null && !details.isEmpty()) {
                  for (Model.BookingDetail detail : details) {
              %>
              <li class="list-group-item d-flex justify-content-between">
                <div><%= detail.getFood().getName() %> x<%= detail.getQuantity() %></div>
                <div><%= detail.getPrice() %>VND</div>
              </li>
              <%
                }
              } else {
              %>
              <li class="list-group-item text-muted">No food items.</li>
              <% } %>
            </ul>
            <% if ((booking.getStatus() == BookingStatus.DEPOSITED || booking.getStatus() == BookingStatus.PAID) && booking.getEndTime().isBefore(LocalDateTime.now())) {%>
            <a href="<%=request.getContextPath()%>/customer/review?bookingId=<%=booking.getId()%>">
              <button class="btn btn-success">Review</button>
            </a>
            <% }%>
          </div>
        </div>
      </div>
      <%
        }
      } else {
      %>
      <div class="col-12">
        <div class="alert alert-warning text-center rounded-4 shadow-sm">You have no bookings yet.</div>
      </div>
      <% } %>
    </div>
  </div>
</main>

<!-- /main -->

<%@include file="../common/reservation/footer.jsp"%>
<!--/footer-->

<div id="toTop"></div><!-- Back to top button -->

<!-- Modal terms -->
<div class="modal fade" id="terms-txt" tabindex="-1" role="dialog" aria-labelledby="termsLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="termsLabel">Terms and conditions</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p>Lorem ipsum dolor sit amet, in porro albucius qui, in <strong>nec quod novum accumsan</strong>, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt sensibus.</p>
        <p>Lorem ipsum dolor sit amet, in porro albucius qui, in nec quod novum accumsan, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt sensibus. Lorem ipsum dolor sit amet, <strong>in porro albucius qui</strong>, in nec quod novum accumsan, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt sensibus.</p>
        <p>Lorem ipsum dolor sit amet, in porro albucius qui, in nec quod novum accumsan, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt sensibus.</p>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<%@include file="../common/reservation/js.jsp"%>
<script>
  document.querySelectorAll('.filter-btn').forEach(button => {
    button.addEventListener('click', () => {
      const filter = button.getAttribute('data-filter');

      // Bỏ active khỏi tất cả, thêm vào nút được bấm
      document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
      button.classList.add('active');

      // Duyệt tất cả booking và ẩn/hiện theo trạng thái
      document.querySelectorAll('.booking-item').forEach(item => {
        const statusList = item.getAttribute('data-status').split(',');
        if (filter === 'ALL' || statusList.includes(filter)) {
          item.style.display = '';
        } else {
          item.style.display = 'none';
        }
      });
    });
  });
</script>
</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
