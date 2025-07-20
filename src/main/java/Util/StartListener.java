package Util;

import Dao.CategoryDao;
import Dao.CustomerDao;
import Dao.RestaurantDao;
import Dao.UserDao;
import Model.Category;
import Model.Constant.Gender;
import Model.Constant.Role;
import Model.Customer;
import Model.Restaurant;
import Model.User;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebListener
public class StartListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        Config.contextPath = sce.getServletContext().getContextPath();
        UserDao userDao = new UserDao();
        CustomerDao customerDao = new CustomerDao();
        RestaurantDao restaurantDao = new RestaurantDao();
        CategoryDao categoryDao = new CategoryDao();
        if (userDao.getAll().isEmpty()) {
            User admin1 = new User("admin1@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456789", "da nang viet nam", null, true, false, Role.ADMIN);
            User admin2 = new User("admin2@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456788", "da nang viet nam", null, true, false, Role.ADMIN);
            User user1 = new User("user1@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456787", "da nang viet nam", null, true, false, Role.CUSTOMER);
            User user2 = new User("user2@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456786", "da nang viet nam", null, true, false, Role.CUSTOMER);
            User user3 = new User("user3@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456785", "da nang viet nam", null, true, false, Role.CUSTOMER);
            User res1 = new User("res1@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456784", "da nang viet nam", null, true, false, Role.RESTAURANT);
            User res2 = new User("res2@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456783", "da nang viet nam", null, true, false, Role.RESTAURANT);
            userDao.saveAll(List.of(admin1, admin2, user1, user2, user3, res1, res2));
            Customer customer1 = new Customer(user1, "Trần", "A", LocalDate.parse("2002-05-08"), Gender.MALE);
            Customer customer2 = new Customer(user2, "Trần", "B", LocalDate.parse("2002-05-08"), Gender.MALE);
            Customer customer3 = new Customer(user3, "Trần", "C", LocalDate.parse("2002-05-08"), Gender.MALE);
            customerDao.saveAll(List.of(customer1, customer2, customer3));
            Restaurant restaurant1 = new Restaurant(res1, "Nhà Hàng Phì Lũ 1", "<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1886.4207963330186!2d108.22034493993043!3d16.0666563692974!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142183377c1ecc3%3A0xd739b07453f05636!2zTmjDoCBIw6BuZyBQaMOsIEzFqSAx!5e0!3m2!1svi!2s!4v1752848871669!5m2!1svi!2s\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>", LocalTime.parse("07:00"), LocalTime.parse("22:00"));
            Restaurant restaurant2 = new Restaurant(res2, "Nhà hàng Madame Lân", "<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3833.6931319995606!2d108.21838725135308!3d16.08140624501313!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31421831ce4d457b%3A0xc2f54574a65b6322!2zTmjDoCBow6BuZyBNYWRhbWUgTMOibg!5e0!3m2!1svi!2s!4v1752848977599!5m2!1svi!2s\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>", LocalTime.parse("09:00"), LocalTime.parse("23:00"));
            restaurantDao.saveAll(List.of(restaurant1, restaurant2));
        }
        if (categoryDao.getAll().isEmpty()){
            Category category1 = new Category("Chay");
            Category category2 = new Category("Mặn");
            Category category3 = new Category("Trung Quốc");
            Category category4 = new Category("Việt Nam");
            Category category5 = new Category("Hàn Quốc");
            Category category6 = new Category("Nhật Bản");
            Category category7 = new Category("Châu Á");
            Category category8 = new Category("Châu Âu");
            categoryDao.saveAll(List.of(category1, category2, category3, category4, category5, category6, category7, category8));
        }
    }
}
