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
    @Column(columnDefinition = "NVARCHAR(1000)")
    private String comment;
    private int rating;
}
