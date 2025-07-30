package Model.Constant;

public enum BookingStatus {
//    PENDING,
//    CANCELLED,
//    COMPLETED
    BOOKED, // chưa thanh toán, thanh toán bị hủy
    DEPOSITED, // đã thanh toán cọc
    WAITING_FINAL_PAYMENT, // đang gọi thêm món, chờ thanh toán lần cuối
    PAID, // đã thanh toán lần cuối
    CANCELED,
    NO_SHOW,
}
