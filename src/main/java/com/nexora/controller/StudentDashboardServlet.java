package com.nexora.controller;

import com.nexora.dao.EventDAO;
import com.nexora.dao.RegistrationDAO;
import com.nexora.model.Event;
import com.nexora.model.Registration;
import com.nexora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {

    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isStudent()) {
            resp.sendRedirect(req.getContextPath() + "/login?role=STUDENT");
            return;
        }

        List<Registration> myRegistrations = registrationDAO.getRegistrationsByStudentId(user.getId());
        List<Event> upcomingEvents = eventDAO.getUpcomingEvents(4);

        req.setAttribute("myRegistrations", myRegistrations);
        req.setAttribute("upcomingEvents", upcomingEvents);
        req.setAttribute("student", user);

        req.getRequestDispatcher("/student/dashboard.jsp").forward(req, resp);
    }
}
