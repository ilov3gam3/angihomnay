package Model;

import Model.Constant.Gender;
import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "customers")
public class Customer {
    @Id
    private Long id;
    @OneToOne
    @MapsId
    @JoinColumn(name="id")
    private User user;
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String firstName;
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String lastName;
    private Date dateOfBirth;
    private Gender gender;
    private String address;

    public Customer(User user, String firstName, String lastName, Date dateOfBirth, Gender gender, String address) {
        this.user = user;
        this.firstName = firstName;
        this.lastName = lastName;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.address = address;
    }
}
