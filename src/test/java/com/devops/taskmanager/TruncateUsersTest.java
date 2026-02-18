package com.devops.taskmanager;

import com.devops.taskmanager.Repository.FriendRequestRepository;
import com.devops.taskmanager.Repository.TaskRepository;
import com.devops.taskmanager.Repository.UserRepository;
import com.devops.taskmanager.entities.User;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.test.annotation.Commit;

import java.util.List;

@SpringBootTest
public class TruncateUsersTest {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private FriendRequestRepository friendRequestRepository;

    @Test
    @Transactional
    @Commit
    public void viderTableUsers() {
        System.out.println("[DEBUG_LOG] Debut du vidage de la table users");
        
        // Supprimer les requêtes d'amis (dépendances)
        friendRequestRepository.deleteAllInBatch();
        System.out.println("[DEBUG_LOG] Friend requests supprimées");
        
        // Les tâches sont liées aux utilisateurs
        taskRepository.deleteAllInBatch();
        System.out.println("[DEBUG_LOG] Tasks supprimées");
        
        // Supprimer les relations d'amitié dans la table de jointure
        List<User> users = userRepository.findAll();
        for (User user : users) {
            user.getFriends().clear();
        }
        userRepository.saveAll(users);
        userRepository.flush();
        System.out.println("[DEBUG_LOG] Relations d'amitié nettoyées");
        
        // Enfin, supprimer tous les utilisateurs
        userRepository.deleteAllInBatch();
        System.out.println("[DEBUG_LOG] Table users vidée");
    }
}
