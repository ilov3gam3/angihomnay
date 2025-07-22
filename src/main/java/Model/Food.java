package Model;

import Util.Config;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.BatchSize;

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
    @ManyToMany(fetch = FetchType.LAZY)
    @BatchSize(size = 10)
    @JoinTable(
            name="categories_food",
            joinColumns = @JoinColumn(name = "food_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private List<Category> categories;
    @ManyToMany(fetch = FetchType.LAZY)
    @BatchSize(size = 10)
    @JoinTable(
            name = "food_allergy",
            joinColumns = @JoinColumn(name = "food_id"),
            inverseJoinColumns = @JoinColumn(name = "allergy_id")
    )
    private List<AllergyType> allergyContents;
    @ManyToMany(fetch = FetchType.LAZY)
    @BatchSize(size = 10)
    @JoinTable(
            name = "food_taste",
            joinColumns = @JoinColumn(name = "food_id"),
            inverseJoinColumns = @JoinColumn(name = "taste_id")
    )
    private List<Taste> tastes;
    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;
    private boolean isAvailable;

    public Food(String name, String description, double price, String image, List<Category> categories, Restaurant restaurant, boolean isAvailable) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
        this.categories = categories;
        this.restaurant = restaurant;
        this.isAvailable = isAvailable;
    }

    public String getImage() {
        if (this.image.startsWith("http")){
            return this.image;
        } else {
            return Config.app_url + Config.contextPath + this.image;
        }
    }
}
