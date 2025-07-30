<%@ page import="Dao.RestaurantDao" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">


<!-- Mirrored from www.ansonika.com/foores/reservations.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:49:43 GMT -->
<head>
    <title>Foores - Single Restaurant Version</title>
    <%@include file="../common/reservation/head.jsp"%>

</head>

<body>

<div id="preloader">
    <div data-loader="circle-side"></div>
</div><!-- /Page Preload -->

<div id="loader_form">
    <div data-loader="circle-side-2"></div>
</div><!-- /loader_form -->

<%@include file="../common/reservation/header.jsp"%>
<!-- /header -->

<main>

    <div class="hero_single inner_pages background-image" data-background="url(<%=request.getContextPath()%>/assets/reservation/img/hero_reservation.jpg)">
        <div class="opacity-mask" data-opacity-mask="rgba(0, 0, 0, 0.6)">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xl-9 col-lg-10 col-md-8">
                        <h1>Reserve a Table</h1>
                        <p>Per consequat adolescens ex cu nibh commune</p>
                    </div>
                </div>
                <!-- /row -->
            </div>
        </div>
        <div class="frame white"></div>
    </div>
    <!-- /hero_single -->

    <div class="pattern_2">
        <div class="container margin_120_100 pb-0">
            <div class="row justify-content-center">
                <div class="col-12 col-md-5 text-center d-none d-lg-block" data-cue="slideInUp">
                    <img src="<%=request.getContextPath()%>/assets/reservation/img/chef.png" width="400" height="733" alt="" class="img-fluid">
                </div>
                <div class="col-12 col-md-7" data-cue="slideInUp">
                    <%
                        String flashSuccess = (String) session.getAttribute("flash_success");
                        String flashError = (String) session.getAttribute("flash_error");
                        session.removeAttribute("flash_success");
                        session.removeAttribute("flash_error");
                    %>
                    <%if (flashSuccess != null) {%>
                    <div class="alert alert-success" role="alert">
                        <%=flashSuccess%>
                    </div>
                    <%}%>
                    <%if (flashError != null) {%>
                    <div class="alert alert-danger" role="alert">
                        <%=flashError%>
                    </div>
                    <%}%>

                    <div class="main_title">
                        <span><em></em></span>
                        <h2>Reserve a table</h2>
                        <p>or Call us at 0344 32423453</p>
                    </div>
                    <div id="wizard_container">
                        <form id="bookingHiddenForm" action="<%=request.getContextPath()%>/customer/book" method="post" style="display: none;">
                            <input type="hidden" name="datepicker_field" id="hidden_date">
                            <input type="hidden" name="restaurantId" id="hidden_restaurant">
                            <input type="hidden" name="startTime" id="hidden_start_time">
                            <input type="hidden" name="note" id="hidden_note">
                            <!-- Sẽ thêm dynamic input cho foodIds[] và quantities[] bằng JS -->
                        </form>
                        <form id="wrapped" method="POST">
                            <input id="website" name="website" type="text" value="">
                            <!-- Leave for security protection, read docs for details -->
                            <div id="middle-wizard">
                                <div class="step">
                                    <h3 class="main_question"><strong>1/4</strong> Vui lòng chọn ngày</h3>
                                    <div class="form-group">
                                        <input type="hidden" name="datepicker_field" id="datepicker_field" class="required">
                                    </div>
                                    <div id="mydatepicker"></div>
                                </div>
                                <!-- /step-->
                                <div class="step">
                                    <h3 class="main_question"><strong>2/4</strong> Select restaurant and time</h3>

                                    <!-- Select restaurant -->
                                    <div class="step_wrapper">
                                        <h4>Select a restaurant</h4>
                                        <div class="select_wrapper add_bottom_15">
                                            <select id="restaurantSelect" class="required form-control">
                                                <% for(Restaurant r : new RestaurantDao().getAll()) { %>
                                                <option value="<%= r.getId() %>"><%= r.getName() %> (<%=r.getOpenTime()%> - <%=r.getCloseTime()%>)</option>
                                                <% } %>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Select time -->
                                    <div class="step_wrapper">
                                        <h4>Select time</h4>
                                        <div class="radio_select add_bottom_15" id="timeOptions">
                                            <!-- JS will populate time options here -->
                                        </div>
                                    </div>
                                </div>
                                <!-- /step-->
                                <div class="step">
                                    <h3 class="main_question"><strong>3/4</strong> Ghi chú</h3>
                                    <div class="form-group">
                                        <textarea id="note" rows="10" class="form-control"></textarea>
                                    </div>
                                </div>
                                <!-- /step-->
                                <div class="submit step">
                                    <h3 class="main_question"><strong>4/4</strong> Chọn món</h3>
                                    <p>nếu bạn không chọn món thì bạn phải trả trước 100.000đ tiền giữ chỗ, số tiền này sẽ được trừ khi bạn thanh toán hóa đơn</p>
                                    <div id="selectedSummary" class="alert alert-info mb-3">
                                        Không chọn món nào, phí giữ chỗ 100.000đ
                                    </div>
                                    <div id="foodContainer" class="row" style="max-height: 600px; overflow-y: auto;"></div>
                                </div>
                                <!-- /step-->
                            </div>
                            <!-- /middle-wizard -->
                            <div id="bottom-wizard">
                                <button type="button" name="backward" class="backward">Prev</button>
                                <button type="button" name="forward" class="forward">Next</button>
                                <button type="button" id="submitBookingBtn" name="process" class="submit">Submit</button>
                            </div>
                            <!-- /bottom-wizard -->
                        </form>
                    </div>
                    <!-- /Wizard container -->
                </div>
            </div>
            <!-- /row -->
        </div>
        <!-- /container -->
    </div>
    <!-- /pattern_2 -->

