package com.nexora.controller;

import com.nexora.dao.EventDAO;
import com.nexora.dao.OrganizerDAO;
import com.nexora.dao.RegistrationDAO;
import com.nexora.model.Event;
import com.nexora.model.Organizer;
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

@WebServlet(name = "OrganizerRegistrationServlet", urlPatterns = {"/organizer/event-registrations"})
public class OrganizerRegistrationServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final OrganizerDAO organizerDAO = new OrganizerDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isOrganizer()) {
            resp.sendRedirect(req.getContextPath() + "/login?role=ORGANIZER");
            return;
        }

        Organizer org = (Organizer) session.getAttribute("organizer");
        if (org == null) {
            org = organizerDAO.findByUserId(user.getId());
            if (org != null) {
                session.setAttribute("organizer", org);
                session.setAttribute("organizerId", org.getId());
                session.setAttribute("clubName", org.getClubName());
            }
        }

        String eventIdStr = req.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.trim().isEmpty() || org == null) {
            resp.sendRedirect(req.getContextPath() + "/organizer/dashboard");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventDAO.getEventById(eventId);

            // Enforce ownership!
            if (event == null || event.getOrganizerId() != org.getId()) {
                resp.sendRedirect(req.getContextPath() + "/organizer/dashboard?error=unauthorized");
                return;
            }

            String search = req.getParameter("search");
            String status = req.getParameter("status");
            String sort = req.getParameter("sort");

            List<Registration> registrations = registrationDAO.getRegistrationsByEventId(eventId, org.getId(), search, status, sort);

            req.setAttribute("event", event);
            req.setAttribute("registrations", registrations);
            req.setAttribute("searchTerm", search != null ? search : "");
            req.setAttribute("statusFilter", status != null ? status : "ALL");
            req.setAttribute("sortBy", sort != null ? sort : "recent");

            req.getRequestDispatcher("/organizer/event-registrations.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/organizer/dashboard");
        }
    }

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
            if (org != null) {
                session.setAttribute("organizer", org);
                session.setAttribute("organizerId", org.getId());
                session.setAttribute("clubName", org.getClubName());
            }
        }

        String eventIdStr = req.getParameter("eventId");
        String regIdStr = req.getParameter("registrationId");
        String newStatus = req.getParameter("newStatus"); // REGISTERED, APPROVED, REJECTED, CANCELLED

        if (eventIdStr != null && regIdStr != null && newStatus != null && org != null) {
            try {
                int regId = Integer.parseInt(regIdStr);
                // DAO enforces ownership match: UPDATE registrations r JOIN events e ON r.event_id=e.id SET r.status=? WHERE r.id=? AND e.organizer_id=?
                boolean updated = registrationDAO.updateRegistrationStatus(regId, newStatus, org.getId());
                if (updated) {
                    resp.sendRedirect(req.getContextPath() + "/organizer/event-registrations?eventId=" + eventIdStr + "&msg=status_updated");
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }

        resp.sendRedirect(req.getContextPath() + "/organizer/event-registrations?eventId=" + (eventIdStr != null ? eventIdStr : "") + "&error=update_failed");
    }
}
