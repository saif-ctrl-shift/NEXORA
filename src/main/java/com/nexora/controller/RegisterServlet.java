package com.nexora.controller;

import com.nexora.dao.UserDAO;
import com.nexora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String department = req.getParameter("department");
        String year = req.getParameter("year");
        String rollNumber = req.getParameter("rollNumber");
        String mobile = req.getParameter("mobile");

        // Basic validations
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Full name, email, and password are required fields.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match. Please verify and re-enter.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.findByEmail(email.trim()) != null) {
            req.setAttribute("error", "An account with this email address already exists. Please login instead.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User newUser = new User();
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPassword(password);
        newUser.setRole("STUDENT"); // Registration is for students
        newUser.setDepartment(department != null ? department.trim() : "");
        newUser.setYear(year != null ? year.trim() : "");
        newUser.setRollNumber(rollNumber != null ? rollNumber.trim() : "");
        newUser.setMobile(mobile != null ? mobile.trim() : "");

        boolean success = userDAO.createUser(newUser);
        if (success) {
            // Auto login student
            HttpSession session = req.getSession(true);
            session.setAttribute("user", newUser);
            session.setAttribute("userId", newUser.getId());
            session.setAttribute("studentId", newUser.getId());
            session.setAttribute("userName", newUser.getFullName());
            session.setAttribute("userEmail", newUser.getEmail());
            session.setAttribute("userRole", "STUDENT");
            session.setAttribute("isLoggedIn", true);

            resp.sendRedirect(req.getContextPath() + "/student/dashboard?registered=true");
        } else {
            req.setAttribute("error", "Failed to create account due to a database issue. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
