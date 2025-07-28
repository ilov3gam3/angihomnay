package Dao;

import Model.Restaurant;
import Model.RestaurantTable;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
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
    public RestaurantTable findAvailableTable(long restaurantId, LocalDateTime startTime, LocalDateTime endTime) {
        TypedQuery<RestaurantTable> query = entityManager.createQuery("""
                    select rt from RestaurantTable rt
                    where rt.restaurant.id = :restaurantId
                    and rt.isAvailable = true
                    and not exists (
                        select 1 from Booking b
                        where b.table.id = rt.id
                        and b.status != 'CANCELLED'
                        and b.startTime < :endTime
                        and b.endTime > :startTime
                    )
                """, RestaurantTable.class);
        List<RestaurantTable> results = query
                .setParameter("restaurantId", restaurantId)
                .setParameter("startTime", startTime)
                .setParameter("endTime", endTime)
                .setMaxResults(1)
                .getResultList();
        return results.isEmpty() ? null : results.getFirst();
    }
}