</main>
<!-- /main -->

<%@include file="../common/reservation/footer.jsp"%>
<!--/footer-->

<div id="toTop"></div><!-- Back to top button -->

<!-- COMMON SCRIPTS -->
<script src="<%=request.getContextPath()%>/assets/reservation/js/common_scripts.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/reservation/js/common_func.js"></script>
<script src="<%=request.getContextPath()%>/assets/reservation/phpmailer/validate.js"></script>

<!-- SPECIFIC SCRIPTS (wizard form) -->
<script src="<%=request.getContextPath()%>/assets/reservation/js/wizard/wizard_scripts.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/reservation/js/wizard/wizard_func.js"></script>
<script>
    $("#mydatepicker").datepicker({
        dateFormat: "yy-mm-dd", // hoặc format bạn muốn
        minDate: 1, // <== đây là dòng quan trọng: chặn từ hôm nay trở về trước
        beforeShowDay: function(date) {
            const today = new Date();
            today.setHours(0, 0, 0, 0); // reset giờ để so chính xác
            if (date < today) {
                return [false, "", "Ngày đã qua"]; // không cho chọn
            }
            return [true]; // cho chọn các ngày khác
        },
        onSelect: function(dateText) {
            // Gán giá trị được chọn vào input hidden
            $("#datepicker_field").val(dateText);
        }
    });
</script>
<script>
    document.getElementById("restaurantSelect").addEventListener("change", function () {
        var resId = this.value;
        loadFoods(resId)
        fetch("<%=request.getContextPath()%>/api/open-hours?resId=" + resId)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var open = data.open;
                var close = data.close;
                var container = document.getElementById("timeOptions");
                container.innerHTML = ""; // Clear previous

                var start = toMinutes(open);
                var end = toMinutes(close);
                const duration = 120;
                var listHtml = "<ul>";
                for (var min = start; min + duration <= end; min += duration) {
                    var timeStr = formatTime(min);
                    var id = "time_" + min;
                    listHtml +=
                        "<li>" +
                        "<input type=\"radio\" id=\"" + id + "\" name=\"time\" value=\"" + timeStr + "\" class=\"required\">" +
                        "<label for=\"" + id + "\">" + timeStr + "</label>" +
                        "</li>";
                }
                listHtml += "</ul>";
                container.innerHTML = listHtml;
            });

        function toMinutes(timeStr) {
            var parts = timeStr.split(":");
            return parseInt(parts[0], 10) * 60 + parseInt(parts[1], 10);
        }

        function formatTime(minutes) {
            var h = Math.floor(minutes / 60);
            var m = minutes % 60;
            var ampm = h >= 12 ? "pm" : "am";
            var h12 = h % 12 === 0 ? 12 : h % 12;
            var mm = m < 10 ? "0" + m : m;
            return h12 + "." + mm + ampm;
        }
    });

    // Trigger on page load for first restaurant
    window.addEventListener("DOMContentLoaded", function () {
        document.getElementById("restaurantSelect").dispatchEvent(new Event("change"));
    });
    function loadFoods(restaurantId) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "<%=request.getContextPath()%>/api/get-foods-of-restaurant?id=" + restaurantId, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var foods = JSON.parse(xhr.responseText);
                var container = document.getElementById("foodContainer");
                container.innerHTML = "";

                for (var i = 0; i < foods.length; i++) {
                    var food = foods[i];
                    if (!food.isAvailable) {
                        continue;
                    }

                    var categories = "";
                    for (var j = 0; j < food.categories.length; j++) {
                        categories += "<span class='badge bg-secondary me-1'>" + food.categories[j].name + "</span>";
                    }

                    var item =
                        "<div class='col-md-6 mb-4'>" +
                        "<div class='card h-100'>" +
                        "<img src='" + food.image + "' class='card-img-top' style='max-height: 180px; object-fit: cover' alt='" + food.name + "'>" +
                        "<div class='card-body'>" +
                        "<h5 class='card-title'>" + food.name + "</h5>" +
                        "<p class='card-text'>" + food.description + "</p>" +
                        "<div class='mb-2'>" + categories + "</div>" +
                        "<p class='fw-bold text-danger'>" + food.price.toLocaleString("vi-VN") + " đ</p>" +
                        "<div class='input-group food-quantity' data-price='" + food.price + "' data-food-id='" + food.id + "'>" +
                        "<button class='btn btn-outline-secondary btn-decrease' type='button'>-</button>" +
                        "<input type='number' class='form-control text-center quantity-input' value='0' min='0' data-price='" + food.price + "'>" +
                        "<button class='btn btn-outline-secondary btn-increase' type='button'>+</button>" +
                        "</div>" +
                        "</div>" +
                        "</div>" +
                        "</div>";

                    container.insertAdjacentHTML("beforeend", item);
                }
                attachQuantityHandlers();
            }
        };
        xhr.send();
    }
    function attachQuantityHandlers() {
        console.log('attachQuantityHandlers')
        var increaseBtns = document.querySelectorAll(".btn-increase");
        var decreaseBtns = document.querySelectorAll(".btn-decrease");
        var quantityInputs = document.querySelectorAll(".quantity-input");

        for (var i = 0; i < increaseBtns.length; i++) {
            increaseBtns[i].addEventListener("click", function () {
                var input = this.parentElement.querySelector(".quantity-input");
                input.value = parseInt(input.value) + 1;
                updateSummary();
            });
        }

        for (var i = 0; i < decreaseBtns.length; i++) {
            decreaseBtns[i].addEventListener("click", function () {
                var input = this.parentElement.querySelector(".quantity-input");
                if (parseInt(input.value) > 0) {
                    input.value = parseInt(input.value) - 1;
                    updateSummary();
                }
            });
        }

        for (var i = 0; i < quantityInputs.length; i++) {
            quantityInputs[i].addEventListener("input", updateSummary);
        }

        updateSummary(); // cập nhật ban đầu
    }
    function updateSummary() {
        console.log('updateSummary')
        var quantityInputs = document.querySelectorAll(".quantity-input");
        var totalItems = 0;
        var totalPrice = 0;

        for (var i = 0; i < quantityInputs.length; i++) {
            var quantity = parseInt(quantityInputs[i].value);
            var price = parseInt(quantityInputs[i].getAttribute("data-price"));
            if (quantity > 0) {
                totalItems += quantity;
                totalPrice += price * quantity;
            }
        }

        var summary = document.getElementById("selectedSummary");
        if (totalItems === 0) {
            summary.innerHTML = "Không chọn món nào, giữ chỗ 100.000đ";
        } else {
            summary.innerHTML = "Đã chọn " + totalItems + " món, tạm tính: " + totalPrice.toLocaleString("vi-VN") + " đ";
        }
    }

