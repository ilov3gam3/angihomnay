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
        <div class="col-12 d-flex justify-content-center">
            <button id="ask_button" class="btn btn-success m-1">Hỏi AI</button>
            <button id="wheel_button" class="btn btn-outline-success m-1">Quay món ngẫu nhiên</button>
        </div>
        <div class="col-12 d-flex justify-content-center">
            <div id="ask" class="col-12">
                <div class="card-header">Gợi ý món ăn từ AI</div>
                <div class="card-body" id="chatBox"
                     style="height: 300px; overflow-y: auto; background: #f8f9fa;"></div>

                <!-- FORM bên trong box chat -->
                <form id="aiSuggestionForm" class="p-3 border-top">
                    <div class="form-group">
                        <label for="emotion">Cảm xúc của bạn?</label>
                        <input type="text" class="form-control" id="emotion" name="emotion" required>
                    </div>
                    <div class="form-group">
                        <label for="hunger">Mức độ đói?</label>
                        <input type="text" class="form-control" id="hunger" name="hunger" required>
                    </div>
                    <div class="form-group">
                        <label for="time">Thời gian ăn?</label>
                        <input type="text" class="form-control" id="time" name="time" required>
                    </div>

                    <% if (user != null) { %>
                    <div class="form-group">
                        <label>Dùng sở thích từ hồ sơ?</label><br>
                        <input type="radio" name="useTastes" value="yes" checked> Có
                        <input type="radio" name="useTastes" value="no"> Không
                        <input type="text" class="form-control mt-2" id="tastesInput"
                               value="<%= user.getFavoriteTastes().stream().map(a -> a.getName()).collect(java.util.stream.Collectors.joining(", ")) %>"
                               disabled>
                    </div>
                    <div class="form-group">
                        <label>Dùng dị ứng từ hồ sơ?</label><br>
                        <input type="radio" name="useAllergies" value="yes" checked> Có
                        <input type="radio" name="useAllergies" value="no"> Không
                        <input type="text" class="form-control mt-2" id="allergiesInput"
                               value="<%= user.getAllergies().stream().map(a -> a.getName()).collect(java.util.stream.Collectors.joining(", ")) %>"
                               disabled>
                    </div>
                    <% } else { %>
                    <div class="form-group">
                        <label>Sở thích món ăn</label>
                        <input type="text" class="form-control" id="tastesInput" name="tastes">
                    </div>
                    <div class="form-group">
                        <label>Dị ứng</label>
                        <input type="text" class="form-control" id="allergiesInput" name="allergies">
                    </div>
                    <% } %>

                    <button type="submit" class="btn btn-success mt-3">Gửi</button>
                </form>
            </div>
            <div id="wheel" style="display: none">
                <button id="spinButton" class="btn btn-success">Quay món ăn</button>
                <h1 class="text-center">↓</h1>
                <canvas id="canvas" width="500" height="500"></canvas>
            </div>
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
    $("#ask_button").click(function () {
        $("#ask").show();
        $("#wheel").hide();
        $("#ask_button").removeClass('btn-outline-success').addClass('btn-success');
        $('#wheel_button').removeClass('btn-success').addClass('btn-outline-success');
    })
    $("#wheel_button").click(function () {
        $("#wheel").show();
        $("#ask").hide();
        $("#ask_button").removeClass('btn-success').addClass('btn-outline-success');
        $('#wheel_button').removeClass('btn-outline-success').addClass('btn-success');
    })
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("aiSuggestionForm");
        const chatBox = document.getElementById("chatBox");

        // Toggle disable/enable input nếu chọn "Không dùng hồ sơ"
        const setupRadioToggle = (radioName, inputId, originalValue) => {
            document.getElementsByName(radioName).forEach(r => {
                r.addEventListener("change", () => {
                    const input = document.getElementById(inputId);
                    if (r.value === "yes") {
                        input.disabled = true;
                        input.value = originalValue;
                    } else {
                        input.disabled = false;
                        input.value = "";
                    }
                });
            });
        };

        // Nếu có radio (chỉ với user đã login)
        if (document.getElementsByName("useTastes").length > 0) {
            setupRadioToggle("useTastes", "tastesInput", document.getElementById("tastesInput").value);
        }
        if (document.getElementsByName("useAllergies").length > 0) {
            setupRadioToggle("useAllergies", "allergiesInput", document.getElementById("allergiesInput").value);
        }
        form.addEventListener("submit", function (e) {
            e.preventDefault();

            const params = new URLSearchParams(new FormData(form)).toString();

            appendChat("👤", "Đang gửi yêu cầu...");

            fetch("<%=request.getContextPath()%>/api/ask-ai?" + params)
                .then(response => response.text())
                .then(data => {
                    let parsed;

                    // Cố gắng parse JSON (AI có thể trả thừa dấu ```json, v.v.)
                    try {
                        const cleaned = data.replace(/```json|```/g, "").trim();
                        parsed = JSON.parse(cleaned);
                    } catch (err) {
                        appendChat("🤖", "❌ Phản hồi từ AI không hợp lệ.");
                        console.error("JSON parse error:", err);
                        return;
                    }

                    const analysis = parsed.analysis || "Không có phân tích.";
                    const ids = parsed.recommendedIds || [];

                    appendChat("🤖", `<p>\${analysis}</p>`);

                    if (ids.length > 0) {
                        const linksHtml = ids.map(id =>
                            `<a href="<%=request.getContextPath()%>/food-detail?id=\${id}" class="btn btn-outline-primary btn-sm m-1">Xem món #\${id}</a>`
                        ).join("");
                        appendChat("🤖", `<div>Gợi ý món ăn phù hợp:<br>\${linksHtml}</div>`);
                    } else {
                        appendChat("🤖", "Không có món ăn nào được gợi ý.");
                    }
                })
                .catch(error => {
                    appendChat("🤖", "Đã xảy ra lỗi!");
                    console.error(error);
                });
        });

        function appendChat(sender, message) {
            const div = document.createElement("div");
            div.className = "mb-3";
            div.innerHTML = `<strong>\${sender}</strong>:<br>\${message}`;
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        }
    });
</script>
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
    document.getElementById('spinButton').addEventListener('click', function () {
        if (theWheel) {
            theWheel.stopAnimation(false); // nếu đang quay thì dừng
            theWheel.rotationAngle = 0;
            theWheel.draw();
            theWheel.startAnimation();
        }
    });
</script>

</body>

<!-- Mirrored from www.ansonika.com/foores/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:51:44 GMT -->
</html>
