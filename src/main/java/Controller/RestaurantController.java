package Controller;

import Dao.RestaurantDao;
import Dao.RestaurantTableDao;
import Model.Restaurant;
import Model.RestaurantTable;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class RestaurantController {
    @WebServlet("/restaurant/profile")
    public static class RestaurantProfileServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = new RestaurantDao().getById(user.getId());
            req.setAttribute("restaurant", restaurant);
            req.getRequestDispatcher("/views/restaurant/profile.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            RestaurantDao restaurantDao = new RestaurantDao();
            String mapEmbedUrl = req.getParameter("mapEmbedUrl");
            LocalTime openTime = LocalTime.parse(req.getParameter("openTime"));
            LocalTime closeTime = LocalTime.parse(req.getParameter("closeTime"));
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = restaurantDao.getById(user.getId());
            restaurant.setMapEmbedUrl(mapEmbedUrl);
            restaurant.setOpenTime(openTime);
            restaurant.setCloseTime(closeTime);
            restaurantDao.update(restaurant);
            req.getSession().setAttribute("flash_success", "Cập nhật nhà hàng thành công.");
            resp.sendRedirect(req.getContextPath() + "/restaurant/profile");
        }
    }

    @WebServlet("/restaurant/tables")
    public static class RestaurantTableServlet extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            RestaurantDao restaurantDao = new RestaurantDao();
            Restaurant restaurant = restaurantDao.getRestaurantWithTables(user.getId());
            req.getSession().setAttribute("tables", restaurant.getRestaurantTables());
            req.getRequestDispatcher("/views/restaurant/tables.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            RestaurantDao restaurantDao = new RestaurantDao();
            RestaurantTableDao restaurantTableDao = new RestaurantTableDao();
            Restaurant restaurant = restaurantDao.getById(user.getId());
            int from = Integer.parseInt(req.getParameter("from"));
            if (req.getParameter("to").isEmpty()){
                List<Integer> numbers = new ArrayList<>();
                numbers.add(from);
                if (restaurantTableDao.existsAnyNumberInList(numbers, restaurant)) {
                    req.getSession().setAttribute("flash_error", "Số bàn đã bị trùng.");
                    resp.sendRedirect(req.getContextPath() + "/restaurant/tables");
                    return;
                }
                RestaurantTable restaurantTable = new RestaurantTable(from, restaurant, true, false);
                restaurantTableDao.save(restaurantTable);
            } else {
               int to = Integer.parseInt(req.getParameter("to"));
                List<Integer> list = IntStream.rangeClosed(from, to)
                        .boxed()
                        .toList();
                if (restaurantTableDao.existsAnyNumberInList(list, restaurant)) {
                    req.getSession().setAttribute("flash_error", "Số bàn đã bị trùng.");
                    resp.sendRedirect(req.getContextPath() + "/restaurant/tables");
                    return;
                }
                List<RestaurantTable> tables = new ArrayList<>();
                for (int i = from; i <= to; i++) {
                    tables.add(new RestaurantTable(i, restaurant, true, false));
                }
                restaurantTableDao.saveAll(tables);
            }
            req.getSession().setAttribute("flash_success", "Thêm mới thành công.");
            resp.sendRedirect(req.getContextPath() + "/restaurant/tables");
        }
    }
    @WebServlet("/restaurant/edit-table")
    public static class RestaurantEditTable extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            RestaurantDao restaurantDao = new RestaurantDao();
            RestaurantTableDao restaurantTableDao = new RestaurantTableDao();
            Restaurant restaurant = restaurantDao.getRestaurantWithTables(user.getId());
            long id = Long.parseLong(req.getParameter("id"));
            RestaurantTable restaurantTable = restaurantTableDao.getTableWithRestaurant(restaurant, id);
            if (restaurantTable == null){
                req.getSession().setAttribute("flash_error", "Không tìm thấy bàn này.");
                return;
            }
            int number = Integer.parseInt(req.getParameter("number"));
            List<Integer> numbers = new ArrayList<>();
            numbers.add(number);
            if (number != restaurantTable.getNumber() && restaurantTableDao.existsAnyNumberInList(numbers, restaurant)) {
                req.getSession().setAttribute("flash_error", "Số bàn đã bị trùng.");
                resp.sendRedirect(req.getContextPath() + "/restaurant/tables");
                return;
            }
            boolean isHavingCustomer = Boolean.parseBoolean(req.getParameter("havingCustomer"));
            boolean isAvailable = Boolean.parseBoolean(req.getParameter("available"));
            restaurantTable.setNumber(number);
            restaurantTable.setHavingCustomer(isHavingCustomer);
            restaurantTable.setAvailable(isAvailable);
            restaurantTableDao.update(restaurantTable);
            req.getSession().setAttribute("flash_success", "Cập nhật thành công.");
            resp.sendRedirect(req.getContextPath() + "/restaurant/tables");
        }
    }
    @WebServlet("/restaurant/change-having-customer")
    public static class RestaurantChangeHavingCustomer extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            RestaurantDao restaurantDao = new RestaurantDao();
            RestaurantTableDao restaurantTableDao = new RestaurantTableDao();
            Restaurant restaurant = restaurantDao.getById(user.getId());
            long id = Long.parseLong(req.getParameter("id"));
            RestaurantTable restaurantTable = restaurantTableDao.getTableWithRestaurant(restaurant, id);
            if (restaurantTable == null){
                req.getSession().setAttribute("flash_error", "Không tìm thấy bàn này.");
                return;
            }
            restaurantTable.setHavingCustomer(!restaurantTable.isHavingCustomer());
            restaurantTableDao.update(restaurantTable);
            req.getSession().setAttribute("flash_success", "Cập nhật thành công.");
            resp.sendRedirect(req.getContextPath() + "/restaurant/tables");
        }
    }
}
