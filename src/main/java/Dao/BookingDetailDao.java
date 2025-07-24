package Dao;

import Model.BookingDetail;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class BookingDetailDao extends GenericDao<BookingDetail>{
    public List<BookingDetail> getBookingDetailsByBookingIdAndFoods(long bookingID){
        TypedQuery<BookingDetail> query = entityManager.createQuery("select bd from BookingDetail bd left join fetch bd.food where bd.booking.id = :id", BookingDetail.class);
        return query.setParameter("id", bookingID).getResultList();
    }
}
