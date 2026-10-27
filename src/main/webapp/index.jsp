<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nexora.dao.EventDAO" %>
<%@ page import="com.nexora.dao.OrganizerDAO" %>
<%@ page import="com.nexora.model.Event" %>
<%@ page import="com.nexora.model.Organizer" %>
<%@ page import="java.util.List" %>
<%
    EventDAO eventDAO = new EventDAO();
    OrganizerDAO organizerDAO = new OrganizerDAO();
    List<Event> featuredEvents = eventDAO.getFeaturedEvents(3);
    List<Event> upcomingEvents = eventDAO.getUpcomingEvents(6);
    List<Organizer> clubs = organizerDAO.getAllOrganizers();
%>
<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="NEXORA – Your College Events | MHSSCE" />
</jsp:include>

<!-- =======================================================================
     HERO SECTION (STRICTLY CENTERED, PREMIUM COLLEGE-TECH)
     ======================================================================= -->
<section class="hero-section">
    <!-- Zoomed NEXORA Brand Logo Showcase -->
    <div class="hero-logo-showcase" style="display: flex; justify-content: center; align-items: center; margin-bottom: 24px;">
        <div style="position: relative; display: inline-block;">
            <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 340px; height: 180px; background: radial-gradient(circle, rgba(255, 179, 0, 0.25) 0%, rgba(255, 107, 0, 0.08) 55%, transparent 75%); filter: blur(32px); pointer-events: none; border-radius: 50%;"></div>
            <img src="<%= request.getContextPath() %>/images/nexora-full-logo.png" alt="NEXORA – Managing Events, Building Opportunities" style="height: 150px; width: auto; max-width: 90vw; object-fit: contain; filter: drop-shadow(0 10px 32px rgba(255, 179, 0, 0.38)); position: relative; z-index: 1;">
        </div>
    </div>

    <!-- College Affiliation Label / Badge -->
    <div class="hero-badge-container" style="margin-bottom: 24px;">
        <div class="hero-college-badge" style="display: inline-flex; align-items: center; gap: 10px; background: rgba(255, 255, 255, 0.04); border: 1px solid rgba(255, 255, 255, 0.1); padding: 7px 18px; border-radius: 40px;">
            <img src="<%= request.getContextPath() %>/images/college-logo.png" alt="MHSSCE" style="height: 20px; width: auto; border-radius: 2px; vertical-align: middle; background: #ffffff; padding: 1px;">
            <span style="color: var(--text-white); font-weight: 600;">M.H. Saboo Siddik College of Engineering</span>
            <span style="color: var(--accent-cyan); font-weight: 700;">• Mumbai</span>
        </div>
    </div>

    <!-- Large Main Heading -->
    <h1 class="hero-main-heading">
        YOUR COLLEGE <span class="hero-gradient-text">EVENTS</span>
    </h1>

    <!-- Stylish Subtitle with Exact Bullet Separators -->
    <div class="hero-subtitle">
        <span>Discover</span>
        <span class="dot-sep">•</span>
        <span>Participate</span>
        <span class="dot-sep">•</span>
        <span>Create</span>
    </div>

    <!-- Supporting Text -->
    <p class="hero-description">
        Your College's Events, All in One Place. Connect with clubs, participate in high-stakes hackathons, attend skill workshops, and elevate your campus journey.
    </p>

    <!-- Large CTA Buttons -->
    <div class="hero-buttons">
        <a href="<%= request.getContextPath() %>/events" class="btn btn-lg btn-primary-explore">
            ⚡ Explore Events
        </a>
        <a href="<%= request.getContextPath() %>/login?role=ORGANIZER" class="btn btn-lg btn-primary-create">
            🎯 Create Event
        </a>
    </div>

    <!-- Event Category Navigation (Straight horizontal row on desktop) -->
    <div class="hero-category-nav">
        <a href="<%= request.getContextPath() %>/events?category=Hackathons" class="hero-cat-item cat-hackathons">
            💻 Hackathons
        </a>
        <span class="cat-divider">|</span>
        <a href="<%= request.getContextPath() %>/events?category=Workshops" class="hero-cat-item cat-workshops">
            🛠️ Workshops
        </a>
        <span class="cat-divider">|</span>
        <a href="<%= request.getContextPath() %>/events?category=Competitions" class="hero-cat-item cat-competitions">
            🏆 Competitions
        </a>
        <span class="cat-divider">|</span>
        <a href="<%= request.getContextPath() %>/events?category=Seminars" class="hero-cat-item cat-seminars">
            🎤 Seminars
        </a>
        <span class="cat-divider">|</span>
        <a href="<%= request.getContextPath() %>/events?category=College Events" class="hero-cat-item cat-college">
            🎉 College Events
        </a>
    </div>
