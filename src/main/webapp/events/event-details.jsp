<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.Event" %>
<%@ page import="com.nexora.model.User" %>
<%
    Event event = (Event) request.getAttribute("event");
    Boolean alreadyRegisteredObj = (Boolean) request.getAttribute("alreadyRegistered");
    boolean alreadyRegistered = (alreadyRegisteredObj != null && alreadyRegisteredObj);
    String errorMessage = (String) request.getAttribute("errorMessage");
    User currentUser = (User) session.getAttribute("user");
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="<%= (event != null ? event.getTitle() : \"Event Details\") + \" – NEXORA\" %>" />
</jsp:include>

<div class="section-container" style="padding-top: 36px; padding-bottom: 80px;">
    <% if (errorMessage != null) { %>
        <div class="alert alert-error" style="max-width: 900px; margin: 0 auto 24px;">
            <span>⚠️</span>
            <span><%= errorMessage %></span>
        </div>
    <% } %>

    <% if (event != null) { %>
        <div style="max-width: 960px; margin: 0 auto;">
            
            <!-- Breadcrumb Navigation -->
            <div style="margin-bottom: 20px; font-size: 0.88rem; color: var(--text-muted);">
                <a href="<%= request.getContextPath() %>/events" style="color: var(--accent-cyan);">&larr; Back to Events</a>
                <span style="margin: 0 8px;">/</span>
                <span><%= event.getCategory() %></span>
                <span style="margin: 0 8px;">/</span>
                <span style="color: var(--text-white);"><%= event.getTitle() %></span>
            </div>

            <!-- Header Card -->
            <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 36px; margin-bottom: 28px; box-shadow: var(--card-shadow);">
                <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px; margin-bottom: 18px;">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span class="category-badge <%= event.getCategoryBadgeClass() %>"><%= event.getCategory() %></span>
                        <span style="font-size: 0.88rem; color: var(--accent-yellow); font-weight: 700;">🏛️ <%= event.getClubName() %></span>
                    </div>
                    <div>
                        <% if (event.isDeadlinePassed()) { %>
                            <span class="status-badge status-closed">Registration Deadline Passed</span>
                        <% } else if (event.isFull()) { %>
                            <span class="status-badge status-closed">Event Full</span>
                        <% } else if (alreadyRegistered) { %>
                            <span class="status-badge status-approved">✓ Already Registered</span>
                        <% } else { %>
                            <span class="status-badge status-approved">● Registration Open</span>
                        <% } %>
                    </div>
                </div>

                <h1 style="font-size: 2.2rem; font-weight: 900; color: var(--text-white); margin-bottom: 20px; line-height: 1.25;">
                    <%= event.getTitle() %>
                </h1>

                <!-- Key Meta Details Grid -->
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 18px; background: #0D131F; border: 1px solid var(--border-light); border-radius: var(--radius-md); padding: 20px; margin-bottom: 24px;">
                    <div>
                        <span style="font-size: 0.76rem; color: var(--text-muted); text-transform: uppercase;">Event Date</span>
                        <div style="font-size: 1.05rem; font-weight: 700; color: var(--text-white); margin-top: 2px;">
                            📅 <%= event.getEventDate() %>
                        </div>
                    </div>
                    <div>
                        <span style="font-size: 0.76rem; color: var(--text-muted); text-transform: uppercase;">Time Slot</span>
                        <div style="font-size: 1.05rem; font-weight: 700; color: var(--text-white); margin-top: 2px;">
                            ⏰ <%= event.getStartTime() %> - <%= event.getEndTime() %>
                        </div>
                    </div>
                    <div>
                        <span style="font-size: 0.76rem; color: var(--text-muted); text-transform: uppercase;">Campus Venue</span>
                        <div style="font-size: 1.05rem; font-weight: 700; color: var(--text-white); margin-top: 2px;">
                            📍 <%= event.getVenue() %>
                        </div>
                    </div>
                    <div>
                        <span style="font-size: 0.76rem; color: var(--text-muted); text-transform: uppercase;">Registration Deadline</span>
                        <div style="font-size: 1.05rem; font-weight: 700; color: var(--accent-orange); margin-top: 2px;">
                            ⏳ <%= event.getRegistrationDeadline().toString().substring(0, 16) %>
                        </div>
                    </div>
                </div>

                <!-- Registration Capacity Monitor -->
                <div style="background: rgba(17, 24, 39, 0.7); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 18px 24px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                        <span style="font-weight: 700; color: var(--text-white); font-size: 0.95rem;">Registration Capacity</span>
                        <span style="font-size: 0.92rem; font-weight: 700; color: var(--accent-cyan);">
                            <%= event.getRegistrationCount() %> / <%= event.getCapacity() %> Seats Filled (<%= event.getRemainingSeats() %> Remaining)
                        </span>
                    </div>
                    <div class="progress-bar-bg" style="height: 10px;">
                        <div class="progress-bar-fill <%= event.getCapacityPercentage() >= 85 ? "near-full" : "" %>" 
                             style="width: <%= event.getCapacityPercentage() %>%;"></div>
                    </div>
                </div>
            </div>

            <!-- Two Columns: Description & Rules vs Registration CTA -->
            <div style="display: grid; grid-template-columns: 2fr 1.1fr; gap: 28px;">
                
                <!-- Left Details Column -->
                <div style="display: flex; flex-direction: column; gap: 24px;">
                    <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 30px;">
                        <h3 style="color: var(--text-white); font-size: 1.25rem; font-weight: 800; margin-bottom: 14px;">About This Event</h3>
                        <p style="color: var(--text-secondary); line-height: 1.7; font-size: 0.98rem; white-space: pre-line;">
                            <%= event.getDescription() %>
                        </p>
                    </div>

                    <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 30px;">
                        <h3 style="color: var(--text-white); font-size: 1.25rem; font-weight: 800; margin-bottom: 14px;">Eligibility Criteria</h3>
                        <div style="display: flex; align-items: center; gap: 10px; color: var(--text-secondary);">
                            <span style="color: var(--accent-green); font-size: 1.2rem;">✓</span>
                            <span><%= event.getEligibility() != null ? event.getEligibility() : "Open to all students" %></span>
                        </div>
                    </div>

                    <% if (event.getRules() != null && !event.getRules().trim().isEmpty()) { %>
                        <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 30px;">
                            <h3 style="color: var(--text-white); font-size: 1.25rem; font-weight: 800; margin-bottom: 14px;">Guidelines &amp; Rules</h3>
                            <div style="color: var(--text-secondary); line-height: 1.7; font-size: 0.95rem; white-space: pre-line;">
                                <%= event.getRules() %>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Right Action Column -->
                <div>
                    <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 30px; position: sticky; top: 100px;">
                        <h3 style="color: var(--text-white); font-size: 1.2rem; font-weight: 800; margin-bottom: 12px;">Event Registration</h3>
                        <p style="color: var(--text-muted); font-size: 0.88rem; margin-bottom: 24px;">
                            Secure your participation pass for this college event.
                        </p>

                        <% if (alreadyRegistered) { %>
                            <div class="alert alert-success" style="margin-bottom: 20px;">
                                <div>
                                    <strong>You are already registered!</strong>
                                    <div style="font-size: 0.82rem; margin-top: 4px;">Check your student dashboard to view your official registration ID and pass.</div>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath() %>/student/dashboard" class="btn btn-primary-explore" style="width: 100%;">
                                Go to My Dashboard
                            </a>

                        <% } else if (event.isDeadlinePassed()) { %>
                            <div class="alert alert-error" style="margin-bottom: 20px;">
                                <div>
                                    <strong>REGISTRATION CLOSED</strong>
                                    <div style="font-size: 0.82rem; margin-top: 4px;">The deadline (<%= event.getRegistrationDeadline().toString().substring(0, 16) %>) has passed. No new registrations are accepted.</div>
                                </div>
                            </div>
                            <button class="btn btn-outline" style="width: 100%; opacity: 0.5; cursor: not-allowed;" disabled>
                                Registration Closed
                            </button>

                        <% } else if (event.isFull()) { %>
                            <div class="alert alert-warning" style="margin-bottom: 20px;">
                                <div>
                                    <strong>EVENT FULL</strong>
                                    <div style="font-size: 0.82rem; margin-top: 4px;">All <%= event.getCapacity() %> seats have been reserved. Registration is closed.</div>
                                </div>
                            </div>
                            <button class="btn btn-outline" style="width: 100%; opacity: 0.5; cursor: not-allowed;" disabled>
                                Event Capacity Reached
                            </button>

                        <% } else { %>
                            <div style="margin-bottom: 20px; font-size: 0.88rem; color: var(--text-secondary); line-height: 1.5;">
                                <div>🎟️ <strong>Free Entry / College Event</strong></div>
                                <div style="margin-top: 6px;">⚡ Instant Confirmation ID generated upon registration.</div>
                            </div>

                            <a href="<%= request.getContextPath() %>/register-event?eventId=<%= event.getId() %>" 
                               class="btn btn-lg btn-primary-explore" style="width: 100%;">
                                Register Now &rarr;
                            </a>
                        <% } %>

                        <!-- Organizer Information Box -->
                        <div style="margin-top: 28px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.06); font-size: 0.85rem;">
                            <span style="color: var(--text-muted);">Organized by:</span>
                            <div style="font-weight: 700; color: var(--text-white); margin-top: 4px;"><%= event.getClubName() %></div>
                            <div style="color: var(--accent-cyan); font-size: 0.8rem; margin-top: 2px;">Faculty/Student Head: <%= event.getOrganizerName() %></div>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    <% } %>
</div>

<jsp:include page="../common/footer.jsp" />
