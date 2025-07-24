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

    private LocalDateTime endTime;
    private String note;
    private double amount;
    @Enumerated(EnumType.STRING)
    private BookingStatus status;
    @OneToMany(mappedBy = "booking")
    private List<BookingDetail> bookingDetails;

    public Booking(Customer customer, RestaurantTable table, LocalDateTime endTime, String note, BookingStatus status) {
        this.customer = customer;
        this.table = table;
        this.endTime = endTime;
        this.note = note;
        this.status = status;
    }
}
