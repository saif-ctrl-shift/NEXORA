package com.nexora.controller;

import com.nexora.dao.OrganizerDAO;
import com.nexora.dao.UserDAO;
import com.nexora.model.Organizer;
import com.nexora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final OrganizerDAO organizerDAO = new OrganizerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String roleParam = req.getParameter("role");
        if (roleParam != null && !roleParam.trim().isEmpty()) {
            req.setAttribute("selectedRole", roleParam.toUpperCase());
        } else {
            req.setAttribute("selectedRole", "STUDENT");
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String expectedRole = req.getParameter("role");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Please provide both email and password.");
            req.setAttribute("selectedRole", expectedRole != null ? expectedRole : "STUDENT");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(email.trim(), password);

        if (user == null) {
            req.setAttribute("error", "Invalid email or password. Please try again.");
            req.setAttribute("selectedRole", expectedRole != null ? expectedRole : "STUDENT");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Validate role selection match
        if (expectedRole != null && !expectedRole.trim().equalsIgnoreCase(user.getRole())) {
            req.setAttribute("error", "Role mismatch! This account is registered as " + user.getRole() + 
                                      ". Please use the " + user.getRole().toLowerCase() + " login portal.");
            req.setAttribute("selectedRole", expectedRole);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Create clean session
        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("isLoggedIn", true);

        if (user.isOrganizer()) {
            Organizer org = organizerDAO.findByUserId(user.getId());
            if (org != null) {
                session.setAttribute("organizer", org);
                session.setAttribute("organizerId", org.getId());
                session.setAttribute("clubName", org.getClubName());
            }
            resp.sendRedirect(req.getContextPath() + "/organizer/dashboard");
        } else {
            session.setAttribute("studentId", user.getId());
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}
