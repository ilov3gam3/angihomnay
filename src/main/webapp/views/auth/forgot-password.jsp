<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quên mật khẩu - AnGiHomNay</title>
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
                        <h2>Quên mật khẩu</h2>
                        <p class="text-muted mb-0">Nhập email để nhận liên kết đặt lại mật khẩu</p>
                    </div>

                    <form action="<%= request.getContextPath() %>/forgot-password" method="post">
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required placeholder="Nhập email">
                        </div>

                        <button type="submit" class="btn btn-danger w-100">Gửi liên kết đặt lại mật khẩu</button>

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
