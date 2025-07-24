package Model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "review_details")
public class ReviewDetail extends DistributedEntity{
    @OneToOne
    private BookingDetail bookingDetail;
    @ManyToOne
    @JoinColumn(name = "review_id")
    private Review review;
    private String comment;
    private int rating;
}
