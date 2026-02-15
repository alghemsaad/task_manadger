package com.devops.taskmanager.Repository;

import com.devops.taskmanager.entities.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    java.util.List<Task> findByUserId(Long userId);
    java.util.List<Task> findByUserIn(java.util.Collection<com.devops.taskmanager.entities.User> users);
}