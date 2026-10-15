<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String selectedRole = (String) request.getAttribute("selectedRole");
    if (selectedRole == null) {
        selectedRole = request.getParameter("role");
    }
    if (selectedRole == null || selectedRole.trim().isEmpty()) {
        selectedRole = "STUDENT";
    }
    String error = (String) request.getAttribute("error");
%>
<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="Portal Login – NEXORA" />
</jsp:include>

<div class="section-container" style="padding-top: 40px; padding-bottom: 80px;">
    <div class="form-card" style="max-width: 480px;">
        
        <!-- Role Switcher Tabs -->
        <div style="display: flex; background: #0D131F; padding: 4px; border-radius: var(--radius-md); margin-bottom: 28px; border: 1px solid var(--border-light);">
            <a href="<%= request.getContextPath() %>/login?role=STUDENT" 
               style="flex: 1; text-align: center; padding: 10px; font-weight: 700; font-size: 0.88rem; border-radius: var(--radius-sm); transition: all 0.2s; <%= "STUDENT".equalsIgnoreCase(selectedRole) ? "background: var(--accent-cyan); color: #080B12; box-shadow: 0 2px 10px rgba(0,229,255,0.3);" : "color: var(--text-secondary);" %>">
               🎓 STUDENT LOGIN
            </a>
            <a href="<%= request.getContextPath() %>/login?role=ORGANIZER" 
               style="flex: 1; text-align: center; padding: 10px; font-weight: 700; font-size: 0.88rem; border-radius: var(--radius-sm); transition: all 0.2s; <%= "ORGANIZER".equalsIgnoreCase(selectedRole) ? "background: var(--accent-orange); color: #080B12; box-shadow: 0 2px 10px rgba(255,122,0,0.3);" : "color: var(--text-secondary);" %>">
               🎯 EVENT ORGANIZER
            </a>
        </div>

        <div style="text-align: center; margin-bottom: 24px;">
            <h2 style="font-size: 1.6rem; font-weight: 800; color: var(--text-white);">
                <%= "ORGANIZER".equalsIgnoreCase(selectedRole) ? "Club Organizer Portal" : "Student Login" %>
            </h2>
            <p style="color: var(--text-muted); font-size: 0.88rem; margin-top: 4px;">
                <%= "ORGANIZER".equalsIgnoreCase(selectedRole) 
                    ? "Manage your college club events and participant lists." 
                    : "Discover, register, and track your college event passes." %>
            </p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-error">
                <span>⚠️</span>
                <span><%= error %></span>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <input type="hidden" name="role" value="<%= selectedRole.toUpperCase() %>">

            <div class="form-group">
                <label class="form-label">Email Address <span class="required">*</span></label>
                <input type="email" name="email" class="form-control" 
                       placeholder="<%= "ORGANIZER".equalsIgnoreCase(selectedRole) ? "club@mhssce.ac.in" : "student@mhssce.ac.in" %>" 
                       required autocomplete="email">
            </div>

            <div class="form-group">
                <label class="form-label">Password <span class="required">*</span></label>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-lg <%= "ORGANIZER".equalsIgnoreCase(selectedRole) ? "btn-primary-create" : "btn-primary-explore" %>" style="width: 100%; margin-top: 8px;">
                Sign In to <%= "ORGANIZER".equalsIgnoreCase(selectedRole) ? "Organizer Hub" : "Student Portal" %>
            </button>
        </form>

        <% if (!"ORGANIZER".equalsIgnoreCase(selectedRole)) { %>
            <div style="text-align: center; margin-top: 24px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.06); font-size: 0.88rem; color: var(--text-secondary);">
                Don't have a student account? 
                <a href="<%= request.getContextPath() %>/register" style="color: var(--accent-cyan); font-weight: 600;">Register Here</a>
            </div>
        <% } %>

        <!-- Demo Credentials Helper Card -->
        <div style="margin-top: 28px; background: rgba(0, 229, 255, 0.04); border: 1px dashed rgba(0, 229, 255, 0.3); border-radius: var(--radius-md); padding: 16px; font-size: 0.82rem;">
            <div style="font-weight: 700; color: var(--accent-yellow); margin-bottom: 6px; display: flex; align-items: center; gap: 6px;">
                🔑 Quick Demo Credentials
            </div>
            <% if ("ORGANIZER".equalsIgnoreCase(selectedRole)) { %>
                <div style="color: var(--text-secondary); line-height: 1.5;">
                    <div><strong>GfG Club:</strong> gfg@mhssce.ac.in / password123</div>
                    <div><strong>IEEE Branch:</strong> ieee@mhssce.ac.in / password123</div>
                    <div><strong>Programmers:</strong> code@mhssce.ac.in / password123</div>
                </div>
            <% } else { %>
                <div style="color: var(--text-secondary); line-height: 1.5;">
                    <div><strong>Student 1:</strong> saif@student.mhssce.ac.in / password123</div>
                    <div><strong>Student 2:</strong> fakhruddin@student.mhssce.ac.in / password123</div>
                </div>
            <% } %>
        </div>

    </div>
</div>

<jsp:include page="common/footer.jsp" />
