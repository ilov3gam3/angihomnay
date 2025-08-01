<%@ page import="java.util.List" %>
<%@ page import="java.time.Duration" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.temporal.Temporal" %>
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
<%@ page import="java.util.List" %>
<%@ page import="Model.Restaurant, Model.Food, Model.Review" %>
<%@ page import="java.time.Duration, java.time.LocalDateTime" %>
<%
  Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
  List<Food> foods = (List<Food>) request.getAttribute("foods");
  List<Review> reviews = (List<Review>) request.getAttribute("reviews");
%>
<main>
  <div class="container my-5">
    <div class="row">
      <!-- Ảnh bên trái -->
      <div class="col-lg-6">
        <img src="<%= restaurant.getUser().getAvatar() %>"
             class="img-fluid rounded shadow" alt="Restaurant Image">
      </div>
      <!-- Thông tin bên phải -->
      <div class="col-lg-6">
        <h2><%= restaurant.getName() %></h2>
        <p><strong>Giờ mở cửa:</strong> <%= restaurant.getOpenTime() %> - <%= restaurant.getCloseTime() %></p>
        <p><strong>Số lượng món ăn:</strong> <%= foods.size() %></p>
        <p>Nhà hàng phục vụ món ăn đa dạng, không gian hiện đại, phục vụ tận tâm.</p>
      </div>
    </div>

    <!-- Tabs -->
    <div class="tabs_product mt-5">
      <ul class="nav nav-tabs" role="tablist">
        <li class="nav-item">
          <a class="nav-link active" data-bs-toggle="tab" href="#reviews" role="tab">Đánh giá</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" data-bs-toggle="tab" href="#map" role="tab">Bản đồ</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" data-bs-toggle="tab" href="#menu" role="tab">Tất cả món ăn</a>
        </li>
      </ul>
    </div>

    <div class="tab-content mt-3">
      <!-- Tab 1: Reviews -->
      <div class="tab-pane fade show active" id="reviews" role="tabpanel">
        <% if (reviews != null && !reviews.isEmpty()) {
          for (Review r : reviews) {
            String name = r.getBooking().getCustomer().getFirstName() + " " + r.getBooking().getCustomer().getLastName();
            String comment = r.getComment();
            int rating = r.getRating();
            LocalDateTime created = r.getCreatedAt().toLocalDateTime();
            long minutesAgo = Duration.between(created, LocalDateTime.now()).toMinutes();
        %>
        <div class="review_content my-3 p-3 border rounded">
          <div class="d-flex justify-content-between align-items-center mb-1">
            <strong><%= name %></strong>
            <span class="text-warning">
                                <% for (int s = 1; s <= 5; s++) { %>
                                    <i class="fa<%= s <= rating ? "s" : "r" %> fa-star"></i>
                                <% } %>
                                <small class="text-muted">(<%= rating %>/5)</small>
                            </span>
          </div>
          <p><%= comment %></p>
          <small class="text-muted">Đăng <%= minutesAgo %> phút trước</small>
        </div>
        <%  }
        } else { %>
        <p class="text-muted">Chưa có đánh giá nào.</p>
        <% } %>
      </div>

      <!-- Tab 2: Bản đồ -->
      <div class="tab-pane fade" id="map" role="tabpanel">
        <div class="ratio ratio-16x9 my-3">
          <%= restaurant.getMapEmbedUrl() %>
        </div>
      </div>

      <!-- Tab 3: Danh sách món ăn -->
      <div class="tab-pane fade" id="menu" role="tabpanel">
        <div class="row">
          <% for (Food f : foods) { %>
          <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
              <img src="<%= f.getImage() %>" class="card-img-top" style="height: 200px; object-fit: cover;" alt="<%= f.getName() %>">
              <div class="card-body">
                <h5 class="card-title">
                  <a href="<%=request.getContextPath()%>/food-detail?id=<%=f.getId()%>"><%= f.getName() %></a>
                </h5>
                <p class="card-text text-muted"><%= f.getDescription() %></p>
                <p class="fw-bold"><%= f.getPrice() %>₫</p>
              </div>
            </div>
          </div>
          <% } %>
        </div>
      </div>
    </div>
  </div>
</main>

<!-- /main -->


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

</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
