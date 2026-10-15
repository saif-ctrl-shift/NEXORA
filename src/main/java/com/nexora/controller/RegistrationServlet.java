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

@WebServlet(name = "RegistrationServlet", urlPatterns = {"/register-event"})
public class RegistrationServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        String eventIdStr = req.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/events");
            return;
        }

        if (user == null || !user.isStudent()) {
            resp.sendRedirect(req.getContextPath() + "/login?role=STUDENT&redirect=" + 
                              req.getContextPath() + "/register-event?eventId=" + eventIdStr);
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventDAO.getEventById(eventId);

            if (event == null || !event.isPublished()) {
                req.setAttribute("errorMessage", "Event is not available for registration.");
                req.getRequestDispatcher("/events/event-list.jsp").forward(req, resp);
                return;
            }

            if (event.isDeadlinePassed()) {
                req.setAttribute("errorMessage", "Registration deadline for this event has passed.");
                req.setAttribute("event", event);
                req.getRequestDispatcher("/events/event-details.jsp").forward(req, resp);
                return;
            }

            if (event.isFull()) {
                req.setAttribute("errorMessage", "Event capacity has been reached. Registrations are closed.");
                req.setAttribute("event", event);
                req.getRequestDispatcher("/events/event-details.jsp").forward(req, resp);
                return;
            }

            if (registrationDAO.isStudentRegisteredForEvent(user.getId(), eventId)) {
                req.setAttribute("errorMessage", "You are already registered for this event.");
                req.setAttribute("event", event);
                req.setAttribute("alreadyRegistered", true);
                req.getRequestDispatcher("/events/event-details.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("event", event);
            req.setAttribute("student", user);
            req.getRequestDispatcher("/student/register-event.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/events");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isStudent()) {
            resp.sendRedirect(req.getContextPath() + "/login?role=STUDENT");
            return;
        }

        String eventIdStr = req.getParameter("eventId");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String mobile = req.getParameter("mobile");
        String college = req.getParameter("college");
        String department = req.getParameter("department");
        String year = req.getParameter("year");
        String rollNumber = req.getParameter("rollNumber");
        String teamName = req.getParameter("teamName");
        String teamMembers = req.getParameter("teamMembers");
        String additionalInfo = req.getParameter("additionalInformation");

        if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/events");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventDAO.getEventById(eventId);

            if (event == null || !event.isPublished()) {
                req.setAttribute("errorMessage", "Event is no longer active or published.");
                req.getRequestDispatcher("/events/event-list.jsp").forward(req, resp);
                return;
            }

            // 1. Server-side deadline check
            if (event.isDeadlinePassed()) {
                req.setAttribute("errorMessage", "Registration deadline has passed. Submission rejected.");
                req.setAttribute("event", event);
                req.getRequestDispatcher("/events/event-details.jsp").forward(req, resp);
                return;
            }

            // 2. Server-side capacity check
            int currentCount = registrationDAO.getRegistrationCountForEvent(eventId);
            if (event.getCapacity() > 0 && currentCount >= event.getCapacity()) {
                req.setAttribute("errorMessage", "EVENT FULL: Capacity limit reached.");
                req.setAttribute("event", event);
                req.getRequestDispatcher("/events/event-details.jsp").forward(req, resp);
                return;
            }

            // 3. Server-side duplicate registration check
            if (registrationDAO.isStudentRegisteredForEvent(user.getId(), eventId)) {
                req.setAttribute("errorMessage", "You are already registered for this event.");
                req.setAttribute("event", event);
                req.setAttribute("alreadyRegistered", true);
                req.getRequestDispatcher("/events/event-details.jsp").forward(req, resp);
                return;
            }

            // 4. Input validation
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                mobile == null || mobile.trim().isEmpty() ||
                college == null || college.trim().isEmpty() ||
                department == null || department.trim().isEmpty() ||
                rollNumber == null || rollNumber.trim().isEmpty()) {

                req.setAttribute("errorMessage", "Please fill in all required registration fields.");
                req.setAttribute("event", event);
                req.setAttribute("student", user);
                req.getRequestDispatcher("/student/register-event.jsp").forward(req, resp);
                return;
            }

            // 5. Generate real unique Registration ID
            String uniqueRegId = registrationDAO.generateUniqueRegistrationId();

            Registration reg = new Registration();
            reg.setRegistrationId(uniqueRegId);
            reg.setEventId(eventId);
            reg.setStudentId(user.getId());
            reg.setFullName(fullName.trim());
            reg.setEmail(email.trim());
            reg.setMobile(mobile.trim());
            reg.setCollege(college.trim());
            reg.setDepartment(department.trim());
            reg.setYear(year != null ? year.trim() : "");
            reg.setRollNumber(rollNumber.trim());
            reg.setTeamName(teamName != null ? teamName.trim() : "");
            reg.setTeamMembers(teamMembers != null ? teamMembers.trim() : "");
            reg.setAdditionalInformation(additionalInfo != null ? additionalInfo.trim() : "");
            reg.setStatus("REGISTERED");

            boolean inserted = registrationDAO.createRegistration(reg);

            if (inserted) {
                // Fetch complete registration with joined data for confirmation view
                Registration savedReg = registrationDAO.getRegistrationByCode(uniqueRegId);
                req.setAttribute("registration", savedReg != null ? savedReg : reg);
                req.setAttribute("event", event);
                req.getRequestDispatcher("/student/registration-success.jsp").forward(req, resp);
            } else {
                req.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
                req.setAttribute("event", event);
                req.setAttribute("student", user);
                req.getRequestDispatcher("/student/register-event.jsp").forward(req, resp);
            }

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/events");
        }
    }
}
