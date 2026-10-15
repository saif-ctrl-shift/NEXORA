<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.Event" %>
<%@ page import="com.nexora.model.Registration" %>
<%@ page import="java.util.List" %>
<%
    Event event = (Event) request.getAttribute("event");
    List<Registration> registrations = (List<Registration>) request.getAttribute("registrations");
    String searchTerm = (String) request.getAttribute("searchTerm");
    if (searchTerm == null) searchTerm = "";
    String statusFilter = (String) request.getAttribute("statusFilter");
    if (statusFilter == null) statusFilter = "ALL";
    String sortBy = (String) request.getAttribute("sortBy");
    if (sortBy == null) sortBy = "recent";
    String msg = request.getParameter("msg");
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Event Registrations – NEXORA" />
</jsp:include>

<div class="section-container" style="padding-top: 36px; padding-bottom: 80px;">
    
    <!-- Top Bar & Breadcrumb -->
    <div style="margin-bottom: 20px; font-size: 0.88rem; color: var(--text-muted);">
        <a href="<%= request.getContextPath() %>/organizer/dashboard" style="color: var(--accent-cyan);">&larr; Back to Organizer Dashboard</a>
        <span style="margin: 0 8px;">/</span>
        <span style="color: var(--text-white);">Participant Registrations</span>
    </div>

    <% if ("status_updated".equalsIgnoreCase(msg)) { %>
        <div class="alert alert-success">
            <span>✓</span> <span>Participant status updated successfully in MySQL database!</span>
        </div>
    <% } %>

    <% if (event != null) { %>
        <!-- Event Summary Header -->
        <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 28px; margin-bottom: 32px; box-shadow: var(--card-shadow); display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 20px;">
            <div>
                <span class="category-badge <%= event.getCategoryBadgeClass() %>"><%= event.getCategory() %></span>
                <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-white); margin: 6px 0;">
                    <%= event.getTitle() %>
                </h1>
                <div style="font-size: 0.88rem; color: var(--text-secondary);">
                    📅 <%= event.getEventDate() %> (<%= event.getStartTime() %> - <%= event.getEndTime() %>) • 📍 <%= event.getVenue() %>
                </div>
            </div>

            <div style="background: #0D131F; border: 1px solid var(--border-light); border-radius: var(--radius-md); padding: 16px 24px; text-align: right;">
                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Registration Count</div>
                <div style="font-size: 1.8rem; font-weight: 900; color: var(--accent-cyan); margin: 2px 0;">
                    <%= event.getRegistrationCount() %> <span style="font-size: 1.1rem; color: var(--text-muted);">/ <%= event.getCapacity() %></span>
                </div>
                <div style="font-size: 0.8rem; color: var(--accent-green);">
                    <%= event.getRemainingSeats() %> Seats Remaining
                </div>
            </div>
        </div>

        <!-- Filter, Search, and Sort Bar -->
        <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 20px; margin-bottom: 28px;">
            <form action="<%= request.getContextPath() %>/organizer/event-registrations" method="get" style="display: flex; gap: 14px; flex-wrap: wrap; align-items: center;">
                <input type="hidden" name="eventId" value="<%= event.getId() %>">

                <div style="flex: 2; min-width: 240px;">
                    <input type="text" name="search" value="<%= searchTerm %>" class="form-control" 
                           placeholder="Search by student name, roll number, email, or Reg ID...">
                </div>

                <div style="flex: 1; min-width: 160px;">
                    <select name="status" class="form-control">
                        <option value="ALL" <%= "ALL".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>All Statuses</option>
                        <option value="REGISTERED" <%= "REGISTERED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>REGISTERED</option>
                        <option value="APPROVED" <%= "APPROVED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>APPROVED</option>
                        <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>REJECTED</option>
                        <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>CANCELLED</option>
                    </select>
                </div>

                <div style="flex: 1; min-width: 160px;">
                    <select name="sort" class="form-control">
                        <option value="recent" <%= "recent".equalsIgnoreCase(sortBy) ? "selected" : "" %>>Sort: Most Recent</option>
                        <option value="name_asc" <%= "name_asc".equalsIgnoreCase(sortBy) ? "selected" : "" %>>Sort: Name (A-Z)</option>
                        <option value="roll_asc" <%= "roll_asc".equalsIgnoreCase(sortBy) ? "selected" : "" %>>Sort: Roll Number</option>
                        <option value="status" <%= "status".equalsIgnoreCase(sortBy) ? "selected" : "" %>>Sort: Status</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary-create" style="padding: 12px 22px;">
                    🔍 Apply
                </button>

                <% if (!searchTerm.isEmpty() || !"ALL".equalsIgnoreCase(statusFilter) || !"recent".equalsIgnoreCase(sortBy)) { %>
                    <a href="<%= request.getContextPath() %>/organizer/event-registrations?eventId=<%= event.getId() %>" class="btn btn-outline" style="padding: 12px 18px;">
                        Reset
                    </a>
                <% } %>
            </form>
        </div>

        <!-- Participants Table -->
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Registration ID</th>
                        <th>Student Name &amp; Contact</th>
                        <th>Academic Info</th>
                        <th>Team</th>
                        <th>Registered Date</th>
                        <th>Current Status</th>
                        <th>Update Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (registrations != null && !registrations.isEmpty()) { 
                        for (Registration reg : registrations) { %>
                        <tr class="participant-row">
                            <td>
                                <span style="font-family: monospace; font-weight: 800; color: var(--accent-cyan); font-size: 0.95rem;">
                                    <%= reg.getRegistrationId() %>
                                </span>
                            </td>
                            <td>
                                <strong style="color: var(--text-white); font-size: 0.95rem;"><%= reg.getFullName() %></strong>
                                <div style="font-size: 0.78rem; color: var(--text-muted); margin-top: 2px;">
                                    ✉️ <%= reg.getEmail() %> • 📱 <%= reg.getMobile() %>
                                </div>
                            </td>
                            <td>
                                <div style="font-size: 0.88rem; color: var(--text-white); font-weight: 600;">
                                    Roll: <%= reg.getRollNumber() %>
                                </div>
                                <div style="font-size: 0.78rem; color: var(--text-muted);">
                                    <%= reg.getDepartment() %> (<%= reg.getYear() %>)
                                </div>
                            </td>
                            <td>
                                <% if (reg.getTeamName() != null && !reg.getTeamName().trim().isEmpty() && !reg.getTeamName().equalsIgnoreCase("Solo")) { %>
                                    <div style="font-weight: 700; color: var(--accent-yellow); font-size: 0.85rem;">
                                        <%= reg.getTeamName() %>
                                    </div>
                                    <% if (reg.getTeamMembers() != null && !reg.getTeamMembers().trim().isEmpty()) { %>
                                        <div style="font-size: 0.74rem; color: var(--text-muted); max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="<%= reg.getTeamMembers() %>">
                                            <%= reg.getTeamMembers() %>
                                        </div>
                                    <% } %>
                                <% } else { %>
                                    <span style="font-size: 0.82rem; color: var(--text-muted);">Solo</span>
                                <% } %>
                            </td>
                            <td style="font-size: 0.82rem; color: var(--text-muted);">
                                <%= reg.getRegistrationDate().toString().substring(0, 16) %>
                            </td>
                            <td>
                                <span class="status-badge <%= reg.getStatusBadgeClass() %>">
                                    <%= reg.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <!-- Quick Status Changer Form -->
                                <form action="<%= request.getContextPath() %>/organizer/event-registrations" method="post" style="display: flex; gap: 6px; align-items: center;">
                                    <input type="hidden" name="eventId" value="<%= event.getId() %>">
                                    <input type="hidden" name="registrationId" value="<%= reg.getId() %>">
                                    
                                    <select name="newStatus" class="form-control" style="padding: 4px 8px; font-size: 0.8rem; width: auto; height: 32px;">
                                        <option value="APPROVED" <%= "APPROVED".equalsIgnoreCase(reg.getStatus()) ? "selected" : "" %>>Approve</option>
                                        <option value="REGISTERED" <%= "REGISTERED".equalsIgnoreCase(reg.getStatus()) ? "selected" : "" %>>Registered</option>
                                        <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(reg.getStatus()) ? "selected" : "" %>>Reject</option>
                                        <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(reg.getStatus()) ? "selected" : "" %>>Cancel</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-outline" style="padding: 4px 10px; font-size: 0.78rem;">
                                        Update
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%  }
                    } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 48px 20px; color: var(--text-muted);">
                                <p style="font-size: 1.05rem;">No registrations found matching the criteria.</p>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    <% } %>

</div>

<jsp:include page="../common/footer.jsp" />
