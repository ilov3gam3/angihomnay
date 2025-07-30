package Controller;

import Dao.*;
import Model.*;
import Model.Constant.BookingStatus;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class BookingController {
    @WebServlet("/customer/book")
    public static class BookingServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/customer/booking.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            String raw = req.getParameter("startTime");
            LocalDateTime startTime = LocalDateTime.parse(raw, formatter);
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
                booking = new Booking(customer, restaurantTable, startTime, endTime, prePaidFee, note, 0L, BookingStatus.BOOKED);
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
                booking = new Booking(customer, restaurantTable, startTime, endTime, 0, note, 0, BookingStatus.BOOKED);
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

            booking.setStatus(BookingStatus.WAITING_FINAL_PAYMENT);
            bookingDao.update(booking);

            req.getSession().setAttribute("flash_success", "Gọi thêm món thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
    @WebServlet("/customer/bookings")
    public static class CustomerBookingServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            BookingDao bookingDao = new BookingDao();
            User user = (User) req.getSession().getAttribute("user");
            List<Booking> bookings = bookingDao.getByUserId(user.getId());
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/views/customer/your-bookings.jsp").forward(req, resp);
        }
    }

    @WebServlet("/restaurant/bookings")
    public static class RestaurantBookingServlet extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            RestaurantDao restaurantDao = new RestaurantDao();
            BookingDao bookingDao = new BookingDao();
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = restaurantDao.getById(user.getId());
            List<Booking> bookings = bookingDao.getBookingByResId(restaurant.getId());
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/views/restaurant/bookings.jsp").forward(req, resp);
        }
    }

    @WebServlet("/restaurant/cancel")
    public static class RestaurantCancel extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            BookingDao bookingDao = new BookingDao();
            Booking booking = bookingDao.getById(id);
            if (booking == null){
                req.getSession().setAttribute("flash_error", "Booking không tồn tại.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            booking.setStatus(BookingStatus.CANCELED);
            bookingDao.update(booking);
            resp.sendRedirect(req.getHeader("referer"));
        }
    }

    @WebServlet("/restaurant/no-show")
    public static class RestaurantNoShow extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            BookingDao bookingDao = new BookingDao();
            Booking booking = bookingDao.getById(id);
            if (booking == null){
                req.getSession().setAttribute("flash_error", "Booking không tồn tại.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            booking.setStatus(BookingStatus.NO_SHOW);
            bookingDao.update(booking);
            resp.sendRedirect(req.getHeader("referer"));
        }
    }

    @WebServlet("/api/revenue-statistics")
    public static class RevenueStatisticsServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            resp.setContentType("application/json");
            String role = req.getParameter("role");
            BookingDao bookingDao = new BookingDao(); // giả sử bạn đã có DAO này
            if ("restaurant".equals(role)) {
                int startWeek = Integer.parseInt(req.getParameter("startWeek"));
                int endWeek = Integer.parseInt(req.getParameter("endWeek"));
                long restaurantId = Long.parseLong(req.getParameter("restaurantId")); // từ session hoặc request

                List<Map<String, Object>> data = bookingDao.getWeeklyRevenue(restaurantId, startWeek, endWeek);
                resp.getWriter().write(new Gson().toJson(data));

            } else if ("admin".equals(role)) {
                int month = Integer.parseInt(req.getParameter("month"));
                int year = Integer.parseInt(req.getParameter("year"));

                List<Map<String, Object>> data = bookingDao.getMonthlyRevenueByRestaurant(month, year);
                resp.getWriter().write(new Gson().toJson(data));
            }
        }
    }
}
