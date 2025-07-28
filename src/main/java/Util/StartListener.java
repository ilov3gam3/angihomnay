package Util;

import Dao.*;
import Model.*;
import Model.Constant.Gender;
import Model.Constant.Role;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

@WebListener
public class StartListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        Config.contextPath = sce.getServletContext().getContextPath();
        UserDao userDao = new UserDao();
        CustomerDao customerDao = new CustomerDao();
        RestaurantDao restaurantDao = new RestaurantDao();
        CategoryDao categoryDao = new CategoryDao();
        AllergyTypeDao allergyTypeDao = new AllergyTypeDao();
        TasteDao tasteDao = new TasteDao();
        FoodDao foodDao = new FoodDao();
        List<AllergyType> allergyTypes;
        if (allergyTypeDao.getAll().isEmpty()){
            AllergyType allergyType1 = new AllergyType("Đậu phộng");
            AllergyType allergyType2 = new AllergyType("Các loại hạt");
            AllergyType allergyType3 = new AllergyType("Sữa/các sản phẩm từ sữa");
            AllergyType allergyType4 = new AllergyType("Trứng");
            AllergyType allergyType5 = new AllergyType("Gluten");
            AllergyType allergyType6 = new AllergyType("Hải sản");
            AllergyType allergyType7 = new AllergyType("Đậu nành");
            AllergyType allergyType8 = new AllergyType("Mè");
            AllergyType allergyType9 = new AllergyType("Lúa mì");
            allergyTypes = List.of(allergyType1, allergyType2, allergyType3, allergyType4, allergyType5, allergyType6, allergyType7, allergyType8, allergyType9);
            allergyTypeDao.saveAll(allergyTypes);
        } else {
            allergyTypes = allergyTypeDao.getAll();
        }
        List<Taste> tastes;
        if (tasteDao.getAll().isEmpty()){
            Taste taste1 = new Taste("Cay");
            Taste taste2 = new Taste("Ngọt");
            Taste taste3 = new Taste("Mặn");
            Taste taste4 = new Taste("Chua");
            Taste taste5 = new Taste("Đắng");
            Taste taste6 = new Taste("Umami");
            Taste taste7 = new Taste("Thanh đạm");
            Taste taste8 = new Taste("Đậm đà");
            tastes = List.of(taste1, taste2, taste3, taste4, taste5, taste6, taste7, taste8);
            tasteDao.saveAll(tastes);
        } else {
            tastes = tasteDao.getAll();
        }
        List<Category> categories;
        if (categoryDao.getAll().isEmpty()){
            Category category1 = new Category("Chay");
            Category category2 = new Category("Mặn");
            Category category3 = new Category("Trung Quốc");
            Category category4 = new Category("Việt Nam");
            Category category5 = new Category("Hàn Quốc");
            Category category6 = new Category("Nhật Bản");
            Category category7 = new Category("Châu Á");
            Category category8 = new Category("Châu Âu");
            categories = List.of(category1, category2, category3, category4, category5, category6, category7, category8);
            categoryDao.saveAll(categories);
        } else {
            categories = categoryDao.getAll();
        }
        List<User> users;
        List<Restaurant> restaurants;
        if (userDao.getAll().isEmpty()) {
            User admin1 = new User("admin1@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456789", "da nang viet nam", null, new HashSet<>(getRandomSubset(allergyTypes)), new HashSet<>(getRandomSubset(tastes)), true, false, Role.ADMIN);
            User admin2 = new User("admin2@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456788", "da nang viet nam", null, new HashSet<>(getRandomSubset(allergyTypes)), new HashSet<>(getRandomSubset(tastes)), true, false, Role.ADMIN);
            User user1 = new User("user1@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456787", "da nang viet nam", null, new HashSet<>(getRandomSubset(allergyTypes)), new HashSet<>(getRandomSubset(tastes)), true, false, Role.CUSTOMER);
            User user2 = new User("user2@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456786", "da nang viet nam", null, new HashSet<>(getRandomSubset(allergyTypes)), new HashSet<>(getRandomSubset(tastes)), true, false, Role.CUSTOMER);
            User user3 = new User("user3@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456785", "da nang viet nam", null, new HashSet<>(getRandomSubset(allergyTypes)), new HashSet<>(getRandomSubset(tastes)), true, false, Role.CUSTOMER);
            User res1 = new User("res1@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456784", "da nang viet nam", null, new HashSet<>(getRandomSubset(allergyTypes)), new HashSet<>(getRandomSubset(tastes)), true, false, Role.RESTAURANT);
            User res2 = new User("res2@gmail.com", BCrypt.hashpw("123456", BCrypt.gensalt()), "/assets/img/default-avatar.jpg", "0123456783", "da nang viet nam", null, new HashSet<>(getRandomSubset(allergyTypes)), new HashSet<>(getRandomSubset(tastes)), true, false, Role.RESTAURANT);
            users = List.of(admin1, admin2, user1, user2, user3, res1, res2);
            userDao.saveAll(users);
            Customer customer1 = new Customer(user1, "Trần", "A", LocalDate.parse("2002-05-08"), Gender.MALE);
            Customer customer2 = new Customer(user2, "Trần", "B", LocalDate.parse("2002-05-08"), Gender.MALE);
            Customer customer3 = new Customer(user3, "Trần", "C", LocalDate.parse("2002-05-08"), Gender.MALE);
            customerDao.saveAll(List.of(customer1, customer2, customer3));
            Restaurant restaurant1 = new Restaurant(res1, "Nhà Hàng Phì Lũ 1", "<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1886.4207963330186!2d108.22034493993043!3d16.0666563692974!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142183377c1ecc3%3A0xd739b07453f05636!2zTmjDoCBIw6BuZyBQaMOsIEzFqSAx!5e0!3m2!1svi!2s!4v1752848871669!5m2!1svi!2s\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>", LocalTime.parse("07:00"), LocalTime.parse("22:00"));
            Restaurant restaurant2 = new Restaurant(res2, "Nhà hàng Madame Lân", "<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3833.6931319995606!2d108.21838725135308!3d16.08140624501313!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31421831ce4d457b%3A0xc2f54574a65b6322!2zTmjDoCBow6BuZyBNYWRhbWUgTMOibg!5e0!3m2!1svi!2s!4v1752848977599!5m2!1svi!2s\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>", LocalTime.parse("09:00"), LocalTime.parse("23:00"));
            restaurants = List.of(restaurant1, restaurant2);
            restaurantDao.saveAll(restaurants);
        } else {
            restaurants = restaurantDao.getAll();
        }
        if (foodDao.getAll().isEmpty()){
            Food food1 = new Food();
        }
    }
    public static <T> List<T> getRandomSubset(List<T> inputList) {
        if (inputList == null || inputList.isEmpty()) return Collections.emptyList();
        Random rand = new Random();
        int x = rand.nextInt(inputList.size()) + 1;
        List<T> copy = new ArrayList<>(inputList);
        Collections.shuffle(copy, rand);
        return copy.subList(0, x);
    }
    public static <T> T getRandomElement(List<T> list) {
        if (list == null || list.isEmpty()) return null;
        Random random = new Random();
        int index = random.nextInt(list.size());
        return list.get(index);
    }
}
