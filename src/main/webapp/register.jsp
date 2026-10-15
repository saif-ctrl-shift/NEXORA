<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
%>
<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="Student Registration – NEXORA" />
</jsp:include>

<div class="section-container" style="padding-top: 40px; padding-bottom: 80px;">
    <div class="form-card">
        <div style="text-align: center; margin-bottom: 28px;">
            <span class="section-eyebrow">MHSSCE Student Portal</span>
            <h2 style="font-size: 1.8rem; font-weight: 800; color: var(--text-white);">Create Student Account</h2>
            <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 4px;">
                Join NEXORA to explore, register, and generate digital event passes.
            </p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-error">
                <span>⚠️</span>
                <span><%= error %></span>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/register" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Full Name <span class="required">*</span></label>
                    <input type="text" name="fullName" class="form-control" placeholder="e.g. Saif Ali" required>
                </div>
                <div class="form-group">
                    <label class="form-label">College Email <span class="required">*</span></label>
                    <input type="email" name="email" class="form-control" placeholder="name@student.mhssce.ac.in" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Password <span class="required">*</span></label>
                    <input type="password" name="password" class="form-control" placeholder="Min 6 characters" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Confirm Password <span class="required">*</span></label>
                    <input type="password" name="confirmPassword" class="form-control" placeholder="Re-type password" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Department <span class="required">*</span></label>
                    <select name="department" class="form-control" required>
                        <option value="">Select Department</option>
                        <option value="Computer Engineering">Computer Engineering</option>
                        <option value="Information Technology">Information Technology</option>
                        <option value="Artificial Intelligence & Data Science">Artificial Intelligence & Data Science</option>
                        <option value="Mechanical Engineering">Mechanical Engineering</option>
                        <option value="Civil Engineering">Civil Engineering</option>
                        <option value="Electronics & Telecommunication">Electronics &amp; Telecommunication</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Year of Study <span class="required">*</span></label>
                    <select name="year" class="form-control" required>
                        <option value="">Select Year</option>
                        <option value="First Year (FE)">First Year (FE)</option>
                        <option value="Second Year (SE)">Second Year (SE)</option>
                        <option value="Third Year (TE)">Third Year (TE)</option>
                        <option value="Fourth Year (BE)">Fourth Year (BE)</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Roll Number / Student ID <span class="required">*</span></label>
                    <input type="text" name="rollNumber" class="form-control" placeholder="e.g. 21CO15" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Mobile Number <span class="required">*</span></label>
                    <input type="tel" name="mobile" class="form-control" placeholder="e.g. 9876543210" required>
                </div>
            </div>

            <button type="submit" class="btn btn-lg btn-primary-explore" style="width: 100%; margin-top: 12px;">
                Register &amp; Access Dashboard
            </button>
        </form>

        <div style="text-align: center; margin-top: 24px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.06); font-size: 0.88rem; color: var(--text-secondary);">
            Already have an account? 
            <a href="<%= request.getContextPath() %>/login?role=STUDENT" style="color: var(--accent-cyan); font-weight: 600;">Sign in here</a>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />
