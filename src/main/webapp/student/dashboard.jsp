<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.User" %>
<%@ page import="com.nexora.model.Registration" %>
<%@ page import="com.nexora.model.Event" %>
<%@ page import="java.util.List" %>
<%
    User student = (User) request.getAttribute("student");
    if (student == null) student = (User) session.getAttribute("user");
    List<Registration> myRegistrations = (List<Registration>) request.getAttribute("myRegistrations");
    List<Event> upcomingEvents = (List<Event>) request.getAttribute("upcomingEvents");
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Student Dashboard – NEXORA" />
</jsp:include>

<!-- Student Dashboard Header -->
<div class="dashboard-header">
    <div class="dashboard-header-inner">
        <div>
            <span class="section-eyebrow">MHSSCE Student Portal</span>
            <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--text-white);">
                Welcome back, <%= student != null ? student.getFullName() : "Student" %>!
            </h1>
            <p style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 4px;">
                <%= student != null ? student.getDepartment() + " • " + student.getYear() + " (Roll: " + student.getRollNumber() + ")" : "" %>
            </p>
        </div>
        <div style="display: flex; gap: 12px;">
            <a href="<%= request.getContextPath() %>/events" class="btn btn-primary-explore">
                ⚡ Explore New Events
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline" style="border-color: rgba(255,59,48,0.4); color: #FF5C5C;">
                Logout
            </a>
        </div>
    </div>
</div>

<div class="section-container" style="padding-top: 36px; padding-bottom: 80px;">
    
    <!-- Quick Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon cyan">🎟️</div>
            <div>
                <div class="stat-value"><%= myRegistrations != null ? myRegistrations.size() : 0 %></div>
                <div class="stat-label">My Registered Events</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon orange">🏛️</div>
            <div>
                <div class="stat-value"><%= student != null ? student.getDepartment() : "Engineering" %></div>
                <div class="stat-label">Department</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">🎓</div>
            <div>
                <div class="stat-value"><%= student != null ? student.getRollNumber() : "-" %></div>
                <div class="stat-label">Roll Number</div>
            </div>
        </div>
    </div>

    <!-- My Registrations Section -->
    <div style="margin-bottom: 50px;">
        <div class="section-header">
            <div class="section-title-wrap">
                <span class="section-eyebrow">Registered Passes</span>
                <h2 class="section-title">My Registrations</h2>
            </div>
            <a href="<%= request.getContextPath() %>/events" class="btn btn-sm btn-outline-cyan">
                + Register for More Events
            </a>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Registration ID</th>
                        <th>Event Name</th>
                        <th>Category</th>
                        <th>Event Date</th>
                        <th>Venue</th>
                        <th>Registration Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (myRegistrations != null && !myRegistrations.isEmpty()) { 
                        for (Registration reg : myRegistrations) { %>
                        <tr>
                            <td>
                                <span style="font-family: monospace; font-weight: 700; color: var(--accent-cyan); font-size: 0.95rem;">
                                    <%= reg.getRegistrationId() %>
                                </span>
                            </td>
                            <td>
                                <strong style="color: var(--text-white); font-size: 0.95rem;"><%= reg.getEventTitle() %></strong>
                                <div style="font-size: 0.78rem; color: var(--text-muted);"><%= reg.getClubName() %></div>
                            </td>
                            <td>
                                <span class="category-badge badge-default"><%= reg.getEventCategory() %></span>
                            </td>
                            <td><%= reg.getEventDate() %></td>
                            <td><%= reg.getEventVenue() %></td>
                            <td style="font-size: 0.82rem; color: var(--text-muted);"><%= reg.getRegistrationDate().toString().substring(0, 16) %></td>
                            <td>
                                <span class="status-badge <%= reg.getStatusBadgeClass() %>">
                                    <%= reg.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <a href="<%= request.getContextPath() %>/event-details?id=<%= reg.getEventId() %>" 
                                   class="btn btn-sm btn-outline" style="font-size: 0.8rem; padding: 4px 10px;">
                                    View Event
                                </a>
                            </td>
                        </tr>
                    <%  }
                    } else { %>
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 48px 20px; color: var(--text-muted);">
                                <p style="font-size: 1.1rem; margin-bottom: 12px;">You haven't registered for any events yet.</p>
                                <a href="<%= request.getContextPath() %>/events" class="btn btn-sm btn-primary-explore">
                                    Browse Events Directory
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Suggested Upcoming Events Section -->
    <div>
        <div class="section-header">
            <div class="section-title-wrap">
                <span class="section-eyebrow" style="color: var(--accent-yellow);">Opportunities</span>
                <h2 class="section-title">Recommended Upcoming Events</h2>
            </div>
            <a href="<%= request.getContextPath() %>/events" class="btn btn-sm btn-outline">
                All Events &rarr;
            </a>
        </div>

        <div class="event-grid">
            <% if (upcomingEvents != null) { 
                for (Event ev : upcomingEvents) { %>
                <div class="event-card">
                    <div class="event-card-header">
                        <span class="event-club-tag"><%= ev.getClubName() %></span>
                        <span class="category-badge <%= ev.getCategoryBadgeClass() %>"><%= ev.getCategory() %></span>
                    </div>
                    <div class="event-card-body">
                        <h4 class="event-title"><%= ev.getTitle() %></h4>
                        <div class="event-meta-list">
                            <div class="event-meta-item">
                                <span>📅</span> <%= ev.getEventDate() %>
                            </div>
                            <div class="event-meta-item">
                                <span>📍</span> <%= ev.getVenue() %>
                            </div>
                        </div>
                    </div>
                    <div class="event-card-footer">
                        <span style="font-size: 0.8rem; color: var(--accent-cyan);"><%= ev.getRemainingSeats() %> seats left</span>
                        <a href="<%= request.getContextPath() %>/event-details?id=<%= ev.getId() %>" class="btn btn-sm btn-outline-cyan">
                            Details
                        </a>
                    </div>
                </div>
            <%  }
            } %>
        </div>
    </div>

</div>

<jsp:include page="../common/footer.jsp" />
