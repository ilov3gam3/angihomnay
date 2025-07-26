package Model;

import Model.Constant.PaymentType;
import Model.Constant.TransactionStatus;
import jakarta.persistence.*;
import lombok.*;

import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "payments")
@ToString
public class Payment extends DistributedEntity{

    @ManyToOne
    @JoinColumn(name = "booking_id")
    private Booking booking;

    @Enumerated(EnumType.STRING)
    private PaymentType type;

    private long amount;
    public String txnRef;
    public String orderInfo;
    public String bankCode;
    public String transactionNo;
    @Enumerated(EnumType.STRING)
    public TransactionStatus transactionStatus;
    public String cardType;
    public String bankTranNo;
    public Timestamp paid_at;
}
