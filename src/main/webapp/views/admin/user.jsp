<%@ page import="java.util.List" %>
<%@ page import="Model.Constant.Gender" %>
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
        <button data-bs-toggle="modal" data-bs-target="#create_modal" class="btn-register m-1">Thêm người dùng</button>
        <div class="btn-group mb-2" role="group">
            <button class="btn btn-primary" onclick="showTable('userTable')">User</button>
            <button class="btn btn-primary" onclick="showTable('customerTable')">Customer</button>
            <button class="btn btn-primary" onclick="showTable('restaurantTable')">Restaurant</button>
        </div>
        <% List<User> users = (List<User>) request.getAttribute("users"); %>
        <% List<Customer> customers = (List<Customer>) request.getAttribute("customers"); %>
        <% List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants"); %>
        <%-- User table --%>
        <table id="userTable" class="nutrition-table">
            <thead>
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
                <td><%=users.get(i).getId()%></td>
                <td><%=users.get(i).getEmail()%></td>
                <td><%=users.get(i).getPhone()%></td>
                <td><%=users.get(i).getAddress()%></td>
                <td><%=users.get(i).getCreatedAt()%></td>
                <td><%=users.get(i).getRole()%></td>
                <td>
                    <img src="<%=users.get(i).getAvatar()%>" alt="<%=users.get(i).getEmail()%>" style="width:50px;height:50px;object-fit: cover">
                </td>
                <td>
                    <button class="btn-register m-1"
                            data-bs-toggle="modal"
                            data-bs-target="#update_modal"
                            onclick="populateUpdateForm(this)"
                            data-id="<%= users.get(i).getId() %>"
                            data-email="<%= users.get(i).getEmail() %>"
                            data-phone="<%= users.get(i).getPhone() %>"
                            data-address="<%= users.get(i).getAddress() %>"
                            data-role="<%= users.get(i).getRole() %>"
                            data-blocked="<%= users.get(i).isBlocked() %>"

                            data-firstname="<%= c != null ? c.getFirstName() : "" %>"
                            data-lastname="<%= c != null ? c.getLastName() : "" %>"
                            data-dob="<%= c != null ? c.getDateOfBirth() : "" %>"
                            data-gender="<%= c != null ? c.getGender() : "" %>"

                            data-closeTime="<%= r != null ? r.getCloseTime() : "" %>"
                            data-openTime="<%= r != null ? r.getOpenTime() : "" %>"
                            data-name="<%= r != null ? r.getName() : "" %>"
                            data-mapEmbedUrl='<%= r != null ? r.getMapEmbedUrl() : "" %>'
                    > Cập nhật </button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <%-- Customer table --%>
        <table id="customerTable" style="display: none;" class="nutrition-table">
            <thead>
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
            <% for (int i = 0; i < customers.size(); i++) { %>
            <tr>
                <td><%=customers.get(i).getId()%></td>
                <td><%=customers.get(i).getUser().getEmail()%></td>
                <td><%=customers.get(i).getUser().getPhone()%></td>
                <td><%=customers.get(i).getLastName()%> <%=customers.get(i).getFirstName()%></td>
                <td><%=customers.get(i).getDateOfBirth()%></td>
                <td><%=customers.get(i).getGender() == Gender.MALE ? "NAM" : customers.get(i).getGender() == Gender.FEMALE ? "Nữ" : "Khác"%></td>
                <td>
                    <button class="btn-register m-1"
                            data-bs-toggle="modal"
                            data-bs-target="#update_modal"
                            onclick="populateUpdateForm(this)"
                            data-id="<%= customers.get(i).getId() %>"
                            data-email="<%= customers.get(i).getUser().getEmail() %>"
                            data-phone="<%= customers.get(i).getUser().getPhone() %>"
                            data-address="<%= customers.get(i).getUser().getAddress() %>"
                            data-role="<%= customers.get(i).getUser().getRole() %>"
                            data-blocked="<%= customers.get(i).getUser().isBlocked() %>"

                            data-firstname="<%= customers.get(i).getFirstName() %>"
                            data-lastname="<%= customers.get(i).getLastName() %>"
                            data-dob="<%= customers.get(i).getDateOfBirth() %>"
                            data-gender="<%= customers.get(i).getGender() %>"
                    > Cập nhật </button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <%-- Restaurant table --%>
        <table id="restaurantTable" style="display: none;" class="nutrition-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Tên</th>
                <th>Thời gian</th>
                <th>Url bản đồ</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% for (int i = 0; i < restaurants.size(); i++) { %>
            <tr>
                <td><%=restaurants.get(i).getId()%></td>
                <td><%=restaurants.get(i).getUser().getEmail()%></td>
                <td><%=restaurants.get(i).getUser().getPhone()%></td>
                <td><%=restaurants.get(i).getName()%></td>
                <td><%=restaurants.get(i).getOpenTime()%> - <%=restaurants.get(i).getCloseTime()%></td>
                <td>
                    <a target="_blank" href="<%=request.getContextPath()%>/views/public/preview-map.jsp?id=<%=restaurants.get(i).getId()%>">
                        Xem bản đồ
                    </a>
                </td>
                <td>
                    <button class="btn-register m-1"
                            data-bs-toggle="modal"
                            data-bs-target="#update_modal"
                            onclick="populateUpdateForm(this)"
                            data-id="<%= restaurants.get(i).getId() %>"
                            data-email="<%= restaurants.get(i).getUser().getEmail() %>"
                            data-phone="<%= restaurants.get(i).getUser().getPhone() %>"
                            data-address="<%= restaurants.get(i).getUser().getAddress() %>"
                            data-role="<%= restaurants.get(i).getUser().getRole() %>"
                            data-blocked="<%= restaurants.get(i).getUser().isBlocked() %>"

                            data-closeTime="<%= restaurants.get(i).getCloseTime() %>"
                            data-openTime="<%= restaurants.get(i).getOpenTime() %>"
                            data-mapEmbedUrl='<%= restaurants.get(i).getMapEmbedUrl() %>'
                            data-name="<%= restaurants.get(i).getName() %>"
                    > Cập nhật </button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </section>
</main>
<!-- Create Modal -->
<div class="modal fade" id="create_modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/admin/user" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="createRole"><i class="fas fa-envelope"></i>Vai trò</label>
                        <select name="role" id="createRole" class="form-control" onchange="onRoleChange(this.value)">
                            <option value="ADMIN">Admin</option>
                            <option value="CUSTOMER">Customer</option>
                            <option value="RESTAURANT">Restaurant</option>
                        </select>
                    </div>
                    <!-- Chung -->
                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" name="email" id="email" class="input-focus-animation" placeholder="Email" required>
                    </div>
                    <div class="form-group">
                        <label for="password"><i class="fas fa-lock"></i> Mật khẩu</label>
                        <input type="password" name="password" id="password" class="input-focus-animation" placeholder="Mật khẩu" required>
                    </div>
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> SĐT</label>
                        <input type="text" name="phone" id="phone" class="input-focus-animation" placeholder="SĐT" required>
                    </div>
                    <div class="form-group">
                        <label for="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <input id="address" type="text" name="address" class="input-focus-animation" placeholder="Địa chỉ quán">
                    </div>

                    <!-- CUSTOMER ONLY -->
                    <div id="customerFields" style="display: none;">
                        <div class="form-group">
                            <label for="firstName"><i class="fas fa-user"></i> Họ</label>
                            <input type="text" name="firstName" class="input-focus-animation" id="firstName" placeholder="Nhập họ">
                        </div>
                        <div class="form-group">
                            <label for="lastName"><i class="fas fa-user"></i> Tên</label>
                            <input type="text" name="lastName" class="input-focus-animation" id="lastName" placeholder="Nhập tên">
                        </div>
                        <div class="form-group">
                            <label for="dob"><i class="fas fa-calendar-alt"></i> Ngày sinh</label>
                            <input type="date" name="dob" class="input-focus-animation" id="dob">
                        </div>
                        <div class="form-group">
                            <label for="gender"><i class="fas fa-venus-mars"></i> Giới tính</label>
                            <select id="gender" name="gender" class="form-control input-focus-animation">
                                <option value="MALE">Nam</option>
                                <option value="FEMALE">Nữ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                    </div>

                    <!-- RESTAURANT ONLY -->
                    <div id="restaurantFields" style="display: none;">
                        <div class="form-group">
                            <label for="name"><i class="fas fa-user"></i> Tên nhà hàng</label>
                            <input type="text" name="name" class="input-focus-animation" id="name" placeholder="Nhập tên">
                        </div>
                        <div class="form-group">
                            <label for="mapEmbedUrl"><i class="fas fa-map"></i> Google Map Embed URL</label>
                            <input id="mapEmbedUrl" type="text" name="mapEmbedUrl" class="input-focus-animation" placeholder="Map URL">
                        </div>
                        <div class="form-group">
                            <label for="openTime"><i class="fas fa-clock"></i> Giờ mở cửa</label>
                            <input id="openTime" type="time" name="openTime" class="input-focus-animation">
                        </div>
                        <div class="form-group">
                            <label for="closeTime"><i class="fas fa-clock"></i> Giờ đóng cửa</label>
                            <input id="closeTime" type="time" name="closeTime" class="input-focus-animation">
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
<div class="modal fade" id="update_modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="<%=request.getContextPath()%>/admin/update-user" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Cập nhật người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Hidden ID -->
                    <input type="hidden" id="update_id" name="id" required readonly>

                    <!-- Chung -->
                    <div class="form-group">
                        <label for="update_email"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" name="email" id="update_email" class="input-focus-animation" placeholder="Email" required>
                    </div>
                    <div class="form-group">
                        <label for="update_phone"><i class="fas fa-phone"></i> SĐT</label>
                        <input type="text" name="phone" id="update_phone" class="input-focus-animation" placeholder="Số điện thoại" required>
                    </div>
                    <div class="form-group">
                        <label for="update_address"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                        <input type="text" name="address" id="update_address" class="input-focus-animation" placeholder="Địa chỉ">
                    </div>
                    <div class="form-group">
                        <label for="update_blocked"><i class="fas fa-map-marker-alt"></i> Bị chặn</label>
                        <select class="form-control" name="blocked" id="update_blocked" >
                            <option value="false">Không bị chặn</option>
                            <option value="true">Bị chặn</option>
                        </select>
                    </div>

                    <!-- CUSTOMER ONLY -->
                    <div id="editCustomerFields" style="display: none;">
                        <div class="form-group">
                            <label for="update_firstName"><i class="fas fa-user"></i> Họ</label>
                            <input type="text" name="firstName" id="update_firstName" class="input-focus-animation" placeholder="Nhập họ">
                        </div>
                        <div class="form-group">
                            <label for="update_lastName"><i class="fas fa-user"></i> Tên</label>
                            <input type="text" name="lastName" id="update_lastName" class="input-focus-animation" placeholder="Nhập tên">
                        </div>
                        <div class="form-group">
                            <label for="update_dob"><i class="fas fa-calendar-alt"></i> Ngày sinh</label>
                            <input type="date" name="dob" id="update_dob" class="input-focus-animation">
                        </div>
                        <div class="form-group">
                            <label for="update_gender"><i class="fas fa-venus-mars"></i> Giới tính</label>
                            <select name="gender" id="update_gender" class="form-control input-focus-animation">
                                <option value="MALE">Nam</option>
                                <option value="FEMALE">Nữ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                    </div>

                    <!-- RESTAURANT ONLY -->
                    <div id="editRestaurantFields" style="display: none;">
                        <div class="form-group">
                            <label for="update_name"><i class="fas fa-store"></i> Tên quán</label>
                            <input type="text" name="name" id="update_name" class="input-focus-animation" placeholder="Tên quán">
                        </div>
                        <div class="form-group">
                            <label for="update_mapEmbedUrl"><i class="fas fa-map"></i> Google Map Embed URL</label>
                            <input type="text" name="mapEmbedUrl" id="update_mapEmbedUrl" class="input-focus-animation" placeholder="Map URL">
                        </div>
                        <div class="form-group">
                            <label for="update_openTime"><i class="fas fa-clock"></i> Giờ mở cửa</label>
                            <input type="time" name="openTime" id="update_openTime" class="input-focus-animation">
                        </div>
                        <div class="form-group">
                            <label for="update_closeTime"><i class="fas fa-clock"></i> Giờ đóng cửa</label>
                            <input type="time" name="closeTime" id="update_closeTime" class="input-focus-animation">
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
<!-- Footer -->
</body>
<%@include file="../common/foot.jsp" %>
<%@include file="../common/js.jsp" %>
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
</html>