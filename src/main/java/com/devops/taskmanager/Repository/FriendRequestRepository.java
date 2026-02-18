package com.devops.taskmanager.Repository;

import com.devops.taskmanager.entities.FriendRequest;
import com.devops.taskmanager.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface FriendRequestRepository extends JpaRepository<FriendRequest, Long> {
    List<FriendRequest> findByReceiverAndStatus(User receiver, FriendRequest.RequestStatus status);
    Optional<FriendRequest> findBySenderAndReceiver(User sender, User receiver);

    @Modifying
    @Transactional
    @Query("DELETE FROM FriendRequest f WHERE f.sender = ?1 OR f.receiver = ?1")
    void deleteByUser(User user);
}