</script>
<script>
    document.getElementById("submitBookingBtn").addEventListener("click", function () {
        const hiddenForm = document.getElementById("bookingHiddenForm");

        // 1. Binding ngày
        const rawDate = document.getElementById("datepicker_field").value;
        const isoDate = document.getElementById("datepicker_field").value;
        document.getElementById("hidden_date").value = isoDate

        // 2. Binding nhà hàng
        const resId = document.getElementById("restaurantSelect").value;
        document.getElementById("hidden_restaurant").value = resId;

        // 3. Binding giờ
        const selectedTime = document.querySelector('input[name="time"]:checked');
        if (!selectedTime) {
            alert("Vui lòng chọn giờ");
            return;
        }

        // Ghép ngày + giờ thành LocalDateTime: yyyy-MM-ddTHH:mm
        const timeStr = selectedTime.value.replace("am", "").replace("pm", "");
        let [hour, minute] = timeStr.split(".");
        hour = parseInt(hour);
        if (selectedTime.value.includes("pm") && hour < 12) hour += 12;
        if (selectedTime.value.includes("am") && hour === 12) hour = 0;

        const startTime = isoDate + "T" + hour.toString().padStart(2, '0') + ":" + minute;
        console.log("startTime:", startTime);
        document.getElementById("hidden_start_time").value = startTime;

        // 4. Gán note nếu có (tùy thêm sau)
        document.getElementById("hidden_note").value = document.getElementById("note").value

        // 5. Xóa input cũ
        const existingFoodInputs = hiddenForm.querySelectorAll("input[name='foodIds'], input[name='quantities']");
        existingFoodInputs.forEach(el => el.remove());

        // 6. Binding món ăn và quantity
        const quantityInputs = document.querySelectorAll(".quantity-input");
        quantityInputs.forEach((input) => {
            const qty = parseInt(input.value);
            if (qty > 0) {
                const foodId = input.closest(".food-quantity").getAttribute("data-food-id");

                const foodInput = document.createElement("input");
                foodInput.type = "hidden";
                foodInput.name = "foodIds";
                foodInput.value = foodId;

                const qtyInput = document.createElement("input");
                qtyInput.type = "hidden";
                qtyInput.name = "quantities";
                qtyInput.value = qty;

                hiddenForm.appendChild(foodInput);
                hiddenForm.appendChild(qtyInput);
            }
        });
        hiddenForm.submit();
    });

    function formatDateToISO(dateStr) {
        const parts = dateStr.split('/');
        if (parts.length !== 3) return "";
        const [month, day, year] = parts;
        return `\${year}-\${month.padStart(2, '0')}-\${day.padStart(2, '0')}`;
    }
</script>

</body>

<!-- Mirrored from www.ansonika.com/foores/reservations.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 24 Jul 2025 13:49:43 GMT -->
</html>