package com.devops.taskmanager.Controller;
import com.devops.taskmanager.Repository.UserRepository;
import org.springframework.ui.Model;
import com.devops.taskmanager.entities.User;
import com.devops.taskmanager.services.AuthService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
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
                        @RequestParam(required = false) String rememberMe,
                        HttpSession session,
                        HttpServletResponse response,
                        Model model) {
        User user = authService.authenticate(username, password);
        if (user != null) {
            session.setAttribute("loggedInUser", user);
            
            if (rememberMe != null) {
                Cookie cookie = new Cookie("remember_me", user.getUsername());
                cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                cookie.setPath("/");
                response.addCookie(cookie);
            }
            
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
    public String logout(HttpSession session, HttpServletResponse response) {
        session.invalidate();
        Cookie cookie = new Cookie("remember_me", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
        return "redirect:/login";
    }

    @GetMapping("/profile")
    public String profilePage(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login";
        }
        return "profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String username,
                                @RequestParam String email,
                                @RequestParam(required = false) String password,
                                HttpSession session,
                                Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        // Re-load user from DB to ensure we have the latest state and can save updates
        User user = userRepository.findById(loggedInUser.getId()).orElse(null);
        if (user == null) {
            return "redirect:/login";
        }

        // Check if username is changed and if it already exists
        if (!user.getUsername().equals(username) && userRepository.findByUsername(username).isPresent()) {
            model.addAttribute("error", "Username already exists.");
            return "profile";
        }

        user.setUsername(username);
        user.setEmail(email);
        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(password);
        }

        userRepository.save(user);
        session.setAttribute("loggedInUser", user);
        model.addAttribute("success", "Profile updated successfully!");
        return "profile";
    }

    @PostMapping("/profile/delete")
    public String deleteProfile(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        authService.deleteUser(loggedInUser.getId());
        session.invalidate();
        return "redirect:/signup?deleted";
    }
}