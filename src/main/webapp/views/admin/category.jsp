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

<main class="bg_gray">
    <div class="container margin_60_40">
        <div class="main_title center">
            <h2>Danh sách Loại món ăn</h2>
        </div>

        <div class="text-end mb-3">
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#create_modal">Thêm mới</button>
        </div>

        <% List<Category> categories = (List<Category>) request.getAttribute("categories"); %>
        <div class="table-responsive">
            <table class="table table-bordered nutrition-table">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>Được thêm lúc</th>
                    <th>Cập nhật lúc</th>
                    <th>Số lượng món ăn</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% for (int i = 0; i < categories.size(); i++) { %>
                <tr>
                    <td><%=categories.get(i).getId()%></td>
                    <td><%=categories.get(i).getName()%></td>
                    <td><%=categories.get(i).getCreatedAt()%></td>
                    <td><%=categories.get(i).getUpdatedAt()%></td>
                    <td><%=categories.get(i).getFoods().size()%></td>
                    <td>
                        <button class="btn btn-outline-primary btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#update_modal"
                                onclick="populateForm(
                                    <%=categories.get(i).getId()%>,
                                        '<%=categories.get(i).getName()%>',
                                        '<%=categories.get(i).getCreatedAt()%>',
                                        '<%=categories.get(i).getUpdatedAt()%>'
                                        )">
                            Cập nhật
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>
<div class="modal fade" id="create_modal" tabindex="-1" aria-labelledby="createModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="<%=request.getContextPath()%>/admin/categories" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="createModalLabel">Thêm mới loại thực phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="name" class="form-label">Tên</label>
                        <input type="text" id="name" name="name" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Thêm mới</button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="modal fade" id="update_modal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="<%=request.getContextPath()%>/admin/update-category" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateModalLabel">Cập nhật loại thực phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="update_id" class="form-label">ID</label>
                        <input type="text" id="update_id" name="id" class="form-control" readonly required>
                    </div>
                    <div class="mb-3">
                        <label for="update_name" class="form-label">Tên</label>
                        <input type="text" id="update_name" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="update_created_at" class="form-label">Được thêm lúc</label>
                        <input type="text" id="update_created_at" name="created_at" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="update_updated_at" class="form-label">Cập nhật lúc</label>
                        <input type="text" id="update_updated_at" name="updated_at" class="form-control" readonly>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- /main -->


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
    function populateForm(id, name, create, update) {
        document.getElementById("update_id").value = id;
        document.getElementById("update_name").value = name;
        document.getElementById("update_created_at").value = create;
        document.getElementById("update_updated_at").value = update;
    }
</script>
</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
