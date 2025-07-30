<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">


<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:43 GMT -->
<head>
    <title>Foores - Single Restaurant Version</title>
    <%@include file="../common/reservation/head.jsp"%>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
</head>

<body>

<div id="preloader">
    <div data-loader="circle-side"></div>
</div><!-- /Page Preload -->

<%@include file="../common/reservation/header.jsp"%>
<!-- /header -->

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0">Danh sách Món ăn</h3>
        <button data-bs-toggle="modal" data-bs-target="#create_modal" class="btn btn-primary">Thêm món ăn mới</button>
    </div>

    <% List<Food> foods = (List<Food>) request.getAttribute("foods"); %>
    <% if (foods != null && !foods.isEmpty()) { %>
    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Mô tả</th>
                <th>Giá</th>
                <th>Ảnh</th>
                <th>Danh mục</th>
                <th>Khẩu vị</th>
                <th>Dị ứng</th>
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
                    <img src="<%= food.getImage() %>" alt="food" width="80" class="img-thumbnail"/>
                </td>
                <td>
                    <ul class="mb-0 ps-3">
                        <% for (Category c : food.getCategories()) { %>
                        <li><%= c.getName() %></li>
                        <% } %>
                    </ul>
                </td>
                <td>
                    <ul class="mb-0 ps-3">
                        <% for (Taste t : food.getTastes()) { %>
                        <li><%= t.getName() %></li>
                        <% } %>
                    </ul>
                </td>
                <td>
                    <ul class="mb-0 ps-3">
                        <% for (AllergyType a : food.getAllergyContents()) { %>
                        <li><%= a.getName() %></li>
                        <% } %>
                    </ul>
                </td>
                <td>
                        <span class="badge bg-<%= food.isAvailable() ? "success" : "secondary" %>">
                            <%= food.isAvailable() ? "Có" : "Không" %>
                        </span>
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
                            data-categories="<%= food.getCategories().stream().map(c -> c.getId().toString()).collect(java.util.stream.Collectors.joining(",")) %>"
                            data-tastes="<%= food.getTastes().stream().map(t -> t.getId().toString()).collect(java.util.stream.Collectors.joining(",")) %>"
                            data-allergies="<%= food.getAllergyContents().stream().map(a -> a.getId().toString()).collect(java.util.stream.Collectors.joining(",")) %>">
                        Sửa
                    </button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
    <div class="alert alert-info">Chưa có món ăn nào trong hệ thống.</div>
    <% } %>
</main>
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
                        <textarea name="description" id="description" class="form-control" style="height: 200px;" required></textarea>
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

                    <div class="form-group">
                        <label for="tasteIds">Khẩu vị</label>
                        <select class="form-control js-example-basic-multiple" id="tasteIds" name="tasteIds" multiple="multiple">
                            <% List<Taste> tastes = (List<Taste>) request.getAttribute("tastes"); %>
                            <% for (Taste taste : tastes) { %>
                            <option value="<%= taste.getId() %>"><%= taste.getName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="allergyIds">Thành phần dị ứng</label>
                        <select class="form-control js-example-basic-multiple" id="allergyIds" name="allergyIds" multiple="multiple">
                            <% List<AllergyType> allergies = (List<AllergyType>) request.getAttribute("allergies"); %>
                            <% for (AllergyType allergy : allergies) { %>
                            <option value="<%= allergy.getId() %>"><%= allergy.getName() %></option>
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
                        <textarea name="description" id="edit_description" class="form-control" style="height: 200px;" required></textarea>
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
                        <select class="form-control js-example-basic-multiple-update" id="edit_categoryIds" name="categoryIds" multiple="multiple">
                            <% for (Category category : categories) { %>
                            <option value="<%= category.getId() %>"><%= category.getName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="edit_tasteIds">Khẩu vị</label>
                        <select class="form-control js-example-basic-multiple-update" id="edit_tasteIds" name="tasteIds" multiple="multiple">
                            <% for (Taste taste : tastes) { %>
                            <option value="<%= taste.getId() %>"><%= taste.getName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="edit_allergyIds">Thành phần dị ứng</label>
                        <select class="form-control js-example-basic-multiple-update" id="edit_allergyIds" name="allergyIds" multiple="multiple">
                            <% for (AllergyType allergy : allergies) { %>
                            <option value="<%= allergy.getId() %>"><%= allergy.getName() %></option>
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
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
</body>
<script>
    $(document).ready(function () {
        $('.js-example-basic-multiple').select2({
            placeholder: "Chọn danh mục cho món ăn",
            width: '100%',
            dropdownParent: $('#create_modal')
        });
    });
    $(document).ready(function () {
        $('.js-example-basic-multiple-update').select2({
            placeholder: "Chọn danh mục cho món ăn",
            width: '100%',
            dropdownParent: $('#update_modal')
        });
    });
    function populateEditForm(button) {
        const id = button.dataset.id;
        const name = button.dataset.name;
        const description = button.dataset.description;
        const price = button.dataset.price;
        const available = button.dataset.available;
        const categoryIds = button.dataset.categories ? button.dataset.categories.split(",") : [];
        const tasteIds = button.dataset.tastes ? button.dataset.tastes.split(",") : [];
        const allergyIds = button.dataset.allergies ? button.dataset.allergies.split(",") : [];

        $('#edit_tasteIds').val(null).trigger('change');
        $('#edit_tasteIds').val(tasteIds).trigger('change');

        $('#edit_allergyIds').val(null).trigger('change');
        $('#edit_allergyIds').val(allergyIds).trigger('change');

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
<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
