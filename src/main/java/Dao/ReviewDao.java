package Dao;

import Model.Review;
import Model.ReviewDetail;
import jakarta.persistence.TypedQuery;

import java.util.*;

public class ReviewDao extends GenericDao<Review> {
    public Review getReviewByBookingId(long bookingId) {
        TypedQuery<Review> bookingTypedQuery = entityManager.createQuery("select r from Review r where r.booking.id = :id", Review.class);
        bookingTypedQuery.setParameter("id", bookingId);
        return bookingTypedQuery.getResultStream().findFirst().orElse(null);
    }
}
