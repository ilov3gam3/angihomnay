<%-- 
    Document   : forgot
    Created on : Jun 16, 2025, 6:58:46 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu - AnGiHomNay</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/auth.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/animations.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .success-message {
                display: none;
                text-align: center;
                color: #2ecc71;
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
            <div class="auth-box fade-in">
                <h2>Quên mật khẩu</h2>
                <p style="text-align: center; color: #666; margin-bottom: 2rem;">
                    Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu
                </p>
                
                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) {%>  
                <div class="error-message slide-in-left"><%= error%></div>
                <% }%>
                
                <% String success = (String) request.getAttribute("success"); %>
                <% String tempPassword = (String) request.getAttribute("tempPassword"); %>
                
                <% if (success != null) {%>
                <div class="success-message slide-in-left" style="display: block;">
                    <i class="fas fa-check-circle heartbeat"></i>
                    <p><%= success%></p>
                    <% if (tempPassword != null) {%>
                    <div class="temp-password pulse">
                        <strong>Mật khẩu tạm thời: <%= tempPassword%></strong><br>
                        <small>(Vui lòng đổi mật khẩu sau khi đăng nhập)</small>
                    </div>
                    <% }%>
                </div>
                <% } else { %>
                
                <form id="forgotPasswordForm" class="auth-form" method="post" action="${pageContext.request.contextPath}/forgot-password">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <div class="input-group">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" required placeholder="Nhập email của bạn"
                                   value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                                   class="input-focus-animation">
                        </div>
                    </div>
                    <button type="submit" class="btn-primary btn-login-submit btn-hover-effect">Gửi yêu cầu</button>
                </form>
                
                <% } %>

                <div class="back-to-login">
                    <a href="<%= request.getContextPath() %>/view/authen/login.jsp" class="btn-hover-effect">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại đăng nhập
                    </a>
                </div>
            </div>
        </main>

        <script src="<%= request.getContextPath() %>/js/auth.js"></script>
    </body>
</html> 