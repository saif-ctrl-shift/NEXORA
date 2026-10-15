<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.Registration" %>
<%@ page import="com.nexora.model.Event" %>
<%
    Registration reg = (Registration) request.getAttribute("registration");
    Event event = (Event) request.getAttribute("event");
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Registration Successful – NEXORA Pass" />
</jsp:include>

<div class="section-container" style="padding-top: 40px; padding-bottom: 80px;">
    
    <!-- Printable / Screenshot Pass Card -->
    <div class="confirmation-ticket">
        <div class="ticket-header">
            <div class="ticket-badge">✓ REGISTRATION SUCCESSFUL</div>
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-white); margin-bottom: 6px;">
                Official Event Admission Pass
            </h1>
            <p style="color: var(--text-muted); font-size: 0.88rem;">
                M.H. Saboo Siddik College of Engineering, Byculla, Mumbai
            </p>
            <div class="ticket-id"><%= reg != null ? reg.getRegistrationId() : "NX-2026-XXXXX" %></div>
            <div style="font-size: 0.78rem; color: var(--accent-cyan); text-transform: uppercase; letter-spacing: 1px;">
                Unique Registration Verification ID
            </div>
        </div>

        <div class="ticket-grid">
            <div>
                <div class="ticket-field-label">Student Name</div>
                <div class="ticket-field-value"><%= reg != null ? reg.getFullName() : "-" %></div>
            </div>
            <div>
                <div class="ticket-field-label">Roll Number &amp; Dept</div>
                <div class="ticket-field-value"><%= reg != null ? reg.getRollNumber() + " (" + reg.getDepartment() + ")" : "-" %></div>
            </div>
            <div>
                <div class="ticket-field-label">Event Name</div>
                <div class="ticket-field-value" style="color: var(--accent-yellow);"><%= reg != null ? reg.getEventTitle() : (event != null ? event.getTitle() : "-") %></div>
            </div>
            <div>
                <div class="ticket-field-label">Organizing Club</div>
                <div class="ticket-field-value"><%= reg != null && reg.getClubName() != null ? reg.getClubName() : (event != null ? event.getClubName() : "College Committee") %></div>
            </div>
            <div>
                <div class="ticket-field-label">Event Date &amp; Time</div>
                <div class="ticket-field-value">📅 <%= reg != null && reg.getEventDate() != null ? reg.getEventDate() : (event != null ? event.getEventDate() + " • " + event.getStartTime() : "-") %></div>
            </div>
            <div>
                <div class="ticket-field-label">Campus Venue</div>
                <div class="ticket-field-value">📍 <%= reg != null && reg.getEventVenue() != null ? reg.getEventVenue() : (event != null ? event.getVenue() : "Campus") %></div>
            </div>
            <div>
                <div class="ticket-field-label">Registration Status</div>
                <div class="ticket-field-value">
                    <span class="status-badge status-approved"><%= reg != null ? reg.getStatus() : "REGISTERED" %></span>
                </div>
            </div>
            <div>
                <div class="ticket-field-label">Registration Timestamp</div>
                <div class="ticket-field-value" style="font-size: 0.88rem; color: var(--text-secondary);">
                    <%= reg != null && reg.getRegistrationDate() != null ? reg.getRegistrationDate().toString().substring(0, 19) : "Just now" %>
                </div>
            </div>
        </div>

        <% if (reg != null && reg.getTeamName() != null && !reg.getTeamName().trim().isEmpty()) { %>
            <div style="background: #0D131F; border: 1px solid var(--border-light); border-radius: var(--radius-sm); padding: 14px; margin-bottom: 24px; font-size: 0.85rem;">
                <div style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">Team Details</div>
                <div style="font-weight: 700; color: var(--text-white); margin-top: 2px;">Team: <%= reg.getTeamName() %></div>
                <% if (reg.getTeamMembers() != null && !reg.getTeamMembers().trim().isEmpty()) { %>
                    <div style="color: var(--text-secondary); margin-top: 4px; white-space: pre-line;"><%= reg.getTeamMembers() %></div>
                <% } %>
            </div>
        <% } %>

        <div style="text-align: center; border-top: 1px dashed rgba(255, 255, 255, 0.12); padding-top: 24px; display: flex; gap: 14px; justify-content: center; flex-wrap: wrap;">
            <button onclick="window.print()" class="btn btn-outline" style="font-size: 0.9rem;">
                🖨️ Print / Save Pass
            </button>
            <a href="<%= request.getContextPath() %>/student/dashboard" class="btn btn-primary-explore">
                Go to My Dashboard &rarr;
            </a>
            <a href="<%= request.getContextPath() %>/events" class="btn btn-outline-cyan">
                Browse More Events
            </a>
        </div>
    </div>

</div>

<jsp:include page="../common/footer.jsp" />
