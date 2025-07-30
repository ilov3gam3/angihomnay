<%@ page import="Model.*" %>
<%@ page import="Model.Constant.Role" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<% User user = (User) request.getSession().getAttribute("user"); %>

<!-- Header -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/">Trang chủ</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-between" id="navbarNav">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <%--<li class="nav-item"><a class="nav-link text-light" href="#">Quay món</a></li>
            <li class="nav-item"><a class="nav-link text-light" href="#">Món hot</a></li>
            <li class="nav-item"><a class="nav-link text-light" href="#">Thực đơn</a></li>
            <li class="nav-item"><a class="nav-link text-light" href="#">Gói đăng ký</a></li>
            <li class="nav-item"><a class="nav-link text-light" href="#">Lịch sử</a></li>--%>
            <% if (user != null && user.getRole() == Role.ADMIN) { %>
            <li><a class="nav-link text-light" href="<%= request.getContextPath()%>/admin/user">Quản lý người dùng</a>
            </li>
            <li><a class="nav-link text-light" href="<%= request.getContextPath()%>/admin/categories">Quản lý loại món ăn</a>
            </li>
            <li><a class="nav-link text-light" href="<%= request.getContextPath()%>/views/admin/revenue.jsp">Thống kê</a>
            </li>
            <% } else if (user != null && user.getRole() == Role.RESTAURANT) { %>
            <li><a class="nav-link text-light" href="<%= request.getContextPath()%>/restaurant/foods">Quản lý món ăn</a>
            </li>
            <li><a class="nav-link text-light" href="<%= request.getContextPath()%>/restaurant/tables">Quản lý bàn</a>
            </li>
            <li><a class="nav-link text-light" href="<%= request.getContextPath()%>/views/restaurant/revenue.jsp">Thống kê</a>
            </li>
            <li><a class="nav-link text-light" href="<%= request.getContextPath()%>/restaurant/bookings">Đơn đặt bàn</a>
            </li>
            <% } else { %>
            <li><a class="nav-link text-light" href="<%= request.getContextPath()%>/customer/book">Đặt bàn ngay</a>
            </li>
            <% } %>
        </ul>

        <!-- Search -->
        <form class="d-flex me-3" role="search" action="<%=request.getContextPath()%>/search">
            <input class="form-control me-2" type="search" placeholder="Tìm kiếm" aria-label="Search" name="searchString">
            <button class="btn btn-outline-light" type="submit"><i class="fas fa-search"></i></button>
        </form>

        <!-- Account -->
        <% if (user != null) { %>
        <div class="dropdown">
            <button class="btn btn-dark d-flex align-items-center dropdown-toggle" type="button"
                    id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="avatar rounded-circle bg-purple text-white d-flex align-items-center justify-content-center me-2"
                     style="width: 30px; height: 30px;">
                    <%= user.getEmail() != null ? user.getEmail().substring(0, 1).toUpperCase() : "U" %>
                </div>
                <%= user.getEmail() %>
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <% if (user.getRole() != Role.ADMIN) {%>
                <li>
                    <a class="dropdown-item"
                       href="<%= request.getContextPath()%>/<%=user.getRole() == Role.CUSTOMER ? "customer" : "restaurant"%>/profile"><i
                            class="fas fa-user"></i> Trang cá nhân</a></li>
                <% } %>
                <% if (user.getRole() != Role.ADMIN) {%>
                <li>
                <a class="dropdown-item"
                   href="<%= request.getContextPath()%>/customer/bookings"><i
                        class="fas fa-utensils"></i> Booking của bạn</a></li>
                <% } %>
                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/logout"><i
                        class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
            </ul>
        </div>
        <% } else { %>
        <a href="<%= request.getContextPath() %>/login" class="btn btn-outline-light">Đăng nhập</a>
        <% } %>
    </div>
</nav>

<!-- Custom CSS -->
<style>
    .bg-purple {
        background-color: #6f42c1 !important;
    }

    .dropdown-menu {
        min-width: 180px;
        font-size: 0.95rem;
        border-radius: 0.5rem;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
</style>

