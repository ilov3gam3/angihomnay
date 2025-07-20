package Dao;

import Model.Customer;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class CustomerDao extends GenericDao<Customer> {
    public List<Customer> getAllWithUsers() {
        TypedQuery<Customer> query = entityManager.createQuery("select c from Customer c join fetch c.user", Customer.class);
        return query.getResultList();
    }
}
