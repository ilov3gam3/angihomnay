<%@ page import="Model.User" %>
<%@ page import="Model.Customer" %>
<%@ page import="Model.Constant.Gender" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User tempUser = (User) session.getAttribute("tempUser");
    Customer tempCustomer = (Customer) session.getAttribute("tempCustomer");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông tin bổ sung - AnGiHomNay</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo.jpg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animations.css">
    <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/search.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>

        .password-group {
            display: flex;
            align-items: center;
        }

        .password-group input {
            flex: 1;
        }

        .password-toggle {
            background: none;
            border: none;
            cursor: pointer;
            margin-left: 5px;
        }

        .auth-btn {
            width: 100%;
            padding: 10px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .auth-header h2 {
            margin-bottom: 10px;
        }

        .auth-card {
            max-width: 800px;
            margin: auto;
        }
        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .form-col {
            flex: 1;
            min-width: 300px;
        }

        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="auth-card fade-in">
        <!-- Logo -->
        <div class="auth-logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.jpg" alt="AnGiHomNay">
        </div>

        <!-- Header -->
        <div class="auth-header">
            <h2>Bổ sung thông tin</h2>
            <p>Hoàn tất thông tin để tiếp tục sử dụng dịch vụ</p>
        </div>
        <!-- Form -->
        <form class="auth-form" action="${pageContext.request.contextPath}/add-more-info" method="POST">
            <div class="form-row">
                <div class="form-col">
                    <!-- First Name -->
                    <div class="form-group">
                        <label for="firstName"><i class="fas fa-user"></i> Họ</label>
                        <input type="text" id="firstName" name="firstName" class="input-focus-animation" placeholder="Nhập họ"
                               required value="<%= tempCustomer != null && tempCustomer.getFirstName() != null ? tempCustomer.getFirstName() : "" %>">
                    </div>

                    <!-- Last Name -->
                    <div class="form-group">
                        <label for="lastName"><i class="fas fa-user"></i> Tên</label>
                        <input type="text" id="lastName" name="lastName" class="input-focus-animation" placeholder="Nhập tên"
                               required value="<%= tempCustomer != null && tempCustomer.getLastName() != null ? tempCustomer.getLastName() : "" %>">
                    </div>

                    <!-- Date of Birth -->
                    <div class="form-group">
                        <label for="dateOfBirth"><i class="fas fa-calendar-alt"></i> Ngày sinh</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" class="input-focus-animation" required
                               value="<%= tempCustomer != null && tempCustomer.getDateOfBirth() != null ? tempCustomer.getDateOfBirth() : "" %>">
                    </div>

                    <!-- Gender -->
                    <div class="form-group">
                        <label for="gender"><i class="fas fa-venus-mars"></i> Giới tính</label>
                        <select id="gender" name="gender" class="input-focus-animation filter-select" required>
                            <option value="" disabled selected>Chọn giới tính</option>
                            <option value="MALE" <%= tempCustomer != null && tempCustomer.getGender() != null && tempCustomer.getGender() == Gender.MALE ? "selected" : "" %>>Nam</option>
                            <option value="FEMALE" <%= tempCustomer != null && tempCustomer.getGender() != null && tempCustomer.getGender() == Gender.FEMALE ? "selected" : "" %>>Nữ</option>
                            <option value="OTHER" <%= tempCustomer != null && tempCustomer.getGender() != null && tempCustomer.getGender() == Gender.OTHER ? "selected" : "" %>>Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-col">
                    <!-- Phone -->
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" class="input-focus-animation" placeholder="Nhập số điện thoại"
                               required value="<%= tempUser.getPhone() != null ? tempUser.getPhone() : "" %>">
                    </div>

                    <!-- Address -->
                    <div class="form-group">
                        <label for="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <input type="text" id="address" name="address" class="input-focus-animation" placeholder="Nhập địa chỉ"
                               required value="<%= tempUser.getAddress() != null ? tempUser.getAddress() : "" %>">
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label for="password"><i class="fas fa-lock"></i> Mật khẩu</label>
                        <div class="password-group">
                            <input type="password" id="password" name="password" class="input-focus-animation" placeholder="Nhập mật khẩu" required>
                            <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                <i class="fas fa-eye" id="passwordIcon"></i>
                            </button>
                        </div>
                        <small>Mật khẩu tối thiểu 6 ký tự</small>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <label for="confirmPassword"><i class="fas fa-lock"></i> Xác nhận mật khẩu</label>
                        <div class="password-group">
                            <input type="password" id="confirmPassword" name="confirmPassword" class="input-focus-animation" placeholder="Nhập lại mật khẩu" required>
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Submit -->
            <button type="submit" class="auth-btn btn-hover-effect">
                <i class="fas fa-check-circle"></i> Hoàn tất đăng ký
            </button>
        </form>
    </div>
</div>

<!-- JavaScript -->
<script>
    function togglePassword(inputId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(inputId + 'Icon');

        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
</script>
<%@include file="../common/foot.jsp"%>
<%@include file="../common/js.jsp"%>
</body>
</html>
