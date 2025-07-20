<%@ page import="java.util.List" %>
<%@ page import="Model.Category, Model.Food" %>
<%@ page import="Model.Category" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>AnGiHomNay - Món ăn</title>
    <%@include file="../common/head.jsp" %>
</head>
<body>
<%@include file="../common/header.jsp" %>

<main>
    <section class="recommendations">
        <h3>Danh sách Món ăn</h3>
        <button data-bs-toggle="modal" data-bs-target="#create_modal" class="btn-register m-1">Thêm món ăn mới</button>

        <% List<Food> foods = (List<Food>) request.getAttribute("foods"); %>
        <table class="nutrition-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Mô tả</th>
                <th>Giá</th>
                <th>Ảnh</th>
                <th>Danh mục</th>
                <th>Khả dụng</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% for (Food food : foods) { %>
            <tr>
                <td><%= food.getId() %></td>
                <td><%= food.getName() %></td>
                <td><%= food.getDescription() %></td>
                <td><%= food.getPrice() %>đ</td>
                <td>
                    <img src="<%=request.getContextPath()%>/<%= food.getImage() %>" alt="food" width="80"/>
                </td>
                <td>
                    <ul>
                        <% for (Category c : food.getCategories()) { %>
                        <li><%= c.getName() %></li>
                        <% } %>
                    </ul>
                </td>
                <td>
                    <%=food.isAvailable() ? "Có": "Không"%>
                </td>
                <td>
                    <button
                            class="btn btn-warning btn-sm"
                            data-bs-toggle="modal"
                            data-bs-target="#update_modal"
                            onclick="populateEditForm(this)"
                            data-id="<%= food.getId() %>"
                            data-name="<%= food.getName() %>"
                            data-description="<%= food.getDescription() %>"
                            data-price="<%= food.getPrice() %>"
                            data-available="<%= food.isAvailable() %>"
                            data-categories="<%= food.getCategories().stream().map(c -> c.getId().toString()).collect(java.util.stream.Collectors.joining(",")) %>">
                        Sửa
                    </button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </section>
</main>

<!-- Create Modal -->
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<div class="modal fade" id="create_modal" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/restaurant/foods" method="post" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm món ăn mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="name">Tên món ăn</label>
                        <input type="text" name="name" id="name" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Mô tả</label>
                        <textarea name="description" id="description" class="form-control" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="price">Giá</label>
                        <input type="number" name="price" id="price" class="form-control" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="image">Ảnh món ăn</label>
                        <input type="file" name="image" id="image" accept="image/*" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="categoryIds">Danh mục</label>
                        <select class="form-control js-example-basic-multiple" id="categoryIds" name="categoryIds" multiple="multiple" required>
                            <% for (Category category : categories) { %>
                            <option value="<%= category.getId() %>">Món <%= category.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Thêm món ăn</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%-- Update Modal--%>
<div class="modal fade" id="update_modal" tabindex="-1" aria-labelledby="updateLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <form action="<%=request.getContextPath()%>/restaurant/edit-food" method="post" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Cập nhật món ăn</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <!-- Hidden ID -->
                    <input type="hidden" name="id" id="edit_id">

                    <div class="form-group">
                        <label for="edit_name">Tên món ăn</label>
                        <input type="text" name="name" id="edit_name" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="edit_description">Mô tả</label>
                        <textarea name="description" id="edit_description" class="form-control" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="edit_price">Giá</label>
                        <input type="number" name="price" id="edit_price" class="form-control" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="edit_image">Cập nhật ảnh mới (nếu cần)</label>
                        <input type="file" name="image" id="edit_image" accept="image/*" class="form-control">
                    </div>
                    
                    <div class="form-group">
                        <label for="edit_available">Khả dụng</label>
                        <select name="available" id="edit_available" class="form-control">
                            <option value="true">Có</option>
                            <option value="false">Không</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="edit_categoryIds">Danh mục</label>
                        <select class="form-control js-example-basic-multiple" id="edit_categoryIds" name="categoryIds" multiple="multiple">
                            <% for (Category category : categories) { %>
                            <option value="<%= category.getId() %>"><%= category.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Cập nhật món</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@include file="../common/foot.jsp" %>
<%@include file="../common/js.jsp" %>

<!-- Select2 init -->
<script>
    $(document).ready(function () {
        $('.js-example-basic-multiple').select2({
            placeholder: "Chọn danh mục cho món ăn",
            width: '100%',
            dropdownParent: $('#create_modal')
        });
    });
    function populateEditForm(button) {
        const id = button.dataset.id;
        const name = button.dataset.name;
        const description = button.dataset.description;
        const price = button.dataset.price;
        const available = button.dataset.available;
        const categoryIds = button.dataset.categories ? button.dataset.categories.split(",") : [];

        $('#edit_id').val(id);
        $('#edit_name').val(name);
        $('#edit_description').val(description);
        $('#edit_price').val(price);
        $('#edit_available').val(available);

        // Set selected categories (clear and select again)
        const $select = $('#edit_categoryIds');
        $select.val(null).trigger('change'); // clear
        $select.val(categoryIds).trigger('change'); // set selected
    }
</script>

</body>
</html>