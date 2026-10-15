package com.nexora.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Registration {
    private int id;
    private String registrationId; // format: NX-2026-XXXXX
    private int eventId;
    private int studentId;
    private String fullName;
    private String email;
    private String mobile;
    private String college;
    private String department;
    private String year;
    private String rollNumber;
    private String teamName;
    private String teamMembers;
    private String additionalInformation;
    private Timestamp registrationDate;
    private String status; // REGISTERED, APPROVED, REJECTED, CANCELLED

    // Joined fields for display
    private String eventTitle;
    private String eventCategory;
    private Date eventDate;
    private String eventVenue;
    private String clubName;

    public Registration() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRegistrationId() { return registrationId; }
    public void setRegistrationId(String registrationId) { this.registrationId = registrationId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getCollege() { return college; }
    public void setCollege(String college) { this.college = college; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getYear() { return year; }
    public void setYear(String year) { this.year = year; }

    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public String getTeamMembers() { return teamMembers; }
    public void setTeamMembers(String teamMembers) { this.teamMembers = teamMembers; }

    public String getAdditionalInformation() { return additionalInformation; }
    public void setAdditionalInformation(String additionalInformation) { this.additionalInformation = additionalInformation; }

    public Timestamp getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Timestamp registrationDate) { this.registrationDate = registrationDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public String getEventCategory() { return eventCategory; }
    public void setEventCategory(String eventCategory) { this.eventCategory = eventCategory; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public String getEventVenue() { return eventVenue; }
    public void setEventVenue(String eventVenue) { this.eventVenue = eventVenue; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }

    public String getStatusBadgeClass() {
        if (status == null) return "status-registered";
        switch (status.toUpperCase()) {
            case "APPROVED": return "status-approved";
            case "REJECTED": return "status-rejected";
            case "CANCELLED": return "status-cancelled";
            case "REGISTERED":
            default:
                return "status-registered";
        }
    }
}
