package Dao;

import Model.ReviewDetail;
import jakarta.persistence.TypedQuery;

import java.util.*;

public class ReviewDetailDao extends GenericDao<ReviewDetail>{
    public List<ReviewDetail> getDetailsByFoodId(long foodId){
        TypedQuery<ReviewDetail> query = entityManager.createQuery("select d from ReviewDetail d where d.bookingDetail.food.id = :foodId", ReviewDetail.class);
        query.setParameter("foodId", foodId);
        return query.getResultList();
    }
    public List<List<ReviewDetail>> findReviewDetailsByFoodIdsInOrder(List<Long> foodIds) {
        if (foodIds == null || foodIds.isEmpty()) return Collections.emptyList();

        // Truy vấn như trên
        String hql = """
        SELECT rd FROM ReviewDetail rd
        JOIN FETCH rd.bookingDetail bd
        JOIN FETCH bd.food f
        WHERE f.id IN :foodIds
    """;

        List<ReviewDetail> allReviewDetails = entityManager.createQuery(hql, ReviewDetail.class)
                .setParameter("foodIds", foodIds)
                .getResultList();

        Map<Long, List<ReviewDetail>> foodIdToReviewList = new HashMap<>();
        for (ReviewDetail rd : allReviewDetails) {
            Long fid = rd.getBookingDetail().getFood().getId();
            foodIdToReviewList
                    .computeIfAbsent(fid, k -> new ArrayList<>())
                    .add(rd);
        }

        List<List<ReviewDetail>> result = new ArrayList<>();
        for (Long id : foodIds) {
            result.add(foodIdToReviewList.getOrDefault(id, new ArrayList<>()));
        }

        return result;
    }
}
