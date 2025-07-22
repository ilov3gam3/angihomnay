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
    <div class="search-bar mb-5 ">
        <div class="search-wrapper">
            <%
                String searchString = request.getParameter("searchString");
                String priceFrom = request.getParameter("priceFrom");
                String priceTo = request.getParameter("priceTo");

                String[] selectedCategoryIds = request.getParameterValues("categories");
                String[] selectedAllergyIds = request.getParameterValues("allergyContents");
                String[] selectedTasteIds = request.getParameterValues("tastes");

                java.util.Set<String> catSet = selectedCategoryIds != null ? new java.util.HashSet<>(java.util.Arrays.asList(selectedCategoryIds)) : java.util.Collections.emptySet();
                java.util.Set<String> allergySet = selectedAllergyIds != null ? new java.util.HashSet<>(java.util.Arrays.asList(selectedAllergyIds)) : java.util.Collections.emptySet();
                java.util.Set<String> tasteSet = selectedTasteIds != null ? new java.util.HashSet<>(java.util.Arrays.asList(selectedTasteIds)) : java.util.Collections.emptySet();
            %>

            <form action="<%=request.getContextPath()%>/search" method="get" class="row g-3 align-items-end">

                <!-- Search string -->
                <div class="col-lg-5 col-md-12">
                    <div class="search-input position-relative">
                        <i class="fas fa-search position-absolute" style="left: 12px; top: 50%; transform: translateY(-50%); color: #aaa;"></i>
                        <input type="text" class="form-control ps-5" name="searchString"
                               placeholder="Tìm kiếm món ăn, mô tả..."
                               value="<%=searchString != null ? searchString : ""%>">
                    </div>
                </div>

                <!-- Price range -->
                <div class="col-md-2">
                    <input type="number" class="form-control" name="priceFrom" min="0" step="1000" placeholder="Giá từ"
                           value="<%=priceFrom != null ? priceFrom : ""%>">
                </div>
                <div class="col-md-2">
                    <input type="number" class="form-control" name="priceTo" min="0" step="1000" placeholder="Giá đến"
                           value="<%=priceTo != null ? priceTo : ""%>">
                </div>

                <!-- Submit -->
                <div class="col-3">
                    <button type="submit" class="btn btn-primary px-4 search-btn">Tìm kiếm</button>
                </div>

                <!-- Categories -->
                <div class="col-md-4">
                    <label class="form-label">Loại món ăn</label>
                    <select name="categories" class="form-control select2" multiple>
                        <% for (Category c : categories) { %>
                        <option value="<%=c.getId()%>"
                                <%= catSet.contains(String.valueOf(c.getId())) ? "selected" : "" %>>
                            <%=c.getName()%>
                        </option>
                        <% } %>
                    </select>
                </div>

                <!-- Allergy contents -->
                <div class="col-md-4">
                    <label class="form-label">Dị ứng</label>
                    <select name="allergyContents" class="form-control select2" multiple>
                        <% for (AllergyType a : allergies) { %>
                        <option value="<%=a.getId()%>"
                                <%= allergySet.contains(String.valueOf(a.getId())) ? "selected" : "" %>>
                            <%=a.getName()%>
                        </option>
                        <% } %>
                    </select>
                </div>

                <!-- Tastes -->
                <div class="col-md-4">
                    <label class="form-label">Hương vị</label>
                    <select name="tastes" class="form-control select2" multiple>
                        <% for (Taste t : tastes) { %>
                        <option value="<%=t.getId()%>"
                                <%= tasteSet.contains(String.valueOf(t.getId())) ? "selected" : "" %>>
                            <%=t.getName()%>
                        </option>
                        <% } %>
                    </select>
                </div>

            </form>

        </div>
    </div>

    <div style="height: 120px;"></div>
    <div class="container">
    <%
        List<Food> foodList = (List<Food>) request.getAttribute("foodList");
        if (foodList != null) {
    %>
    <div class="food-grid">
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
                    <% for (Category c : food.getCategories()) { %>
                    <span><%=c.getName()%></span>
                    <% } %>
                </p>
                <p class="food-tags">
                    <% for (Taste t : food.getTastes()) { %>
                    <span><%=t.getName()%></span>
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