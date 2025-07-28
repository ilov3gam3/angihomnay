<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Đăng nhập - AnGiHomNay</title>
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
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm border-0 p-4">
                    <div class="text-center mb-4">
                        <img src="<%= request.getContextPath() %>/assets/img/logo.jpg" alt="Logo" style="height: 60px;">
                        <h2 class="mt-3">Đăng nhập</h2>
                        <p class="text-muted mb-0">Chào mừng bạn trở lại AnGiHomNay</p>
                    </div>

                    <form action="<%= request.getContextPath() %>/login" method="post">
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required placeholder="Nhập email">
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

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="remember" name="remember">
                                <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                            </div>
                            <a href="<%= request.getContextPath() %>/forgot-password" class="text-danger text-decoration-none">Quên mật khẩu?</a>
                        </div>

                        <button type="submit" class="btn btn-danger w-100 mb-3">Đăng nhập</button>

                        <div class="text-center mb-2">
                            <span>Hoặc</span>
                        </div>

                        <a href="<%= request.getContextPath() %>/google/oauth" class="btn btn-outline-danger w-100">
                            <i class="fab fa-google me-2"></i> Đăng nhập với Google
                        </a>
                    </form>

                    <div class="text-center mt-4">
                        <p>Chưa có tài khoản? <a href="<%= request.getContextPath() %>/register" class="text-danger">Đăng ký ngay</a></p>
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
