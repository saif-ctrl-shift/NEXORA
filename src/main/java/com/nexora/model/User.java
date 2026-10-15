package com.nexora.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String role; // "STUDENT" or "ORGANIZER"
    private String department;
    private String year;
    private String rollNumber;
    private String mobile;
    private Timestamp createdAt;

    public User() {}

    public User(int id, String fullName, String email, String password, String role, 
                String department, String year, String rollNumber, String mobile, Timestamp createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.department = department;
        this.year = year;
        this.rollNumber = rollNumber;
        this.mobile = mobile;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getYear() { return year; }
    public void setYear(String year) { this.year = year; }

    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isStudent() {
        return "STUDENT".equalsIgnoreCase(this.role);
    }

    public boolean isOrganizer() {
        return "ORGANIZER".equalsIgnoreCase(this.role);
    }
}
