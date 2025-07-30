<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">


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

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0">Danh sách Bàn ăn</h3>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addTableModal">Thêm bàn ăn</button>
    </div>

    <%
        List<RestaurantTable> tables = (List<RestaurantTable>) session.getAttribute("tables");
        if (tables != null && !tables.isEmpty()) {
    %>
    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
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
                <td><span class="badge bg-<%= t.isAvailable() ? "success" : "secondary" %>">
                        <%= t.isAvailable() ? "Có" : "Không" %>
                    </span>
                </td>
                <td>
                    <form action="<%= request.getContextPath() %>/restaurant/change-having-customer" method="post" class="d-inline">
                        <input type="hidden" name="id" value="<%= t.getId() %>">
                        <button class="btn btn-sm <%= t.isHavingCustomer() ? "btn-danger" : "btn-outline-success" %>" type="submit">
                            <%= t.isHavingCustomer() ? "Đang có khách" : "Bàn trống" %>
                        </button>
                    </form>
                </td>
                <td>
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
    </div>
    <% } else { %>
    <div class="alert alert-info">Không có bàn nào trong hệ thống.</div>
    <% } %>

    <!-- Modal Thêm Bàn -->
    <div class="modal fade" id="addTableModal" tabindex="-1" aria-labelledby="addTableLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="<%= request.getContextPath() %>/restaurant/tables" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm bàn ăn</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="from" class="form-label">Từ số</label>
                        <input type="number" name="from" id="from" class="form-control" required min="1">
                    </div>
                    <div class="mb-3">
                        <label for="to" class="form-label">Đến số (nếu thêm nhiều)</label>
                        <input type="number" name="to" id="to" class="form-control" min="1">
                        <div class="form-text">Để trống nếu chỉ muốn thêm 1 bàn</div>
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
                    <div class="mb-3">
                        <label for="edit_number" class="form-label">Số bàn</label>
                        <input type="number" name="number" id="edit_number" class="form-control" required min="1">
                    </div>
                    <div class="mb-3">
                        <label for="edit_available" class="form-label">Khả dụng</label>
                        <select name="available" id="edit_available" class="form-select">
                            <option value="true">Có</option>
                            <option value="false">Không</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="edit_havingCustomer" class="form-label">Đang có khách</label>
                        <select name="havingCustomer" id="edit_havingCustomer" class="form-select">
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
</main>
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
    function populateEditForm(id, number, available, havingCustomer) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_number').value = number;
        document.getElementById('edit_available').value = available;
        document.getElementById('edit_havingCustomer').value = havingCustomer;
    }
</script>
</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
