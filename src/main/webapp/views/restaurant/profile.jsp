<%@ page import="java.util.*" %>
<%@ page import="Dao.TasteDao" %>
<%@ page import="Model.Taste" %>
<%@ page import="Model.Customer" %>
<%@ page import="Model.Constant.Gender" %>
<%@ page import="Dao.AllergyTypeDao" %>
<%@ page import="Dao.RestaurantDao" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thông tin cá nhân</title>
    <%@include file="../common/reservation/head.jsp"%>
</head>
<body>

<%@include file="../common/reservation/header.jsp"%>
<%
    Restaurant restaurant = new RestaurantDao().getById(user.getId());
%>
<main class="container py-5">
    <h2 class="mb-4">Trang cá nhân</h2>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-4" id="profileTabs" role="tablist">
        <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#avatar">Ảnh đại diện</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#password">Đổi mật khẩu</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#account">Thông tin tài khoản</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#restaurant">Thông tin nhà hàng</button></li>
    </ul>

    <div class="tab-content">
        <!-- Avatar -->
        <div class="tab-pane fade show active" id="avatar">
            <form action="<%= request.getContextPath() %>/update-avatar" method="post" enctype="multipart/form-data">
                <div class="text-center mb-3">
                    <img src="<%=user.getAvatar()%>" class="rounded-circle border" style="width:150px; height:150px;object-fit: cover">
                </div>
                <div class="mb-3">
                    <input type="file" name="avatar" accept="image/*" class="form-control">
                </div>
                <button type="submit" class="btn btn-primary">Cập nhật ảnh</button>
            </form>
        </div>

        <!-- Password -->
        <div class="tab-pane fade" id="password">
            <form action="<%= request.getContextPath() %>/change-password" method="post">
                <div class="mb-3"><label>Mật khẩu cũ:</label><input type="password" name="oldPassword" class="form-control" required></div>
                <div class="mb-3"><label>Mật khẩu mới:</label><input type="password" name="newPassword" id="newPassword" class="form-control" required></div>
                <div class="mb-3"><label>Xác nhận mật khẩu:</label><input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required></div>
                <button type="submit" class="btn btn-warning">Đổi mật khẩu</button>
            </form>
        </div>

        <!-- Account Info -->
        <div class="tab-pane fade" id="account">
            <form action="<%= request.getContextPath() %>/user/profile" method="post">
                <div class="mb-3"><label>Email:</label><input type="email" name="email" class="form-control" value="<%= user.getEmail() %>" required></div>
                <div class="mb-3"><label>Số điện thoại:</label><input type="tel" name="phone" class="form-control" value="<%= user.getPhone() %>" required></div>
                <div class="mb-3"><label>Địa chỉ:</label><input type="text" name="address" class="form-control" value="<%= user.getAddress() %>" required></div>
                <button type="submit" class="btn btn-warning">Cập nhật</button>
            </form>
        </div>
        <!-- Restaurant Info -->
        <div class="tab-pane fade" id="restaurant">
            <form action="<%= request.getContextPath() %>/restaurant/profile" method="post">
                <div class="mb-3"><label>Bản đồ:</label><input type="text" name="mapEmbedUrl" class="form-control" value='<%= restaurant.getMapEmbedUrl() %>' required></div>
                <div class="mb-3"><label>Giờ mở cửa:</label><input type="time" name="openTime" class="form-control" value="<%= restaurant.getOpenTime() %>" required></div>
                <div class="mb-3"><label>Giờ đóng cửa:</label><input type="time" name="closeTime" class="form-control" value="<%= restaurant.getCloseTime() %>" required></div>
                <button type="submit" class="btn btn-warning">Cập nhật</button>
            </form>
            <div class="col-12" style="width: 100%">
                <%=restaurant.getMapEmbedUrl()%>
            </div>
        </div>
    </div>
</main>

<%@include file="../common/reservation/footer.jsp"%>
<%@include file="../common/reservation/js.jsp"%>

<script>
    $(document).ready(function () {
        $('.select-tastes').select2({
            placeholder: "Chọn khẩu vị bạn yêu thích",
            width: '100%'
        });
        $('.select-allergies').select2({
            placeholder: "Chọn khẩu vị bạn yêu thích",
            width: '100%'
        });

        // Validate password confirmation
        $('form[action$="change-password"]').on('submit', function (e) {
            const newPass = $('#newPassword').val();
            const confirmPass = $('#confirmPassword').val();
            if (newPass !== confirmPass) {
                alert("Mật khẩu mới và xác nhận không trùng khớp.");
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>
