<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.Event" %>
<%@ page import="com.nexora.model.Organizer" %>
<%
    Event event = (Event) request.getAttribute("event");
    Organizer organizerObj = (Organizer) session.getAttribute("organizer");
    String errorMessage = (String) request.getAttribute("errorMessage");

    String deadlineStr = "";
    if (event != null && event.getRegistrationDeadline() != null) {
        deadlineStr = event.getRegistrationDeadline().toString().substring(0, 16).replace(" ", "T");
    }
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Edit Event – NEXORA" />
</jsp:include>

<div class="section-container" style="padding-top: 36px; padding-bottom: 80px;">
    <div style="max-width: 800px; margin: 0 auto;">
        
        <div style="margin-bottom: 20px; font-size: 0.88rem; color: var(--text-muted);">
            <a href="<%= request.getContextPath() %>/organizer/dashboard" style="color: var(--accent-cyan);">&larr; Back to Organizer Dashboard</a>
            <span style="margin: 0 8px;">/</span>
            <span style="color: var(--text-white);">Edit Event</span>
        </div>

        <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <span>⚠️</span>
                <span><%= errorMessage %></span>
            </div>
        <% } %>

        <% if (event != null) { %>
            <div class="form-card" style="max-width: 100%;">
                <div style="margin-bottom: 28px; border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 16px; display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 10px;">
                    <div>
                        <span class="section-eyebrow" style="color: var(--accent-orange);">Editing Event ID #<%= event.getId() %></span>
                        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-white); margin-top: 4px;">
                            <%= event.getTitle() %>
                        </h1>
                    </div>
                    <span class="status-badge <%= event.isPublished() ? "status-published" : "status-draft" %>">
                        <%= event.getStatus() %>
                    </span>
                </div>

                <form action="<%= request.getContextPath() %>/organizer/edit-event" method="post">
                    <input type="hidden" name="id" value="<%= event.getId() %>">

                    <div class="form-group">
                        <label class="form-label">Event Title <span class="required">*</span></label>
                        <input type="text" name="title" class="form-control" value="<%= event.getTitle() %>" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Category <span class="required">*</span></label>
                            <select name="category" class="form-control" required>
                                <option value="Hackathons" <%= "Hackathons".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>💻 Hackathons</option>
                                <option value="Workshops" <%= "Workshops".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>🛠️ Workshops</option>
                                <option value="Competitions" <%= "Competitions".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>🏆 Competitions</option>
                                <option value="Seminars" <%= "Seminars".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>🎤 Seminars</option>
                                <option value="College Events" <%= "College Events".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>🎉 College Events</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Publication Status <span class="required">*</span></label>
                            <select name="status" class="form-control" required>
                                <option value="PUBLISHED" <%= "PUBLISHED".equalsIgnoreCase(event.getStatus()) ? "selected" : "" %>>🟢 PUBLISHED (Visible to Students)</option>
                                <option value="DRAFT" <%= "DRAFT".equalsIgnoreCase(event.getStatus()) ? "selected" : "" %>>🟡 DRAFT (Hidden from Students)</option>
                                <option value="CLOSED" <%= "CLOSED".equalsIgnoreCase(event.getStatus()) ? "selected" : "" %>>🔴 CLOSED (Registration Stopped)</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Venue / Location <span class="required">*</span></label>
                        <input type="text" name="venue" class="form-control" value="<%= event.getVenue() %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Description <span class="required">*</span></label>
                        <textarea name="description" class="form-control" style="min-height: 120px;" required><%= event.getDescription() %></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Event Date <span class="required">*</span></label>
                            <input type="date" name="eventDate" class="form-control" value="<%= event.getEventDate() %>" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Registration Deadline <span class="required">*</span></label>
                            <input type="datetime-local" name="registrationDeadline" class="form-control" value="<%= deadlineStr %>" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Start Time <span class="required">*</span></label>
                            <input type="time" name="startTime" class="form-control" value="<%= event.getStartTime().toString().substring(0, 5) %>" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">End Time <span class="required">*</span></label>
                            <input type="time" name="endTime" class="form-control" value="<%= event.getEndTime().toString().substring(0, 5) %>" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Capacity (Max Seats) <span class="required">*</span></label>
                            <input type="number" name="capacity" class="form-control" value="<%= event.getCapacity() %>" min="1" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Eligibility Criteria</label>
                            <input type="text" name="eligibility" class="form-control" value="<%= event.getEligibility() %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Guidelines / Rules</label>
                        <textarea name="rules" class="form-control" style="min-height: 80px;"><%= event.getRules() != null ? event.getRules() : "" %></textarea>
                    </div>

                    <div style="display: flex; gap: 16px; margin-top: 32px; border-top: 1px solid rgba(255,255,255,0.06); padding-top: 24px;">
                        <a href="<%= request.getContextPath() %>/organizer/dashboard" class="btn btn-lg btn-outline" style="flex: 1;">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-lg btn-primary-create" style="flex: 1.5;">
                            ✓ Save Changes
                        </button>
                    </div>
                </form>
            </div>
        <% } %>

    </div>
</div>

<jsp:include page="../common/footer.jsp" />
