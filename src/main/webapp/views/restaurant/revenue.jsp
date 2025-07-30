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
    <div class="container">
        <h2>Thống kê doanh thu</h2>
        <div id="restaurantSection" class="mb-4">
            <div class="row mb-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label">Tuần bắt đầu <small id="startWeekRange" class="form-text text-muted"></small></label>
                    <input class="form-control" type="number" id="startWeek" min="1" max="52">

                </div>
                <div class="col-md-4">
                    <label class="form-label">Tuần kết thúc <small id="endWeekRange" class="form-text text-muted"></small></label>
                    <input class="form-control" type="number" id="endWeek" min="1" max="52">

                </div>
                <div class="col-md-4">
                    <button id="loadRestaurantRevenue" class="btn btn-success btn-lg h-100 w-100">Xem doanh thu</button>
                </div>
            </div>
            <canvas id="restaurantChart" height="100"></canvas>
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
<script>
    const ctxRestaurant = document.getElementById('restaurantChart').getContext('2d');
    let restaurantChart, adminChart;
    document.getElementById("loadRestaurantRevenue").addEventListener("click", () => {
        const startWeek = document.getElementById("startWeek").value;
        const endWeek = document.getElementById("endWeek").value;
        const restaurantId = <%=user.getId()%>; // Hoặc lấy từ session, hidden input...

        fetch(`<%=request.getContextPath()%>/api/revenue-statistics?role=restaurant&startWeek=\${startWeek}&endWeek=\${endWeek}&restaurantId=\${restaurantId}`)
            .then(res => res.json())
            .then(data => {
                const labels = data.map(item => "Tuần " + item.week);
                const revenues = data.map(item => item.revenue);

                if (restaurantChart) restaurantChart.destroy();
                restaurantChart = new Chart(ctxRestaurant, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Doanh thu',
                            data: revenues,
                            backgroundColor: '#4caf50'
                        }]
                    }
                });
            });
    });
</script>
<script>
    // Trả về số tuần trong năm cho một ngày cụ thể
    function getWeekNumber(date) {
        const firstDay = new Date(date.getFullYear(), 0, 1);
        const days = Math.floor((date - firstDay) / (24 * 60 * 60 * 1000));
        return Math.ceil((days + firstDay.getDay() + 1) / 7);
    }

    // Trả về range ngày (từ thứ hai đến chủ nhật) của tuần thứ `week` trong năm `year`
    function getWeekRange(year, week) {
        const jan1 = new Date(year, 0, 1);
        const start = new Date(jan1.setDate(jan1.getDate() + (week - 1) * 7));
        const day = start.getDay();
        const diffToMonday = start.getDate() - day + (day === 0 ? -6 : 1);
        start.setDate(diffToMonday);

        const end = new Date(start);
        end.setDate(start.getDate() + 6);

        return {
            start: start.toLocaleDateString('vi-VN'),
            end: end.toLocaleDateString('vi-VN')
        };
    }

    function updateWeekRangeInfo() {
        const year = new Date().getFullYear();
        const startWeek = parseInt(document.getElementById("startWeek").value);
        const endWeek = parseInt(document.getElementById("endWeek").value);

        const startInfo = document.getElementById("startWeekRange");
        const endInfo = document.getElementById("endWeekRange");

        if (startWeek >= 1 && startWeek <= 52) {
            const range = getWeekRange(year, startWeek);
            startInfo.textContent = `(\${range.start} - \${range.end})`;
        } else {
            startInfo.textContent = "";
        }

        if (endWeek >= 1 && endWeek <= 52) {
            const range = getWeekRange(year, endWeek);
            endInfo.textContent = `(\${range.start} - \${range.end})`;
        } else {
            endInfo.textContent = "";
        }
    }

    function autoFillWeeks() {
        const today = new Date();
        const currentWeek = getWeekNumber(today);
        const previousWeek = Math.max(1, currentWeek - 1); // tránh < 1

        document.getElementById("startWeek").value = previousWeek;
        document.getElementById("endWeek").value = currentWeek;

        updateWeekRangeInfo();
    }

    // Gọi khi trang load
    window.addEventListener("DOMContentLoaded", () => {
        autoFillWeeks();

        document.getElementById("startWeek").addEventListener("input", updateWeekRangeInfo);
        document.getElementById("endWeek").addEventListener("input", updateWeekRangeInfo);
    });
</script>


<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
