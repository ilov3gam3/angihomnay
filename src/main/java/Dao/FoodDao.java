package Dao;

import Model.*;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

public class FoodDao extends GenericDao<Food> {
    public List<Food> getFoodsOfRestaurant(Restaurant restaurant) {
        List<Food> foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f WHERE f.restaurant = :restaurant", Food.class)
                .setParameter("restaurant", restaurant)
                .getResultList();

        if (foods.isEmpty()) return foods;

        foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f LEFT JOIN FETCH f.categories WHERE f IN :foods", Food.class)
                .setParameter("foods", foods)
                .getResultList();

        foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f LEFT JOIN FETCH f.allergyContents WHERE f IN :foods", Food.class)
                .setParameter("foods", foods)
                .getResultList();

        foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f LEFT JOIN FETCH f.tastes WHERE f IN :foods", Food.class)
                .setParameter("foods", foods)
                .getResultList();

        return foods;
    }

    public List<Food> getFoodsWithAllProperties(){
        List<Food> foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f", Food.class)
                .getResultList();

        if (foods.isEmpty()) return foods;

        foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f LEFT JOIN FETCH f.categories WHERE f IN :foods", Food.class)
                .setParameter("foods", foods)
                .getResultList();

        foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f LEFT JOIN FETCH f.allergyContents WHERE f IN :foods", Food.class)
                .setParameter("foods", foods)
                .getResultList();

        foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f LEFT JOIN FETCH f.tastes WHERE f IN :foods", Food.class)
                .setParameter("foods", foods)
                .getResultList();

        return foods;
    }

    public Food getFoodOfRestaurant(Restaurant restaurant, long foodId) {
        TypedQuery<Food> query = entityManager.createQuery("select f from Food f left join fetch f.categories where f.restaurant = :restaurant and f.id = : foodId", Food.class);
        query.setParameter("restaurant", restaurant);
        query.setParameter("foodId", foodId);
        return query.getResultStream().findFirst().orElse(null);
    }
    public List<Food> searchFoods(String keyword, Double priceFrom, Double priceTo,
                                  String[] categoryIds, String[] allergyIds, String[] tasteIds) {
        try {
            CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            CriteriaQuery<Food> cq = cb.createQuery(Food.class);
            Root<Food> foodRoot = cq.from(Food.class);

            // Fetch liên quan (phải khớp kiểu join bên dưới)
            foodRoot.fetch("categories", JoinType.LEFT);
            foodRoot.fetch("allergyContents", JoinType.LEFT);
            foodRoot.fetch("tastes", JoinType.LEFT);
            cq.select(foodRoot).distinct(true);

            // Tạo các join riêng để lọc
            Join<Food, Category> categoryJoin = foodRoot.join("categories", JoinType.LEFT);
            Join<Food, AllergyType> allergyJoin = foodRoot.join("allergyContents", JoinType.LEFT);
            Join<Food, Taste> tasteJoin = foodRoot.join("tastes", JoinType.LEFT);

            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(foodRoot.get("isAvailable"), true));

            // Keyword
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim().toLowerCase() + "%";
                predicates.add(cb.or(
                        cb.like(cb.lower(foodRoot.get("name")), pattern),
                        cb.like(cb.lower(foodRoot.get("description")), pattern)
                ));
            }

            // Price range
            if (priceFrom != null) {
                predicates.add(cb.greaterThanOrEqualTo(foodRoot.get("price"), priceFrom));
            }
            if (priceTo != null) {
                predicates.add(cb.lessThanOrEqualTo(foodRoot.get("price"), priceTo));
            }

            // Category filter
            if (categoryIds != null && categoryIds.length > 0) {
                predicates.add(categoryJoin.get("id").in((Object[]) categoryIds));
            }

            // Allergy filter
            if (allergyIds != null && allergyIds.length > 0) {
                predicates.add(allergyJoin.get("id").in((Object[]) allergyIds));
            }

            // Taste filter
            if (tasteIds != null && tasteIds.length > 0) {
                predicates.add(tasteJoin.get("id").in((Object[]) tasteIds));
            }

            cq.where(cb.and(predicates.toArray(new Predicate[0])));

            List<Food> result = entityManager.createQuery(cq).getResultList();

            // Optional: ép Set nếu cần tránh lazy load sau khi session đóng
            for (Food food : result) {
                food.setCategories(new HashSet<>(food.getCategories()));
                food.setAllergyContents(new HashSet<>(food.getAllergyContents()));
                food.setTastes(new HashSet<>(food.getTastes()));
            }

            return result;
        } finally {
            entityManager.close(); // Đóng session sau khi data đã được fetch
        }
    }
    public List<Food> getAvailableByIds(List<Long> ids){
        TypedQuery<Food> query = entityManager.createQuery("select f from Food f where f.id in (:ids) and f.isAvailable = true ", Food.class);
        return query.setParameter("ids", ids).getResultList();
    }
}
