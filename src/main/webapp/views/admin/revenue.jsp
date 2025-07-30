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
        <div id="adminSection">
            <label>Tháng: <input class="form-control" type="number" id="month" min="1" max="12"></label>
            <label>Năm: <input class="form-control" type="number" id="year" value="<%=java.time.LocalDate.now().getYear()%>"></label>
            <button id="loadAdminRevenue" class="btn btn-success">Xem doanh thu</button>
            <canvas id="adminChart" height="100"></canvas>
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
    const ctxAdmin = document.getElementById('adminChart').getContext('2d');
    let restaurantChart, adminChart;
    document.getElementById("loadAdminRevenue").addEventListener("click", () => {
        const month = document.getElementById("month").value;
        const year = document.getElementById("year").value;

        fetch(`<%=request.getContextPath()%>/api/revenue-statistics?role=admin&month=\${month}&year=\${year}`)
            .then(res => res.json())
            .then(data => {
                const labels = data.map(item => item.restaurant);
                const revenues = data.map(item => item.revenue);

                if (adminChart) adminChart.destroy();
                adminChart = new Chart(ctxAdmin, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Doanh thu',
                            data: revenues,
                            backgroundColor: '#2196f3'
                        }]
                    }
                });
            });
    });
</script>
<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
