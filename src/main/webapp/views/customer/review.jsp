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
<% Booking booking = (Booking) request.getAttribute("booking");%>
<main>
    <div class="container margin_60_40">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="write_review">
                    <form action="<%=request.getContextPath()%>/customer/review" method="post">
                        <input type="hidden" name="bookingId" value="<%=booking.getId()%>">

                        <h1>Để lại đánh giá cho booking <%=booking.getId()%></h1>
                        <div class="rating_submit">
                            <div class="form-group mb-2">
                                <label class="d-block">Đánh giá chung cho nhà hàng <%=booking.getTable().getRestaurant().getName()%></label>
                                <span class="rating mb-0">
                                    <% for (int i = 5; i >= 1; i--) { %>
                                        <input type="radio" class="rating-input" id="main_<%=i%>_star" name="rating" value="<%=i%>">
                                        <label for="main_<%=i%>_star" class="rating-star"></label>
                                    <% } %>
                                </span>
                            </div>
                        </div>
                        <div class="form-group mb-5">
                            <label>Nhận xét của bạn</label>
                            <textarea class="form-control" style="height: 180px;" name="comment" placeholder="Viết cảm nhận của bạn..."></textarea>
                        </div>
                        <hr />

                        <% for (int i = 0; i < booking.getBookingDetails().size(); i++) {
                            Model.BookingDetail detail = booking.getBookingDetails().get(i);
                        %>
                        <h3>Đánh giá cho món ăn <%=detail.getFood().getName()%></h3>
                        <div class="rating_submit">
                            <div class="form-group mb-2">
                                <label class="d-block">Chọn số sao</label>
                                <span class="rating mb-0">
                                    <% for (int j = 5; j >= 1; j--) { %>
                                        <input type="radio" class="rating-input" id="food_<%=detail.getId()%>_<%=j%>_star"
                                               name="reviewDetail_rating_<%=detail.getId()%>" value="<%=j%>">
                                        <label for="food_<%=detail.getId()%>_<%=j%>_star" class="rating-star"></label>
                                    <% } %>
                                </span>
                            </div>
                        </div>
                        <div class="form-group mb-5">
                            <label>Nhận xét món ăn</label>
                            <textarea class="form-control" style="height: 180px;"
                                      name="reviewDetail_comment_<%=detail.getId()%>"
                                      placeholder="Nhận xét của bạn về món này..."></textarea>
                        </div>
                        <hr />
                        <% } %>

                        <p><button type="submit" class="btn_1">Submit review</button></p>
                    </form>
                </div>
            </div>
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
