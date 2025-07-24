package Controller;

import Dao.BookingDao;
import Dao.BookingDetailDao;
import Dao.PaymentDao;
import Model.Booking;
import Model.BookingDetail;
import Model.Constant.BookingStatus;
import Model.Constant.TransactionStatus;
import Model.Payment;
import Util.Config;
import Util.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class PaymentController {
    @WebServlet("/get-vnpay-url")
    public static class GetVNPayUrlServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            Booking booking = new BookingDao().getById(id);
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String orderType = "other";
            long amount = getAmount(booking) * 100L;
            String bankCode = req.getParameter("bankCode");
            String vnp_TxnRef = VNPayUtil.getRandomNumber(8);
            String vnp_IpAddr = VNPayUtil.getIpAddress(req);
            String vnp_TmnCode = Config.vnp_TmnCode;
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");
            if (bankCode != null && !bankCode.isEmpty()) {
                vnp_Params.put("vnp_BankCode", bankCode);
            }
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            String vnp_OrderInfo = UUID.randomUUID() + "-" + System.currentTimeMillis() + "|" + req.getParameter("id");
            vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.put("vnp_OrderType", orderType);
            String locate = req.getParameter("language");
            if (locate != null && !locate.isEmpty()) {
                vnp_Params.put("vnp_Locale", locate);
            } else {
                vnp_Params.put("vnp_Locale", "vn");
            }
            vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
            List fieldNames = new ArrayList(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = (String) itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            String queryUrl = query.toString();
            String vnp_SecureHash = VNPayUtil.hmacSHA512(Config.secretKey, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            Payment payment = new Payment();
            payment.setAmount(amount/100);
            payment.setTxnRef(vnp_TxnRef);
            payment.setOrderInfo(vnp_OrderInfo);
            new PaymentDao().save(payment);
            String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
            resp.sendRedirect(paymentUrl);
        }
        public static long getAmount(Booking booking){
            long amount = 0;
            BookingDetailDao bookingDetailDao = new BookingDetailDao();
            List<BookingDetail> bookingDetails = bookingDetailDao.getBookingDetailsByBookingIdAndFoods(booking.getId());
            for (BookingDetail bookingDetail : bookingDetails) {
                amount += (long) (bookingDetail.getFood().getPrice() * bookingDetail.getQuantity());
            }
            return amount;
        }
    }

    @WebServlet("/vnpay-result")
    public static class VNPayResultServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            BookingDao bookingDao = new BookingDao();
            PaymentDao paymentDao = new PaymentDao();
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<?> params = req.getParameterNames(); params.hasMoreElements(); ) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(req.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                    fields.put(fieldName, fieldValue);
                }
            }
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");
            String signValue = VNPayUtil.hashAllFields(fields);
            if (!signValue.equals(req.getParameter("vnp_SecureHash"))){
                req.getSession().setAttribute("flash_error", "Mã băm không khớp");
                resp.sendRedirect(req.getContextPath() + "/customer/bookings");
                return;
            }
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            SimpleDateFormat sqlFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String paid_at = req.getParameter("vnp_PayDate");
            String vnp_OrderInfo = req.getParameter("vnp_OrderInfo");
            Payment payment = paymentDao.findByOrderInfo(vnp_OrderInfo);
            if (payment != null) {
                req.getSession().setAttribute("warning", "Vui lòng không spam");
                resp.sendRedirect(req.getContextPath() + "/customer/bookings");
                return;
            }
            String vnp_TransactionStatus = req.getParameter("vnp_TransactionStatus");
            String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");
            String vnp_BankTranNo = req.getParameter("vnp_BankTranNo");
            String vnp_CardType = req.getParameter("vnp_CardType");
            String vnp_BankCode = req.getParameter("vnp_BankCode");
            payment.setBankCode(vnp_BankCode);
            payment.setTransactionNo(vnp_TransactionNo);
            payment.setTransactionStatus(TransactionStatus.fromCode(vnp_TransactionStatus));
            payment.setCardType(vnp_CardType);
            payment.setBankTranNo(vnp_BankTranNo);
            long booking_id = Long.parseLong(vnp_OrderInfo.split("\\|")[1]);
            Booking booking = bookingDao.getById(booking_id);
            if (payment.transactionStatus == TransactionStatus.SUCCESS){
                booking.setStatus(BookingStatus.COMPLETED);
                booking.setAmount(payment.getAmount());
            } else {
                booking.setStatus(BookingStatus.CANCELLED);
            }
            bookingDao.update(booking);
            payment.setBooking(booking);
            paymentDao.update(payment);
            try {
                payment.setPaid_at(Timestamp.valueOf(sqlFormatter.format(formatter.parse(paid_at))));
            } catch (ParseException e) {
                throw new RuntimeException(e);
            }
            if (payment.transactionStatus != TransactionStatus.SUCCESS){
                req.getSession().setAttribute("flash_success", "Thanh toán không thành công.");
                resp.sendRedirect(req.getContextPath() + "/customer/bookings");
                return;
            }
            req.getSession().setAttribute("success", "Thanh toán thành công.");
            resp.sendRedirect(req.getContextPath() + "/customer/bookings");
        }
    }
}
