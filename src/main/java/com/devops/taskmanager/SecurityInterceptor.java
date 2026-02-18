package com.devops.taskmanager;

import com.devops.taskmanager.Repository.UserRepository;
import com.devops.taskmanager.entities.User;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Optional;

@Component
public class SecurityInterceptor implements HandlerInterceptor {

    @Autowired
    private UserRepository userRepository;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String path = request.getRequestURI();
        if (path.equals("/login") || path.equals("/signup") || path.startsWith("/css") || path.startsWith("/js")) {
            return true;
        }

        if (request.getSession().getAttribute("loggedInUser") == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("remember_me".equals(cookie.getName())) {
                        String username = cookie.getValue();
                        Optional<User> user = userRepository.findByUsername(username);
                        if (user.isPresent()) {
                            request.getSession().setAttribute("loggedInUser", user.get());
                            return true;
                        }
                    }
                }
            }
            response.sendRedirect("/login");
            return false;
        }
        return true;
    }
}