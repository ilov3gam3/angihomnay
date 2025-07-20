package Controller;

import Dao.CategoryDao;
import Model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class CategoryController {
    @WebServlet("/admin/categories")
    public static class CategoryServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            CategoryDao categoryDao = new CategoryDao();
            List<Category> categories = categoryDao.getAllWithFoods();
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/views/admin/category.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String name = req.getParameter("name");
            CategoryDao categoryDao = new CategoryDao();
            Category category = new Category();
            category.setName(name);
            categoryDao.save(category);
            req.getSession().setAttribute("flash_success", "Thêm loại món ăn thành công.");
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }
    @WebServlet("/admin/update-category")
    public static class UpdateCategoryServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            String name = req.getParameter("name");
            CategoryDao categoryDao = new CategoryDao();
            Category category = categoryDao.getById(id);
            category.setName(name);
            categoryDao.update(category);
            req.getSession().setAttribute("flash_success", "Cập nhật loại món ăn thành công.");
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }
}
