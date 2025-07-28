package Controller;

import Dao.BookingDao;
import Dao.ReviewDao;
import Dao.ReviewDetailDao;
import Model.Booking;
import Model.BookingDetail;
import Model.Review;
import Model.ReviewDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ReviewController {
    @WebServlet("/customer/review")
    public static class CustomerReviewServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            BookingDao bookingDao = new BookingDao();
            ReviewDao reviewDao = new ReviewDao();
            long bookingId = Long.parseLong(req.getParameter("bookingId"));
            if (reviewDao.getReviewByBookingId(bookingId) != null) {
                req.getSession().setAttribute("flash_error", "Bạn đã đánh giá cho đơn này rồi.");
                resp.sendRedirect(req.getContextPath() + "/customer/bookings");
                return;
            }
            Booking booking = bookingDao.getBookingByIdAndDetails(bookingId);
            req.setAttribute("booking", booking);
            req.getRequestDispatcher("/views/customer/review.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            try {
                long bookingId = Long.parseLong(req.getParameter("bookingId"));
                String comment = req.getParameter("comment");
                int rating = Integer.parseInt(req.getParameter("rating"));

                BookingDao bookingDao = new BookingDao();
                ReviewDao reviewDao = new ReviewDao();

                // Lấy Booking cùng với BookingDetails
                Booking booking = bookingDao.getByIdWithDetails(bookingId);
                if (booking == null || booking.getBookingDetails() == null) {
                    req.getSession().setAttribute("flash_error", "Không tìm thấy đơn đặt món.");
                    resp.sendRedirect(req.getContextPath() + "/customer/bookings");
                    return;
                }

                // Tạo Review chính
                Review review = new Review();
                review.setBooking(booking);
                review.setComment(comment);
                review.setRating(rating);

                List<ReviewDetail> reviewDetails = new ArrayList<>();

                // Duyệt qua từng BookingDetail để tạo ReviewDetail
                for (BookingDetail bd : booking.getBookingDetails()) {
                    String detailComment = req.getParameter("reviewDetail_comment_" + bd.getId());
                    String detailRatingStr = req.getParameter("reviewDetail_rating_" + bd.getId());

                    if (detailComment == null || detailRatingStr == null || detailRatingStr.isEmpty()) {
                        continue; // Bỏ qua nếu thiếu thông tin
                    }

                    int detailRating = Integer.parseInt(detailRatingStr);

                    ReviewDetail rd = new ReviewDetail();
                    rd.setBookingDetail(bd);
                    rd.setComment(detailComment);
                    rd.setRating(detailRating);
                    rd.setReview(review);

                    reviewDetails.add(rd);
                }

                review.setReviewDetails(reviewDetails);

                // Lưu toàn bộ: nếu Review có cascade thì chỉ cần save Review
                reviewDao.save(review);

                // Nếu bạn không dùng cascade thì uncomment dòng dưới
                // reviewDetailDao.saveAll(reviewDetails);

                req.getSession().setAttribute("flash_success", "Đánh giá thành công!");
            } catch (Exception e) {
                e.printStackTrace();
                req.getSession().setAttribute("flash_error", "Đã có lỗi xảy ra khi gửi đánh giá.");
            }
            resp.sendRedirect(req.getContextPath() + "/customer/bookings");
        }
    }
}
