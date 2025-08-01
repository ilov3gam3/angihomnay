<%@ page import="java.util.List" %>
<%@ page import="Dao.FoodDao" %>
<%@ page import="java.util.Collections" %>
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

<main>
    <div id="carousel-home">
        <div class="owl-carousel owl-theme">
            <div class="owl-slide cover lazy" data-bg="url(<%=request.getContextPath()%>/assets/reservation/img/slides/slide_home_1.jpg)">
                <div class="opacity-mask d-flex align-items-center" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                    <div class="container">
                        <div class="row justify-content-center justify-content-md-end">
                            <div class="col-lg-6 static">
                                <div class="slide-text text-end white">
                                    <h2 class="owl-slide-animated owl-slide-title">Taste<br>unique food</h2>
                                    <p class="owl-slide-animated owl-slide-subtitle">
                                        Cooking delicious food since 2005
                                    </p>
                                    <div class="owl-slide-animated owl-slide-cta"><a class="btn_1 btn_scroll" href="menu-1.html" role="button">Read more</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--/owl-slide-->
            <div class="owl-slide cover lazy" data-bg="url(<%=request.getContextPath()%>/assets/reservation/img/slides/slide_home_2.jpg)">
                <div class="opacity-mask d-flex align-items-center" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                    <div class="container">
                        <div class="row justify-content-center justify-content-md-start">
                            <div class="col-lg-6 static">
                                <div class="slide-text white">
                                    <h2 class="owl-slide-animated owl-slide-title">Reserve<br>a Table Now</h2>
                                    <p class="owl-slide-animated owl-slide-subtitle">
                                        Cooking delicious food since 2005
                                    </p>
                                    <div class="owl-slide-animated owl-slide-cta"><a class="btn_1" href="reservations.html" role="button">Read more</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--/owl-slide-->
            <div class="owl-slide cover lazy" data-bg="url(<%=request.getContextPath()%>/assets/reservation/img/slides/slide_home_3.jpg)">
                <div class="opacity-mask d-flex align-items-center" data-opacity-mask="rgba(0, 0, 0, 0.6)">
                    <div class="container">
                        <div class="row justify-content-center justify-content-md-start">
                            <div class="col-lg-12 static">
                                <div class="slide-text text-center white">
                                    <h2 class="owl-slide-animated owl-slide-title">Enjoy<br>a friends dinner</h2>
                                    <p class="owl-slide-animated owl-slide-subtitle">
                                        Cooking delicious food since 2005
                                    </p>
                                    <div class="owl-slide-animated owl-slide-cta"><a class="btn_1" href="menu-1.html" role="button">Read more</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--/owl-slide-->
            </div>
        </div>
        <div id="icon_drag_mobile"></div>
    </div>
    <!--/carousel-->

    <ul id="banners_grid" class="clearfix">
        <li>
            <a href="menu-1.html" class="img_container">
                <img src="<%=request.getContextPath()%>/assets/reservation/img/banners_cat_placeholder.jpg" data-src="<%=request.getContextPath()%>/assets/reservation/img/banner_1.jpg" alt="" class="lazy">
                <div class="short_info opacity-mask" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                    <h3>Our Menu</h3>
                    <p>View Our Specialites</p>
                </div>
            </a>
        </li>
        <li>
            <a href="order-food.html" class="img_container">
                <img src="<%=request.getContextPath()%>/assets/reservation/img/banners_cat_placeholder.jpg" data-src="<%=request.getContextPath()%>/assets/reservation/img/banner_2.jpg" alt="" class="lazy">
                <div class="short_info opacity-mask" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                    <h3>Delivery</h3>
                    <p>Home delivery or take away food</p>
                </div>
            </a>
        </li>
        <li>
            <a href="gallery.html" class="img_container">
                <img src="<%=request.getContextPath()%>/assets/reservation/img/banners_cat_placeholder.jpg" data-src="<%=request.getContextPath()%>/assets/reservation/img/banner_3.jpg" alt="" class="lazy">
                <div class="short_info opacity-mask" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                    <h3>Inside Foores</h3>
                    <p>View the Gallery</p>
                </div>
            </a>
        </li>
    </ul>
    <!--/banners_grid -->

    <div class="pattern_2">
        <div class="container margin_120_100 home_intro">
            <div class="row justify-content-center d-flex align-items-center">
                <div class="col-lg-5 text-lg-center d-none d-lg-block" data-cue="slideInUp">
                    <figure>
                        <img src="<%=request.getContextPath()%>/assets/reservation/img/home_1_placeholder.png" data-src="<%=request.getContextPath()%>/assets/reservation/img/home_1.jpg" width="354" height="440" alt="" class="img-fluid lazy">
                        <a href="https://www.youtube.com/watch?v=MO7Hi_kBBBg" class="btn_play" data-cue="zoomIn" data-delay="500"><span class="pulse_bt"><i class="arrow_triangle-right"></i></span></a>
                    </figure>
                </div>
                <div class="col-lg-5 pt-lg-4" data-cue="slideInUp" data-delay="500">
                    <div class="main_title">
                        <span><em></em></span>
                        <h2>Some words about us</h2>
                        <p>Cum doctus civibus efficiantur in imperdiet deterruisset.</p>
                    </div>
                    <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
                    <p><img src="<%=request.getContextPath()%>/assets/reservation/img/signature.png" width="140" height="50" alt="" class="mt-3"></p>
                </div>
            </div>
            <!--/row -->
        </div>
        <!--/container -->
    </div>
    <!--/pattern_2 -->

    <div class="bg_gray">
        <div class="container margin_120_100" data-cue="slideInUp">
            <div class="main_title center mb-5">
                <span><em></em></span>
                <h2>Our Daily Menu</h2>
            </div>
            <!-- /main_title -->
            <div class="banner lazy" data-bg="url(<%=request.getContextPath()%>/assets/reservation/img/banner_bg.jpg)">
                <div class="wrapper d-flex align-items-center justify-content-between opacity-mask" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                    <div>
                        <small>Special Offer</small>
                        <h3>Burgher Menu $18 only</h3>
                        <p>Hamburgher, Chips, Mix Sausages, Beer, Muffin</p>
                        <a href="reservations.html" class="btn_1">Reserve now</a>
                    </div>
                    <figure class="d-none d-lg-block"><img src="<%=request.getContextPath()%>/assets/reservation/img/banner.svg" alt="" width="200" height="200" class="img-fluid"></figure>
                </div>
                <!-- /wrapper -->
            </div>
            <!-- /banner -->
            <div class="row magnific-gallery homepage add_bottom_25">
                <% List<Food> foods = new FoodDao().getAll();
                    Collections.shuffle(foods);%>
                <% for (int i = 0; i < foods.size(); i++) { %>
                <div class="col-lg-6" data-cue="slideInUp">
                    <div class="menu_item">
                        <figure>
                            <a href="<%=foods.get(i).getImage()%>" title="Summer Berry" data-effect="mfp-zoom-in">
                                <img src="<%=foods.get(i).getImage()%>" data-src="<%=foods.get(i).getImage()%>" class="lazy" alt="">
                            </a>
                        </figure>
                        <div class="menu_title" onclick="location.href='<%=request.getContextPath()%>/food-detail?id=<%=foods.get(i).getId()%>'">
                                <h3><%=foods.get(i).getName()%></h3><em><%=foods.get(i).getPrice()%> VND</em>
                        </div>
                    </div>
                </div>
                <% if (i == 7 ) break;%>
                <% } %>
            </div>
            <!-- /row -->
            <p class="text-center"><a href="#0" class="btn_1 outline" data-cue="zoomIn">Download Menu</a></p>
        </div>
        <!-- /container -->
    </div>
    <!-- /bg_gray -->

    <div class="call_section lazy" data-bg="url(<%=request.getContextPath()%>/assets/reservation/img/bg_call_section.jpg)">
        <div class="container clearfix">
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-6 text-center">
                    <div class="box_1" data-cue="slideInUp">
                        <h2>Celebrate<span>a Special Event with us!</span></h2>
                        <p>Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.</p>
                        <a href="contacts.html" class="btn_1 mt-3">Contact us</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--/call_section-->

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
