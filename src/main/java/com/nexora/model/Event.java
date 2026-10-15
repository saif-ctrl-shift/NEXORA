package com.nexora.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Event {
    private int id;
    private int organizerId;
    private String title;
    private String category; // Hackathons, Workshops, Competitions, Seminars, College Events
    private String description;
    private Date eventDate;
    private Time startTime;
    private Time endTime;
    private String venue;
    private String eligibility;
    private String rules;
    private Timestamp registrationDeadline;
    private int capacity;
    private String status; // DRAFT, PUBLISHED, CLOSED, COMPLETED
    private String banner;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Additional display fields from joins
    private String clubName;
    private String organizerName;
    private int registrationCount;

    public Event() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrganizerId() { return organizerId; }
    public void setOrganizerId(int organizerId) { this.organizerId = organizerId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public String getEligibility() { return eligibility; }
    public void setEligibility(String eligibility) { this.eligibility = eligibility; }

    public String getRules() { return rules; }
    public void setRules(String rules) { this.rules = rules; }

    public Timestamp getRegistrationDeadline() { return registrationDeadline; }
    public void setRegistrationDeadline(Timestamp registrationDeadline) { this.registrationDeadline = registrationDeadline; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getBanner() { return banner; }
    public void setBanner(String banner) { this.banner = banner; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }

    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }

    public int getRegistrationCount() { return registrationCount; }
    public void setRegistrationCount(int registrationCount) { this.registrationCount = registrationCount; }

    // Business Logic Helper Methods
    public int getRemainingSeats() {
        int remaining = capacity - registrationCount;
        return Math.max(remaining, 0);
    }

    public int getCapacityPercentage() {
        if (capacity <= 0) return 100;
        int pct = (int) Math.round(((double) registrationCount / capacity) * 100);
        return Math.min(pct, 100);
    }

    public boolean isPublished() {
        return "PUBLISHED".equalsIgnoreCase(this.status);
    }

    public boolean isDraft() {
        return "DRAFT".equalsIgnoreCase(this.status);
    }

    public boolean isDeadlinePassed() {
        if (registrationDeadline == null) return false;
        return System.currentTimeMillis() > registrationDeadline.getTime();
    }

    public boolean isFull() {
        return capacity > 0 && registrationCount >= capacity;
    }

    public boolean isRegistrationOpen() {
        return isPublished() && !isDeadlinePassed() && !isFull();
    }

    public String getCategoryBadgeClass() {
        if (category == null) return "badge-default";
        String cat = category.toLowerCase().trim();
        if (cat.contains("hackathon")) return "badge-hackathon";
        if (cat.contains("workshop")) return "badge-workshop";
        if (cat.contains("competition")) return "badge-competition";
        if (cat.contains("seminar")) return "badge-seminar";
        if (cat.contains("college")) return "badge-college";
        return "badge-default";
    }
}
