package Dao;

import Model.Booking;
import Model.Constant.BookingStatus;
import Model.RestaurantTable;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookingDao extends GenericDao<Booking> {
    public Booking getByTableId(long id) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.table.id = :id", Booking.class);
        query.setParameter("id", id);
        return query.getResultStream().findFirst().orElse(null);
    }

    public Booking getByTableIdAndUserId(long id, long userId) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.table.id = :id and b.customer.id = :userId", Booking.class);
        query.setParameter("id", id);
        query.setParameter("userId", userId);
        return query.getResultStream().findFirst().orElse(null);
    }

    public Booking getPendingBookingByUserId(long userId) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.customer.id = :userId", Booking.class);
        query.setParameter("userId", userId);
        return query.getResultStream().findFirst().orElse(null);
    }

    public Booking getByIdWithDetails(long id) {
        String jpql = "SELECT b FROM Booking b LEFT JOIN FETCH b.bookingDetails WHERE b.id = :id";
        return entityManager.createQuery(jpql, Booking.class)
                .setParameter("id", id)
                .getSingleResult();
    }

    public List<Booking> getByUserId(long userId) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b left join fetch b.bookingDetails where b.customer.id = :userId", Booking.class);
        return query.setParameter("userId", userId).getResultList();
    }
    public Booking getBookingByIdAndDetails(long bookingId) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b left join fetch b.bookingDetails where b.id = :bookingId", Booking.class);
        query.setParameter("bookingId", bookingId);
        return query.getResultStream().findFirst().orElse(null);
    }
    public List<Booking> getBookingByResId(long resId){
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b left join fetch b.bookingDetails where b.table.restaurant.id = :resId", Booking.class);
        query.setParameter("resId", resId);
        return query.getResultList();
    }
    public List<Map<String, Object>> getWeeklyRevenue(long restaurantId, int startWeek, int endWeek) {
        List<Map<String, Object>> result = new ArrayList<>();

        for (int week = startWeek; week <= endWeek; week++) {
            Double revenue = entityManager.createQuery(
                            "SELECT COALESCE(SUM(b.amount), 0) FROM Booking b " +
                                    "WHERE FUNCTION('WEEK', b.startTime) = :week " +
                                    "AND FUNCTION('YEAR', b.startTime) = :year " +
                                    "AND b.table.restaurant.id = :restaurantId", Double.class)
                    .setParameter("week", week)
                    .setParameter("year", LocalDate.now().getYear())
                    .setParameter("restaurantId", restaurantId)
                    .getSingleResult();

            Map<String, Object> map = new HashMap<>();
            map.put("week", week);
            map.put("revenue", revenue);
            result.add(map);
        }

        return result;
    }

    public List<Map<String, Object>> getMonthlyRevenueByRestaurant(int month, int year) {
        List<Object[]> results = entityManager.createQuery(
                        "SELECT b.table.restaurant.name, SUM(b.amount) " +
                                "FROM Booking b " +
                                "WHERE FUNCTION('MONTH', b.startTime) = :month " +
                                "AND FUNCTION('YEAR', b.startTime) = :year " +
                                "GROUP BY b.table.restaurant.name", Object[].class)
                .setParameter("month", month)
                .setParameter("year", year)
                .getResultList();

        List<Map<String, Object>> data = new ArrayList<>();
        for (Object[] row : results) {
            Map<String, Object> map = new HashMap<>();
            map.put("restaurant", row[0]);
            map.put("revenue", row[1]);
            data.add(map);
        }

        return data;
    }

    public void updateTableCustomerStatus() {
        EntityTransaction tx = null;

        try {
            tx = entityManager.getTransaction();
            tx.begin();

            LocalDateTime now = LocalDateTime.now();

            List<BookingStatus> activeStatuses = List.of(
                    BookingStatus.DEPOSITED,
                    BookingStatus.WAITING_FINAL_PAYMENT,
                    BookingStatus.PAID
            );

            System.out.println("===> Checking bookings at: " + now);

            // Set isHavingCustomer = true if booking has started
            List<Booking> ongoingBookings = entityManager.createQuery("""
            SELECT b FROM Booking b
            WHERE b.startTime <= :now AND b.endTime > :now
            AND b.status IN :statuses
        """, Booking.class)
                    .setParameter("now", now)
                    .setParameter("statuses", activeStatuses)
                    .getResultList();

            System.out.println("===> Found " + ongoingBookings.size() + " ongoing bookings.");

            for (Booking booking : ongoingBookings) {
                RestaurantTable table = booking.getTable();
                if (!table.isHavingCustomer()) {
                    System.out.printf("✅ Booking %d has started => Setting isHavingCustomer = true for table %d%n",
                            booking.getId(), table.getId());
                    table.setHavingCustomer(true);
                    entityManager.merge(table);
                }
            }

            // Set isHavingCustomer = false if booking has ended
            List<Booking> endedBookings = entityManager.createQuery("""
            SELECT b FROM Booking b
            WHERE b.endTime <= :now
            AND b.status IN :statuses
        """, Booking.class)
                    .setParameter("now", now)
                    .setParameter("statuses", activeStatuses)
                    .getResultList();

            System.out.println("===> Found " + endedBookings.size() + " ended bookings.");

            for (Booking booking : endedBookings) {
                RestaurantTable table = booking.getTable();
                if (table.isHavingCustomer()) {
                    System.out.printf("🔁 Booking %d has ended => Setting isHavingCustomer = false for table %d%n",
                            booking.getId(), table.getId());
                    table.setHavingCustomer(false);
                    entityManager.merge(table);
                }
            }

            entityManager.flush(); // ensure everything is written
            tx.commit();
            System.out.println("===> Done updating table status.");

        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            entityManager.close();
        }
    }
}
