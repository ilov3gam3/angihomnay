package Dao;

import Model.Booking;
import Model.Constant.BookingStatus;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;

public class BookingDao extends GenericDao<Booking> {
    public Booking getByTableId(long id) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.table.id = :id", Booking.class);
        query.setParameter("id", id);
        return query.getResultStream().findFirst().orElse(null);
    }

    public Booking getByTableIdAndUserId(long id, long userId) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.table.id = :id and b.customer.id = :userId and b.status = :status", Booking.class);
        query.setParameter("id", id);
        query.setParameter("userId", userId);
        query.setParameter("status", BookingStatus.PENDING);
        return query.getResultStream().findFirst().orElse(null);
    }

    public Booking getPendingBookingByUserId(long userId) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.customer.id = :userId and b.status = :status", Booking.class);
        query.setParameter("userId", userId);
        query.setParameter("status", BookingStatus.PENDING);
        return query.getResultStream().findFirst().orElse(null);
    }

    public Booking getByIdWithDetails(long id) {
        String jpql = "SELECT b FROM Booking b LEFT JOIN FETCH b.bookingDetails WHERE b.id = :id";
        return entityManager.createQuery(jpql, Booking.class)
                .setParameter("id", id)
                .getSingleResult();
    }

    public void autocancelBooking() {
        LocalDateTime thirtyMinAgo = LocalDateTime.now().minusMinutes(30);
        entityManager.createQuery("update Booking b set b.status = :status where b.startTime = :startTime and b.status = 'PENDING'")
                .setParameter("status", BookingStatus.CANCELLED)
                .setParameter("startTime", thirtyMinAgo)
                .executeUpdate();
    }
    public List<Booking> getByUserId(long userId) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.customer.id = :userId", Booking.class);
        return query.setParameter("userId", userId).getResultList();
    }
    public Booking getBookingByIdAndDetails(long bookingId) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b left join fetch b.bookingDetails where b.id = :bookingId", Booking.class);
        query.setParameter("bookingId", bookingId);
        return query.getResultStream().findFirst().orElse(null);
    }
}
