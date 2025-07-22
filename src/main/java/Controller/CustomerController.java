package Controller;

import Dao.CustomerDao;
import Dao.TasteDao;
import Dao.UserDao;
import Model.Constant.Gender;
import Model.Customer;
import Model.Taste;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class CustomerController {
    @WebServlet("/customer/profile")
    public static class ProfileServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            Customer customer = new CustomerDao().getById(user.getId());
            req.setAttribute("customer", customer);
            req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            CustomerDao customerDao = new CustomerDao();
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            LocalDate dateOfBirth = LocalDate.parse(req.getParameter("dateOfBirth"));
            Gender gender = Gender.valueOf(req.getParameter("gender"));
            User user = (User) req.getSession().getAttribute("user");
            Customer customer = customerDao.getById(user.getId());
            customer.setFirstName(firstName);
            customer.setLastName(lastName);
            customer.setDateOfBirth(dateOfBirth);
            customer.setGender(gender);
            customerDao.update(customer);
            req.getSession().setAttribute("flash_success", "Cập nhật người dùng thành công.");
            resp.sendRedirect(req.getContextPath() + "/customer/profile");
        }
    }

    @WebServlet("/customer/tastes")
    public static class TastesServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            TasteDao tasteDao = new TasteDao();
            UserDao userDao = new UserDao();
            User user = (User) req.getSession().getAttribute("user");
            user = userDao.getById(user.getId());
            List<Long> tastesIds = Optional.ofNullable(req.getParameterValues("tastesIds")).stream().flatMap(Arrays::stream)
                    .map(Long::parseLong)
                    .toList();
            List<Taste> tastes = tasteDao.getByIds(tastesIds);
            user.setFavoriteTastes(tastes);
            userDao.update(user);
            req.getSession().setAttribute("user", user);
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
