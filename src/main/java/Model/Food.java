package Model;

import Util.Config;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.BatchSize;

import java.util.List;
import java.util.Set;

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
    @Column(nullable = false, columnDefinition = "NVARCHAR(3000)")
    private String description;
    private double price;
    private String image;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name="categories_food",
            joinColumns = @JoinColumn(name = "food_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private Set<Category> categories;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "food_allergy",
            joinColumns = @JoinColumn(name = "food_id"),
            inverseJoinColumns = @JoinColumn(name = "allergy_id")
    )
    private Set<AllergyType> allergyContents;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "food_taste",
            joinColumns = @JoinColumn(name = "food_id"),
            inverseJoinColumns = @JoinColumn(name = "taste_id")
    )
    private Set<Taste> tastes;
    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;
    private boolean isAvailable;

    public Food(String name, String description, double price, String image, Set<Category> categories, Restaurant restaurant, boolean isAvailable) {
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
