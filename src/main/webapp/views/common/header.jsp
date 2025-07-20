<%@ page import="Model.*" %>
<%@ page import="Model.Constant.Role" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<% User user = (User) request.getSession().getAttribute("user");%>
<style>
    .user-dropdown {
        position: relative;
        display: inline-block;
    }

    .avatar-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        cursor: pointer;
        border: 2px solid #eee;
        background: #fff;
        object-fit: cover;
        transition: box-shadow 0.2s;
    }

    .avatar-icon:hover {
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    }

    .dropdown-menu {
        display: none;
        position: absolute;
        right: 0;
        top: 110%;
        background: #fff;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        border-radius: 8px;
        min-width: 180px;
        z-index: 100;
        padding: 0.5rem 0;
        animation: fadeIn 0.2s;
    }

    .user-dropdown.open .dropdown-menu {
        display: block;
    }

    .dropdown-menu li {
        list-style: none;
    }

    .dropdown-menu a {
        display: block;
        padding: 0.75rem 1.5rem;
        color: #333;
        text-decoration: none;
        transition: background 0.2s;
    }

    .dropdown-menu a:hover {
        background: #f5f5f5;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>
<header class="header">
    <div class="header-container">
        <div class="logo">
            <a href="<%=request.getContextPath()%>/">
                <h1>AnGiHomNay</h1>
            </a>
        </div>
        <nav class="main-nav">
            <ul>
                <% if (user != null && user.getRole() == Role.ADMIN) { %>
                <li><a href="<%= request.getContextPath()%>/admin/user">Quản lý người dùng</a></li>
                <li><a href="<%= request.getContextPath()%>/admin/categories">Quản lý loại món ăn</a></li>
                <% } else if (user != null && user.getRole() == Role.RESTAURANT){ %>
                <li><a href="<%= request.getContextPath()%>/restaurant/foods">Quản lý món ăn</a></li>
                <li><a href="<%= request.getContextPath()%>/restaurant/tables">Quản lý bàn</a></li>
                <% } else { %>
                <li><a href="<%= request.getContextPath()%>/">Trang chủ</a></li>
                <li><a href="<%= request.getContextPath()%>/view/random.jsp">Quay món</a></li>
                <li><a href="<%= request.getContextPath()%>/view/trending.jsp">Món hot</a></li>
                <li><a href="<%= request.getContextPath()%>/view/nutrition.jsp">Thực đơn & Dinh dưỡng</a></li>
                <li><a href="<%= request.getContextPath()%>/view/packages.jsp">Gói đăng ký</a></li>
                <li><a href="<%= request.getContextPath()%>/view/history.jsp">Lịch sử nấu ăn</a></li>
                <% } %>
            </ul>
        </nav>
        <div style="width: 300px" class="user-actions">
            <% if (user == null) { %>
            <a href="<%= request.getContextPath()%>/login" class="btn-login">Đăng nhập</a>
            <a href="<%= request.getContextPath()%>/register" class="btn-register">Đăng ký</a>
            <% } else { %>
            <div class="user-dropdown" id="userDropdownWrap">
                <div style="display: flex; gap: 10px; align-items: center; justify-content: flex-start;">
                    <p style="margin: 0;"><%= user.getEmail() %></p>
                    <img src="<%= user.getAvatar() %>" alt="User" class="avatar-icon" id="avatarIcon">
                </div>
                <ul class="dropdown-menu" id="userDropdown">
                    <% if (user.getRole() != Role.ADMIN) {%>
                    <li>
                        <a href="<%= request.getContextPath()%>/<%=user.getRole() == Role.CUSTOMER ? "customer" : "restaurant"%>/profile"><i
                                class="fas fa-user"></i> Trang cá nhân</a></li>
                    <% } %>
                    <li>
                        <a href="<%= request.getContextPath()%>/settings.jsp"><i class="fas fa-cog"></i> Cài đặt</a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                    </li>
                </ul>
            </div>
            <% } %>
        </div>
    </div>
</header>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var avatar = document.getElementById('avatarIcon');
        var dropdownWrap = document.getElementById('userDropdownWrap');
        if (avatar && dropdownWrap) {
            avatar.addEventListener('click', function (e) {
                e.stopPropagation();
                dropdownWrap.classList.toggle('open');
            });
            document.addEventListener('click', function () {
                dropdownWrap.classList.remove('open');
            });
        }
    });
</script>
