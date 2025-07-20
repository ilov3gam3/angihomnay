package Dao;

import Model.Food;
import Model.Restaurant;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class FoodDao extends GenericDao<Food> {
    public List<Food> getFoodsOfRestaurant(Restaurant restaurant) {
        return entityManager.createQuery(
                        "SELECT DISTINCT f FROM Food f " +
                                "LEFT JOIN FETCH f.categories " +
                                "WHERE f.restaurant = :restaurant", Food.class)
                .setParameter("restaurant", restaurant)
                .getResultList();
    }
    public Food getFoodOfRestaurant(Restaurant restaurant, long foodId) {
        TypedQuery<Food> query = entityManager.createQuery("select f from Food f left join fetch f.categories where f.restaurant = :restaurant and f.id = : foodId", Food.class);
        query.setParameter("restaurant", restaurant);
        query.setParameter("foodId", foodId);
        return query.getResultStream().findFirst().orElse(null);
    }
}