</section>

<!-- =======================================================================
     FEATURED EVENTS SECTION
     ======================================================================= -->
<section class="section-container" id="events">
    <div class="section-header">
        <div class="section-title-wrap">
            <span class="section-eyebrow">Highlights</span>
            <h2 class="section-title">Featured Events</h2>
        </div>
        <a href="<%= request.getContextPath() %>/events" class="btn btn-sm btn-outline-cyan">
            View All Events &rarr;
        </a>
    </div>

    <div class="event-grid">
        <% if (featuredEvents != null && !featuredEvents.isEmpty()) { 
            for (Event ev : featuredEvents) { %>
            <div class="event-card">
                <div class="event-card-header">
                    <span class="event-club-tag"><%= ev.getClubName() != null ? ev.getClubName() : "College Committee" %></span>
                    <span class="category-badge <%= ev.getCategoryBadgeClass() %>"><%= ev.getCategory() %></span>
                </div>
                <div class="event-card-body">
                    <h3 class="event-title"><%= ev.getTitle() %></h3>
                    <p class="event-description"><%= ev.getDescription() %></p>
                    
                    <div class="event-meta-list">
                        <div class="event-meta-item">
                            <span>📅</span> <strong><%= ev.getEventDate() %></strong> • <%= ev.getStartTime() %>
                        </div>
                        <div class="event-meta-item">
                            <span>📍</span> <%= ev.getVenue() %>
                        </div>
                    </div>

                    <!-- Live Capacity Progress Bar -->
                    <div class="capacity-progress-wrap">
                        <div class="capacity-info">
                            <span>Capacity Status</span>
                            <span class="seats-count"><%= ev.getRegistrationCount() %> / <%= ev.getCapacity() %> Registered</span>
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
                            <span style="font-size: 0.82rem; color: var(--accent-green); font-weight: 700;">● Open Now</span>
                        <% } %>
                    </div>
                    <a href="<%= request.getContextPath() %>/event-details?id=<%= ev.getId() %>" class="btn btn-sm btn-outline">
                        View Details
                    </a>
                </div>
            </div>
        <%  }
        } else { %>
            <div style="grid-column: 1/-1; text-align: center; padding: 48px; background: var(--bg-card); border-radius: var(--radius-lg); border: 1px solid var(--border-color);">
                <p style="color: var(--text-muted); font-size: 1.1rem;">No published featured events currently available.</p>
                <p style="margin-top: 8px;"><a href="<%= request.getContextPath() %>/events" class="btn btn-sm btn-outline-cyan">Explore All Events</a></p>
            </div>
        <% } %>
    </div>
</section>

<!-- =======================================================================
     UPCOMING EVENTS SECTION
     ======================================================================= -->
<section class="section-container" style="padding-top: 0;">
    <div class="section-header">
        <div class="section-title-wrap">
            <span class="section-eyebrow" style="color: var(--accent-orange);">Calendar</span>
            <h2 class="section-title">Upcoming Events</h2>
        </div>
        <div style="display: flex; gap: 8px;">
            <a href="<%= request.getContextPath() %>/events?category=Workshops" class="btn btn-sm btn-outline">Workshops</a>
            <a href="<%= request.getContextPath() %>/events?category=Hackathons" class="btn btn-sm btn-outline">Hackathons</a>
        </div>
    </div>

    <div class="event-grid">
        <% if (upcomingEvents != null && !upcomingEvents.isEmpty()) { 
            for (Event ev : upcomingEvents) { %>
            <div class="event-card">
                <div class="event-card-header">
                    <span class="event-club-tag"><%= ev.getClubName() != null ? ev.getClubName() : "College Committee" %></span>
                    <span class="category-badge <%= ev.getCategoryBadgeClass() %>"><%= ev.getCategory() %></span>
                </div>
                <div class="event-card-body">
                    <h3 class="event-title"><%= ev.getTitle() %></h3>
                    <p class="event-description"><%= ev.getDescription() %></p>
                    
                    <div class="event-meta-list">
                        <div class="event-meta-item">
                            <span>📅</span> <strong><%= ev.getEventDate() %></strong>
                        </div>
                        <div class="event-meta-item">
                            <span>📍</span> <%= ev.getVenue() %>
                        </div>
                    </div>

                    <div class="capacity-progress-wrap">
                        <div class="capacity-info">
                            <span>Seats Remaining</span>
                            <span class="seats-count" style="color: var(--accent-cyan);"><%= ev.getRemainingSeats() %> left</span>
                        </div>
                        <div class="progress-bar-bg">
                            <div class="progress-bar-fill <%= ev.getCapacityPercentage() >= 85 ? "near-full" : "" %>" 
                                 style="width: <%= ev.getCapacityPercentage() %>%;"></div>
                        </div>
                    </div>
                </div>
                <div class="event-card-footer">
                    <span style="font-size: 0.8rem; color: var(--text-muted);">Deadline: <%= ev.getRegistrationDeadline().toString().substring(0, 10) %></span>
                    <a href="<%= request.getContextPath() %>/event-details?id=<%= ev.getId() %>" class="btn btn-sm btn-outline-cyan">
                        Register &rarr;
                    </a>
                </div>
            </div>
        <%  }
        } else { %>
            <div style="grid-column: 1/-1; text-align: center; padding: 48px; background: var(--bg-card); border-radius: var(--radius-lg);">
                <p style="color: var(--text-muted);">Check back soon for upcoming campus events.</p>
            </div>
        <% } %>
    </div>
