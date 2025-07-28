<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">


<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:43 GMT -->
<head>
    <title>Foores - Single Restaurant Version</title>
    <%@include file="../common/reservation/head.jsp"%>
    <link href="<%=request.getContextPath()%>/assets/reservation/css/shop.css" rel="stylesheet">
</head>

<body>

<div id="preloader">
    <div data-loader="circle-side"></div>
</div><!-- /Page Preload -->

<%@include file="../common/reservation/header.jsp"%>
<!-- /header -->
<%
    List<AllergyType> allergies = new Dao.AllergyTypeDao().getAll();
    List<Taste> tastes = new Dao.TasteDao().getAll();
    List<Category> categories = new Dao.CategoryDao().getAll();

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
<main>
    <div class="filters_full clearfix">
        <div class="container">
            <a href="#0" class="open_filters btn_filters"><i class="icon_adjust-vert"></i></a>
            <div class="sort_select">
                <select name="sort" id="sort">
                    <option value="popularity" selected="selected">Sort by Popularity</option>
                    <option value="rating">Sort by Average rating</option>
                    <option value="date">Sort by newness</option>
                    <option value="price">Sort by Price: low to high</option>
                    <option value="price-desc">Sort by Price: high to low</option>
                </select>
            </div>
        </div>
    </div>

    <div class="container margin_60_40">

        <div class="row">
            <aside class="col-lg-3" id="sidebar_fixed">
                <form action="<%=request.getContextPath()%>/search" method="get">
                    <div class="filter_col">
                        <div class="inner_bt">
                            <a href="#" class="open_filters"><i class="icon_close"></i></a>
                        </div>

                        <div class="filter_type version_2">
                            <h4><a href="#filter_1" data-bs-toggle="collapse" class="opened">Tên món ăn</a></h4>
                            <div class="collapse show" id="filter_1">
                                <input type="text" class="form-control" name="searchString" value="<%=searchString != null ? searchString : ""%>">
                            </div>
                        </div>

                        <!-- Loại món ăn -->
                        <div class="filter_type version_2">
                            <h4><a href="#filter_1" data-bs-toggle="collapse" class="opened">Loại món ăn</a></h4>
                            <div class="collapse show" id="filter_1">
                                <ul>
                                    <% for (Category c : categories) { %>
                                    <li>
                                        <label class="container_check"><%=c.getName()%>
                                            <input type="checkbox" name="categories" value="<%=c.getId()%>"
                                                <%= catSet != null && catSet.contains(String.valueOf(c.getId())) ? "checked" : "" %>>
                                            <span class="checkmark"></span>
                                        </label>
                                    </li>
                                    <% } %>
                                </ul>
                            </div>
                        </div>

                        <!-- Hương vị -->
                        <div class="filter_type version_2">
                            <h4><a href="#filter_2" data-bs-toggle="collapse" class="opened">Hương vị</a></h4>
                            <div class="collapse show" id="filter_2">
                                <ul>
                                    <% for (Taste t : tastes) { %>
                                    <li>
                                        <label class="container_check"><%=t.getName()%>
                                            <input type="checkbox" name="tastes" value="<%=t.getId()%>"
                                                <%= tasteSet != null && tasteSet.contains(String.valueOf(t.getId())) ? "checked" : "" %>>
                                            <span class="checkmark"></span>
                                        </label>
                                    </li>
                                    <% } %>
                                </ul>
                            </div>
                        </div>

                        <!-- Dị ứng -->
                        <div class="filter_type version_2">
                            <h4><a href="#filter_3" data-bs-toggle="collapse" class="opened">Không chứa thành phần dị ứng</a></h4>
                            <div class="collapse show" id="filter_3">
                                <ul>
                                    <% for (AllergyType a : allergies) { %>
                                    <li>
                                        <label class="container_check"><%=a.getName()%>
                                            <input type="checkbox" name="allergyContents" value="<%=a.getId()%>"
                                                <%= allergySet != null && allergySet.contains(String.valueOf(a.getId())) ? "checked" : "" %>>
                                            <span class="checkmark"></span>
                                        </label>
                                    </li>
                                    <% } %>
                                </ul>
                            </div>
                        </div>

                        <!-- Giá -->
                        <div class="filter_type version_2">
                            <h4><a href="#filter_4" data-bs-toggle="collapse" class="opened">Giá</a></h4>
                            <div class="collapse show" id="filter_4">
                                Giá từ
                                <input type="number" class="form-control" name="priceFrom" step="1000"
                                       value="<%= priceFrom != null ? priceFrom : "" %>">
                                đến
                                <input type="number" class="form-control" name="priceTo" step="1000"
                                       value="<%= priceTo != null ? priceTo : "" %>">
                            </div>
                        </div>

                        <!-- Submit -->
                        <div class="buttons">
                            <button type="submit" class="btn_1">Tìm kiếm</button>
                            <a href="<%=request.getContextPath()%>/search" class="btn_1 gray">Reset</a>
                        </div>
                    </div>
                </form>
            </aside>

            <!-- /col -->
            <div class="col-lg-9">
                <%
                    List<Food> foodList = (List<Food>) request.getAttribute("foodList");
                    List<List<ReviewDetail>> details = (List<List<ReviewDetail>>) request.getAttribute("details");
                %>
                <% if (foodList!= null && !foodList.isEmpty()) { %>
                <% int i = 0; for (Food food : foodList) {%>
                <div class="row row_item" data-cue="slideInUp">
                    <div class="col-sm-4">
                        <figure>
                            <a href="<%=request.getContextPath()%>/food-detail?id=<%=food.getId()%>">
                                <img class="img-fluid lazy" src="<%=food.getImage()%>" data-src="<%=food.getImage()%>" alt="">
                            </a>
                        </figure>
                    </div>
                    <div class="col-sm-8">
                        <%
                            int count = 0;
                            for (int j = 0; j < details.get(i).size(); j++) {
                                count += details.get(i).get(j).getRating();
                            }
                            float avg = (float) count / details.get(i).size();
                        %>
                        <div class="rating"><%=avg%><i class="icon_star voted"></i><%=details.get(i).size()%> đánh giá</div>
                        <a href="<%=request.getContextPath()%>/food-detail?id=<%=food.getId()%>">
                            <h3><%=food.getName()%></h3>
                        </a>
                        <p><%=food.getDescription()%></p>
                        <div class="price_box">
                            <span class="new_price"><%=food.getPrice()%> VND</span>
                        </div>
                    </div>
                </div>
                <% i++; %>
                <% } %>
                <% } else { %>
                <p>Không tìm thấy món ăn nào phù hợp.</p>
                <% } %>
            </div>
            <!-- /col -->
        </div>
        <!-- /row -->
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

</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
