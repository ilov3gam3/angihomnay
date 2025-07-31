<%@ page import="java.util.List" %>
<%@ page import="Model.Constant.Gender" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<% List<User> users = (List<User>) request.getAttribute("users"); %>
<% List<Customer> customers = (List<Customer>) request.getAttribute("customers"); %>
<% List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants"); %>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:43 GMT -->
<head>
    <title>Foores - Single Restaurant Version</title>
    <%@include file="../common/reservation/head.jsp"%>
</head>

<body>

<div id="preloader">
    <div data-loader="circle-side"></div>
</div><!-- /Page Preload -->

<%@include file="../common/reservation/header.jsp"%>
<!-- /header -->
<main class="bg_gray">
    <div class="container margin_60_40">
        <div class="main_title center">
            <h2>Danh sách Người dùng</h2>
            <p>Quản lý User - Customer - Restaurant</p>
        </div>

        <div class="text-center mb-3">
            <button data-bs-toggle="modal" data-bs-target="#create_modal" class="btn btn-success m-1">Thêm người dùng</button>
        </div>

        <div class="d-flex justify-content-center mb-3">
            <div class="btn-group" role="group">
                <button class="btn btn-primary" onclick="showTable('userTable')">User</button>
                <button class="btn btn-primary" onclick="showTable('customerTable')">Customer</button>
                <button class="btn btn-primary" onclick="showTable('restaurantTable')">Restaurant</button>
            </div>
        </div>

        <!-- User Table -->
        <div class="table-responsive">
            <table id="userTable" class="table table-bordered nutrition-table">
                <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Địa chỉ</th>
                    <th>Được tạo lúc</th>
                    <th>Vai trò</th>
                    <th>Ảnh</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% for (int i = 0; i < users.size(); i++) {
                    User temp = users.get(i);
                    Customer c = customers.stream().filter(cus -> cus.getId().equals(temp.getId())).findFirst().orElse(null);
                    Restaurant r = restaurants.stream().filter(res -> res.getId().equals(temp.getId())).findFirst().orElse(null);
                %>
                <tr>
                    <td><%= temp.getId() %></td>
                    <td><%= temp.getEmail() %></td>
                    <td><%= temp.getPhone() %></td>
                    <td><%= temp.getAddress() %></td>
                    <td><%= temp.getCreatedAt() %></td>
                    <td><%= temp.getRole() %></td>
                    <td>
                        <img src="<%= temp.getAvatar() %>" alt="<%= temp.getEmail() %>" class="img-fluid rounded-circle" style="width:50px;height:50px;object-fit:cover;">
                    </td>
                    <td>
                        <button class="btn btn-outline-primary btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#update_modal"
                                onclick="populateUpdateForm(this)"
                                data-id="<%= temp.getId() %>"
                                data-email="<%= temp.getEmail() %>"
                                data-phone="<%= temp.getPhone() %>"
                                data-address="<%= temp.getAddress() %>"
                                data-role="<%= temp.getRole() %>"
                                data-blocked="<%= temp.isBlocked() %>"

                                data-firstname="<%= c != null ? c.getFirstName() : "" %>"
                                data-lastname="<%= c != null ? c.getLastName() : "" %>"
                                data-dob="<%= c != null ? c.getDateOfBirth() : "" %>"
                                data-gender="<%= c != null ? c.getGender() : "" %>"

                                data-closeTime="<%= r != null ? r.getCloseTime() : "" %>"
                                data-openTime="<%= r != null ? r.getOpenTime() : "" %>"
                                data-name="<%= r != null ? r.getName() : "" %>"
                                data-mapEmbedUrl='<%= r != null ? r.getMapEmbedUrl() : "" %>'
                        >Cập nhật</button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Customer Table -->
        <div class="table-responsive">
            <table id="customerTable" class="table table-bordered nutrition-table" style="display: none;">
                <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Tên</th>
                    <th>Ngày sinh</th>
                    <th>Giới tính</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% for (Customer c : customers) { %>
                <tr>
                    <td><%= c.getId() %></td>
                    <td><%= c.getUser().getEmail() %></td>
                    <td><%= c.getUser().getPhone() %></td>
                    <td><%= c.getLastName() %> <%= c.getFirstName() %></td>
                    <td><%= c.getDateOfBirth() %></td>
                    <td><%= c.getGender() == Gender.MALE ? "Nam" : c.getGender() == Gender.FEMALE ? "Nữ" : "Khác" %></td>
                    <td>
                        <button class="btn btn-outline-primary btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#update_modal"
                                onclick="populateUpdateForm(this)"
                                data-id="<%= c.getId() %>"
                                data-email="<%= c.getUser().getEmail() %>"
                                data-phone="<%= c.getUser().getPhone() %>"
                                data-address="<%= c.getUser().getAddress() %>"
                                data-role="<%= c.getUser().getRole() %>"
                                data-blocked="<%= c.getUser().isBlocked() %>"
                                data-firstname="<%= c.getFirstName() %>"
                                data-lastname="<%= c.getLastName() %>"
                                data-dob="<%= c.getDateOfBirth() %>"
                                data-gender="<%= c.getGender() %>"
                        >Cập nhật</button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Restaurant Table -->
        <div class="table-responsive">
            <table id="restaurantTable" class="table table-bordered nutrition-table" style="display: none;">
                <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Email</th>
                    <th>SĐT</th>
                    <th>Tên</th>
                    <th>Giờ mở - đóng</th>
                    <th>Map</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% for (Restaurant r : restaurants) { %>
                <tr>
                    <td><%= r.getId() %></td>
                    <td><%= r.getUser().getEmail() %></td>
                    <td><%= r.getUser().getPhone() %></td>
                    <td><%= r.getName() %></td>
                    <td><%= r.getOpenTime() %> - <%= r.getCloseTime() %></td>
                    <td>
                        <a class="btn btn-sm btn-outline-info"
                           href="<%=request.getContextPath()%>/views/public/preview-map.jsp?id=<%= r.getId() %>"
                           target="_blank">Xem bản đồ</a>
                    </td>
                    <td>
                        <button class="btn btn-outline-primary btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#update_modal"
                                onclick="populateUpdateForm(this)"
                                data-id="<%= r.getId() %>"
                                data-email="<%= r.getUser().getEmail() %>"
                                data-phone="<%= r.getUser().getPhone() %>"
                                data-address="<%= r.getUser().getAddress() %>"
                                data-role="<%= r.getUser().getRole() %>"
                                data-blocked="<%= r.getUser().isBlocked() %>"
                                data-name="<%= r.getName() %>"
                                data-mapEmbedUrl='<%= r.getMapEmbedUrl() %>'
                                data-openTime="<%= r.getOpenTime() %>"
                                data-closeTime="<%= r.getCloseTime() %>"
                        >Cập nhật</button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>
<div class="modal fade" id="create_modal" tabindex="-1" aria-labelledby="createModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/admin/user" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="createModalLabel">Thêm người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body row g-3">
                    <div class="col-md-6">
                        <label for="createRole" class="form-label"><i class="fas fa-user-tag"></i> Vai trò</label>
                        <select name="role" id="createRole" class="form-select" onchange="onRoleChange(this.value)">
                            <option value="ADMIN">Admin</option>
                            <option value="CUSTOMER">Customer</option>
                            <option value="RESTAURANT">Restaurant</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="email" class="form-label"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" name="email" id="email" class="form-control input-focus-animation" required>
                    </div>
                    <div class="col-md-6">
                        <label for="password" class="form-label"><i class="fas fa-lock"></i> Mật khẩu</label>
                        <input type="password" name="password" id="password" class="form-control input-focus-animation" required>
                    </div>
                    <div class="col-md-6">
                        <label for="phone" class="form-label"><i class="fas fa-phone"></i> SĐT</label>
                        <input type="text" name="phone" id="phone" class="form-control input-focus-animation" required>
                    </div>
                    <div class="col-12">
                        <label for="address" class="form-label"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <input id="address" type="text" name="address" class="form-control input-focus-animation">
                    </div>

                    <!-- CUSTOMER ONLY -->
                    <div id="customerFields" style="display: none;">
                        <div class="col-md-6">
                            <label for="firstName" class="form-label"><i class="fas fa-user"></i> Họ</label>
                            <input type="text" name="firstName" id="firstName" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="lastName" class="form-label"><i class="fas fa-user"></i> Tên</label>
                            <input type="text" name="lastName" id="lastName" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="dob" class="form-label"><i class="fas fa-calendar-alt"></i> Ngày sinh</label>
                            <input type="date" name="dob" id="dob" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="gender" class="form-label"><i class="fas fa-venus-mars"></i> Giới tính</label>
                            <select name="gender" id="gender" class="form-select input-focus-animation">
                                <option value="MALE">Nam</option>
                                <option value="FEMALE">Nữ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                    </div>

                    <!-- RESTAURANT ONLY -->
                    <div id="restaurantFields" style="display: none;">
                        <div class="col-12">
                            <label for="name" class="form-label"><i class="fas fa-store"></i> Tên nhà hàng</label>
                            <input type="text" name="name" id="name" class="form-control input-focus-animation">
                        </div>
                        <div class="col-12">
                            <label for="mapEmbedUrl" class="form-label"><i class="fas fa-map"></i> Google Map Embed URL</label>
                            <input type="text" name="mapEmbedUrl" id="mapEmbedUrl" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="openTime" class="form-label"><i class="fas fa-clock"></i> Giờ mở cửa</label>
                            <input type="time" name="openTime" id="openTime" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="closeTime" class="form-label"><i class="fas fa-clock"></i> Giờ đóng cửa</label>
                            <input type="time" name="closeTime" id="closeTime" class="form-control input-focus-animation">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Thêm</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- Update Modal -->
<div class="modal fade" id="update_modal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <form action="<%=request.getContextPath()%>/admin/update-user" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateModalLabel">Cập nhật người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body row g-3">
                    <input type="hidden" id="update_id" name="id" readonly required>

                    <div class="col-md-6">
                        <label for="update_email" class="form-label"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" name="email" id="update_email" class="form-control input-focus-animation" required>
                    </div>
                    <div class="col-md-6">
                        <label for="update_phone" class="form-label"><i class="fas fa-phone"></i> SĐT</label>
                        <input type="text" name="phone" id="update_phone" class="form-control input-focus-animation" required>
                    </div>
                    <div class="col-12">
                        <label for="update_address" class="form-label"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <input type="text" name="address" id="update_address" class="form-control input-focus-animation">
                    </div>
                    <div class="col-12">
                        <label for="update_blocked" class="form-label"><i class="fas fa-ban"></i> Trạng thái</label>
                        <select name="blocked" id="update_blocked" class="form-select input-focus-animation">
                            <option value="false">Không bị chặn</option>
                            <option value="true">Bị chặn</option>
                        </select>
                    </div>

                    <!-- CUSTOMER ONLY -->
                    <div id="editCustomerFields" style="display: none;">
                        <div class="col-md-6">
                            <label for="update_firstName" class="form-label"><i class="fas fa-user"></i> Họ</label>
                            <input type="text" name="firstName" id="update_firstName" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="update_lastName" class="form-label"><i class="fas fa-user"></i> Tên</label>
                            <input type="text" name="lastName" id="update_lastName" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="update_dob" class="form-label"><i class="fas fa-calendar-alt"></i> Ngày sinh</label>
                            <input type="date" name="dob" id="update_dob" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="update_gender" class="form-label"><i class="fas fa-venus-mars"></i> Giới tính</label>
                            <select name="gender" id="update_gender" class="form-select input-focus-animation">
                                <option value="MALE">Nam</option>
                                <option value="FEMALE">Nữ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                    </div>

                    <!-- RESTAURANT ONLY -->
                    <div id="editRestaurantFields" style="display: none;">
                        <div class="col-12">
                            <label for="update_name" class="form-label"><i class="fas fa-store"></i> Tên quán</label>
                            <input type="text" name="name" id="update_name" class="form-control input-focus-animation">
                        </div>
                        <div class="col-12">
                            <label for="update_mapEmbedUrl" class="form-label"><i class="fas fa-map"></i> Google Map Embed URL</label>
                            <input type="text" name="mapEmbedUrl" id="update_mapEmbedUrl" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="update_openTime" class="form-label"><i class="fas fa-clock"></i> Giờ mở cửa</label>
                            <input type="time" name="openTime" id="update_openTime" class="form-control input-focus-animation">
                        </div>
                        <div class="col-md-6">
                            <label for="update_closeTime" class="form-label"><i class="fas fa-clock"></i> Giờ đóng cửa</label>
                            <input type="time" name="closeTime" id="update_closeTime" class="form-control input-focus-animation">
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- /main -->

<%@include file="../common/reservation/footer.jsp"%>
<!--/footer-->

<div id="toTop"></div><!-- Back to top button -->

<!-- Modal terms -->
<div class="modal fade" id="terms-txt" tabindex="-1" role="dialog" aria-labelledby="termsLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="termsLabel">Terms and conditions</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Lorem ipsum dolor sit amet, in porro albucius qui, in <strong>nec quod novum accumsan</strong>, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt sensibus.</p>
                <p>Lorem ipsum dolor sit amet, in porro albucius qui, in nec quod novum accumsan, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt sensibus. Lorem ipsum dolor sit amet, <strong>in porro albucius qui</strong>, in nec quod novum accumsan, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt sensibus.</p>
                <p>Lorem ipsum dolor sit amet, in porro albucius qui, in nec quod novum accumsan, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt sensibus.</p>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<%@include file="../common/reservation/js.jsp"%>
<script>
    function showTable(id) {
        document.querySelectorAll(".nutrition-table").forEach(el => el.style.display = "none");
        document.getElementById(id).style.display = "table";
    }

    function onRoleChange(role) {
        document.getElementById("customerFields").style.display = (role === "CUSTOMER") ? "block" : "none";
        document.getElementById("restaurantFields").style.display = (role === "RESTAURANT") ? "block" : "none";
    }
    function populateUpdateForm(btn) {
        const role = btn.dataset.role;
        document.getElementById("update_id").value = btn.dataset.id;
        document.getElementById("update_email").value = btn.dataset.email;
        document.getElementById("update_phone").value = btn.dataset.phone;
        document.getElementById("update_blocked").value = btn.dataset.blocked;
        document.getElementById("update_address").value = btn.dataset.address || '';

        // Hiển thị form theo role
        document.getElementById("editCustomerFields").style.display = role === "CUSTOMER" ? "block" : "none";
        document.getElementById("editRestaurantFields").style.display = role === "RESTAURANT" ? "block" : "none";

        if (role === "<%=Role.CUSTOMER%>") {
            document.getElementById("update_firstName").value = btn.dataset.firstname || '';
            document.getElementById("update_lastName").value = btn.dataset.lastname || '';
            document.getElementById("update_dob").value = btn.dataset.dob || '';
            document.getElementById("update_gender").value = btn.dataset.gender || '';
        }

        if (role === "<%=Role.RESTAURANT%>") {
            document.getElementById("update_name").value = btn.dataset.name || '';
            document.getElementById("update_mapEmbedUrl").value = btn.dataset.mapembedurl || '';
            document.getElementById("update_openTime").value = btn.dataset.opentime || '';
            document.getElementById("update_closeTime").value = btn.dataset.closetime || '';
        }
    }
</script>
</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
