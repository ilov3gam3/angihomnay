package Model;

import Model.Constant.BookingStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "bookings")
public class Booking extends DistributedEntity {
    @ManyToOne
    private Customer customer;

    @ManyToOne
    private RestaurantTable table;

    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private double prePaidFee;
    @Column(columnDefinition = "NVARCHAR(255)")
    private String note;
    private double amount;

    @OneToMany(mappedBy = "booking", cascade = CascadeType.ALL)
    private List<Payment> payments;

    @Enumerated(EnumType.STRING)
    private BookingStatus status;

    @OneToMany(mappedBy = "booking", cascade = CascadeType.ALL)
    private List<BookingDetail> bookingDetails;

    public Booking(Customer customer, RestaurantTable table, LocalDateTime startTime, LocalDateTime endTime, long prePaidFee, String note, double amount, BookingStatus status) {
        this.customer = customer;
        this.table = table;
        this.startTime = startTime;
        this.endTime = endTime;
        this.prePaidFee = prePaidFee;
        this.note = note;
        this.amount = amount;
        this.status = status;
    }

    public Booking(Customer customer, RestaurantTable table, LocalDateTime startTime, LocalDateTime endTime, double prePaidFee, String note, double amount, BookingStatus status, List<BookingDetail> bookingDetails) {
        this.customer = customer;
        this.table = table;
        this.startTime = startTime;
        this.endTime = endTime;
        this.prePaidFee = prePaidFee;
        this.note = note;
        this.amount = amount;
        this.status = status;
        this.bookingDetails = bookingDetails;
    }
}
