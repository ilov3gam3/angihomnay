package Model;

import Model.Constant.Role;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "users")
public class User extends DistributedEntity {
    @Column(unique = true, nullable = false)
    private String email;
    private String password;
    private String avatar;
    @Column(unique = true, nullable = false)
    private String phone;
    private String token;
    private boolean isVerified;
    private boolean isBlocked;
    @Enumerated(EnumType.STRING)
    private Role role;
}
