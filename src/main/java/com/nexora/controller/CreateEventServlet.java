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

@WebServlet(name = "CreateEventServlet", urlPatterns = {"/organizer/create-event"})
public class CreateEventServlet extends HttpServlet {

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

        req.getRequestDispatcher("/organizer/create-event.jsp").forward(req, resp);
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
            }
        }

        if (org == null) {
            resp.sendRedirect(req.getContextPath() + "/login?role=ORGANIZER");
            return;
        }

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
        String banner = req.getParameter("banner");
        String action = req.getParameter("action"); // "draft" or "publish"

        if (title == null || title.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            eventDateStr == null || eventDateStr.trim().isEmpty() ||
            deadlineStr == null || deadlineStr.trim().isEmpty()) {

            req.setAttribute("errorMessage", "Title, Category, Description, Date, and Deadline are required.");
            req.getRequestDispatcher("/organizer/create-event.jsp").forward(req, resp);
            return;
        }

        try {
            Event event = new Event();
            event.setOrganizerId(org.getId()); // Secured from session!
            event.setTitle(title.trim());
            event.setCategory(category.trim());
            event.setDescription(description.trim());
            event.setEventDate(Date.valueOf(eventDateStr.trim()));
            
            // Format time strings (ensure HH:mm:ss)
            String startFormatted = (startTimeStr != null && !startTimeStr.trim().isEmpty()) 
                ? (startTimeStr.trim().length() == 5 ? startTimeStr.trim() + ":00" : startTimeStr.trim()) 
                : "10:00:00";
            String endFormatted = (endTimeStr != null && !endTimeStr.trim().isEmpty()) 
                ? (endTimeStr.trim().length() == 5 ? endTimeStr.trim() + ":00" : endTimeStr.trim()) 
                : "17:00:00";
            
            event.setStartTime(Time.valueOf(startFormatted));
            event.setEndTime(Time.valueOf(endFormatted));
            event.setVenue(venue != null ? venue.trim() : "MHSSCE Campus");
            event.setEligibility(eligibility != null ? eligibility.trim() : "All Engineering Students");
            event.setRules(rules != null ? rules.trim() : "");

            // Parse deadline (e.g., 2026-10-25T18:00 or 2026-10-25 18:00:00)
            String cleanDeadline = deadlineStr.replace("T", " ");
            if (cleanDeadline.length() == 16) {
                cleanDeadline += ":00";
            }
            event.setRegistrationDeadline(Timestamp.valueOf(cleanDeadline));

            int capacity = (capacityStr != null && !capacityStr.trim().isEmpty()) 
                ? Integer.parseInt(capacityStr.trim()) : 100;
            event.setCapacity(capacity);

            // Status: DRAFT or PUBLISHED
            if ("publish".equalsIgnoreCase(action)) {
                event.setStatus("PUBLISHED");
            } else {
                event.setStatus("DRAFT");
            }

            event.setBanner(banner != null && !banner.trim().isEmpty() ? banner.trim() : "default_event.jpg");

            int generatedId = eventDAO.createEvent(event);
            if (generatedId > 0) {
                resp.sendRedirect(req.getContextPath() + "/organizer/dashboard?msg=created");
            } else {
                req.setAttribute("errorMessage", "Failed to create event in database. Please check inputs.");
                req.getRequestDispatcher("/organizer/create-event.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Invalid date/time format: " + e.getMessage());
            req.getRequestDispatcher("/organizer/create-event.jsp").forward(req, resp);
        }
    }
}
