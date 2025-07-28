package Model;

import Model.Constant.Role;
import Util.Config;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;
import java.util.Set;

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
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String address;
    private String token;
    @ManyToMany
    @JoinTable(
            name = "user_allergy",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "allergy_id")
    )
    private Set<AllergyType> allergies;
    @ManyToMany
    @JoinTable(
            name = "user_taste",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "taste_id")
    )
    private Set<Taste> favoriteTastes;
    private boolean isVerified;
    private boolean isBlocked;
    @Enumerated(EnumType.STRING)
    private Role role;

    public String getAvatar(){
        if (this.avatar.startsWith("http")){
            return this.avatar;
        } else {
            return Config.app_url + Config.contextPath + this.avatar;
        }
    }

    public User(String email, String password, String avatar, String phone, String address, String token, boolean isVerified, boolean isBlocked, Role role) {
        this.email = email;
        this.password = password;
        this.avatar = avatar;
        this.phone = phone;
        this.address = address;
        this.token = token;
        this.isVerified = isVerified;
        this.isBlocked = isBlocked;
        this.role = role;
    }
}
