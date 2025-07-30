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
        RestaurantTableDao restaurantTableDao = new RestaurantTableDao();
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
            Food food1 = new Food("Mì Quảng", "Món ăn gắn liền với cuộc sống của người dân Đà Nẵng. Một tô mì quảng thơm lừng kết hợp hài hòa của vị ngọt từ thịt, tươi mát từ rau sống, giòn rụm của bánh đa và cái béo bùi của đậu phộng, quyện lại tạo nên món ăn dân dã nhưng mỹ vị.", 30000, "https://s3-ap-southeast-1.amazonaws.com/cntatr-assets-ap-southeast-1-250226768838-55a62c9399d4d8a6/2022/11/mon-ngon-da-nang-1.jpg?tr=q-70,c-at_max,w-500,h-300,dpr-2", new HashSet<>(getRandomSubset(categories)), restaurants.get(0), true);
            Food food2 = new Food("Bún Mắm Nêm", "Nếu là tín đồ của bún mắm thì đây là món tuyệt đối bạn không thể bỏ qua khi đến đây du lịch. Một mùi năm nêm đặc trưng, kết hợp cùng vị bùi của mít non, xen chút mùi thơm của rau sống và vị béo của đậu phộng rang. Trông thì có vẻ đơn giản nhưng càng ăn là càng ghiền.", 25000, "https://s3-ap-southeast-1.amazonaws.com/cntatr-assets-ap-southeast-1-250226768838-55a62c9399d4d8a6/2022/11/mon-ngon-da-nang-2-1024x740.jpg?tr=q-70,c-at_max,w-500,h-300,dpr-2", new HashSet<>(getRandomSubset(categories)), restaurants.get(0), true);
            Food food3 = new Food("Bún Chả Cá", "Những con cá tươi ngon được người dân mang về rồi bào lấy thịt, đem xay nhuyễn cùng với các loại gia vị, quết thật kỹ cho thịt cá dai rồi đem chế biến thành chả cá. Từng miếng chả thơm ngon, không hề vương lại mùi tanh chính là linh hồn của món bún cá Đà Nẵng.", 25000, "https://s3-ap-southeast-1.amazonaws.com/cntatr-assets-ap-southeast-1-250226768838-55a62c9399d4d8a6/2022/11/mon-ngon-da-nang-3.jpg?tr=q-70,c-at_max,w-500,h-300,dpr-2", new HashSet<>(getRandomSubset(categories)), restaurants.get(0), true);
            Food food4 = new Food("Bún Cá Ngừ", "Lát cá ngừ săn chắc thơm ngon, ăn xen cùng sợi bún nhỏ tươi hòa quyện trong tô nước dùng chua chua, thanh ngọt tất cả tạo nên hương vị hài hòa, ngon ngọt đậm vị..", 25000, "https://s3-ap-southeast-1.amazonaws.com/cntatr-assets-ap-southeast-1-250226768838-55a62c9399d4d8a6/2022/11/mon-ngon-da-nang-3.jpg?tr=q-70,c-at_max,w-500,h-300,dpr-2", new HashSet<>(getRandomSubset(categories)), restaurants.get(0), true);
            Food food5 = new Food("Pizza", "Khi nhắc đến ẩm thực Ý, bạn sẽ không thể chối từ bất kỳ món ăn nào từ món chính đến tráng miệng. Pizza chính là món ăn không chỉ nổi tiếng tại đây mà tại Việt Nam cũng được khá nhiều người ưa chuộng vì hương vị đặc biệt của loại bánh này. Đặc biệt, khi đặt chân đến Ý bạn sẽ được trải nghiệm hai món ăn này với hương vị gốc ngọt béo mà không hề ngán. Vậy nên, nếu đặt chân đến Ý mà không thử một lát pizza, thì có lẽ bạn chưa thực sự trải qua trọn vẹn trải nghiệm Ý.", 150000, "https://www.luavietours.com/wp/wp-content/uploads/2023/09/1-pizza-mon-an-chau-au-quen-thuoc-voi-huong-vi-kho-quen.jpg", new HashSet<>(getRandomSubset(categories)), restaurants.get(0), true);
            Food food6 = new Food("Ức vịt sốt cam", "Được xem là một trong những bản sắc ẩm thực truyền thống lâu đời của Pháp và được duy trì độ suốt nhiều thế hệ. Ức vịt sốt cam không chỉ là một món ăn mà còn là một phần không thể thiếu trong nền văn hóa ẩm thực Châu Âu. Nguyên liệu chính để tạo nên món ăn này chính là ức vịt và cam cùng một số nguyên liệu phụ khác. Đặc biệt, món ăn châu Âu này được ưa chuộng trong những dịp cuối năm, khi gia đình tụ họp lại bên nhau và tận hưởng những khoảnh khắc quý giá.", 100000, "https://www.luavietours.com/wp/wp-content/uploads/2023/09/4-mon-an-khong-the-thieu-trong-am-thuc-chau-au.jpg", new HashSet<>(getRandomSubset(categories)), restaurants.get(0), true);
            Food food7 = new Food("Carbonnade Flamande", "Carbonnade Flamande là một biểu tượng của ẩm thực Bỉ, được nhiều người dân địa phương tại Bỉ ưa chuộng. Đặc biệt, loại đồ ăn châu Âu này thường xuất hiện trên bàn ăn của hầu hết các nhà hàng và quán ăn trên khắp cả quốc gia này. Món ăn được chế biến từ thịt bò và hành tây, nấu chín cùng với bia và một loạt các gia vị thơm ngon như rau húng tây, lá nguyệt quế và mùa tạt tạo nên một hương vị đặc trưng. Một số đầu bếp còn thêm nấm xắt nhỏ hoặc vụn bánh mì để tạo thêm sự hấp dẫn cho món ăn này.", 200000, "https://www.luavietours.com/wp/wp-content/uploads/2023/09/6-carbonnade-flamande-bieu-tuong-am-thuc-tai-bi.jpg", new HashSet<>(getRandomSubset(categories)), restaurants.get(0), true);
            Food food8 = new Food("Súp tỏi", "Súp tỏi, một món ăn truyền thống của Cộng Hòa Séc, thường được người dân tại đây thưởng thức trong những ngày đầu năm mới với mong muốn cho một năm mới đầy sức khỏe và thịnh vượng. Đây là một món ẩm thực đơn giản với sự kết hợp của khoai tây, tỏi, hành, bánh mì đen, phô mai và majoranka. ", 200000, "https://www.luavietours.com/wp/wp-content/uploads/2023/09/9-mon-an-truyen-thong-duoc-nguoi-dan-sec-thuong-thuc-vao-ngay-dau-nam-moi.jpg", new HashSet<>(getRandomSubset(categories)), restaurants.get(0), true);
            foodDao.saveAll(List.of(food1, food2, food3, food4, food5, food6, food7, food8));
        }
        if (restaurantDao.getAll().isEmpty()){
            RestaurantTable restaurantTable1 = new RestaurantTable(1, restaurants.getFirst(), true, true);
            RestaurantTable restaurantTable2 = new RestaurantTable(2, restaurants.getFirst(), true, true);
            RestaurantTable restaurantTable3 = new RestaurantTable(3, restaurants.getFirst(), true, true);
            RestaurantTable restaurantTable4 = new RestaurantTable(4, restaurants.getFirst(), true, true);
            RestaurantTable restaurantTable5 = new RestaurantTable(5, restaurants.getFirst(), true, true);
            restaurantTableDao.saveAll(List.of(restaurantTable1, restaurantTable2, restaurantTable3, restaurantTable4, restaurantTable5));
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
