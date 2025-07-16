package Util;

import Model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.List;

@WebListener
public class StartListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("angihomnay");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();

        List<User> users = em.createQuery("select u from User u", User.class).getResultList();
        System.out.println(users.size());
        em.getTransaction().commit();
        em.close();
    }
}
