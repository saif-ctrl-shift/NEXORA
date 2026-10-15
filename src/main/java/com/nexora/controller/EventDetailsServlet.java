package com.nexora.controller;

import com.nexora.dao.EventDAO;
import com.nexora.dao.RegistrationDAO;
import com.nexora.model.Event;
import com.nexora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "EventDetailsServlet", urlPatterns = {"/event-details"})
public class EventDetailsServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/events");
            return;
        }

        try {
            int eventId = Integer.parseInt(idStr);
            Event event = eventDAO.getEventById(eventId);

            if (event == null) {
                req.setAttribute("errorMessage", "Event not found or has been removed.");
                req.getRequestDispatcher("/events/event-list.jsp").forward(req, resp);
                return;
            }

            // Check if logged in student is already registered
            boolean alreadyRegistered = false;
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                if (user.isStudent()) {
                    alreadyRegistered = registrationDAO.isStudentRegisteredForEvent(user.getId(), eventId);
                }
            }

            req.setAttribute("event", event);
            req.setAttribute("alreadyRegistered", alreadyRegistered);
            req.getRequestDispatcher("/events/event-details.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/events");
        }
    }
}
