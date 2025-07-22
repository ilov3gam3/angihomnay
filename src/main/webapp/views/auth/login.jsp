<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - AnGiHomNay</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath()%>/assets/img/logo.jpg">
    <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/main.css">
    <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/auth.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>
<div class="auth-container">
    <div class="auth-card">
        <div class="auth-logo">
            <img src="<%= request.getContextPath()%>/assets/img/logo.jpg" alt="AnGiHomNay Logo">
        </div>

        <div class="auth-header">
            <h2>Đăng nhập</h2>
            <p>Chào mừng bạn trở lại AnGiHomNay</p>
        </div>

        <form action="<%= request.getContextPath()%>/login" method="post" class="auth-form">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <div class="password-group">
                    <input type="password" id="password" name="password" required>
                    <button type="button" class="password-toggle" onclick="togglePassword()">
                        <i class="fas fa-eye" id="passwordIcon"></i>
                    </button>
                </div>
            </div>

            <div class="remember-forgot">
                <div class="remember-me">
                    <input type="checkbox" id="remember" name="remember" value="on">
                    <label for="remember">Ghi nhớ đăng nhập</label>
                </div>
                <a href="<%= request.getContextPath()%>/forgot-password" class="forgot-password">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="auth-btn">Đăng nhập</button>
        </form>

        <div class="auth-links">
            <p>Chưa có tài khoản? <a href="<%= request.getContextPath()%>/register">Đăng ký ngay</a></p>
        </div>

        <div class="social-login">
            <p>Hoặc đăng nhập bằng</p>
            <a href="<%= request.getContextPath()%>/google/oauth" class="social-btn google">
                <i class="fab fa-google"></i>
                Đăng nhập với Google
            </a>
        </div>
    </div>
</div>
<script>
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const passwordIcon = document.getElementById('passwordIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            passwordIcon.classList.remove('fa-eye');
            passwordIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            passwordIcon.classList.remove('fa-eye-slash');
            passwordIcon.classList.add('fa-eye');
        }
    }

    // Add loading state to form submission
    document.querySelector('.auth-form').addEventListener('submit', function () {
        const submitBtn = document.querySelector('.auth-btn');
        submitBtn.classList.add('loading');
        submitBtn.disabled = true;
    });
</script>
<%@include file="../common/foot.jsp"%>
<%@include file="../common/js.jsp"%>
</body>
</html>