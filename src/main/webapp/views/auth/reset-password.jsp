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
        <form id="forgotPasswordForm" class="auth-form" action="<%=request.getContextPath()%>/reset-password" method="post" >
            <input type="hidden" name="token" value="<%=request.getParameter("token")%>">
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu của bạn">
                </div>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Xác nhận lại mật khẩu</label>
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Nhập mật khẩu của bạn">
                </div>
            </div>
            <button type="submit" class="btn-primary btn-login-submit">Đặt lại mật khẩu</button>
        </form>
    </div>
</main>

<%@include file="../common/footer.jsp"%>
</body>
<%@include file="../common/foot.jsp"%>
<%@include file="../common/js.jsp"%>
</html>