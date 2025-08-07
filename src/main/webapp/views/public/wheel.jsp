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
    <h1 class="text-center mb-3">🎯 Vòng quay món ăn</h1>

    <div class="mb-4 text-center">
      <label class="me-3">
        <input type="radio" name="mode" value="auto" checked> Random 6 món ăn
      </label>
      <label>
        <input type="radio" name="mode" value="manual"> Chọn món ăn thủ công
      </label>
    </div>

    <div id="manualSelectWrapper" class="mb-4 d-none">
      <label>Chọn tối đa 6 món ăn:</label>
      <select id="manualSelect" class="form-select" multiple size="6">
        <!-- Sẽ được JS đổ dữ liệu -->
      </select>
      <small class="text-muted">Giữ Ctrl (Windows) hoặc Cmd (Mac) để chọn nhiều món.</small>
    </div>
    <h1 class="text-center">↓</h1>
    <div class="d-flex justify-content-center mt-4">
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
  let allFoods = [];

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

  // Lấy dữ liệu món ăn từ API
  fetch('<%=request.getContextPath()%>/api/get-all-food')
          .then(response => response.json())
          .then(data => {
            if (!Array.isArray(data) || data.length < 1) {
              alert("Không có dữ liệu món ăn!");
              return;
            }

            allFoods = data;

            // Auto mode default
            foodList = shuffle(allFoods).slice(0, 6);
            createWheel(foodList);

            // Đổ dữ liệu vào select
            const select = document.getElementById('manualSelect');
            allFoods.forEach(food => {
              const opt = document.createElement('option');
              opt.value = food.id;
              opt.textContent = food.name;
              select.appendChild(opt);
            });
          })
          .catch(error => {
            console.error('Lỗi khi gọi API:', error);
            alert('Lỗi khi lấy danh sách món ăn.');
          });

  // Chọn chế độ
  document.querySelectorAll('input[name="mode"]').forEach(radio => {
    radio.addEventListener('change', (e) => {
      const mode = e.target.value;
      const wrapper = document.getElementById('manualSelectWrapper');

      if (mode === 'manual') {
        wrapper.classList.remove('d-none');
      } else {
        wrapper.classList.add('d-none');
        foodList = shuffle(allFoods).slice(0, 6);
        createWheel(foodList);
      }
    });
  });

  // Xử lý khi chọn món thủ công
  document.getElementById('manualSelect').addEventListener('change', () => {
    const selectedIds = Array.from(document.getElementById('manualSelect').selectedOptions).map(opt => opt.value);

    if (selectedIds.length > 6) {
      alert("Vui lòng chọn tối đa 6 món ăn.");
      return;
    }

    foodList = allFoods.filter(f => selectedIds.includes(f.id.toString()));
    if (foodList.length > 0) {
      createWheel(foodList);
    }
  });

  function spin() {
    if (theWheel) {
      theWheel.stopAnimation(false);
      theWheel.rotationAngle = 0;
      theWheel.draw();
      theWheel.startAnimation();
    }
  }
</script>


</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
