package Controller;

import Dao.CategoryDao;
import Dao.FoodDao;
import Dao.RestaurantDao;
import Dao.TasteDao;
import Dao.AllergyTypeDao;
import Model.Taste;
import Model.AllergyType;

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
            TasteDao tasteDao = new TasteDao();
            AllergyTypeDao allergyDao = new AllergyTypeDao();

            List<Category> categories = categoryDao.getAll();
            RestaurantDao restaurantDao = new RestaurantDao();
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = restaurantDao.getById(user.getId());
            List<Food> foods = foodDao.getFoodsOfRestaurant(restaurant).reversed();
            List<Taste> tastes = tasteDao.getAll();
            List<AllergyType> allergies = allergyDao.getAll();

            req.setAttribute("tastes", tastes);
            req.setAttribute("allergies", allergies);
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
            List<Long> tasteIds = Optional.ofNullable(req.getParameterValues("tasteIds"))
                    .stream().flatMap(Arrays::stream).map(Long::parseLong).toList();
            List<Taste> tastes = new TasteDao().getByIds(tasteIds);

            List<Long> allergyIds = Optional.ofNullable(req.getParameterValues("allergyIds"))
                    .stream().flatMap(Arrays::stream).map(Long::parseLong).toList();
            List<AllergyType> allergies = new AllergyTypeDao().getByIds(allergyIds);
            User user = (User) req.getSession().getAttribute("user");
            Restaurant restaurant = restaurantDao.getById(user.getId());
            Food food = new Food(name, description, price, image, categories, restaurant, true);
            food.setTastes(tastes);
            food.setAllergyContents(allergies);
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

            List<Long> tasteIds = Optional.ofNullable(req.getParameterValues("tasteIds"))
                    .stream().flatMap(Arrays::stream).map(Long::parseLong).toList();
            List<Taste> tastes = new TasteDao().getByIds(tasteIds);

            List<Long> allergyIds = Optional.ofNullable(req.getParameterValues("allergyIds"))
                    .stream().flatMap(Arrays::stream).map(Long::parseLong).toList();
            List<AllergyType> allergies = new AllergyTypeDao().getByIds(allergyIds);

            food.setName(name);
            food.setDescription(description);
            food.setPrice(price);
            food.setCategories(categories);
            food.setAvailable(isAvailable);
            food.setTastes(tastes);
            food.setAllergyContents(allergies);
            foodDao.update(food);
            req.getSession().setAttribute("flash_success", "Cập nhật thành công.");
            resp.sendRedirect(req.getContextPath() + "/restaurant/foods");
        }
    }

    @WebServlet("/search")
    public static class SearchFoodServlet extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

            boolean hasParams = req.getParameterMap().keySet().stream()
                    .anyMatch(key -> req.getParameter(key) != null && !req.getParameter(key).trim().isEmpty());

            if (!hasParams) {
                req.getRequestDispatcher("/views/public/search.jsp").forward(req, resp);
                return;
            }
            FoodDao foodDao = new FoodDao();
            String searchString = req.getParameter("searchString");
            String[] categoryIds = req.getParameterValues("categories");
            String[] allergyIds = req.getParameterValues("allergyContents");
            String[] tasteIds = req.getParameterValues("tastes");

            Double priceFrom = parseDouble(req.getParameter("priceFrom"));
            Double priceTo = parseDouble(req.getParameter("priceTo"));

            List<Food> result = foodDao.searchFoods(searchString, priceFrom, priceTo, categoryIds, allergyIds, tasteIds);
            for (int i = 0; i < result.size(); i++) {
                System.out.println(result.get(i).getId());
                System.out.println(result.get(i).getCategories());
                System.out.println(result.get(i).getAllergyContents());
                System.out.println(result.get(i).getTastes());
            }
            req.setAttribute("foodList", result);
            req.getRequestDispatcher("/views/public/search.jsp").forward(req, resp);
        }
        private Double parseDouble(String s) {
            try {
                return (s != null && !s.trim().isEmpty()) ? Double.parseDouble(s) : null;
            } catch (NumberFormatException e) {
                return null;
            }
        }
    }
}
