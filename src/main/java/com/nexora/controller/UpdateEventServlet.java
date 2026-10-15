package com.nexora.controller;

import com.nexora.dao.EventDAO;
import com.nexora.dao.OrganizerDAO;
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
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

@WebServlet(name = "UpdateEventServlet", urlPatterns = {"/organizer/edit-event"})
public class UpdateEventServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final OrganizerDAO organizerDAO = new OrganizerDAO();

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

        String eventIdStr = req.getParameter("id");
        if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/organizer/dashboard");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventDAO.getEventById(eventId);

            // Enforce ownership!
            if (event == null || org == null || event.getOrganizerId() != org.getId()) {
                resp.sendRedirect(req.getContextPath() + "/organizer/dashboard?error=unauthorized");
                return;
            }

            req.setAttribute("event", event);
            req.getRequestDispatcher("/organizer/edit-event.jsp").forward(req, resp);

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

        String eventIdStr = req.getParameter("id");
        String title = req.getParameter("title");
        String category = req.getParameter("category");
        String description = req.getParameter("description");
        String eventDateStr = req.getParameter("eventDate");
        String startTimeStr = req.getParameter("startTime");
        String endTimeStr = req.getParameter("endTime");
        String venue = req.getParameter("venue");
        String eligibility = req.getParameter("eligibility");
        String rules = req.getParameter("rules");
        String deadlineStr = req.getParameter("registrationDeadline");
        String capacityStr = req.getParameter("capacity");
        String status = req.getParameter("status");
        String banner = req.getParameter("banner");

        if (eventIdStr == null || eventIdStr.trim().isEmpty() || org == null) {
            resp.sendRedirect(req.getContextPath() + "/organizer/dashboard");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event existingEvent = eventDAO.getEventById(eventId);

            // Ownership check!
            if (existingEvent == null || existingEvent.getOrganizerId() != org.getId()) {
                resp.sendRedirect(req.getContextPath() + "/organizer/dashboard?error=unauthorized");
                return;
            }

            existingEvent.setTitle(title.trim());
            existingEvent.setCategory(category.trim());
            existingEvent.setDescription(description.trim());
            existingEvent.setEventDate(Date.valueOf(eventDateStr.trim()));

            String startFormatted = (startTimeStr != null && !startTimeStr.trim().isEmpty()) 
                ? (startTimeStr.trim().length() == 5 ? startTimeStr.trim() + ":00" : startTimeStr.trim()) 
                : "10:00:00";
            String endFormatted = (endTimeStr != null && !endTimeStr.trim().isEmpty()) 
                ? (endTimeStr.trim().length() == 5 ? endTimeStr.trim() + ":00" : endTimeStr.trim()) 
                : "17:00:00";

            existingEvent.setStartTime(Time.valueOf(startFormatted));
            existingEvent.setEndTime(Time.valueOf(endFormatted));
            existingEvent.setVenue(venue != null ? venue.trim() : "MHSSCE Campus");
            existingEvent.setEligibility(eligibility != null ? eligibility.trim() : "All Students");
            existingEvent.setRules(rules != null ? rules.trim() : "");

            String cleanDeadline = deadlineStr.replace("T", " ");
            if (cleanDeadline.length() == 16) {
                cleanDeadline += ":00";
            }
            existingEvent.setRegistrationDeadline(Timestamp.valueOf(cleanDeadline));

            int cap = (capacityStr != null && !capacityStr.trim().isEmpty()) ? Integer.parseInt(capacityStr.trim()) : 100;
            existingEvent.setCapacity(cap);

            if (status != null && !status.trim().isEmpty()) {
                existingEvent.setStatus(status.toUpperCase().trim());
            }

            if (banner != null && !banner.trim().isEmpty()) {
                existingEvent.setBanner(banner.trim());
            }

            boolean updated = eventDAO.updateEvent(existingEvent);
            if (updated) {
                resp.sendRedirect(req.getContextPath() + "/organizer/dashboard?msg=updated");
            } else {
                req.setAttribute("errorMessage", "Failed to update event.");
                req.setAttribute("event", existingEvent);
                req.getRequestDispatcher("/organizer/edit-event.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/organizer/dashboard?error=invalid_data");
        }
    }
}
