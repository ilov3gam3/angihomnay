package Model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "reviews")
public class Review extends DistributedEntity{
    @OneToOne
    @JoinColumn(name = "booking_id")
    private Booking booking;

    @OneToMany(mappedBy = "review", cascade = CascadeType.ALL)
    private List<ReviewDetail> reviewDetails;
    @Column(columnDefinition = "NVARCHAR(1000)")
    private String comment;
    private int rating;
}
