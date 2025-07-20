package Model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "tables")
public class RestaurantTable extends DistributedEntity {
    @Column(unique = true, nullable = false)
    private int number;
    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;
    private boolean isAvailable = true;
    private boolean isHavingCustomer = false;
}
