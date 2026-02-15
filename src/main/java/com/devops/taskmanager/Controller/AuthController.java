package com.devops.taskmanager.Controller;
import com.devops.taskmanager.Repository.UserRepository;
import org.springframework.ui.Model;
import com.devops.taskmanager.entities.User;
import com.devops.taskmanager.services.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/login")
    public String loginPage() {
        return "login"; }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {
        User user = authService.authenticate(username, password);
        if (user != null) {
            session.setAttribute("loggedInUser", user);
            return "redirect:/tasks";
        }
        model.addAttribute("error", "Incorrect username or password. Please try again.");        return "login";
    }


    @GetMapping("/signup")
    public String signupPage() {
        return "signup";}

    @PostMapping("/signup")
    public String register(@ModelAttribute User user, Model model) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty() ||
            user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            model.addAttribute("error", "Username and password are required.");
            return "signup";
        }
        
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            model.addAttribute("error", "Username already exists. Please choose another one.");            return "signup";
        }

        userRepository.save(user);
        return "redirect:/login?success";
    }


    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}