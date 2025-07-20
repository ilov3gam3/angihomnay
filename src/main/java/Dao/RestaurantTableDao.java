package Dao;

import Model.Restaurant;
import Model.RestaurantTable;
import jakarta.persistence.TypedQuery;

import java.util.ArrayList;
import java.util.List;

public class RestaurantTableDao extends GenericDao<RestaurantTable> {
    public RestaurantTable getTableWithRestaurant(Restaurant restaurant, long id){
        TypedQuery<RestaurantTable> query = entityManager.createQuery("select r from RestaurantTable r where r.id = :id and r.restaurant = :restaurant", RestaurantTable.class);
        query.setParameter("id", id);
        query.setParameter("restaurant", restaurant);
        return query.getResultStream().findFirst().orElse(null);
    }
    public boolean existsAnyNumberInList(List<Integer> numbers, Restaurant restaurant) {
        String jpql = "SELECT COUNT(rt) FROM RestaurantTable rt WHERE rt.number IN :numbers AND rt.restaurant = :restaurant";
        Long count = entityManager.createQuery(jpql, Long.class)
                .setParameter("numbers", numbers)
                .setParameter("restaurant", restaurant)
                .getSingleResult();
        return count > 0;
    }
}
