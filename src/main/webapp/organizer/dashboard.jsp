<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.Event" %>
<%@ page import="com.nexora.model.Organizer" %>
<%@ page import="java.util.List" %>
<%
    Organizer organizerObj = (Organizer) request.getAttribute("organizer");
    if (organizerObj == null) organizerObj = (Organizer) session.getAttribute("organizer");

    Integer totalEvents = (Integer) request.getAttribute("totalEvents");
    Integer totalRegistrations = (Integer) request.getAttribute("totalRegistrations");
    Integer upcomingCount = (Integer) request.getAttribute("upcomingCount");
    Integer activeCount = (Integer) request.getAttribute("activeCount");

    List<Event> events = (List<Event>) request.getAttribute("events");

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Event Organizer Dashboard – NEXORA" />
</jsp:include>

<!-- Organizer Header -->
<div class="dashboard-header">
    <div class="dashboard-header-inner">
        <div>
            <span class="section-eyebrow" style="color: var(--accent-orange);">Event Organizer Portal</span>
            <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--text-white);">
                <%= organizerObj != null ? organizerObj.getClubName() : "College Club" %>
            </h1>
            <p style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 4px;">
                Organizer Lead: <strong><%= organizerObj != null ? organizerObj.getOrganizerName() : "Faculty/Club Lead" %></strong> • MHSSCE
            </p>
        </div>
        <div style="display: flex; gap: 12px;">
            <a href="<%= request.getContextPath() %>/organizer/create-event" class="btn btn-primary-create">
                + Create New Event
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline" style="border-color: rgba(255,59,48,0.4); color: #FF5C5C;">
                Logout
            </a>
        </div>
    </div>
</div>

<div class="section-container" style="padding-top: 36px; padding-bottom: 80px;">
    
    <!-- Flash Messages -->
    <% if ("created".equalsIgnoreCase(msg)) { %>
        <div class="alert alert-success">
            <span>✓</span> <span>Event created successfully!</span>
        </div>
    <% } else if ("updated".equalsIgnoreCase(msg)) { %>
        <div class="alert alert-success">
            <span>✓</span> <span>Event updated successfully!</span>
        </div>
    <% } else if ("deleted".equalsIgnoreCase(msg)) { %>
        <div class="alert alert-success">
            <span>✓</span> <span>Event deleted successfully.</span>
        </div>
    <% } else if ("status_updated".equalsIgnoreCase(msg)) { %>
        <div class="alert alert-success">
            <span>✓</span> <span>Event status updated successfully.</span>
        </div>
    <% } else if (error != null) { %>
        <div class="alert alert-error">
            <span>⚠️</span> <span>Action could not be performed or unauthorized.</span>
        </div>
    <% } %>

    <!-- Organizer Metrics / Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon cyan">📊</div>
            <div>
                <div class="stat-value"><%= totalEvents != null ? totalEvents : 0 %></div>
                <div class="stat-label">Total Events</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon orange">👥</div>
            <div>
                <div class="stat-value"><%= totalRegistrations != null ? totalRegistrations : 0 %></div>
                <div class="stat-label">Total Registrations</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">⚡</div>
            <div>
                <div class="stat-value"><%= activeCount != null ? activeCount : 0 %></div>
                <div class="stat-label">Active Published</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon yellow">📅</div>
            <div>
                <div class="stat-value"><%= upcomingCount != null ? upcomingCount : 0 %></div>
                <div class="stat-label">Upcoming Events</div>
            </div>
        </div>
    </div>

    <!-- Managed Events Table -->
    <div class="section-header">
        <div class="section-title-wrap">
            <span class="section-eyebrow">Club Events</span>
            <h2 class="section-title">Manage Your Events</h2>
        </div>
        <a href="<%= request.getContextPath() %>/organizer/create-event" class="btn btn-sm btn-primary-create">
            + New Event
        </a>
    </div>

    <div class="table-responsive">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Event Name</th>
                    <th>Category</th>
                    <th>Event Date</th>
                    <th>Registered / Capacity</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (events != null && !events.isEmpty()) { 
                    for (Event ev : events) { %>
                    <tr>
                        <td>
                            <strong style="color: var(--text-white); font-size: 0.98rem;"><%= ev.getTitle() %></strong>
                            <div style="font-size: 0.78rem; color: var(--text-muted); margin-top: 2px;">
                                📍 <%= ev.getVenue() %> • ⏳ Deadline: <%= ev.getRegistrationDeadline().toString().substring(0, 10) %>
                            </div>
                        </td>
                        <td>
                            <span class="category-badge <%= ev.getCategoryBadgeClass() %>"><%= ev.getCategory() %></span>
                        </td>
                        <td>
                            <strong><%= ev.getEventDate() %></strong>
                            <div style="font-size: 0.76rem; color: var(--text-muted);"><%= ev.getStartTime() %></div>
                        </td>
                        <td>
                            <div style="font-weight: 700; color: var(--text-white); margin-bottom: 4px;">
                                <%= ev.getRegistrationCount() %> / <%= ev.getCapacity() %>
                            </div>
                            <div class="progress-bar-bg" style="height: 5px; width: 120px;">
                                <div class="progress-bar-fill <%= ev.getCapacityPercentage() >= 85 ? "near-full" : "" %>" 
                                     style="width: <%= ev.getCapacityPercentage() %>%;"></div>
                            </div>
                        </td>
                        <td>
                            <% if (ev.isPublished()) { %>
                                <span class="status-badge status-published">PUBLISHED</span>
                            <% } else if (ev.isDraft()) { %>
                                <span class="status-badge status-draft">DRAFT</span>
                            <% } else { %>
                                <span class="status-badge status-closed"><%= ev.getStatus() %></span>
                            <% } %>
                        </td>
                        <td>
                            <div style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
                                <!-- View Details -->
                                <a href="<%= request.getContextPath() %>/event-details?id=<%= ev.getId() %>" 
                                   class="btn btn-sm btn-outline" title="Preview event" target="_blank">
                                    View
                                </a>

                                <!-- View Registrations -->
                                <a href="<%= request.getContextPath() %>/organizer/event-registrations?eventId=<%= ev.getId() %>" 
                                   class="btn btn-sm btn-outline-cyan" title="Manage registrations">
                                    Registrations (<%= ev.getRegistrationCount() %>)
                                </a>

                                <!-- Edit -->
                                <a href="<%= request.getContextPath() %>/organizer/edit-event?id=<%= ev.getId() %>" 
                                   class="btn btn-sm btn-outline-orange" title="Edit event">
                                    Edit
                                </a>

                                <!-- Delete Form -->
                                <form action="<%= request.getContextPath() %>/organizer/delete-event" method="post" 
                                      onsubmit="return confirm('Are you sure you want to delete this event? This will also remove its registrations.');" 
                                      style="display: inline;">
                                    <input type="hidden" name="id" value="<%= ev.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger" style="padding: 4px 10px;">
                                        Delete
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <%  }
                } else { %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 48px 20px; color: var(--text-muted);">
                            <p style="font-size: 1.1rem; margin-bottom: 12px;">You haven't created any events yet.</p>
                            <a href="<%= request.getContextPath() %>/organizer/create-event" class="btn btn-sm btn-primary-create">
                                Create Your First Event
                            </a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</div>

<jsp:include page="../common/footer.jsp" />
