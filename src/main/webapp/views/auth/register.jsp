<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - AnGiHomNay</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo.jpg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animations.css">
    <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/search.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
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

        .field-error {
            color: red;
            font-size: 13px;
        }

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

        .checkbox-group {
            margin-top: 10px;
            margin-bottom: 15px;
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
            <h2>Đăng ký tài khoản</h2>
            <p>Tạo tài khoản để khám phá thế giới ẩm thực cùng AnGiHomNay</p>
        </div>

        <!-- Registration Form -->
        <form class="auth-form" action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
            <div class="form-row">
                <!-- Cột trái -->
                <div class="form-col">
                    <!-- First Name -->
                    <div class="form-group">
                        <label for="firstName"><i class="fas fa-user"></i> Họ</label>
                        <input type="text" id="firstName" name="firstName" class="input-focus-animation" placeholder="Nhập họ" required>
                        <div class="field-error" id="firstNameError"></div>
                    </div>

                    <!-- Last Name -->
                    <div class="form-group">
                        <label for="lastName"><i class="fas fa-user"></i> Tên</label>
                        <input type="text" id="lastName" name="lastName" class="input-focus-animation" placeholder="Nhập tên" required>
                        <div class="field-error" id="lastNameError"></div>
                    </div>

                    <!-- Date of Birth -->
                    <div class="form-group">
                        <label for="dob"><i class="fas fa-calendar-alt"></i> Ngày sinh</label>
                        <input type="date" id="dob" name="dob" class="input-focus-animation" required>
                        <div class="field-error" id="dobError"></div>
                    </div>

                    <!-- Gender -->
                    <div class="form-group">
                        <label for="gender"><i class="fas fa-venus-mars"></i> Giới tính</label>
                        <select id="gender" name="gender" class="input-focus-animation filter-select" required>
                            <option value="" disabled selected>Chọn giới tính</option>
                            <option value="MALE">Nam</option>
                            <option value="FEMALE">Nữ</option>
                            <option value="OTHER">Khác</option>
                        </select>
                        <div class="field-error" id="genderError"></div>
                    </div>
                </div>

                <!-- Cột phải -->
                <div class="form-col">
                    <!-- Email -->
                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" id="email" name="email" class="input-focus-animation" placeholder="Nhập email" required>
                        <div class="field-error" id="emailError"></div>
                    </div>

                    <!-- Phone -->
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" class="input-focus-animation" placeholder="Nhập số điện thoại" required>
                        <div class="field-error" id="phoneError"></div>
                    </div>

                    <!-- Address -->
                    <div class="form-group">
                        <label for="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <input type="text" id="address" name="address" class="input-focus-animation" placeholder="Nhập địa chỉ" required>
                        <div class="field-error" id="addressError"></div>
                    </div>
                </div>
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
                <div class="field-error" id="passwordError"></div>
                <small class="form-text">Mật khẩu phải có ít nhất 6 ký tự</small>
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
                <div class="field-error" id="confirmPasswordError"></div>
            </div>

            <!-- Điều khoản -->
            <div class="checkbox-group">
                <input type="checkbox" id="terms" name="terms" required>
                <label for="terms">
                    Tôi đồng ý với <a href="#" style="color: var(--primary-color);">Điều khoản sử dụng</a>
                    và <a href="#" style="color: var(--primary-color);">Chính sách bảo mật</a>
                </label>
            </div>

            <!-- Submit -->
            <button type="submit" class="auth-btn btn-hover-effect" id="registerBtn">
                <i class="fas fa-user-plus"></i>
                Đăng ký
            </button>
        </form>

        <!-- Login Link -->
        <div class="auth-links">
            <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
            </p>
        </div>
    </div>
</div>

<!-- JavaScript -->
<script>
    // Toggle Password Visibility
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

    // Form Validation - SỬA LẠI ĐỂ KHỚP VỚI FIELDS MỚI
    document.getElementById('registerForm').addEventListener('submit', function (e) {
        e.preventDefault();

        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const terms = document.getElementById('terms').checked;

        let isValid = true;

        // Clear previous errors
        clearErrors();

        // Validate name
        if (firstName.length < 2) {
            showError('nameError', 'Tên phải có ít nhất 2 ký tự');
            isValid = false;
        }

        if (lastName.length < 2) {
            showError('nameError', 'Họ phải có ít nhất 2 ký tự');
            isValid = false;
        }

        // Validate email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            showError('emailError', 'Email không hợp lệ');
            isValid = false;
        }

        // Validate phone
        const phoneRegex = /^(0|84)(3[2-9]|5[689]|7[06-9]|8[1-689]|9[0-46-9])[0-9]{7}$/;
        if (!phoneRegex.test(phone)) {
            showError('phoneError', 'Số điện thoại không đúng định dạng');
            isValid = false;
        }

        // Validate password
        if (password.length < 6) {
            showError('passwordError', 'Mật khẩu phải có ít nhất 6 ký tự');
            isValid = false;
        }

        // Validate confirm password
        if (password !== confirmPassword) {
            showError('confirmPasswordError', 'Mật khẩu xác nhận không khớp');
            isValid = false;
        }

        // Validate terms
        if (!terms) {
            alert('Vui lòng đồng ý với điều khoản sử dụng');
            isValid = false;
        }

        if (isValid) {
            // Show loading state
            const btn = document.getElementById('registerBtn');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            btn.disabled = true;

            // Submit form
            this.submit();
        }
    });

    function showError(elementId, message) {
        const errorElement = document.getElementById(elementId);
        errorElement.textContent = message;
        errorElement.parentElement.classList.add('error');
    }

    function clearErrors() {
        const errorElements = document.querySelectorAll('.field-error');
        errorElements.forEach(element => {
            element.textContent = '';
            element.parentElement.classList.remove('error');
        });
    }

    // Real-time validation
    document.getElementById('confirmPassword').addEventListener('input', function () {
        const password = document.getElementById('password').value;
        const confirmPassword = this.value;

        if (confirmPassword && password !== confirmPassword) {
            showError('confirmPasswordError', 'Mật khẩu xác nhận không khớp');
        } else {
            document.getElementById('confirmPasswordError').textContent = '';
            this.parentElement.parentElement.classList.remove('error');
        }
    });
</script>
<%@include file="../common/foot.jsp"%>
<%@include file="../common/js.jsp"%>
</body>
</html>