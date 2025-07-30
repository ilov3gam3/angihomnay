<%@ page import="java.util.List" %>
<%@ page import="java.time.Duration" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.temporal.Temporal" %>
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
<% Food food = (Food) request.getAttribute("food");%>
<% List<ReviewDetail> reviewDetails = (List<ReviewDetail>) request.getAttribute("reviewDetails"); %>
<main>
    <div class="hero_single inner_pages background-image" data-background="url(<%=request.getContextPath()%>/assets/reservation/img/slides/slide_home_1.jpg)">
        <div class="opacity-mask" data-opacity-mask="rgba(0, 0, 0, 0.6)">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xl-9 col-lg-10 col-md-8">
                        <h1>Our Shop</h1>
                        <p>Order food with home delivery or take away</p>
                    </div>
                </div>
                <!-- /row -->
            </div>
        </div>
        <div class="frame white"></div>
    </div>
    <!-- /hero_single -->
    <div class="container margin_60_40">
        <div class="row">
            <div class="col-lg-6 magnific-gallery">
                <p>
                    <a href="<%=food.getImage()%>" title="Photo title" data-effect="mfp-zoom-in"><img src="<%=food.getImage()%>" alt="" class="img-fluid"></a>
                </p>
            </div>
            <div class="col-lg-6" id="sidebar_fixed">
                <div class="prod_info">
                    <%
                        int count = 0;
                        for (int i = 0; i < reviewDetails.size(); i++) {
                            count += reviewDetails.get(i).getRating();
                        }
                        float avg = (float) count / reviewDetails.size();
                    %>
                    <span class="rating"><%=avg%><i class="icon_star voted"></i><em><%=reviewDetails.size()%> reviews</em></span>
                    <h1><%=food.getName()%></h1>
                    <p><%=food.getDescription()%></p>
<%--                    <div class="prod_options">--%>
<%--                        <div class="row">--%>
<%--                            <label class="col-xl-5 col-lg-5  col-md-6 col-6"><strong>Quantity</strong></label>--%>
<%--                            <div class="col-xl-4 col-lg-5 col-md-6 col-6">--%>
<%--                                <div class="numbers-row">--%>
<%--                                    <input type="text" value="1" id="quantity_1" class="qty2" name="quantity_1">--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
                    <div class="row">
                        <div class="col-lg-5 col-md-6">
                            <div class="price_main"><span class="new_price"><%=food.getPrice()%> VND</span></div>
                        </div>
<%--                        <div class="col-lg-4 col-md-6">--%>
<%--                            <div class="btn_add_to_cart"><a href="#0" class="btn_1D">Đặt bàn với món này</a></div>--%>
<%--                        </div>--%>
                    </div>
                </div>
                <!-- /prod_info -->
            </div>
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->

    <div class="tabs_product">
        <div class="container">
            <ul class="nav nav-tabs" role="tablist">
                <li class="nav-item">
                    <a id="tab-A" href="#pane-A" class="nav-link active" data-bs-toggle="tab" role="tab">Description</a>
                </li>
                <li class="nav-item">
                    <a id="tab-B" href="#pane-B" class="nav-link" data-bs-toggle="tab" role="tab">Reviews</a>
                </li>
                <li class="nav-item">
                    <a id="tab-C" href="#pane-C" class="nav-link" data-bs-toggle="tab" role="tab">Địa chỉ nhà hàng</a>
                </li>
            </ul>
        </div>
    </div>
    <!-- /tabs_product -->
    <div class="tab_content_wrapper">
        <div class="container">
            <div class="tab-content" role="tablist">
                <div id="pane-A" class="card tab-pane fade show active" role="tabpanel" aria-labelledby="tab-A">
                    <div class="card-header" role="tab" id="heading-A">
                        <h5 class="mb-0">
                            <a class="collapsed" data-bs-toggle="collapse" href="#collapse-A" aria-expanded="false" aria-controls="collapse-A">
                                Description
                            </a>
                        </h5>
                    </div>
                    <div id="collapse-A" class="collapse" role="tabpanel" aria-labelledby="heading-A">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h3>Details</h3>
                                    <p><%=food.getDescription()%></p>
                                </div>
                                <div class="col-md-6">
                                    <h3>Specifications (100g)</h3>
                                    <div class="table-responsive">
                                        <table class="table table-sm table-striped">
                                            <tbody>
                                            <tr>
                                                <td><strong>Calories</strong></td>
                                                <td>380kcl</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Protein</strong></td>
                                                <td>15,4g</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Carboidrates</strong></td>
                                                <td>25g</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Fat</strong></td>
                                                <td>12g</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- /table-responsive -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="pane-B" class="card tab-pane fade" role="tabpanel" aria-labelledby="tab-B">
                    <div class="card-header" role="tab" id="heading-B">
                        <h5 class="mb-0">
                            <a class="collapsed" data-bs-toggle="collapse" href="#collapse-B" aria-expanded="false" aria-controls="collapse-B">
                                Reviews
                            </a>
                        </h5>
                    </div>
                    <div id="collapse-B" class="collapse" role="tabpanel" aria-labelledby="heading-B">
                        <div class="card-body">
                            <% for (int i = 0; i < reviewDetails.size(); i++) { %>
                            <div class="col-lg-6">
                                <div class="review_content">
                                    <div class="clearfix add_bottom_10">
                                        <span class="rating"><i class="icon_star"></i><i class="icon_star"></i><i class="icon_star"></i><i class="icon_star"></i><i class="icon_star"></i><em><%=reviewDetails.get(i).getRating()%>/5.0</em></span>
                                        <em>Đã đăng <%=Duration.between(reviewDetails.get(i).getCreatedAt().toLocalDateTime(), LocalDateTime.now()).toMinutes()%> phút trước</em>
                                    </div>
                                    <h3><%=reviewDetails.get(i).getBookingDetail().getBooking().getCustomer().getFirstName()%></h3>
                                    <p><%=reviewDetails.get(i).getComment()%></p>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        <!-- /card-body -->
                    </div>
                </div>
                <div id="pane-C" class="card tab-pane fade" role="tabpanel" aria-labelledby="tab-C">
                    <div class="col-12 row">
                        <%=food.getRestaurant().getMapEmbedUrl()%>
                    </div>
                </div>
            </div>
            <!-- /tab-content -->
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

</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
