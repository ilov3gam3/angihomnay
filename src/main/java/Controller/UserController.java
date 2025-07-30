package Controller;

import Dao.CustomerDao;
import Dao.RememberMeTokenDao;
import Dao.RestaurantDao;
import Dao.UserDao;
import Model.Constant.Gender;
import Model.Constant.Role;
import Model.Customer;
import Model.RememberMeToken;
import Model.Restaurant;
import Model.User;
import Util.Config;
import Util.Mail;
import Util.UploadImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Arrays;
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

            if ("on".equals(req.getParameter("remember"))) {
                String token = java.util.UUID.randomUUID().toString();
                LocalDateTime expiry = LocalDateTime.now().plusDays(30);

                RememberMeTokenDao tokenDao = new RememberMeTokenDao();
                tokenDao.save(new RememberMeToken(token, expiry, user));

                Cookie cookie = new Cookie("remember_token", token);
                cookie.setHttpOnly(true);
                cookie.setMaxAge(30 * 24 * 60 * 60);
                cookie.setPath(req.getContextPath());
                resp.addCookie(cookie);
            }
            if (user.getRole() == Role.RESTAURANT) {
                resp.sendRedirect(req.getContextPath() + "/views/restaurant/revenue.jsp");
                return;
            }
            if (user.getRole() == Role.ADMIN) {
                resp.sendRedirect(req.getContextPath() + "/views/admin/revenue.jsp");
                return;
            }
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
            String address = req.getParameter("address");
            User user = new User(email, BCrypt.hashpw(password, BCrypt.gensalt()), "/assets/img/default-avatar.jpg", phone, address, token, false, false, Role.CUSTOMER);
            userDao.save(user);
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            LocalDate dob = LocalDate.parse(req.getParameter("dob"));
            Gender gender = Gender.valueOf(req.getParameter("gender"));
            Customer customer = new Customer(user, firstName, lastName, dob, gender);
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
                req.getSession().setAttribute("flash_success", "Xác thực tài khoản thành công.");
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
            User user = (User) req.getSession().getAttribute("user");
            new RememberMeTokenDao().deleteByUser(user);
            Cookie cookie = new Cookie("remember_token", "");
            cookie.setMaxAge(0);
            cookie.setPath(req.getContextPath());
            resp.addCookie(cookie);
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
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
                String re_password = req.getParameter("confirmPassword");
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
            List<Customer> customers = new CustomerDao().getAllWithUsers();
            List<Restaurant> restaurants = new RestaurantDao().getAllWithUsers();
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
            String address = req.getParameter("address");
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
            User user = new User(email, BCrypt.hashpw(password, BCrypt.gensalt()), "/assets/img/default-avatar.jpg", phone, address, null, true, false, role);
            userDao.save(user);
            if (role == Role.CUSTOMER){
                CustomerDao customerDao = new CustomerDao();
                String firstName = req.getParameter("firstName");
                String lastName = req.getParameter("lastName");
                LocalDate dob = LocalDate.parse(req.getParameter("dob"));
                Gender gender = Gender.valueOf(req.getParameter("gender"));
                Customer customer = new Customer(user, firstName, lastName, dob, gender);
                customerDao.save(customer);
            }
            if (role == Role.RESTAURANT){
                RestaurantDao restaurantDao = new RestaurantDao();
                String name = req.getParameter("name");
                String mapEmbedUrl = req.getParameter("mapEmbedUrl");
                LocalTime openTime = LocalTime.parse(req.getParameter("openTime"));
                LocalTime closeTime = LocalTime.parse(req.getParameter("closeTime"));
                Restaurant restaurant = new Restaurant();
                restaurant.setUser(user);
                restaurant.setName(name);
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
            if (userDao.findByEmailExcept(email, user.getId())!=null) {
                req.getSession().setAttribute("flash_error", "Email đã được sử dụng bởi tài khoản khác.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            if (userDao.findByPhoneExcept(phone, user.getId())!=null) {
                req.getSession().setAttribute("flash_error", "Số điện thoại đã được sử dụng bởi tài khoản khác.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            boolean isBlocked = Boolean.parseBoolean(req.getParameter("blocked"));
            String address = req.getParameter("address");
            user.setEmail(email);
            user.setPhone(phone);
            user.setBlocked(isBlocked);
            user.setAddress(address);
            userDao.update(user);
            if (user.getRole() == Role.CUSTOMER){
                CustomerDao customerDao = new CustomerDao();
                String firstName = req.getParameter("firstName");
                String lastName = req.getParameter("lastName");
                LocalDate dob = LocalDate.parse(req.getParameter("dob"));
                Gender gender = Gender.valueOf(req.getParameter("gender"));
                Customer customer = customerDao.getById(user.getId());
                customer.setFirstName(firstName);
                customer.setLastName(lastName);
                customer.setDateOfBirth(dob);
                customer.setGender(gender);
                customerDao.update(customer);
            }
            if (user.getRole() == Role.RESTAURANT){
                RestaurantDao restaurantDao = new RestaurantDao();
                String name = req.getParameter("name");
                String mapEmbedUrl = req.getParameter("mapEmbedUrl");
                LocalTime openTime = LocalTime.parse(req.getParameter("openTime"));
                LocalTime closeTime = LocalTime.parse(req.getParameter("closeTime"));
                Restaurant restaurant = restaurantDao.getById(user.getId());
                restaurant.setUser(user);
                restaurant.setName(name);
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
    @WebServlet("/google/oauth")
    public static class GoogleOauthServlet extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            GoogleAuthorizationCodeFlow googleAuthorizationCodeFlow = new GoogleAuthorizationCodeFlow.Builder(
                    new NetHttpTransport(),
                    new JacksonFactory(),
                    Config.google_oauth_client_id,
                    Config.google_oauth_client_secret,
                    Arrays.asList("openid", "profile", "email")
            ).build();
            String loginUrl = googleAuthorizationCodeFlow.newAuthorizationUrl()
                    .setRedirectUri(new Config().google_oauth_redirect_uri)
                    .build();
            resp.sendRedirect(loginUrl);
        }
    }
    @WebServlet("/login-google")
    public static class LoginGoogle extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String authorizationCode = req.getParameter("code");
            UserDao userDao = new UserDao();
            GoogleTokenResponse googleTokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    new JacksonFactory(),
                    "https://oauth2.googleapis.com/token",
                    Config.google_oauth_client_id,
                    Config.google_oauth_client_secret,
                    authorizationCode,
                    new Config().google_oauth_redirect_uri
            ).execute();
            GoogleIdToken googleIdToken = googleTokenResponse.parseIdToken();
            GoogleIdToken.Payload payload = googleIdToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            String avatar = (String) payload.get("picture");
            User user = userDao.findByEmail(email);
            if (user == null) {
                user = new User();
                user.setEmail(email);
                user.setAvatar(avatar);
                req.getSession().setAttribute("tempUser", user);
                resp.sendRedirect(req.getContextPath() + "/add-more-info");
            } else {
                req.getSession().setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/");
            }
        }
    }
    @WebServlet("/add-more-info")
    public static class AddMoreInfoServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/add-more-info.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            UserDao userDao = new UserDao();
            User tempUser = (User) req.getSession().getAttribute("tempUser");
            if (tempUser == null) {
                req.getSession().setAttribute("flash_error", "Đã có lỗi xảy ra.");
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String phone = req.getParameter("phone");
            String address = req.getParameter("address");
            tempUser.setPhone(phone);
            tempUser.setAddress(address);
            CustomerDao customerDao = new CustomerDao();
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            Gender gender = Gender.valueOf(req.getParameter("gender"));
            LocalDate dateOfBirth = LocalDate.parse(req.getParameter("dateOfBirth"));
            Customer customer = new Customer(tempUser, firstName, lastName, dateOfBirth, gender);
            if (userDao.findByPhone(phone) != null) {
                req.getSession().setAttribute("tempUser", tempUser);
                req.getSession().setAttribute("tempCustomer", customer);
                req.getSession().setAttribute("flash_error", "Số điện thoại đã được sử dụng");
                resp.sendRedirect(req.getContextPath() + "/add-more-info");
                return;
            }
            if (!confirmPassword.equals(password)) {
                req.getSession().setAttribute("tempUser", tempUser);
                req.getSession().setAttribute("tempCustomer", customer);
                req.getSession().setAttribute("flash_error", "Mật khẩu không trùng khớp");
                resp.sendRedirect(req.getContextPath() + "/add-more-info");
                return;
            }
            tempUser.setVerified(true);
            tempUser.setBlocked(false);
            tempUser.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            tempUser.setRole(Role.CUSTOMER);
            userDao.save(tempUser);
            customerDao.save(customer);
            req.getSession().setAttribute("user", tempUser);
            req.getSession().setAttribute("flash_success", "Đăng nhập thành công.");
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
    @WebServlet("/user/profile")
    public static class UserProfile extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String address = req.getParameter("address");
            User user = (User) req.getSession().getAttribute("user");
            UserDao userDao = new UserDao();
            if (userDao.findByEmailExcept(email, user.getId()) != null) {
                req.getSession().setAttribute("flash_error", "Email đã được sử dụng.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            if (userDao.findByPhoneExcept(phone, user.getId()) != null) {
                req.getSession().setAttribute("flash_error", "Số điện thoại đã được sử dụng.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            user.setPhone(phone);
            user.setAddress(address);
            user.setEmail(email);
            userDao.update(user);
            req.getSession().setAttribute("user", user);
            req.getSession().setAttribute("flash_success", "Cập nhật thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
