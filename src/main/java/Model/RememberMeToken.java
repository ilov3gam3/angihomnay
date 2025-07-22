package Model;

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "remember_me_tokens")
public class RememberMeToken extends DistributedEntity{
    private String token;

    private LocalDateTime expiry;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}
