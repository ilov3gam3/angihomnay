<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Customer"%>
<%@page import="Model.Constant.Gender"%>
<%@ page import="java.util.List" %>
<%@ page import="Dao.TasteDao" %>
<%@ page import="java.util.Objects" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>AnGiHomNay - Hồ sơ cá nhân</title>
    <%@include file="../common/head.jsp"%>
    <style>
        .profile-section {
            max-width: 800px;
            margin: auto;
            padding: 2rem;
        }
        .avatar-img {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #ccc;
        }
        .form-group label {
            font-weight: bold;
        }
    </style>
</head>
<body>
<%@include file="../common/header.jsp"%>

<main class="profile-section">
    <h2 class="mb-4">Thông tin cá nhân</h2>

    <!-- Avatar Section -->
    <h3>Cập nhật ảnh đại diện</h3>
    <form action="<%= request.getContextPath() %>/update-avatar" method="post" enctype="multipart/form-data" class="mb-4">
        <div class="mb-3">
            <img src="<%=user.getAvatar()%>"
                 alt="Avatar" class="avatar-img mb-2">
        </div>
        <div class="mb-3">
            <label for="avatar">Đổi ảnh đại diện:</label>
            <input type="file" name="avatar" id="avatar" accept="image/*" class="form-control">
        </div>
        <button type="submit" class="btn btn-primary">Cập nhật ảnh</button>
    </form>

    <!-- Profile Info Form -->
    <hr class="my-5">
    <h3>Cập nhật thông tin khách hàng</h3>
    <form action="<%= request.getContextPath() %>/customer/profile" method="post">
        <div class="form-group mb-3">
            <label for="firstName">Họ:</label>
            <input type="text" name="firstName" id="firstName" class="form-control" value="<%= customer.getFirstName() %>" required>
        </div>
        <div class="form-group mb-3">
            <label for="lastName">Tên:</label>
            <input type="text" name="lastName" id="lastName" class="form-control" value="<%= customer.getLastName() %>" required>
        </div>
        <div class="form-group mb-3">
            <label for="dateOfBirth">Ngày sinh:</label>
            <input type="date" name="dateOfBirth" id="dateOfBirth" class="form-control"
                   value="<%= customer.getDateOfBirth() != null ? customer.getDateOfBirth().toString() : "" %>" required>
        </div>
        <div class="form-group mb-3">
            <label>Giới tính:</label>
            <div>
                <label class="me-3">
                    <input type="radio" name="gender" value="MALE"
                        <%= customer.getGender() == Gender.MALE ? "checked" : "" %>> Nam
                </label>
                <label class="me-3">
                    <input type="radio" name="gender" value="FEMALE"
                        <%= customer.getGender() == Gender.FEMALE ? "checked" : "" %>> Nữ
                </label>
                <label>
                    <input type="radio" name="gender" value="OTHER"
                        <%= customer.getGender() == Gender.OTHER ? "checked" : "" %>> Khác
                </label>
            </div>
        </div>
        <button type="submit" class="btn btn-success">Lưu thay đổi</button>
    </form>


    <hr class="my-5">
    <h3>Đổi mật khẩu</h3>
    <form action="<%= request.getContextPath() %>/change-password" method="post">
        <div class="form-group mb-3">
            <label for="oldPassword">Mật khẩu hiện tại:</label>
            <input type="password" name="oldPassword" id="oldPassword" class="form-control" required>
        </div>
        <div class="form-group mb-3">
            <label for="newPassword">Mật khẩu mới:</label>
            <input type="password" name="newPassword" id="newPassword" class="form-control" required>
        </div>
        <div class="form-group mb-3">
            <label for="confirmPassword">Xác nhận mật khẩu mới:</label>
            <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-warning">Cập nhật mật khẩu</button>
    </form>

    <hr class="my-5">
    <h3>Cập nhật thông tin tài khoản</h3>
    <form action="<%= request.getContextPath() %>/user/profile" method="post">
        <div class="form-group mb-3">
            <label for="email">Email:</label>
            <input type="email" name="email" id="email" class="form-control" required value="<%=user.getEmail()%>">
        </div>
        <div class="form-group mb-3">
            <label for="phone">Số điện thoại:</label>
            <input type="tel" name="phone" id="phone" class="form-control" required value="<%=user.getPhone()%>">
        </div>
        <div class="form-group mb-3">
            <label for="address">Xác nhận mật khẩu mới:</label>
            <input type="text" name="address" id="address" class="form-control" required value="<%=user.getAddress()%>">
        </div>
        <button type="submit" class="btn btn-warning">Cập nhật thông tin</button>
    </form>

    <hr class="my-5">
    <h3>Cập nhật khẩu vị của bạn</h3>
    <form action="<%=request.getContextPath()%>/customer/tastes" method="post">
        <div class="form-group mb-3">
            <label for="tastes">khẩu vị của bạn</label>
            <select name="tastes" id="tastes" class="form-control select-tastes" multiple>
                <% List<Taste> tastes =  new TasteDao().getAll(); %>
                <% for (int i = 0; i < tastes.size(); i++) { %>
                <%
                    List<Taste> userTastes = user.getFavoriteTastes();
                    boolean check = false;
                    for (int j = 0; j < userTastes.size(); j++) {
                        if (Objects.equals(tastes.get(i).getId(), userTastes.get(j).getId())){
                            check = true;
                        }
                    }
                %>
                <option value="<%=tastes.get(i).getId()%>" <%= check ? "selected" : "" %>><%=tastes.get(i).getName()%></option>
                <% } %>
            </select>
        </div>
        <button type="submit" class="btn btn-warning">Cập nhật thông tin</button>
    </form>

</main>

<%@include file="../common/footer.jsp"%>
</body>
<%@include file="../common/foot.jsp"%>
<%@include file="../common/js.jsp"%>
<script>
    $(document).ready(function () {
        $('.select-tastes').select2({
            placeholder: "Chọn danh mục cho món ăn",
            width: '100%'
        });
    });
    document.addEventListener("DOMContentLoaded", () => {
        const form = document.querySelector('form[action$="change-password"]');
        if (form) {
            form.addEventListener("submit", function (e) {
                const newPass = form.querySelector("#newPassword").value;
                const confirmPass = form.querySelector("#confirmPassword").value;
                if (newPass !== confirmPass) {
                    alert("Mật khẩu mới và xác nhận không trùng khớp.");
                    e.preventDefault();
                }
            });
        }
    });
</script>

</html>