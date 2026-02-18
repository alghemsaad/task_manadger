package com.devops.taskmanager.services;

import com.devops.taskmanager.Repository.FriendRequestRepository;
import com.devops.taskmanager.Repository.UserRepository;
import com.devops.taskmanager.entities.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FriendRequestRepository friendRequestRepository;

    public User authenticate(String username, String password) {
        return userRepository.findByUsername(username)
                .filter(user -> user.getPassword().equals(password))
                .orElse(null);
    }

    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) return;

        // 1. Delete all friend requests involving this user
        friendRequestRepository.deleteByUser(user);

        // 2. Remove this user from all friends' lists
        for (User friend : user.getFriends()) {
            friend.getFriends().remove(user);
            userRepository.save(friend);
        }
        user.getFriends().clear();

        // 3. Delete the user (Tasks will be deleted via CascadeType.ALL)
        userRepository.delete(user);
    }
}