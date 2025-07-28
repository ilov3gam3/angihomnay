package Util;

import Model.Booking;
import Model.Constant.PaymentType;
import Model.Payment;

import java.util.List;

public class BookingUtil {
    public static boolean isBookingDone(Booking booking){
        List<Payment> payments = booking.getPayments();
        boolean checkDeposit = false;
        boolean checkFinal = false;
        for (Payment p : payments){
            if (p.getType() == PaymentType.DEPOSIT){
                checkDeposit = true;
            }
            if (p.getType() == PaymentType.FINAL){
                checkFinal = true;
            }
        }
        return checkDeposit && checkFinal;
    }
}
