package Dao;

import Model.Restaurant;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class RestaurantDao extends GenericDao<Restaurant>{
    public List<Restaurant> getAllWithUsers(){
        TypedQuery<Restaurant> query = entityManager.createQuery("select r from Restaurant r join fetch r.user", Restaurant.class);
        return query.getResultList();
    }
    public Restaurant getRestaurantWithTables(long id){
        TypedQuery<Restaurant> query = entityManager.createQuery("select r from Restaurant r left join fetch r.restaurantTables where r.id = :id", Restaurant.class);
        query.setParameter("id", id);
        return query.getSingleResult();
    }
}
