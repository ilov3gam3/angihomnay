package Model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "restaurants")
public class Restaurant {
    @Id
    private Long id;
    @OneToOne
    @MapsId
    @JoinColumn(name="id")
    private User user;
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String name;
    @Column(length = 1500)
    private String mapEmbedUrl;
    private LocalTime openTime;
    private LocalTime closeTime;
    @OneToMany(mappedBy = "restaurant")
    private List<RestaurantTable> restaurantTables;
    @OneToMany(mappedBy = "restaurant")
    private List<Food> foods;

    public Restaurant(User user, String name, String mapEmbedUrl, LocalTime openTime, LocalTime closeTime) {
        this.user = user;
        this.name = name;
        this.mapEmbedUrl = mapEmbedUrl;
        this.openTime = openTime;
        this.closeTime = closeTime;
    }
}
