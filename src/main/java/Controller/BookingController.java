package Controller;

import Dao.*;
import Model.*;
import Model.Constant.BookingStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

public class BookingController {
    @WebServlet("/customer/book")
    public static class BookingServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            /*RestaurantTableDao restaurantTableDao = new RestaurantTableDao();
            BookingDetailDao bookingDetailDao = new BookingDetailDao();
            FoodDao foodDao = new FoodDao();
            BookingDao bookingDao = new BookingDao();
            User user = (User) req.getSession().getAttribute("user");
            long tableId = Long.parseLong(req.getParameter("tableId"));
            RestaurantTable restaurantTable = restaurantTableDao.getById(tableId);
            if (restaurantTable == null) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy bàn này.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            List<Long> foodIds = Optional.ofNullable(req.getParameterValues("foodIds"))
                    .stream().flatMap(Arrays::stream).map(Long::parseLong).toList();
            List<Food> foods = foodDao.getAvailableByIds(foodIds);
            List<Integer> quantities = Optional.ofNullable(req.getParameterValues("quantities"))
                    .stream().flatMap(Arrays::stream).map(Integer::parseInt).toList();
            if (foods.size() != quantities.size()) {
                req.getSession().setAttribute("flash_error", "Đã có lỗi xảy ra.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            if (foods.isEmpty()) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy món này.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            Booking existingBooking = bookingDao.getPendingBookingByUserId(user.getId());
            if (existingBooking != null && !Objects.equals(existingBooking.getTable().getRestaurant().getId(), restaurantTable.getRestaurant().getId())){
                req.getSession().setAttribute("flash_error", "Bạn chỉ được đặt món ở một nhà hàng tại một thời điểm.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            if (restaurantTable.isHavingCustomer()){ // bàn đang có khách đồng nghĩa với việc đang có booking.
                // lấy booking cũ ra và thêm vào details đã có sẵn
                if (!Objects.equals(existingBooking.getCustomer().getId(), user.getId())){
                    req.getSession().setAttribute("flash_error", "Bàn đang được sử dụng bởi người khác.");
                    resp.sendRedirect(req.getHeader("referer"));
                    return;
                }
                List<BookingDetail> bookingDetails = bookingDetailDao.getBookingDetailsByBookingIdAndFoods(existingBooking.getId());
                for (int i = 0; i < foods.size(); i++) {
                    Food food = foods.get(i);
                    int quantity = quantities.get(i);
                    boolean isExisting = false;
                    for (BookingDetail detail : bookingDetails) {
                        if (Objects.equals(detail.getFood().getId(), food.getId())) {
                            detail.setQuantity(detail.getQuantity() + quantity);
                            bookingDetailDao.update(detail); // Đảm bảo cập nhật DB
                            isExisting = true;
                            break;
                        }
                    }
                    // Nếu chưa có thì thêm mới
                    if (!isExisting) {
                        BookingDetail newDetail = new BookingDetail(existingBooking, food, quantity);
                        bookingDetailDao.save(newDetail);
                    }
                }
                bookingDetailDao.updateAll(bookingDetails);
            } else {
                Customer customer = new CustomerDao().getById(user.getId());
                String note = req.getParameter("note");
                Booking booking = new Booking(customer, restaurantTable, LocalDateTime.now(), note, BookingStatus.PENDING);
                bookingDao.save(booking); // để có ID

                for (int i = 0; i < foods.size(); i++) {
                    BookingDetail bookingDetail = new BookingDetail(booking, foods.get(i), quantities.get(i));
                    bookingDetailDao.save(bookingDetail);
                }
                restaurantTable.setHavingCustomer(true);
                restaurantTableDao.update(restaurantTable);
            }
            req.getSession().setAttribute("flash_success", "Đặt món thành công.");
            resp.sendRedirect(req.getHeader("referer"));*/
            RestaurantTableDao restaurantTableDao = new RestaurantTableDao();
            RestaurantDao restaurantDao = new RestaurantDao();
            BookingDao bookingDao = new BookingDao();
            BookingDetailDao bookingDetailDao = new BookingDetailDao();
            CustomerDao customerDao = new CustomerDao();
            FoodDao foodDao = new FoodDao();
            User user = (User) req.getSession().getAttribute("user");
            long restaurantId = Long.parseLong(req.getParameter("restaurantId"));
            Restaurant restaurant = restaurantDao.getById(restaurantId);
            if (restaurant == null) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy nhà hàng này.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            LocalDateTime startTime = LocalDateTime.parse(req.getParameter("startTime"));
            LocalDateTime endTime = startTime.plusHours(2);
            RestaurantTable restaurantTable = restaurantTableDao.findAvailableTable(restaurantId, startTime, endTime);
            if (restaurantTable == null) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy bàn trống trong thời gian này.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            List<Long> foodIds = Optional.ofNullable(req.getParameterValues("foodIds"))
                    .stream().flatMap(Arrays::stream).map(Long::parseLong).toList();
            List<Integer> quantities = Optional.ofNullable(req.getParameterValues("quantities"))
                    .stream().flatMap(Arrays::stream).map(Integer::parseInt).toList();
            Customer customer = customerDao.getById(user.getId());
            String note = req.getParameter("note");
            Booking booking;
            if (foodIds.isEmpty()){
                long prePaidFee = 100000;
                booking = new Booking(customer, restaurantTable, startTime, endTime, prePaidFee, note, 0L, BookingStatus.PENDING);
                bookingDao.save(booking);
            } else {
                // lọc ra các món có số lượng > 0
                List<Long> filteredFoodIds = new ArrayList<>();
                List<Integer> filteredQuantities = new ArrayList<>();
                for (int i = 0; i < foodIds.size(); i++) {
                    if (quantities.get(i) > 0) {
                        filteredFoodIds.add(foodIds.get(i));
                        filteredQuantities.add(quantities.get(i));
                    }
                }
                if (filteredQuantities.size() != filteredFoodIds.size()) {
                    req.getSession().setAttribute("flash_error", "Đã có lỗi xảy ra.");
                    resp.sendRedirect(req.getHeader("referer"));
                    return;
                }
                // lọc ra các món có số lượng > 0
                List<Food> foods = foodDao.getAvailableByIds(filteredFoodIds);
                if (foodIds.size() != quantities.size()) {
                    req.getSession().setAttribute("flash_error", "Dữ liệu không hợp lệ.");
                    resp.sendRedirect(req.getHeader("referer"));
                    return;
                }
                booking = new Booking(customer, restaurantTable, startTime, endTime, 0, note, 0, BookingStatus.PENDING);
                bookingDao.save(booking);

                long prePaidFee = 0;
                List<BookingDetail> bookingDetails = new ArrayList<>();
                for (int i = 0; i < foods.size(); i++) {
                    prePaidFee += (long) foods.get(i).getPrice() * filteredQuantities.get(i);
                    BookingDetail bookingDetail = new BookingDetail(booking, foods.get(i), foods.get(i).getPrice(), filteredQuantities.get(i));
                    bookingDetails.add(bookingDetail);
                }
                bookingDetailDao.saveAll(bookingDetails);
                booking.setPrePaidFee(prePaidFee);
                bookingDao.save(booking);
            }
            resp.sendRedirect(req.getContextPath() + "/get-vnpay-url?id=" + booking.getId());
        }
    }
    @WebServlet("/restaurant/remove-food-from-booking")
    public static class RemoveFoodFromBookingServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long bookingId = Long.parseLong(req.getParameter("bookingId"));
            long foodId = Long.parseLong(req.getParameter("foodId"));
            BookingDao bookingDao = new BookingDao();
            FoodDao foodDao = new FoodDao();
            BookingDetailDao bookingDetailDao = new BookingDetailDao();
            Booking booking = bookingDao.getById(bookingId);
            if (booking == null) {
                req.getSession().setAttribute("flash_success", "Không tìm thấy booking này.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            Food food = foodDao.getById(foodId);
            if (food == null) {
                req.getSession().setAttribute("flash_success", "Không tìm thấy món  này.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            List<BookingDetail> bookingDetails = booking.getBookingDetails();
            for (int i = 0; i < bookingDetails.size(); i++) {
                if (Objects.equals(bookingDetails.get(i).getFood().getId(), food.getId())) {
                    bookingDetails.remove(i);
                    break;
                }
            }
            bookingDetailDao.updateAll(bookingDetails);
        }
    }
    @WebServlet("/customer/add-food-to-booking")
    public static class AddFoodServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            BookingDao bookingDao = new BookingDao();
            BookingDetailDao bookingDetailDao = new BookingDetailDao();
            FoodDao foodDao = new FoodDao();
            long bookingId = Long.parseLong(req.getParameter("bookingId"));
            Booking booking = bookingDao.getById(bookingId);
            if (booking == null) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy booking này.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            List<Long> foodIds = Optional.ofNullable(req.getParameterValues("foodIds"))
                    .stream().flatMap(Arrays::stream).map(Long::parseLong).toList();
            List<Integer> quantities = Optional.ofNullable(req.getParameterValues("quantities"))
                    .stream().flatMap(Arrays::stream).map(Integer::parseInt).toList();
            List<Long> filteredFoodIds = new ArrayList<>();
            List<Integer> filteredQuantities = new ArrayList<>();
            for (int i = 0; i < foodIds.size(); i++) {
                if (quantities.get(i) > 0) {
                    filteredFoodIds.add(foodIds.get(i));
                    filteredQuantities.add(quantities.get(i));
                }
            }
            if (filteredQuantities.size() != filteredFoodIds.size()) {
                req.getSession().setAttribute("flash_error", "Đã có lỗi xảy ra.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            List<Food> foods = foodDao.getAvailableByIds(filteredFoodIds);
            if (foodIds.size() != quantities.size()) {
                req.getSession().setAttribute("flash_error", "Dữ liệu không hợp lệ.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            List<BookingDetail> bookingDetails = booking.getBookingDetails();
            Map<Long, BookingDetail> existingDetailMap = new HashMap<>();
            for (BookingDetail detail : bookingDetails) {
                existingDetailMap.put(detail.getFood().getId(), detail);
            }

            for (int i = 0; i < foods.size(); i++) {
                Food food = foods.get(i);
                int quantity = filteredQuantities.get(i);

                if (existingDetailMap.containsKey(food.getId())) {
                    // Đã có món này → cộng thêm số lượng
                    BookingDetail existing = existingDetailMap.get(food.getId());
                    existing.setQuantity(existing.getQuantity() + quantity);
                    bookingDetailDao.update(existing);
                } else {
                    // Chưa có → tạo mới
                    BookingDetail newDetail = new BookingDetail(booking, food, food.getPrice(), quantity);
                    bookingDetailDao.save(newDetail);
                    bookingDetails.add(newDetail); // cập nhật lại list
                }
            }

            // Cập nhật trạng thái booking về PENDING nếu cần
            booking.setStatus(BookingStatus.PENDING);
            bookingDao.update(booking);

            req.getSession().setAttribute("flash_success", "Gọi thêm món thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
