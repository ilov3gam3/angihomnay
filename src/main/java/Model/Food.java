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
@Table(name = "foods")
public class Food extends DistributedEntity {
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String name;
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String description;
    private double price;
    private String image;
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name="categories_food",
            joinColumns = @JoinColumn(name = "food_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private List<Category> categories;
    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;
    private boolean isAvailable;
}
