<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Đăng ký tài khoản</title>
    <%@ include file="../common/reservation/head.jsp" %>
</head>

<body>

<%@ include file="../common/reservation/header.jsp" %>

<main class="bg-light min-vh-100 d-flex align-items-center justify-content-center">
    <div class="container">
        <div class="card shadow p-4 rounded-4 mx-auto" style="max-width: 850px;">
            <div class="text-center mb-4">
                <img src="${pageContext.request.contextPath}/assets/img/logo.jpg" alt="AnGiHomNay" height="60">
                <h2 class="mt-3">Đăng ký tài khoản</h2>
                <p class="text-muted">Tạo tài khoản để khám phá thế giới ẩm thực cùng AnGiHomNay</p>
            </div>

            <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
                <div class="row">
                    <!-- Cột trái -->
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="firstName" class="form-label"><i class="fas fa-user"></i> Họ</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" required placeholder="Nhập họ">
                        </div>
                        <div class="mb-3">
                            <label for="lastName" class="form-label"><i class="fas fa-user"></i> Tên</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required placeholder="Nhập tên">
                        </div>
                        <div class="mb-3">
                            <label for="dob" class="form-label"><i class="fas fa-calendar-alt"></i> Ngày sinh</label>
                            <input type="date" class="form-control" id="dob" name="dob" required>
                        </div>
                        <div class="mb-3">
                            <label for="gender" class="form-label"><i class="fas fa-venus-mars"></i> Giới tính</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="" disabled selected>Chọn giới tính</option>
                                <option value="MALE">Nam</option>
                                <option value="FEMALE">Nữ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                    </div>

                    <!-- Cột phải -->
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="email" class="form-label"><i class="fas fa-envelope"></i> Email</label>
                            <input type="email" class="form-control" id="email" name="email" required placeholder="Nhập email">
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label"><i class="fas fa-phone"></i> Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required placeholder="Nhập số điện thoại">
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                            <input type="text" class="form-control" id="address" name="address" required placeholder="Nhập địa chỉ">
                        </div>
                    </div>
                </div>

                <!-- Mật khẩu -->
                <div class="mb-3">
                    <label for="password" class="form-label"><i class="fas fa-lock"></i> Mật khẩu</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="password" name="password" required placeholder="Nhập mật khẩu">
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('password', 'passwordIcon')">
                            <i class="fas fa-eye" id="passwordIcon"></i>
                        </button>
                    </div>
                    <small class="form-text text-muted">Mật khẩu phải có ít nhất 6 ký tự</small>
                </div>

                <!-- Xác nhận mật khẩu -->
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label"><i class="fas fa-lock"></i> Xác nhận mật khẩu</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword', 'confirmPasswordIcon')">
                            <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                        </button>
                    </div>
                </div>

                <!-- Điều khoản -->
                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" id="terms" name="terms" required>
                    <label class="form-check-label" for="terms">
                        Tôi đồng ý với <a href="#" class="text-danger text-decoration-none">Điều khoản sử dụng</a> và
                        <a href="#" class="text-danger text-decoration-none">Chính sách bảo mật</a>
                    </label>
                </div>

                <!-- Đăng ký -->
                <div class="d-grid">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-user-plus me-2"></i> Đăng ký
                    </button>
                </div>
            </form>

            <!-- Liên kết đăng nhập -->
            <div class="text-center mt-3">
                <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-danger text-decoration-none">Đăng nhập ngay</a></p>
            </div>
        </div>
    </div>
</main>

<%@ include file="../common/reservation/footer.jsp" %>
<%@ include file="../common/reservation/js.jsp" %>

<script>
    function togglePassword(inputId, iconId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        if (input.type === "password") {
            input.type = "text";
            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");
        } else {
            input.type = "password";
            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");
        }
    }
</script>
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
    // document.getElementById('registerForm').addEventListener('submit', function (e) {
    //     e.preventDefault();
    //
    //     const firstName = document.getElementById('firstName').value.trim();
    //     const lastName = document.getElementById('lastName').value.trim();
    //     const email = document.getElementById('email').value.trim();
    //     const phone = document.getElementById('phone').value.trim();
    //     const password = document.getElementById('password').value;
    //     const confirmPassword = document.getElementById('confirmPassword').value;
    //     const terms = document.getElementById('terms').checked;
    //
    //     let isValid = true;
    //
    //     // Clear previous errors
    //     clearErrors();
    //
    //     // Validate name
    //     if (firstName.length < 2) {
    //         showError('nameError', 'Tên phải có ít nhất 2 ký tự');
    //         isValid = false;
    //     }
    //
    //     if (lastName.length < 2) {
    //         showError('nameError', 'Họ phải có ít nhất 2 ký tự');
    //         isValid = false;
    //     }
    //
    //     // Validate email
    //     const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    //     if (!emailRegex.test(email)) {
    //         showError('emailError', 'Email không hợp lệ');
    //         isValid = false;
    //     }
    //
    //     // Validate phone
    //     const phoneRegex = /^(0|84)(3[2-9]|5[689]|7[06-9]|8[1-689]|9[0-46-9])[0-9]{7}$/;
    //     if (!phoneRegex.test(phone)) {
    //         showError('phoneError', 'Số điện thoại không đúng định dạng');
    //         isValid = false;
    //     }
    //
    //     // Validate terms
    //     if (!terms) {
    //         alert('Vui lòng đồng ý với điều khoản sử dụng');
    //         isValid = false;
    //     }
    //
    //     if (isValid) {
    //         // Show loading state
    //         const btn = document.getElementById('registerBtn');
    //         btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    //         btn.disabled = true;
    //
    //         // Submit form
    //         this.submit();
    //     }
    // });
    //
    // function showError(elementId, message) {
    //     const errorElement = document.getElementById(elementId);
    //     errorElement.textContent = message;
    //     errorElement.parentElement.classList.add('error');
    // }
    //
    // function clearErrors() {
    //     const errorElements = document.querySelectorAll('.field-error');
    //     errorElements.forEach(element => {
    //         element.textContent = '';
    //         element.parentElement.classList.remove('error');
    //     });
    // }
</script>
</body>
</html>
