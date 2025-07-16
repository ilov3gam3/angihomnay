package Controller;

import Dao.RestaurantDao;
import Model.Restaurant;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalTime;

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
            String address = req.getParameter("address");
            String mapEmbedUrl = req.getParameter("mapEmbedUrl");
            LocalTime openTime = LocalTime.parse(req.getParameter("openTime"));
            LocalTime closeTime = LocalTime.parse(req.getParameter("closeTime"));
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = restaurantDao.getById(user.getId());
            restaurant.setAddress(address);
            restaurant.setMapEmbedUrl(mapEmbedUrl);
            restaurant.setOpenTime(openTime);
            restaurant.setCloseTime(closeTime);
            restaurantDao.update(restaurant);
            req.getSession().setAttribute("flash_success", "Cập nhật nhà hàng thành công.");
            resp.sendRedirect(req.getContextPath() + "/restaurant/profile");
        }
    }
}
