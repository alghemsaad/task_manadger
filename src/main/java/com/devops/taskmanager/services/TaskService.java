package com.devops.taskmanager.services;

import com.devops.taskmanager.entities.Task;
import com.devops.taskmanager.entities.TaskStatus;
import com.devops.taskmanager.entities.User;
import com.devops.taskmanager.Repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private com.devops.taskmanager.Repository.UserRepository userRepository;

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public List<Task> getSharedTasks(User user) {
        // Reload user to avoid LazyInitializationException since it's from session
        User reloadedUser = userRepository.findById(user.getId()).orElse(user);
        java.util.Set<User> visibleTo = new java.util.HashSet<>(reloadedUser.getFriends());
        visibleTo.add(reloadedUser);
        return taskRepository.findByUserIn(visibleTo);
    }

    public List<Task> getTasksByUserId(Long userId) {
        return taskRepository.findByUserId(userId);
    }

    public void saveTask(Task task) {
        taskRepository.save(task);
    }
    public Task getTaskById(Long id) {
        return taskRepository.findById(id).orElseThrow(() -> new RuntimeException("Task not found"));
    }
    public void deleteTask(Long id) {
        taskRepository.deleteById(id);
    }


    public void createTaskForUser(Task task, User user) {
        task.setUser(user);
        task.setStatus(TaskStatus.TODO);
        taskRepository.save(task);
    }

    public void updateTask(Task task) {
        taskRepository.save(task);
    }
}