<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.RestaurantTable"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Bàn ăn</title>
    <%@ include file="../common/head.jsp" %>
</head>
<body>
<%@ include file="../common/header.jsp" %>

<main>
    <section class="recommendations">
    <h3>Danh sách Bàn ăn</h3>
    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addTableModal">Thêm bàn ăn</button>

    <%
        List<RestaurantTable> tables = (List<RestaurantTable>) session.getAttribute("tables");
        if (tables != null && !tables.isEmpty()) {
    %>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Số bàn</th>
            <th>Khả dụng</th>
            <th>Được sử dụng</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <% for (RestaurantTable t : tables) { %>
        <tr>
            <td><%= t.getId() %></td>
            <td><%= t.getNumber() %></td>
            <td><%= t.isAvailable() ? "Có" : "Không" %></td>
            <td>
                <form action="<%= request.getContextPath() %>/restaurant/change-having-customer" method="post" class="d-inline">
                    <input type="hidden" name="id" value="<%= t.getId() %>">
                    <button class="btn btn-secondary btn-sm" type="submit">
                        <%=t.isHavingCustomer() ? "Đang có khách" : "Bàn trống"%>
                    </button>
                </form>
            </td>
            <td>
                <!-- Nút sửa -->
                <button class="btn btn-warning btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#editTableModal"
                        onclick="populateEditForm(<%= t.getId() %>, <%= t.getNumber() %>, <%= t.isAvailable() %>, <%= t.isHavingCustomer() %>)">
                    Sửa
                </button>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p>Không có bàn nào trong hệ thống.</p>
    <% } %>
    </section>
</main>

<!-- Modal Thêm Bàn -->
<div class="modal fade" id="addTableModal" tabindex="-1" aria-labelledby="addTableLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="<%= request.getContextPath() %>/restaurant/tables" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm bàn ăn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="form-group mb-2">
                    <label for="from">Từ số</label>
                    <input type="number" name="from" id="from" class="form-control" required min="1">
                </div>
                <div class="form-group mb-2">
                    <label for="to">Đến số (nếu thêm nhiều)</label>
                    <input type="number" name="to" id="to" class="form-control" min="1">
                    <small class="text-muted">Để trống nếu chỉ muốn thêm 1 bàn</small>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Thêm bàn</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Cập nhật Bàn -->
<div class="modal fade" id="editTableModal" tabindex="-1" aria-labelledby="editTableLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="<%= request.getContextPath() %>/restaurant/edit-table" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập nhật bàn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="edit_id">
                <div class="form-group mb-2">
                    <label for="edit_number">Số bàn</label>
                    <input type="number" name="number" id="edit_number" class="form-control" required min="1">
                </div>
                <div class="form-group mb-2">
                    <label for="edit_available">Khả dụng</label>
                    <select name="available" id="edit_available" class="form-control">
                        <option value="true">Có</option>
                        <option value="false">Không</option>
                    </select>
                </div>
                <div class="form-group mb-2">
                    <label for="edit_havingCustomer">Đang có khách</label>
                    <select name="havingCustomer" id="edit_havingCustomer" class="form-control">
                        <option value="true">Có</option>
                        <option value="false">Không</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Cập nhật bàn</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../common/foot.jsp" %>
<%@ include file="../common/js.jsp" %>

<script>
    function populateEditForm(id, number, available, havingCustomer) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_number').value = number;
        document.getElementById('edit_available').value = available;
        document.getElementById('edit_havingCustomer').value = havingCustomer;
    }
</script>

</body>
</html>