</section>

<!-- =======================================================================
     COLLEGE CLUBS SECTION
     ======================================================================= -->
<section class="section-container" id="clubs" style="background: rgba(17, 24, 39, 0.4); border-radius: var(--radius-lg); margin-bottom: 60px;">
    <div class="section-header" style="justify-content: center; text-align: center; margin-bottom: 40px;">
        <div>
            <span class="section-eyebrow" style="color: var(--accent-yellow);">Student Organizations</span>
            <h2 class="section-title">Clubs &amp; Chapters at MHSSCE</h2>
            <p style="color: var(--text-secondary); max-width: 600px; margin: 8px auto 0;">
                Empowering students through technical workshops, competitive hackathons, and cultural fests.
            </p>
        </div>
    </div>

    <div class="event-grid">
        <% if (clubs != null) {
            for (Organizer club : clubs) { %>
            <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; display: flex; flex-direction: column;">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
                    <div style="width: 42px; height: 42px; border-radius: 8px; background: rgba(0, 229, 255, 0.1); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; color: var(--accent-cyan); font-weight: 800;">
                        <%= club.getClubName().substring(0, 1) %>
                    </div>
                    <div>
                        <h4 style="color: var(--text-white); font-size: 1.05rem;"><%= club.getClubName() %></h4>
                        <span style="font-size: 0.76rem; color: var(--accent-cyan);">Lead: <%= club.getOrganizerName() %></span>
                    </div>
                </div>
                <p style="font-size: 0.85rem; color: var(--text-secondary); line-height: 1.5; flex: 1;">
                    <%= club.getClubDescription() %>
                </p>
                <div style="margin-top: 16px; pt-2; border-top: 1px solid rgba(255, 255, 255, 0.04);">
                    <a href="<%= request.getContextPath() %>/events?search=<%= club.getClubName() %>" style="font-size: 0.82rem; color: var(--accent-yellow); font-weight: 600;">
                        View Club Events &rarr;
                    </a>
                </div>
            </div>
        <%  }
        } %>
    </div>
</section>

<!-- =======================================================================
     ABOUT MHSSCE SECTION
     ======================================================================= -->
<section class="section-container" id="about" style="text-align: center; max-width: 800px;">
    <span class="section-eyebrow" style="color: var(--accent-lime);">Institution</span>
    <h2 class="section-title" style="margin-bottom: 16px;">M.H. Saboo Siddik College of Engineering</h2>
    <p style="color: var(--text-secondary); line-height: 1.7; font-size: 1.02rem; margin-bottom: 24px;">
        Established in Byculla, Mumbai, MHSSCE is committed to fostering academic excellence, innovation, and technological research. NEXORA provides a unified digital backbone connecting our talented student body with departmental and club events.
    </p>
    <div style="display: flex; justify-content: center; gap: 24px; flex-wrap: wrap; color: var(--text-muted); font-size: 0.9rem;">
        <span>📍 8, Shepherd Road, Byculla, Mumbai 400008</span>
        <span>🎓 Affiliated to University of Mumbai</span>
    </div>
</section>

<jsp:include page="common/footer.jsp" />
