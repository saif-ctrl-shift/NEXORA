package com.nexora.controller;

import com.nexora.dao.EventDAO;
import com.nexora.dao.OrganizerDAO;
import com.nexora.dao.RegistrationDAO;
import com.nexora.model.Event;
import com.nexora.model.Organizer;
import com.nexora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrganizerDashboardServlet", urlPatterns = {"/organizer/dashboard"})
public class OrganizerDashboardServlet extends HttpServlet {

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

        if (org == null) {
            req.setAttribute("errorMessage", "Organizer club profile could not be located.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        int organizerId = org.getId();
        int totalEvents = eventDAO.getOrganizerEventCount(organizerId);
        int upcomingCount = eventDAO.getOrganizerUpcomingCount(organizerId);
        int activeCount = eventDAO.getOrganizerActiveCount(organizerId);
        int totalRegistrations = registrationDAO.getTotalRegistrationsForOrganizer(organizerId);

        List<Event> myEvents = eventDAO.getEventsByOrganizerId(organizerId);

        req.setAttribute("totalEvents", totalEvents);
        req.setAttribute("upcomingCount", upcomingCount);
        req.setAttribute("activeCount", activeCount);
        req.setAttribute("totalRegistrations", totalRegistrations);
        req.setAttribute("events", myEvents);
        req.setAttribute("organizer", org);

        req.getRequestDispatcher("/organizer/dashboard.jsp").forward(req, resp);
    }
}
