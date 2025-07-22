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
<main class="page-wrapper d-flex flex-column min-vh-100">
    <%
        List<AllergyType> allergies = new Dao.AllergyTypeDao().getAll();
        List<Taste> tastes = new Dao.TasteDao().getAll();
        List<Category> categories = new Dao.CategoryDao().getAll();
    %>

    <div class="search-bar mb-5">
        <div class="search-wrapper">
            <form action="<%=request.getContextPath()%>/search" method="get" class="row g-3 align-items-end">
                <!-- Search string -->
                <div class="col-lg-6 col-md-12">
                    <div class="search-input position-relative">
                        <i class="fas fa-search position-absolute" style="left: 12px; top: 50%; transform: translateY(-50%); color: #aaa;"></i>
                        <input type="text" class="form-control ps-5" name="searchString" placeholder="Tìm kiếm món ăn, mô tả...">
                    </div>
                </div>

                <!-- Price range -->
                <div class="col-md-3">
                    <label class="form-label mb-0">Giá từ</label>
                    <input type="number" class="form-control" name="priceFrom" min="0" step="1000">
                </div>
                <div class="col-md-3">
                    <label class="form-label mb-0">Giá đến</label>
                    <input type="number" class="form-control" name="priceTo" min="0" step="1000">
                </div>

                <!-- Categories -->
                <div class="col-md-4">
                    <label class="form-label">Loại món ăn</label>
                    <select name="categories" class="form-control select2" multiple>
                        <% for (Category c : categories) { %>
                        <option value="<%=c.getId()%>"><%=c.getName()%></option>
                        <% } %>
                    </select>
                </div>

                <!-- Allergy contents -->
                <div class="col-md-4">
                    <label class="form-label">Dị ứng</label>
                    <select name="allergyContents" class="form-control select2" multiple>
                        <% for (AllergyType a : allergies) { %>
                        <option value="<%=a.getId()%>"><%=a.getName()%></option>
                        <% } %>
                    </select>
                </div>

                <!-- Tastes -->
                <div class="col-md-4">
                    <label class="form-label">Hương vị</label>
                    <select name="tastes" class="form-control select2" multiple>
                        <% for (Taste t : tastes) { %>
                        <option value="<%=t.getId()%>"><%=t.getName()%></option>
                        <% } %>
                    </select>
                </div>

                <!-- Submit -->
                <div class="col-12 text-end">
                    <button type="submit" class="btn btn-primary px-4 search-btn">Tìm kiếm</button>
                </div>
            </form>
        </div>
        <%
            List<Food> foodList = (List<Food>) request.getAttribute("foodList");
            if (foodList != null) {
        %>
        <div class="food-grid mt-4">
            <% if (foodList.isEmpty()) { %>
            <p>Không tìm thấy món ăn nào phù hợp.</p>
            <% } else {
                for (Food food : foodList) {
            %>
            <div class="food-card">
                <div class="food-image">
                    <img src="<%=food.getImage()%>" alt="<%=food.getName()%>">
                </div>
                <div class="food-info">
                    <h4><%=food.getName()%></h4>
                    <div class="rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="far fa-star"></i>
                        <span>(4.0)</span> <%-- Chưa có rating trong model --%>
                    </div>
                    <p class="food-tags">
                        <%-- Tạm gán category làm tag, bạn có thể sửa để đẹp hơn --%>
                        <% for (Category c : food.getCategories()) { %>
                        <span><%=c.getName()%></span>
                        <% } %>
                    </p>
                </div>
            </div>
            <%  }
            }
            %>
        </div>
        <% } %>

    </div>
</main>

<!-- Footer -->
<%@include file="../common/footer.jsp" %>
</body>
<%@include file="../common/foot.jsp" %>
<%@include file="../common/js.jsp" %>
<script>
    $(document).ready(function() {
        $('.select2').select2({
            placeholder: "Chọn mục...",
            allowClear: true,
            width: '100%',
            dropdownParent: $('.search-bar')
        });
    });
</script>
</html>