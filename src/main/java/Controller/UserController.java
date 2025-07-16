package Controller;

import Dao.CustomerDao;
import Dao.RestaurantDao;
import Dao.UserDao;
import Model.Constant.Gender;
import Model.Constant.Role;
import Model.Customer;
import Model.Restaurant;
import Model.User;
import Util.Config;
import Util.Mail;
import Util.UploadImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class UserController {
    @WebServlet("/login")
    public static class LoginServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            User user = new UserDao().findByEmail(email);
            if (user == null) {
                req.getSession().setAttribute("flash_error", "Tài khoản hoặc mật khẩu không đúng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (!BCrypt.checkpw(password, user.getPassword())) {
                req.getSession().setAttribute("flash_error", "Tài khoản hoặc mật khẩu không đúng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (!user.isVerified()){
                req.getSession().setAttribute("flash_error", "Tài khoản chưa được kích hoạt.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (user.isBlocked()){
                req.getSession().setAttribute("flash_error", "Tài khoản đã bị khóa.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            req.getSession().setAttribute("user", user);
            req.getSession().setAttribute("flash_success", "Đăng nhập thành công.");
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
    @WebServlet("/register")
    public static class RegisterServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            UserDao userDao = new UserDao();
            CustomerDao customerDao = new CustomerDao();
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            if (!password.equals(confirmPassword)) {
                req.getSession().setAttribute("flash_error", "Mật khẩu không trùng khớp.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            String email = req.getParameter("email");
            if (userDao.findByEmail(email)!=null) {
                req.getSession().setAttribute("flash_error", "Email đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            String phone = req.getParameter("phone");
            if (userDao.findByPhone(phone)!=null) {
                req.getSession().setAttribute("flash_error", "Số điện thoại đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            String token = UUID.randomUUID().toString();
            // send mail
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            executorService.submit(() -> {
                try {
                    String url = Config.app_url + req.getContextPath() + "/verify-email?token=" + token;
                    String html = "Chúc mừng bạn đã đăng kí thành công, vui lòng nhấn vào <a href='url'>đây</a> để xác thực email của bạn.".replace("url", url);
                    Mail.send(email, "Đăng kí tài khoản", html);
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            });
            executorService.shutdown();
            // end send mail
            User user = new User(email, BCrypt.hashpw(password, BCrypt.gensalt()), "/assets/img/default-avatar.jpg", phone, token, false, false, Role.CUSTOMER);
            userDao.save(user);
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            Date dob = Date.valueOf(req.getParameter("dob"));
            Gender gender = Gender.valueOf(req.getParameter("gender"));
            String address = req.getParameter("address");
            Customer customer = new Customer(user, firstName, lastName, dob, gender, address);
            customerDao.save(customer);
            req.getSession().setAttribute("flash_success", "Đăng kí thành công, vui lòng kiểm tra email.");
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
    @WebServlet("/verify-email")
    public static class VerifyServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String token = req.getParameter("token");
            User user = new UserDao().findByToken(token);
            if (user != null) {
                user.setToken(null);
                user.setVerified(true);
                new UserDao().update(user);
                req.getSession().setAttribute("flash_success", "Đăng kí thành công, vui lòng kiểm tra email.");
            } else {
                req.getSession().setAttribute("flash_error", "Token không tồn tại hoặc không hợp lệ");
            }
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
    @WebServlet("/logout")
    public static class LogoutServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
    @WebServlet("/forgot-password")
    public static class ForgotPassword extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            User user = new UserDao().findByEmail(email);
            if (user != null) {
                String uuid = UUID.randomUUID().toString();
                user.setToken(uuid);
                new UserDao().update(user);
                // send mail
                ExecutorService executorService = Executors.newSingleThreadExecutor();
                executorService.submit(() -> {
                    try {
                        String url = Config.app_url + req.getContextPath() + "/reset-password?token=" + uuid;
                        String html = "Vui lòng nhấn vào <a href='url'>đây</a> để lấy lại mật khẩu của bạn.".replace("url", url);
                        Mail.send(email, "Lấy lại mật khẩu", html);
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                });
                executorService.shutdown();
                // end send mail
            }
            req.getSession().setAttribute("flash_success", "Vui lòng kiểm tra email");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
    @WebServlet("/reset-password")
    public static class ResetPassword extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String token = req.getParameter("token");
            User user = new UserDao().findByToken(token);
            if (user != null) {
                String password = req.getParameter("password");
                String re_password = req.getParameter("re_password");
                if (password.equals(re_password) && !password.isEmpty()) {
                    user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
                    new UserDao().update(user);
                    req.getSession().setAttribute("flash_success", "Đặt lại mật khẩu thành công.");
                    resp.sendRedirect(req.getContextPath() + "/login");
                } else {
                    req.getSession().setAttribute("flash_error", "Mật khẩu không khớp.");
                    resp.sendRedirect(req.getHeader("referer"));
                }
            } else {
                req.getSession().setAttribute("flash_error", "Token không tồn tại.");
                resp.sendRedirect(req.getHeader("referer"));
            }
        }
    }
    @WebServlet("/admin/user")
    public static class AdminUserServlet extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            UserDao userDao = new UserDao();
            List<User> users = userDao.getAll();
            List<Customer> customers = new CustomerDao().getAll();
            List<Restaurant> restaurants = new RestaurantDao().getAll();
            req.setAttribute("users", users);
            req.setAttribute("customers", customers);
            req.setAttribute("restaurants", restaurants);
            req.getRequestDispatcher("/views/admin/user.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            UserDao userDao = new UserDao();
            String password = req.getParameter("password");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            Role role = Role.valueOf(req.getParameter("role"));
            if (userDao.findByEmail(email)!=null) {
                req.getSession().setAttribute("flash_error", "Email đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            if (userDao.findByPhone(phone)!=null) {
                req.getSession().setAttribute("flash_error", "Số điện thoại đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            User user = new User(email, BCrypt.hashpw(password, BCrypt.gensalt()), "/assets/img/default-avatar.jpg", phone, null, true, false, role);
            userDao.save(user);
            if (role == Role.CUSTOMER){
                CustomerDao customerDao = new CustomerDao();
                String firstName = req.getParameter("firstName");
                String lastName = req.getParameter("lastName");
                Date dob = Date.valueOf(req.getParameter("dob"));
                Gender gender = Gender.valueOf(req.getParameter("gender"));
                String address = req.getParameter("address");
                Customer customer = new Customer(user, firstName, lastName, dob, gender, address);
                customerDao.save(customer);
            }
            if (role == Role.RESTAURANT){
                RestaurantDao restaurantDao = new RestaurantDao();
                String address = req.getParameter("address");
                String mapEmbedUrl = req.getParameter("mapEmbedUrl");
                LocalTime openTime = LocalTime.parse(req.getParameter("openTime"));
                LocalTime closeTime = LocalTime.parse(req.getParameter("closeTime"));
                Restaurant restaurant = new Restaurant();
                restaurant.setUser(user);
                restaurant.setAddress(address);
                restaurant.setMapEmbedUrl(mapEmbedUrl);
                restaurant.setOpenTime(openTime);
                restaurant.setCloseTime(closeTime);
                restaurantDao.save(restaurant);
            }
            req.getSession().setAttribute("flash_success", "Thêm người dùng thành công.");
            resp.sendRedirect(req.getContextPath() + "/admin/user");
        }
    }
    @WebServlet("/admin/update-user")
    public static class AdminUpdateUserServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            UserDao userDao = new UserDao();
            User user = userDao.getById(id);
            if (user == null) {
                req.getSession().setAttribute("flash_error", "Người dùng này không tồn tại.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            if (userDao.findByEmail(email)!=null) {
                req.getSession().setAttribute("flash_error", "Email đã được sử dụng bởi tài khoản khác.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            if (userDao.findByPhone(phone)!=null) {
                req.getSession().setAttribute("flash_error", "Số điện thoại đã được sử dụng bởi tài khoản khác.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            boolean isVerified = Boolean.parseBoolean(req.getParameter("isVerified"));
            boolean isBlocked = Boolean.parseBoolean(req.getParameter("isBlocked"));
            user.setEmail(email);
            user.setPhone(phone);
            user.setVerified(isVerified);
            user.setBlocked(isBlocked);
            userDao.update(user);
            if (user.getRole() == Role.CUSTOMER){
                CustomerDao customerDao = new CustomerDao();
                String firstName = req.getParameter("firstName");
                String lastName = req.getParameter("lastName");
                Date dob = Date.valueOf(req.getParameter("dob"));
                Gender gender = Gender.valueOf(req.getParameter("gender"));
                String address = req.getParameter("address");
                Customer customer = customerDao.getById(user.getId());
                customer.setFirstName(firstName);
                customer.setLastName(lastName);
                customer.setDateOfBirth(dob);
                customer.setGender(gender);
                customer.setAddress(address);
                customerDao.update(customer);
            }
            if (user.getRole() == Role.RESTAURANT){
                RestaurantDao restaurantDao = new RestaurantDao();
                String address = req.getParameter("address");
                String mapEmbedUrl = req.getParameter("mapEmbedUrl");
                LocalTime openTime = LocalTime.parse(req.getParameter("openTime"));
                LocalTime closeTime = LocalTime.parse(req.getParameter("closeTime"));
                Restaurant restaurant = restaurantDao.getById(user.getId());
                restaurant.setUser(user);
                restaurant.setAddress(address);
                restaurant.setMapEmbedUrl(mapEmbedUrl);
                restaurant.setOpenTime(openTime);
                restaurant.setCloseTime(closeTime);
            }
            req.getSession().setAttribute("flash_success", "Cập nhật người dùng thành công.");
            resp.sendRedirect(req.getContextPath() + "/admin/user");
        }
    }
    @WebServlet("/change-password")
    public static class ChangePasswordServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String oldPassword = req.getParameter("oldPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            UserDao userDao = new UserDao();
            User user = (User) req.getSession().getAttribute("user");
            if (!BCrypt.checkpw(oldPassword, user.getPassword())) {
                req.getSession().setAttribute("flash_error", "Mật khẩu cũ không đúng.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                req.getSession().setAttribute("flash_error", "Mật khẩu không trùng khớp.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            userDao.update(user);
            req.getSession().setAttribute("flash_success", "Đã cập nhật mật khẩu.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
    @WebServlet("/update-avatar")
    @MultipartConfig
    public static class UpdateAvatarServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            try {
                String filename = UploadImage.saveImage(req, "avatar");
                User user = (User) req.getSession().getAttribute("user");
                user.setAvatar(filename);
                new UserDao().update(user);
                req.getSession().setAttribute("user", user);
            } catch (ServletException e){
                e.printStackTrace();
                req.getSession().setAttribute("warning", "File tải lên phải là 1 ảnh");
            }
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
