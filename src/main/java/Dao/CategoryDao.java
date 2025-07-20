package Dao;

import Model.Category;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class CategoryDao extends GenericDao<Category> {
    public List<Category> getAllWithFoods() {
        TypedQuery<Category> query = entityManager.createQuery("SELECT c FROM Category c left join fetch c.foods", Category.class);
        return query.getResultList();
    }
}
