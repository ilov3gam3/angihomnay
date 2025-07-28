<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Constant.Gender"%>
<%@ page import="Model.User, Model.Customer" %>

<%
    User tempUser = (User) session.getAttribute("tempUser");
    Customer tempCustomer = (Customer) session.getAttribute("tempCustomer");
%>

<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Thêm thông tin - AnGiHomNay</title>
    <%@ include file="../common/reservation/head.jsp" %>
</head>

<body>

<div id="preloader">
    <div data-loader="circle-side"></div>
</div>

<%@ include file="../common/reservation/header.jsp" %>

<main class="bg-light min-vh-100 d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-6">
                <div class="card shadow-sm border-0 p-4">
                    <div class="text-center mb-4">
                        <img src="<%= request.getContextPath() %>/assets/img/logo.jpg" alt="Logo" style="height: 60px;">
                        <h2 class="mt-3">Thêm thông tin</h2>
                        <p class="text-muted mb-0">Xin chào <%=tempUser.getEmail()%>, vui lòng hoàn tất đăng ký bằng cách cung cấp thêm thông tin</p>
                    </div>

                    <form action="<%= request.getContextPath() %>/add-more-info" method="post">
                        <div class="mb-3">
                            <label for="firstName" class="form-label">Họ</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" required placeholder="Nhập họ"
                                   value="<%= tempCustomer != null ? tempCustomer.getFirstName() : "" %>">
                        </div>

                        <div class="mb-3">
                            <label for="lastName" class="form-label">Tên</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required placeholder="Nhập tên"
                                   value="<%= tempCustomer != null ? tempCustomer.getLastName() : "" %>">
                        </div>

                        <div class="mb-3">
                            <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required
                                   value="<%= tempCustomer != null ? tempCustomer.getDateOfBirth() : "" %>">
                        </div>

                        <div class="mb-3">
                            <label for="gender" class="form-label">Giới tính</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="" disabled <%= tempCustomer == null ? "selected" : "" %>>Chọn giới tính</option>
                                <option value="MALE" <%= tempCustomer != null && tempCustomer.getGender() == Gender.MALE ? "selected" : "" %>>Nam</option>
                                <option value="FEMALE" <%= tempCustomer != null && tempCustomer.getGender() == Gender.FEMALE ? "selected" : "" %>>Nữ</option>
                                <option value="OTHER" <%= tempCustomer != null && tempCustomer.getGender() == Gender.OTHER ? "selected" : "" %>>Khác</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required placeholder="Nhập số điện thoại"
                                   value="<%= tempUser.getPhone() != null ? tempUser.getPhone() : "" %>">
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <input type="text" class="form-control" id="address" name="address" required placeholder="Nhập địa chỉ"
                                   value="<%= tempUser.getAddress() != null ? tempUser.getAddress() : "" %>">
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="password" name="password" required placeholder="Nhập mật khẩu">
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword()">
                                    <i class="fas fa-eye" id="passwordIcon"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
                        </div>

                        <button type="submit" class="btn btn-danger w-100">Hoàn tất đăng ký</button>
                    </form>

                    <div class="text-center mt-4">
                        <p>Đã có tài khoản? <a href="<%= request.getContextPath() %>/login" class="text-danger">Đăng nhập</a></p>
                    </div>

                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="../common/reservation/footer.jsp" %>
<%@ include file="../common/reservation/js.jsp" %>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById("password");
        const passwordIcon = document.getElementById("passwordIcon");
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            passwordIcon.classList.remove("fa-eye");
            passwordIcon.classList.add("fa-eye-slash");
        } else {
            passwordInput.type = "password";
            passwordIcon.classList.remove("fa-eye-slash");
            passwordIcon.classList.add("fa-eye");
        }
    }
</script>

</body>
</html>
