<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>AnGiHomNay - Nền tảng đánh giá và gợi ý ẩm thực</title>
    <%@include file="../common/head.jsp" %>
</head>
<body>
<%@include file="../common/header.jsp" %>
<!-- Main Content -->
<main>
    <!-- Context Based Recommendations -->
    <section class="recommendations">
        <h3>Danh sách Loại món ăn</h3>
        <button data-bs-toggle="modal" data-bs-target="#create_modal" class="btn-register m-1">Thêm mới</button>
        <div class="btn-group mb-2" role="group">
            <button class="btn btn-primary" onclick="showTable('adminTable')">Admin</button>
            <button class="btn btn-primary" onclick="showTable('customerTable')">Customer</button>
            <button class="btn btn-primary" onclick="showTable('restaurantTable')">Restaurant</button>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#create_modal">Thêm người dùng</button>
        </div>
        <% List<User> users = (List<User>) request.getAttribute("users"); %>
        <% List<Customer> customers = (List<Customer>) request.getAttribute("customers"); %>
        <% List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants"); %>
        <%-- User table --%>
        <table class="nutrition-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Được tạo lúc</th>
                <th>Vai trò</th>
                <th>Ảnh</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% for (int i = 0; i < users.size(); i++) { %>
            <tr>
                <td><%=users.get(i).getId()%></td>
                <td><%=users.get(i).getEmail()%></td>
                <td><%=users.get(i).getPhone()%></td>
                <td><%=users.get(i).getCreatedAt()%></td>
                <td><%=users.get(i).getRole()%></td>
                <td>
                    <img src="<%=request.getContextPath()%><%=users.get(i).getAvatar()%>" alt="">
                </td>
                <td>
                    <button onclick="populateForm()" data-bs-toggle="modal" data-bs-target="#update_modal" class="btn-register m-1">Cập nhật</button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <%-- Customer table --%>
        <table class="nutrition-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Được tạo lúc</th>
                <th>Vai trò</th>
                <th>Ảnh</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% for (int i = 0; i < customers.size(); i++) { %>
            <tr>
                <td><%=users.get(i).getId()%></td>
                <td><%=users.get(i).getEmail()%></td>
                <td><%=users.get(i).getPhone()%></td>
                <td><%=users.get(i).getCreatedAt()%></td>
                <td><%=users.get(i).getRole()%></td>
                <td>
                    <img src="<%=request.getContextPath()%><%=users.get(i).getAvatar()%>" alt="">
                </td>
                <td>
                    <button onclick="populateForm()" data-bs-toggle="modal" data-bs-target="#update_modal" class="btn-register m-1">Cập nhật</button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </section>
</main>
<!-- Create Modal -->
<div class="modal fade" id="create_modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="<%=request.getContextPath()%>/admin/categories" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" >Thêm mới loại thực phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="name">Tên</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Thêm mới</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- Update Modal -->
<div class="modal fade" id="update_modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="<%=request.getContextPath()%>/admin/update-category" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" >Cập nhật</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="update_id">ID</label>
                        <input type="text" id="update_id" name="id" required readonly>
                    </div>
                    <div class="form-group">
                        <label for="update_name">Tên</label>
                        <input type="text" id="update_name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="update_created_at">Thêm nhật lúc</label>
                        <input type="text" id="update_created_at" name="name" required readonly>
                    </div>
                    <div class="form-group">
                        <label for="update_updated_at">Cập nhật lúc</label>
                        <input type="text" id="update_updated_at" name="name" required readonly>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- Footer -->
</body>
<%@include file="../common/foot.jsp" %>
<%@include file="../common/js.jsp" %>
<script>

</script>
</html>