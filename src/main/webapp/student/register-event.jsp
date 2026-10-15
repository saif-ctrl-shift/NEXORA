<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.Event" %>
<%@ page import="com.nexora.model.User" %>
<%
    Event event = (Event) request.getAttribute("event");
    User student = (User) request.getAttribute("student");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Event Registration – NEXORA" />
</jsp:include>

<div class="section-container" style="padding-top: 36px; padding-bottom: 80px;">
    <div style="max-width: 760px; margin: 0 auto;">
        
        <!-- Breadcrumb -->
        <div style="margin-bottom: 20px; font-size: 0.88rem; color: var(--text-muted);">
            <a href="<%= request.getContextPath() %>/event-details?id=<%= event != null ? event.getId() : "" %>" style="color: var(--accent-cyan);">&larr; Back to Event</a>
            <span style="margin: 0 8px;">/</span>
            <span style="color: var(--text-white);">Registration Form</span>
        </div>

        <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <span>⚠️</span>
                <span><%= errorMessage %></span>
            </div>
        <% } %>

        <% if (event != null) { %>
            <!-- Event Summary Banner -->
            <div style="background: #0D131F; border: 1px solid var(--border-light); border-radius: var(--radius-md); padding: 22px; margin-bottom: 28px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 14px;">
                <div>
                    <span class="category-badge <%= event.getCategoryBadgeClass() %>" style="margin-bottom: 6px;"><%= event.getCategory() %></span>
                    <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-white); margin: 4px 0;"><%= event.getTitle() %></h2>
                    <div style="font-size: 0.85rem; color: var(--text-muted);">
                        🏛️ Organized by <%= event.getClubName() %> • 📅 <%= event.getEventDate() %> • 📍 <%= event.getVenue() %>
                    </div>
                </div>
                <div style="text-align: right;">
                    <div style="font-size: 0.82rem; color: var(--text-muted);">Seats Remaining</div>
                    <div style="font-size: 1.4rem; font-weight: 800; color: var(--accent-cyan);"><%= event.getRemainingSeats() %></div>
                </div>
            </div>

            <!-- Registration Form Card -->
            <div class="form-card" style="max-width: 100%;">
                <div style="margin-bottom: 24px; border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 16px;">
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--text-white);">Participant Details</h3>
                    <p style="font-size: 0.86rem; color: var(--text-muted); margin-top: 4px;">
                        Please verify your student information before confirming registration.
                    </p>
                </div>

                <form action="<%= request.getContextPath() %>/register-event" method="post">
                    <input type="hidden" name="eventId" value="<%= event.getId() %>">

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Full Name <span class="required">*</span></label>
                            <input type="text" name="fullName" class="form-control" 
                                   value="<%= student != null ? student.getFullName() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">College Email <span class="required">*</span></label>
                            <input type="email" name="email" class="form-control" 
                                   value="<%= student != null ? student.getEmail() : "" %>" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mobile Number <span class="required">*</span></label>
                            <input type="tel" name="mobile" class="form-control" 
                                   value="<%= student != null ? student.getMobile() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">College / Institute <span class="required">*</span></label>
                            <input type="text" name="college" class="form-control" 
                                   value="M.H. Saboo Siddik College of Engineering, Mumbai" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Department <span class="required">*</span></label>
                            <input type="text" name="department" class="form-control" 
                                   value="<%= student != null ? student.getDepartment() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Year of Study <span class="required">*</span></label>
                            <input type="text" name="year" class="form-control" 
                                   value="<%= student != null ? student.getYear() : "" %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Roll Number / Student ID <span class="required">*</span></label>
                        <input type="text" name="rollNumber" class="form-control" 
                               value="<%= student != null ? student.getRollNumber() : "" %>" required>
                    </div>

                    <!-- Team Details (For Hackathons / Team Competitions) -->
                    <div style="margin: 28px 0 16px; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.06);">
                        <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--text-white); margin-bottom: 4px;">Team Details (If Applicable)</h4>
                        <p style="font-size: 0.82rem; color: var(--text-muted); margin-bottom: 16px;">
                            For solo registrations, you can leave Team Name as "Solo" or blank.
                        </p>

                        <div class="form-group">
                            <label class="form-label">Team Name</label>
                            <input type="text" name="teamName" class="form-control" placeholder="e.g. HackSquad / Solo">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Team Members (Names &amp; Roll Numbers)</label>
                            <textarea name="teamMembers" class="form-control" style="min-height: 80px;" 
                                      placeholder="e.g. 1. Saif Ali (21CO15) - Team Lead&#10;2. Fakhruddin Mansuri (21IT28)&#10;3. Hamza Sayed (22AI09)"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Additional Information / Prior Experience</label>
                        <textarea name="additionalInformation" class="form-control" style="min-height: 80px;" 
                                  placeholder="Mention any relevant projects, dietary requirements, or questions for organizers..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-lg btn-primary-explore" style="width: 100%; margin-top: 16px;">
                        ✓ Confirm Registration &amp; Generate ID
                    </button>
                </form>
            </div>
        <% } %>

    </div>
</div>

<jsp:include page="../common/footer.jsp" />
