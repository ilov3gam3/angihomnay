package Model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "allergy_types")
public class AllergyType extends DistributedEntity{
    @Column(columnDefinition = "NVARCHAR(255)")
    private String name;
}
