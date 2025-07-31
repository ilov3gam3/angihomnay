<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">


<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:43 GMT -->
<head>
  <title>Foores - Single Restaurant Version</title>
  <%@include file="../common/reservation/head.jsp" %>
</head>

<body>

<div id="preloader">
  <div data-loader="circle-side"></div>
</div><!-- /Page Preload -->

<%@include file="../common/reservation/header.jsp" %>
<!-- /header -->

<main>
  <div class="container">
        <h1 class="text-center">↓</h1>
    <div class="d-flex justify-content-center">
      <canvas onclick="spin()" id="canvas" width="500" height="500"></canvas>
    </div>
  </div>
</main>
<!-- /main -->

<%@include file="../common/reservation/footer.jsp" %>
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
        <p>Lorem ipsum dolor sit amet, in porro albucius qui, in <strong>nec quod novum accumsan</strong>, mei
          ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne
          quod dicunt sensibus.</p>
        <p>Lorem ipsum dolor sit amet, in porro albucius qui, in nec quod novum accumsan, mei ludus tamquam
          dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt
          sensibus. Lorem ipsum dolor sit amet, <strong>in porro albucius qui</strong>, in nec quod novum
          accumsan, mei ludus tamquam dolores id. No sit debitis meliore postulant, per ex prompta alterum
          sanctus, pro ne quod dicunt sensibus.</p>
        <p>Lorem ipsum dolor sit amet, in porro albucius qui, in nec quod novum accumsan, mei ludus tamquam
          dolores id. No sit debitis meliore postulant, per ex prompta alterum sanctus, pro ne quod dicunt
          sensibus.</p>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<%@include file="../common/reservation/js.jsp" %>
<script src="https://cdn.jsdelivr.net/gh/zarocknz/javascript-winwheel@2.7.0/Winwheel.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.11.5/gsap.min.js"></script> <!-- GSAP là bắt buộc -->
<script>
  let theWheel = null;
  let foodList = [];
  const fixedColors = ['#e74c3c', '#27ae60', '#3498db', '#f39c12', '#9b59b6', '#e91e63'];
  function shuffle(array) {
    return array.sort(() => Math.random() - 0.5);
  }

  function createWheel(foods) {
    const segments = foods.map((food, index) => ({
      fillStyle: fixedColors[index % fixedColors.length],
      text: food.name,
      id: food.id
    }));

    theWheel = new Winwheel({
      'canvasId': 'canvas',
      'numSegments': segments.length,
      'segments': segments,
      'animation': {
        'type': 'spinToStop',
        'duration': 5,
        'spins': 8,
        'callbackFinished': function (indicatedSegment) {
          const selectedFood = foodList.find(f => f.name === indicatedSegment.text);
          if (selectedFood) {
            const go = confirm("Bạn đã trúng món: " + selectedFood.name + "\nBạn có muốn xem chi tiết món này?");
            if (go) {
              window.location.href = "<%=request.getContextPath()%>/food-detail?id=" + selectedFood.id;
            }
          }
        }
      }
    });
  }

  // // Tạo màu ngẫu nhiên cho từng phần
  // function getRandomColor() {
  //     const letters = '0123456789ABCDEF';
  //     let color = '#';
  //     for (let i = 0; i < 6; i++)
  //         color += letters[Math.floor(Math.random() * 16)];
  //     return color;
  // }

  // Gọi API và khởi tạo vòng quay
  fetch('<%=request.getContextPath()%>/api/get-all-food')
          .then(response => response.json())
          .then(data => {
            if (!Array.isArray(data) || data.length < 1) {
              alert("Không có dữ liệu món ăn!");
              return;
            }

            foodList = shuffle(data).slice(0, 6); // Lấy 6 món ngẫu nhiên
            createWheel(foodList);
          })
          .catch(error => {
            console.error('Lỗi khi gọi API:', error);
            alert('Lỗi khi lấy danh sách món ăn.');
          });

  // Gắn sự kiện quay khi bấm nút
    function spin() {
      if (theWheel) {
        theWheel.stopAnimation(false); // nếu đang quay thì dừng
        theWheel.rotationAngle = 0;
        theWheel.draw();
        theWheel.startAnimation();
      }
    }
</script>

</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
