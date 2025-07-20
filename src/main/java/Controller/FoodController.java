package Controller;

import Dao.CategoryDao;
import Dao.FoodDao;
import Dao.RestaurantDao;
import Model.Category;
import Model.Food;
import Model.Restaurant;
import Model.User;
import Util.UploadImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class FoodController {
    @WebServlet("/restaurant/foods")
    @MultipartConfig
    public static class RestaurantFoodServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            CategoryDao categoryDao = new CategoryDao();
            FoodDao foodDao = new FoodDao();
            List<Category> categories = categoryDao.getAll().reversed();
            RestaurantDao restaurantDao = new RestaurantDao();
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = restaurantDao.getById(user.getId());
            List<Food> foods = foodDao.getFoodsOfRestaurant(restaurant).reversed();
            req.setAttribute("foods", foods);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/views/restaurant/food.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            RestaurantDao restaurantDao = new RestaurantDao();
            FoodDao foodDao = new FoodDao();
            CategoryDao categoryDao = new CategoryDao();
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            String image = UploadImage.saveImage(req, "image");
            List<Long> categoryIds = Optional.ofNullable(req.getParameterValues("categoryIds")).stream().flatMap(Arrays::stream)
                    .map(Long::parseLong)
                    .toList();
            List<Category> categories = categoryDao.getByIds(categoryIds);
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = restaurantDao.getById(user.getId());
            Food food = new Food(name, description, price, image, categories, restaurant, true);
            foodDao.save(food);
            req.getSession().setAttribute("flash_success", "Thêm món ăn thành công.");
            resp.sendRedirect(req.getContextPath() + "/restaurant/foods");
        }
    }
    @WebServlet("/restaurant/edit-food")
    @MultipartConfig
    public static class RestaurantEditFood extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            RestaurantDao restaurantDao = new RestaurantDao();
            FoodDao foodDao = new FoodDao();
            CategoryDao categoryDao = new CategoryDao();
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = restaurantDao.getById(user.getId());
            long id = Long.parseLong(req.getParameter("id"));
            Food food = foodDao.getFoodOfRestaurant(restaurant, id);
            if (food == null) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy món ăn này.");
                resp.sendRedirect(req.getContextPath() + "/restaurant/foods");
                return;
            }
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            List<Long> categoryIds = Optional.ofNullable(req.getParameterValues("categoryIds")).stream().flatMap(Arrays::stream)
                    .map(Long::parseLong)
                    .toList();
            List<Category> categories = categoryDao.getByIds(categoryIds);
            boolean isAvailable = Boolean.parseBoolean(req.getParameter("available"));
            if (req.getPart("image") != null && req.getPart("image").getSize() > 0) {
                food.setImage(UploadImage.saveImage(req, "image"));
            }
            food.setName(name);
            food.setDescription(description);
            food.setPrice(price);
            food.setCategories(categories);
            food.setAvailable(isAvailable);
            foodDao.update(food);
            req.getSession().setAttribute("flash_success", "Cập nhật thành công.");
            resp.sendRedirect(req.getContextPath() + "/restaurant/foods");
        }
    }
}
