package com.nexora.model;

import java.sql.Timestamp;

public class Organizer {
    private int id;
    private int userId;
    private String clubName;
    private String clubDescription;
    private Timestamp createdAt;

    // Associated User fields for convenience
    private String organizerName;
    private String email;
    private String mobile;

    public Organizer() {}

    public Organizer(int id, int userId, String clubName, String clubDescription, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.clubName = clubName;
        this.clubDescription = clubDescription;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }

    public String getClubDescription() { return clubDescription; }
    public void setClubDescription(String clubDescription) { this.clubDescription = clubDescription; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }
}
