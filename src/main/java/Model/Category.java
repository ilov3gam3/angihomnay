package Model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "categories")
public class Category extends DistributedEntity {
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String name;
    @ManyToMany(mappedBy = "categories")
    private List<Food> foods;

    public Category(String name) {
        this.name = name;
    }
}
