<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">


<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:43 GMT -->
<head>
    <title>Foores - Single Restaurant Version</title>
    <%@include file="head.jsp"%>
</head>

<body>

<div id="preloader">
    <div data-loader="circle-side"></div>
</div><!-- /Page Preload -->

<%@include file="header.jsp"%>
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
</main>
<!-- /main -->

<%@include file="footer.jsp"%>
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

<%@include file="js.jsp"%>

</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
