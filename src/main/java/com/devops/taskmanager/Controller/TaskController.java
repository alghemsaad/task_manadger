package com.devops.taskmanager.Controller;

import com.devops.taskmanager.entities.Task;
import com.devops.taskmanager.entities.TaskStatus;
import com.devops.taskmanager.entities.User;
import com.devops.taskmanager.services.TaskService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class TaskController {

    @Autowired
    private TaskService taskService;

    @GetMapping("/tasks")
    public String listTasks(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        List<Task> tasks = taskService.getSharedTasks(loggedInUser);
        model.addAttribute("tasks", tasks);
        model.addAttribute("viewMode", "all");
        return "list";
    }

    @GetMapping("/my-tasks")
    public String listMyTasks(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";
        
        List<Task> tasks = taskService.getTasksByUserId(loggedInUser.getId());
        model.addAttribute("tasks", tasks);
        model.addAttribute("viewMode", "mine");
        return "list";
    }

    @PostMapping("/tasks/add")
    public String addTask(@ModelAttribute Task task, @RequestParam(required = false) String redirect, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            return "redirect:/login";
        }
        taskService.createTaskForUser(task, loggedInUser);
        return (redirect != null && !redirect.isEmpty()) ? "redirect:" + redirect : "redirect:/tasks";
    }

    @GetMapping("/tasks/update")
    public String updateTaskStatus(@RequestParam Long id, @RequestParam String status, @RequestParam(required = false) String redirect, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        Task task = taskService.getTaskById(id);

        if (task != null && task.getUser().getId().equals(loggedInUser.getId())) {
            try {
                task.setStatus(TaskStatus.valueOf(status.toUpperCase()));
                taskService.updateTask(task);
            } catch (IllegalArgumentException e) {
                return "redirect:/tasks?error=invalid_status";
            }
        }
        return (redirect != null && !redirect.isEmpty()) ? "redirect:" + redirect : "redirect:/tasks";
    }

    @GetMapping("/tasks/delete")
    public String deleteTask(@RequestParam Long id, @RequestParam(required = false) String redirect, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        try {
            Task task = taskService.getTaskById(id);
            if (task.getUser().getId().equals(loggedInUser.getId())) {
                taskService.deleteTask(id);
            }
        } catch (RuntimeException e) {
            // Task not found, skip deletion
        }
        return (redirect != null && !redirect.isEmpty()) ? "redirect:" + redirect : "redirect:/tasks";
    }
}