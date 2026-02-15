package com.devops.taskmanager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class SecurityInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String path = request.getRequestURI();
        if (path.equals("/login") || path.equals("/signup") || path.startsWith("/css") || path.startsWith("/js")) {
            return true;
        }

        if (request.getSession().getAttribute("loggedInUser") == null) {
            response.sendRedirect("/login");
            return false;
        }
        return true;
    }
}