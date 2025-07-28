<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt lại mật khẩu - AnGiHomNay</title>
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
                        <h2>Đặt lại mật khẩu</h2>
                        <p class="text-muted mb-0">Nhập mật khẩu mới cho tài khoản của bạn</p>
                    </div>

                    <form action="<%= request.getContextPath() %>/reset-password" method="post">
                        <input type="hidden" name="token" value="<%= request.getAttribute("token") %>">

                        <div class="mb-3">
                            <label for="newPassword" class="form-label">Mật khẩu mới</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required placeholder="Nhập mật khẩu mới">
                        </div>

                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
                        </div>

                        <button type="submit" class="btn btn-danger w-100">Xác nhận</button>

                        <div class="text-center mt-3">
                            <a href="<%= request.getContextPath() %>/login" class="text-decoration-none">Quay lại đăng nhập</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="../common/reservation/footer.jsp" %>
<%@ include file="../common/reservation/js.jsp" %>
</body>
</html>
