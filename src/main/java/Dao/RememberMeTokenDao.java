package Dao;

import jakarta.persistence.NoResultException;
import Model.RememberMeToken;
import Model.User;

import java.time.LocalDateTime;

public class RememberMeTokenDao extends GenericDao<RememberMeToken> {

    public RememberMeToken findValidToken(String token) {
        try {
            return entityManager.createQuery(
                            "SELECT r FROM RememberMeToken r WHERE r.token = :token AND r.expiry > :now",
                            RememberMeToken.class)
                    .setParameter("token", token)
                    .setParameter("now", LocalDateTime.now())
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public void deleteByUser(User user) {
        entityManager.getTransaction().begin();
        entityManager.createQuery("DELETE FROM RememberMeToken r WHERE r.user = :user")
                .setParameter("user", user)
                .executeUpdate();
        entityManager.getTransaction().commit();
    }
}
