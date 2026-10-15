<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.model.Event" %>
<%@ page import="java.util.List" %>
<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "ALL";
    String searchTerm = (String) request.getAttribute("searchTerm");
    if (searchTerm == null) searchTerm = "";
%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Explore Campus Events – NEXORA" />
</jsp:include>

<div class="section-container" style="padding-top: 40px;">
    <!-- Page Header & Search Bar -->
    <div style="text-align: center; max-width: 800px; margin: 0 auto 36px;">
        <span class="section-eyebrow">Discover What's Happening</span>
        <h1 style="font-size: 2.6rem; font-weight: 900; color: var(--text-white); margin-bottom: 12px;">Campus Event Directory</h1>
        <p style="color: var(--text-secondary); font-size: 1.05rem;">
            Explore approved and published events organized by MHSSCE clubs and departments.
        </p>

        <!-- Search Form -->
        <form action="<%= request.getContextPath() %>/events" method="get" style="display: flex; gap: 12px; margin-top: 24px;">
            <input type="hidden" name="category" value="<%= selectedCategory %>">
            <input type="text" name="search" value="<%= searchTerm %>" class="form-control" 
                   placeholder="Search events by title, club name, or venue..." style="flex: 1; padding: 14px 18px;">
            <button type="submit" class="btn btn-primary-explore" style="padding: 14px 28px;">
                🔍 Search
            </button>
            <% if (!searchTerm.isEmpty() || !"ALL".equalsIgnoreCase(selectedCategory)) { %>
                <a href="<%= request.getContextPath() %>/events" class="btn btn-outline" style="padding: 14px 20px;">
                    Reset
                </a>
            <% } %>
        </form>
    </div>

    <!-- Category Filter Bar (Centered horizontally with bright category accents) -->
    <div style="display: flex; justify-content: center; flex-wrap: wrap; gap: 10px; margin-bottom: 40px;">
        <a href="<%= request.getContextPath() %>/events?category=ALL&search=<%= searchTerm %>" 
           class="btn btn-sm <%= "ALL".equalsIgnoreCase(selectedCategory) ? "btn-outline-cyan" : "btn-outline" %>" 
           style="<%= "ALL".equalsIgnoreCase(selectedCategory) ? "background: rgba(0,229,255,0.15); border-color: var(--accent-cyan);" : "" %>">
            All Events
        </a>
        <a href="<%= request.getContextPath() %>/events?category=Hackathons&search=<%= searchTerm %>" 
           class="btn btn-sm btn-outline" 
           style="<%= "Hackathons".equalsIgnoreCase(selectedCategory) ? "background: rgba(0,229,255,0.2); border-color: var(--cat-hackathons); color: var(--cat-hackathons);" : "color: var(--cat-hackathons);" %>">
            💻 Hackathons
        </a>
        <a href="<%= request.getContextPath() %>/events?category=Workshops&search=<%= searchTerm %>" 
           class="btn btn-sm btn-outline" 
           style="<%= "Workshops".equalsIgnoreCase(selectedCategory) ? "background: rgba(255,122,0,0.2); border-color: var(--cat-workshops); color: var(--cat-workshops);" : "color: var(--cat-workshops);" %>">
            🛠️ Workshops
        </a>
        <a href="<%= request.getContextPath() %>/events?category=Competitions&search=<%= searchTerm %>" 
           class="btn btn-sm btn-outline" 
           style="<%= "Competitions".equalsIgnoreCase(selectedCategory) ? "background: rgba(41,121,255,0.2); border-color: var(--cat-competitions); color: var(--cat-competitions);" : "color: var(--cat-competitions);" %>">
            🏆 Competitions
        </a>
        <a href="<%= request.getContextPath() %>/events?category=Seminars&search=<%= searchTerm %>" 
           class="btn btn-sm btn-outline" 
           style="<%= "Seminars".equalsIgnoreCase(selectedCategory) ? "background: rgba(255,45,149,0.2); border-color: var(--cat-seminars); color: var(--cat-seminars);" : "color: var(--cat-seminars);" %>">
            🎤 Seminars
        </a>
        <a href="<%= request.getContextPath() %>/events?category=College Events&search=<%= searchTerm %>" 
           class="btn btn-sm btn-outline" 
           style="<%= "College Events".equalsIgnoreCase(selectedCategory) ? "background: rgba(255,214,10,0.2); border-color: var(--cat-college); color: var(--cat-college);" : "color: var(--cat-college);" %>">
            🎉 College Events
        </a>
    </div>

    <!-- Event Cards Grid -->
    <div class="event-grid">
        <% if (events != null && !events.isEmpty()) { 
            for (Event ev : events) { %>
            <div class="event-card">
                <div class="event-card-header">
                    <span class="event-club-tag"><%= ev.getClubName() %></span>
                    <span class="category-badge <%= ev.getCategoryBadgeClass() %>"><%= ev.getCategory() %></span>
                </div>
                <div class="event-card-body">
                    <h3 class="event-title"><%= ev.getTitle() %></h3>
                    <p class="event-description"><%= ev.getDescription() %></p>
                    
                    <div class="event-meta-list">
                        <div class="event-meta-item">
                            <span>📅</span> <strong><%= ev.getEventDate() %></strong> (<%= ev.getStartTime() %> - <%= ev.getEndTime() %>)
                        </div>
                        <div class="event-meta-item">
                            <span>📍</span> <%= ev.getVenue() %>
                        </div>
                        <div class="event-meta-item">
                            <span>🎓</span> <%= ev.getEligibility() %>
                        </div>
                    </div>

                    <!-- Live Capacity Progress Bar -->
                    <div class="capacity-progress-wrap">
                        <div class="capacity-info">
                            <span>Registered: <%= ev.getRegistrationCount() %> / <%= ev.getCapacity() %></span>
                            <span class="seats-count" style="color: var(--accent-cyan);"><%= ev.getRemainingSeats() %> seats left</span>
                        </div>
                        <div class="progress-bar-bg">
                            <div class="progress-bar-fill <%= ev.getCapacityPercentage() >= 85 ? "near-full" : "" %>" 
                                 style="width: <%= ev.getCapacityPercentage() %>%;"></div>
                        </div>
                    </div>
                </div>
                <div class="event-card-footer">
                    <div>
                        <% if (ev.isDeadlinePassed()) { %>
                            <span class="status-badge status-closed">Registration Closed</span>
                        <% } else if (ev.isFull()) { %>
                            <span class="status-badge status-closed">Event Full</span>
                        <% } else { %>
                            <span class="status-badge status-approved">Open for Registration</span>
                        <% } %>
                    </div>
                    <a href="<%= request.getContextPath() %>/event-details?id=<%= ev.getId() %>" class="btn btn-sm btn-outline-cyan">
                        View Details &rarr;
                    </a>
                </div>
            </div>
        <%  }
        } else { %>
            <div style="grid-column: 1/-1; text-align: center; padding: 60px 20px; background: var(--bg-card); border-radius: var(--radius-lg); border: 1px dashed var(--border-light);">
                <span style="font-size: 2.5rem; display: block; margin-bottom: 12px;">🔍</span>
                <h3 style="color: var(--text-white); font-size: 1.3rem; margin-bottom: 6px;">No events found</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 20px;">
                    No published events matched category "<%= selectedCategory %>" <%= !searchTerm.isEmpty() ? "and keyword \"" + searchTerm + "\"" : "" %>.
                </p>
                <a href="<%= request.getContextPath() %>/events" class="btn btn-sm btn-primary-explore">
                    Clear Filters &amp; Show All
                </a>
            </div>
        <% } %>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
