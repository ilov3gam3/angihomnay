<%@ page import="java.util.*" %>
<%@ page import="Dao.TasteDao" %>
<%@ page import="Model.Taste" %>
<%@ page import="Model.Customer" %>
<%@ page import="Model.Constant.Gender" %>
<%@ page import="Dao.AllergyTypeDao" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thông tin cá nhân</title>
    <%@include file="../common/reservation/head.jsp"%>
</head>
<body>

<%@include file="../common/reservation/header.jsp"%>
<%
    Customer customer = (Customer) request.getAttribute("customer");
    List<Taste> tastes = new TasteDao().getAll();
    List<Taste> userTastes = user.getFavoriteTastes() == null ? new ArrayList<>() : user.getFavoriteTastes().stream().toList();
%>
<main class="container py-5">
    <h2 class="mb-4">Trang cá nhân</h2>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-4" id="profileTabs" role="tablist">
        <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#avatar">Ảnh đại diện</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#info">Thông tin cá nhân</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#password">Đổi mật khẩu</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#account">Thông tin tài khoản</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tastes">Khẩu vị</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#allergies">Dị ứng</button></li>
    </ul>

    <div class="tab-content">
        <!-- Avatar -->
        <div class="tab-pane fade show active" id="avatar">
            <form action="<%= request.getContextPath() %>/update-avatar" method="post" enctype="multipart/form-data">
                <div class="text-center mb-3">
                    <img src="<%=user.getAvatar()%>" class="rounded-circle border" style="width:150px; height:150px;object-fit: cover">
                </div>
                <div class="mb-3">
                    <input type="file" name="avatar" accept="image/*" class="form-control">
                </div>
                <button type="submit" class="btn btn-primary">Cập nhật ảnh</button>
            </form>
        </div>

        <!-- Personal Info -->
        <div class="tab-pane fade" id="info">
            <form action="<%= request.getContextPath() %>/customer/profile" method="post">
                <div class="mb-3"><label>Họ:</label><input type="text" name="firstName" class="form-control" value="<%=customer.getFirstName()%>"></div>
                <div class="mb-3"><label>Tên:</label><input type="text" name="lastName" class="form-control" value="<%=customer.getLastName()%>"></div>
                <div class="mb-3"><label>Ngày sinh:</label><input type="date" name="dateOfBirth" class="form-control" value="<%= customer.getDateOfBirth() != null ? customer.getDateOfBirth().toString() : "" %>"></div>
                <div class="mb-3">
                    <label>Giới tính:</label>
                    <div>
                        <label><input type="radio" name="gender" value="MALE" <%= customer.getGender() == Gender.MALE ? "checked" : "" %>> Nam</label>
                        <label class="ms-3"><input type="radio" name="gender" value="FEMALE" <%= customer.getGender() == Gender.FEMALE ? "checked" : "" %>> Nữ</label>
                        <label class="ms-3"><input type="radio" name="gender" value="OTHER" <%= customer.getGender() == Gender.OTHER ? "checked" : "" %>> Khác</label>
                    </div>
                </div>
                <button type="submit" class="btn btn-success">Lưu thay đổi</button>
            </form>
        </div>

        <!-- Password -->
        <div class="tab-pane fade" id="password">
            <form action="<%= request.getContextPath() %>/change-password" method="post">
                <div class="mb-3"><label>Mật khẩu cũ:</label><input type="password" name="oldPassword" class="form-control" required></div>
                <div class="mb-3"><label>Mật khẩu mới:</label><input type="password" name="newPassword" id="newPassword" class="form-control" required></div>
                <div class="mb-3"><label>Xác nhận mật khẩu:</label><input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required></div>
                <button type="submit" class="btn btn-warning">Đổi mật khẩu</button>
            </form>
        </div>

        <!-- Account Info -->
        <div class="tab-pane fade" id="account">
            <form action="<%= request.getContextPath() %>/user/profile" method="post">
                <div class="mb-3"><label>Email:</label><input type="email" name="email" class="form-control" value="<%= user.getEmail() %>" required></div>
                <div class="mb-3"><label>Số điện thoại:</label><input type="tel" name="phone" class="form-control" value="<%= user.getPhone() %>" required></div>
                <div class="mb-3"><label>Địa chỉ:</label><input type="text" name="address" class="form-control" value="<%= user.getAddress() %>" required></div>
                <button type="submit" class="btn btn-warning">Cập nhật</button>
            </form>
        </div>

        <!-- Tastes -->
        <div class="tab-pane fade" id="tastes">
            <form action="<%=request.getContextPath()%>/customer/tastes" method="post">
                <div class="mb-3">
                    <label>Khẩu vị yêu thích:</label>
                    <select name="tastes" class="form-control select-tastes" multiple>
                        <% for (Taste t : tastes) {
                            boolean selected = userTastes.stream().anyMatch(u -> Objects.equals(u.getId(), t.getId()));
                        %>
                        <option value="<%=t.getId()%>" <%= selected ? "selected" : "" %>><%=t.getName()%></option>
                        <% } %>
                    </select>
                </div>
                <button type="submit" class="btn btn-warning">Cập nhật khẩu vị</button>
            </form>
        </div>

        <!-- Dị ứng thực phẩm -->
        <div class="tab-pane fade" id="allergies">
            <form action="<%=request.getContextPath()%>/customer/allergies" method="post">
                <div class="mb-3">
                    <label>Bạn bị dị ứng với:</label>
                    <select class="form-select select2 select-allergies" name="allergies" multiple="multiple" style="width: 100%;">
                        <%
                            List<AllergyType> allAllergies = new AllergyTypeDao().getAll();
                            Set<AllergyType> userAllergies = user.getAllergies() == null ? new HashSet<>() : user.getAllergies();
                            for (AllergyType allergy : allAllergies) {
                                boolean selected = userAllergies.contains(allergy);
                        %>
                        <option value="<%= allergy.getId() %>" <%= selected ? "selected" : "" %>>
                            <%= allergy.getName() %>
                        </option>
                        <% } %>
                    </select>
                </div>
                <button type="submit" class="btn btn-warning">Cập nhật khẩu vị</button>
            </form>
        </div>

    </div>
</main>

<%@include file="../common/reservation/footer.jsp"%>
<%@include file="../common/reservation/js.jsp"%>

<script>
    $(document).ready(function () {
        $('.select-tastes').select2({
            placeholder: "Chọn khẩu vị bạn yêu thích",
            width: '100%'
        });
        $('.select-allergies').select2({
            placeholder: "Chọn khẩu vị bạn yêu thích",
            width: '100%'
        });

        // Validate password confirmation
        $('form[action$="change-password"]').on('submit', function (e) {
            const newPass = $('#newPassword').val();
            const confirmPass = $('#confirmPassword').val();
            if (newPass !== confirmPass) {
                alert("Mật khẩu mới và xác nhận không trùng khớp.");
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>
