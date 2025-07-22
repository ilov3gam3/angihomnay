<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>AnGiHomNay - Nền tảng đánh giá và gợi ý ẩm thực</title>
        <%@include file="../common/head.jsp"%>
    </head>
    <body>
       <%@include file="../common/header.jsp"%>
        <!-- Main Content -->
        <main>
            <!-- Hero Section -->
            <section class="hero">
                <div class="hero-background">
                    <div class="hero-overlay"></div>
                    <div class="floating-food food-1">
                        <img src="<%= request.getContextPath()%>/assets/img/hero/pho.jpg" alt="Phở">
                    </div>
                    <div class="floating-food food-2">
                        <img src="<%= request.getContextPath()%>/assets/img/hero/banh-mi.jpg" alt="Bánh mì">
                    </div>
                    <div class="floating-food food-3">
                        <img src="<%= request.getContextPath()%>/assets/img/hero/pizza.jpg" alt="Pizza">
                    </div>
                </div>

                <div class="hero-content">
                    <h2>Hôm nay ăn gì?</h2>
                    <p>Để AnGiHomNay gợi ý món ăn phù hợp với bạn</p>
                    <div class="hero-buttons">
                        <button class="btn-primary">Nhận gợi ý ngay</button>
                        <button class="btn-secondary">Khám phá món hot</button>
                    </div>
                </div>
            </section>

            <!-- Search Bar -->
            <div class="search-bar">
                <div class="search-wrapper">
                    <form style="width: 100%" action="<%=request.getContextPath()%>/search" method="get">
                        <div class="row">
                            <div class="col-10">
                                <div class="search-input">
                                    <i class="fas fa-search"></i>
                                    <input class="form-control" type="text" placeholder="Tìm kiếm món ăn, nhà hàng...">
                                </div>
                            </div>
                            <div class="col-2">
                                <button class="search-btn">Tìm kiếm</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Context Based Recommendations -->
            <section class="recommendations">
                <h3>Gợi ý cho bạn</h3>
                <div class="context-filters">
                    <button class="filter-btn active">Thời tiết</button>
                    <button class="filter-btn">Tâm trạng</button>
                    <button class="filter-btn">Sức khỏe</button>
                    <button class="filter-btn">Thói quen</button>
                </div>
                <div class="food-grid">
                    <!-- Food Cards -->
                    <div class="food-card">
                        <div class="food-image">
                            <img src="<%= request.getContextPath()%>/assets/img/foods/pho-bo.jpg" alt="Phở bò">
                        </div>
                        <div class="food-info">
                            <h4>Phở bò</h4>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span>(4.5)</span>
                            </div>
                            <p class="food-tags">
                                <span>Ấm nóng</span>
                                <span>Bổ dưỡng</span>
                            </p>
                        </div>
                    </div>

                    <div class="food-card">
                        <div class="food-image">
                            <img src="<%= request.getContextPath()%>/assets/img/foods/banh-mi.jpg" alt="Bánh mì">
                        </div>
                        <div class="food-info">
                            <h4>Bánh mì thịt</h4>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <span>(4.8)</span>
                            </div>
                            <p class="food-tags">
                                <span>Ăn nhanh</span>
                                <span>Đường phố</span>
                            </p>
                        </div>
                    </div>

                    <div class="food-card">
                        <div class="food-image">
                            <img src="<%= request.getContextPath()%>/assets/img/foods/bun-cha.jpg" alt="Bún chả">
                        </div>
                        <div class="food-info">
                            <h4>Bún chả Hà Nội</h4>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <span>(4.9)</span>
                            </div>
                            <p class="food-tags">
                                <span>Truyền thống</span>
                                <span>Đặc sản</span>
                            </p>
                        </div>
                    </div>

                    <div class="food-card">
                        <div class="food-image">
                            <img src="<%= request.getContextPath()%>/assets/img/foods/com-tam.jpg" alt="Cơm tấm">
                        </div>
                        <div class="food-info">
                            <h4>Cơm tấm sườn bì</h4>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(4.0)</span>
                            </div>
                            <p class="food-tags">
                                <span>Cơm trưa</span>
                                <span>Đậm đà</span>
                            </p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Trending Section -->
            <section class="trending">
                <h3>Món ăn đang hot</h3>
                <div class="trending-grid">
                    <div class="food-card">
                        <div class="food-image">
                            <img src="<%= request.getContextPath()%>/assets/img/foods/tra-sua.jpg" alt="Trà sữa trân châu">
                        </div>
                        <div class="food-info">
                            <h4>Trà sữa trân châu</h4>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <span>(4.7)</span>
                            </div>
                            <p class="food-tags">
                                <span>Giải khát</span>
                                <span>Hot trend</span>
                            </p>
                        </div>
                    </div>

                    <div class="food-card">
                        <div class="food-image">
                            <img src="<%= request.getContextPath()%>/assets/img/foods/banh-trang-tron.jpg" alt="Bánh tráng trộn">
                        </div>
                        <div class="food-info">
                            <h4>Bánh tráng trộn</h4>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span>(4.6)</span>
                            </div>
                            <p class="food-tags">
                                <span>Ăn vặt</span>
                                <span>Cay cay</span>
                            </p>
                        </div>
                    </div>

                    <div class="food-card">
                        <div class="food-image">
                            <img src="<%= request.getContextPath()%>/assets/img/foods/matcha.jpg" alt="Matcha đá xay">
                        </div>
                        <div class="food-info">
                            <h4>Matcha đá xay</h4>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(4.2)</span>
                            </div>
                            <p class="food-tags">
                                <span>Healthy</span>
                                <span>Refreshing</span>
                            </p>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <%@include file="../common/footer.jsp"%>
    </body>
<%@include file="../common/foot.jsp"%>
<%@include file="../common/js.jsp"%>
</html> 