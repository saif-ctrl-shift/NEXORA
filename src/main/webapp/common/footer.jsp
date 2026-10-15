<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</main>
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-top">
            <div>
                <div class="brand-logo" style="margin-bottom: 8px;">
                    <span class="brand-dot"></span>
                    NEXORA
                </div>
                <p style="font-size: 0.88rem; color: var(--text-muted); max-width: 450px;">
                    Centralized event discovery, registration, and club management platform for 
                    <strong>M.H. Saboo Siddik College of Engineering, Byculla, Mumbai</strong>.
                </p>
            </div>
            <div style="display: flex; gap: 40px; flex-wrap: wrap;">
                <div>
                    <h4 style="color: var(--text-white); font-size: 0.88rem; margin-bottom: 12px; text-transform: uppercase; letter-spacing: 0.8px;">Categories</h4>
                    <ul style="list-style: none; font-size: 0.84rem; display: flex; flex-direction: column; gap: 8px;">
                        <li><a href="<%= request.getContextPath() %>/events?category=Hackathons" style="color: var(--cat-hackathons);">Hackathons</a></li>
                        <li><a href="<%= request.getContextPath() %>/events?category=Workshops" style="color: var(--cat-workshops);">Workshops</a></li>
                        <li><a href="<%= request.getContextPath() %>/events?category=Competitions" style="color: var(--cat-competitions);">Competitions</a></li>
                        <li><a href="<%= request.getContextPath() %>/events?category=Seminars" style="color: var(--cat-seminars);">Seminars</a></li>
                        <li><a href="<%= request.getContextPath() %>/events?category=College Events" style="color: var(--cat-college);">College Events</a></li>
                    </ul>
                </div>
                <div>
                    <h4 style="color: var(--text-white); font-size: 0.88rem; margin-bottom: 12px; text-transform: uppercase; letter-spacing: 0.8px;">Quick Links</h4>
                    <ul style="list-style: none; font-size: 0.84rem; display: flex; flex-direction: column; gap: 8px;">
                        <li><a href="<%= request.getContextPath() %>/login?role=STUDENT">Student Portal</a></li>
                        <li><a href="<%= request.getContextPath() %>/login?role=ORGANIZER">Event Organizer Portal</a></li>
                        <li><a href="<%= request.getContextPath() %>/register">Student Registration</a></li>
                        <li><a href="<%= request.getContextPath() %>/events">Browse All Events</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <span>&copy; 2026 NEXORA • M.H. Saboo Siddik College of Engineering. All rights reserved.</span>
            <span>Built with Java Servlets, JSP, JDBC, &amp; MySQL.</span>
        </div>
    </div>
</footer>
<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
