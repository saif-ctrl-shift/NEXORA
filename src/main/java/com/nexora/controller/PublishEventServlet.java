package com.nexora.controller;

import com.nexora.dao.EventDAO;
import com.nexora.dao.OrganizerDAO;
import com.nexora.model.Organizer;
import com.nexora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "PublishEventServlet", urlPatterns = {"/organizer/publish-event"})
public class PublishEventServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final OrganizerDAO organizerDAO = new OrganizerDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isOrganizer()) {
            resp.sendRedirect(req.getContextPath() + "/login?role=ORGANIZER");
            return;
        }

        Organizer org = (Organizer) session.getAttribute("organizer");
        if (org == null) {
            org = organizerDAO.findByUserId(user.getId());
        }

        if (org == null) {
            resp.sendRedirect(req.getContextPath() + "/organizer/dashboard");
            return;
        }

        String eventIdStr = req.getParameter("id");
        String newStatus = req.getParameter("status"); // PUBLISHED, DRAFT, CLOSED

        if (eventIdStr != null && newStatus != null) {
            try {
                int eventId = Integer.parseInt(eventIdStr);
                eventDAO.updateEventStatus(eventId, org.getId(), newStatus.toUpperCase().trim());
            } catch (NumberFormatException ignored) {}
        }

        resp.sendRedirect(req.getContextPath() + "/organizer/dashboard?msg=status_updated");
    }
}
