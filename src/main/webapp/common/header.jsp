<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.User" %>
<%@ page import="com.nexora.model.Organizer" %>
<%
    User currentUser = (User) session.getAttribute("user");
    Organizer currentOrganizer = (Organizer) session.getAttribute("organizer");
    String currentRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : "NEXORA – College Event Management System | MHSSCE"}</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a href="<%= request.getContextPath() %>/" class="brand-logo" style="display: inline-flex; align-items: center; gap: 10px;">
            <span style="background: #ffffff; border-radius: 6px; padding: 2px 4px; display: inline-flex; align-items: center; justify-content: center; box-shadow: 0 1px 4px rgba(0,0,0,0.3); flex-shrink: 0;">
                <img src="<%= request.getContextPath() %>/images/college-logo.png" alt="Logo" style="height: 24px; width: auto; object-fit: contain;">
            </span>
            <span style="display: inline-flex; flex-direction: column;">
                <span style="font-size: 1.25rem; font-weight: 800; letter-spacing: 1.5px; line-height: 1; color: #ffffff;">NEXORA</span>
                <span class="brand-college-tag" style="font-size: 0.68rem; opacity: 0.85;">MHSSCE Mumbai</span>
            </span>
        </a>

        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/#events">Events</a></li>
            <li><a href="<%= request.getContextPath() %>/events">All Events</a></li>
            <li><a href="<%= request.getContextPath() %>/#clubs">Clubs</a></li>
            <li><a href="<%= request.getContextPath() %>/#about">About</a></li>
        </ul>

        <div class="nav-actions">
            <% if (currentUser == null) { %>
                <a href="<%= request.getContextPath() %>/login?role=STUDENT" class="btn btn-sm btn-outline-cyan">Student Login</a>
                <a href="<%= request.getContextPath() %>/login?role=ORGANIZER" class="btn btn-sm btn-outline-orange">Organizer Login</a>
            <% } else if ("ORGANIZER".equalsIgnoreCase(currentRole)) { %>
                <a href="<%= request.getContextPath() %>/organizer/create-event" class="btn btn-sm btn-primary-create">+ Create Event</a>
                <a href="<%= request.getContextPath() %>/organizer/dashboard" class="btn btn-sm btn-outline">Organizer Hub</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-sm btn-outline" style="border-color: rgba(255,59,48,0.4); color: #FF5C5C;">Logout</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/student/dashboard" class="btn btn-sm btn-primary-explore">My Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-sm btn-outline" style="border-color: rgba(255,59,48,0.4); color: #FF5C5C;">Logout</a>
            <% } %>
        </div>
    </div>
</nav>
<main class="main-content">
