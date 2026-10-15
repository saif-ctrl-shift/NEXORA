package com.nexora.controller;

import com.nexora.dao.EventDAO;
import com.nexora.model.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EventServlet", urlPatterns = {"/events"})
public class EventServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("search");
        String category = req.getParameter("category");

        List<Event> eventList = eventDAO.getPublishedEvents(keyword, category);

        req.setAttribute("events", eventList);
        req.setAttribute("selectedCategory", category != null ? category : "ALL");
        req.setAttribute("searchTerm", keyword != null ? keyword : "");

        req.getRequestDispatcher("/events/event-list.jsp").forward(req, resp);
    }
}
