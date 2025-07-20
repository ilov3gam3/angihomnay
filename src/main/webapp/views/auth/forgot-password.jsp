<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Quên mật khẩu - AnGiHomNay</title>
        <meta charset="UTF-8">
        <%@include file="../common/head.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/auth.css">
        <style>
            .success-message {
                text-align: center;
                color: #2ecc71;
                margin-top: 1rem;
                padding: 1rem;
                background-color: #f0fff4;
                border-radius: 5px;
            }

            .error-message {
                text-align: center;
                color: #de0c0c;
                margin-top: 1rem;
                padding: 1rem;
                background-color: #f0fff4;
                border-radius: 5px;
            }

            .success-message i {
                font-size: 2rem;
                margin-bottom: 1rem;
                display: block;
            }

            .back-to-login {
                text-align: center;
                margin-top: 1.5rem;
            }

            .back-to-login a {
                color: #ff7979;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .back-to-login a:hover {
                text-decoration: underline;
            }
            
            .temp-password {
                background-color: #fff3cd;
                border: 1px solid #ffeaa7;
                color: #856404;
                padding: 1rem;
                border-radius: 5px;
                margin-top: 1rem;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="<%= request.getContextPath() %>/view/index.jsp"><h1>AnGiHomNay</h1></a>
                </div>
            </div>
        </header>

        <main class="auth-container">
            <div class="auth-box auth-card">
                <h2>Quên mật khẩu</h2>
                <p style="text-align: center; color: #666; margin-bottom: 2rem;">
                    Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu
                </p>
                <form id="forgotPasswordForm" class="auth-form" action="<%=request.getContextPath()%>/forgot-password" method="post">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <div class="input-group">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" required placeholder="Nhập email của bạn">
                        </div>
                    </div>
                    <button type="submit" class="btn-primary btn-login-submit">Gửi yêu cầu</button>
                </form>
                <% if (request.getParameter("success")!=null) {%>
                <% if (request.getParameter("success").equals("true")) {%>
                <div class="success-message" id="successMessage">
                    <i class="fas fa-check-circle"></i>
                    <p>Chúng tôi đã gửi email hướng dẫn đặt lại mật khẩu đến địa chỉ email của bạn.</p>
                    <p>Vui lòng kiểm tra hộp thư và làm theo hướng dẫn.</p>
                </div>
                <% } %>
                <% if (request.getParameter("success").equals("false")) {%>
                <div class="error-message" id="successMessage">
                    <i class="fas fa-check-circle"></i>
                    <p>Đã có lỗi xảy ra.</p>
                    <p>Vui lòng liên hệ với quản trị viên.</p>
                </div>
                <% } %>
                <% } %>



                <div class="back-to-login">
                    <a href="<%=request.getContextPath()%>/login">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại đăng nhập
                    </a>
                </div>
            </div>
        </main>

        <%@include file="../common/footer.jsp"%>
    </body>
<%@include file="../common/foot.jsp"%>
<%@include file="../common/js.jsp"%>
</html> 