package Dao;

import Model.*;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;

import java.util.ArrayList;
import java.util.List;

public class FoodDao extends GenericDao<Food> {
    public List<Food> getFoodsOfRestaurant(Restaurant restaurant) {
        List<Food> foods = entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f WHERE f.restaurant = :restaurant", Food.class)
                .setParameter("restaurant", restaurant)
                .getResultList();

        if (foods.isEmpty()) return foods;
        entityManager.createQuery(
                        "SELECT f FROM Food f JOIN FETCH f.categories WHERE f IN :foods", Food.class)
                .setParameter("foods", foods)
                .getResultList();

        entityManager.createQuery(
                        "SELECT f FROM Food f JOIN FETCH f.allergyContents WHERE f IN :foods", Food.class)
                .setParameter("foods", foods)
                .getResultList();

        entityManager.createQuery(
                        "SELECT f FROM Food f JOIN FETCH f.tastes WHERE f IN :foods", Food.class)
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

    public List<Food> searchFoods(String keyword, Double priceFrom, Double priceTo, String[] categoryIds, String[] allergyIds, String[] tasteIds) {
        try {
            CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            CriteriaQuery<Food> cq = cb.createQuery(Food.class);
            Root<Food> foodRoot = cq.from(Food.class);
//            foodRoot.fetch("categories", JoinType.LEFT);
//            foodRoot.fetch("allergyContents", JoinType.LEFT);
//            foodRoot.fetch("tastes", JoinType.LEFT);
            cq.select(foodRoot).distinct(true);

            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(foodRoot.get("isAvailable"), true));
            // Tìm theo từ khóa
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim().toLowerCase() + "%";
                Predicate nameLike = cb.like(cb.lower(foodRoot.get("name")), pattern);
                Predicate descLike = cb.like(cb.lower(foodRoot.get("description")), pattern);
                predicates.add(cb.or(nameLike, descLike));
            }

            // Giá từ / đến
            if (priceFrom != null) {
                predicates.add(cb.greaterThanOrEqualTo(foodRoot.get("price"), priceFrom));
            }
            if (priceTo != null) {
                predicates.add(cb.lessThanOrEqualTo(foodRoot.get("price"), priceTo));
            }

            // Danh mục
            if (categoryIds != null && categoryIds.length > 0) {
                Join<Food, Category> catJoin = foodRoot.join("categories");
                predicates.add(catJoin.get("id").in((Object[]) categoryIds));
            }

            // Dị ứng
            if (allergyIds != null && allergyIds.length > 0) {
                Join<Food, AllergyType> allergyJoin = foodRoot.join("allergyContents");
                predicates.add(allergyJoin.get("id").in((Object[]) allergyIds));
            }

            // Hương vị
            if (tasteIds != null && tasteIds.length > 0) {
                Join<Food, Taste> tasteJoin = foodRoot.join("tastes");
                predicates.add(tasteJoin.get("id").in((Object[]) tasteIds));
            }

            cq.where(cb.and(predicates.toArray(new Predicate[0])));
            List<Food> foods = entityManager.createQuery(cq).getResultList();
            return entityManager.createQuery(cq).getResultList();
        } finally {
            entityManager.close();
        }
    }
}
