package Model;

import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "booking_details")
public class BookingDetail extends DistributedEntity {
    @ManyToOne
    private Booking booking;
    @ManyToOne
    private Food food;
    private int quantity;
}
