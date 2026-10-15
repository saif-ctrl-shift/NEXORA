<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.Organizer" %>
<%
    Organizer organizerObj = (Organizer) session.getAttribute("organizer");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Create College Event – NEXORA" />
</jsp:include>

<div class="section-container" style="padding-top: 36px; padding-bottom: 80px;">
    <div style="max-width: 800px; margin: 0 auto;">
        
        <div style="margin-bottom: 20px; font-size: 0.88rem; color: var(--text-muted);">
            <a href="<%= request.getContextPath() %>/organizer/dashboard" style="color: var(--accent-cyan);">&larr; Back to Organizer Dashboard</a>
            <span style="margin: 0 8px;">/</span>
            <span style="color: var(--text-white);">Create Event</span>
        </div>

        <div class="form-card" style="max-width: 100%;">
            <div style="margin-bottom: 28px; border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 16px;">
                <span class="section-eyebrow" style="color: var(--accent-orange);">
                    <%= organizerObj != null ? organizerObj.getClubName() : "Club Event Creation" %>
                </span>
                <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-white); margin-top: 4px;">
                    Create New College Event
                </h1>
                <p style="color: var(--text-muted); font-size: 0.88rem; margin-top: 4px;">
                    Fill out all details below. Save as draft for review or publish directly for student registration.
                </p>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-error">
                    <span>⚠️</span>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/organizer/create-event" method="post">
                
                <div class="form-group">
                    <label class="form-label">Event Title <span class="required">*</span></label>
                    <input type="text" name="title" class="form-control" 
                           placeholder="e.g. Agentic AI &amp; Cloud Workshop 2026" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Category <span class="required">*</span></label>
                        <select name="category" class="form-control" required>
                            <option value="">Select Category</option>
                            <option value="Hackathons">💻 Hackathons</option>
                            <option value="Workshops">🛠️ Workshops</option>
                            <option value="Competitions">🏆 Competitions</option>
                            <option value="Seminars">🎤 Seminars</option>
                            <option value="College Events">🎉 College Events</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Venue / Location <span class="required">*</span></label>
                        <input type="text" name="venue" class="form-control" 
                               placeholder="e.g. Seminar Hall 1, 4th Floor / CC Labs" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Description <span class="required">*</span></label>
                    <textarea name="description" class="form-control" style="min-height: 120px;" 
                              placeholder="Describe the event agenda, topics covered, what participants will learn or build..." required></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Event Date <span class="required">*</span></label>
                        <input type="date" name="eventDate" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Registration Deadline <span class="required">*</span></label>
                        <input type="datetime-local" name="registrationDeadline" class="form-control" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Start Time <span class="required">*</span></label>
                        <input type="time" name="startTime" class="form-control" value="10:00" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">End Time <span class="required">*</span></label>
                        <input type="time" name="endTime" class="form-control" value="16:00" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Capacity (Max Seats) <span class="required">*</span></label>
                        <input type="number" name="capacity" class="form-control" min="1" max="5000" value="80" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Eligibility</label>
                        <input type="text" name="eligibility" class="form-control" 
                               placeholder="e.g. FE, SE, TE, and BE Engineering Students" value="Open to all MHSSCE Students">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Guidelines / Rules</label>
                    <textarea name="rules" class="form-control" style="min-height: 80px;" 
                              placeholder="1. Bring college ID card.&#10;2. Bring personal laptop with charger.&#10;3. Teams of 2 to 4 members."></textarea>
                </div>

                <!-- Two Distinct Actions: Save Draft vs Publish Event -->
                <div style="display: flex; gap: 16px; margin-top: 32px; border-top: 1px solid rgba(255,255,255,0.06); padding-top: 24px;">
                    <button type="submit" name="action" value="draft" class="btn btn-lg btn-outline" style="flex: 1;">
                        💾 SAVE AS DRAFT
                    </button>
                    <button type="submit" name="action" value="publish" class="btn btn-lg btn-primary-create" style="flex: 1.3;">
                        🚀 PUBLISH EVENT
                    </button>
                </div>
            </form>
        </div>

    </div>
</div>

<jsp:include page="../common/footer.jsp" />
