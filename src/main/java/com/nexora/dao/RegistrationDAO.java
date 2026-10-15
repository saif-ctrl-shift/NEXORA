package com.nexora.dao;

import com.nexora.model.Registration;
import com.nexora.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO {

    public synchronized String generateUniqueRegistrationId() {
        // Format: NX-2026-XXXXX
        String prefix = "NX-2026-";
        int nextNum = 1;
        String sql = "SELECT MAX(id) FROM registrations";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                nextNum = rs.getInt(1) + 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return String.format("%s%05d", prefix, nextNum);
    }

    public boolean isStudentRegisteredForEvent(int studentId, int eventId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE student_id = ? AND event_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getRegistrationCountForEvent(int eventId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE event_id = ? AND status != 'CANCELLED'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean createRegistration(Registration reg) {
        String sql = "INSERT INTO registrations (registration_id, event_id, student_id, full_name, email, mobile, " +
                     "college, department, year, roll_number, team_name, team_members, additional_information, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, reg.getRegistrationId());
            ps.setInt(2, reg.getEventId());
            ps.setInt(3, reg.getStudentId());
            ps.setString(4, reg.getFullName());
            ps.setString(5, reg.getEmail());
            ps.setString(6, reg.getMobile());
            ps.setString(7, reg.getCollege());
            ps.setString(8, reg.getDepartment());
            ps.setString(9, reg.getYear());
            ps.setString(10, reg.getRollNumber());
            ps.setString(11, reg.getTeamName() != null ? reg.getTeamName() : "");
            ps.setString(12, reg.getTeamMembers() != null ? reg.getTeamMembers() : "");
            ps.setString(13, reg.getAdditionalInformation() != null ? reg.getAdditionalInformation() : "");
            ps.setString(14, reg.getStatus() != null ? reg.getStatus() : "REGISTERED");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        reg.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Registration> getRegistrationsByStudentId(int studentId) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.*, e.title AS event_title, e.category AS event_category, " +
                     "e.event_date, e.venue AS event_venue, o.club_name " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "JOIN organizers o ON e.organizer_id = o.id " +
                     "WHERE r.student_id = ? " +
                     "ORDER BY r.registration_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToRegistration(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Registration> getRegistrationsByEventId(int eventId, int organizerId, String keyword, String status, String sortBy) {
        List<Registration> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, e.title AS event_title, e.category AS event_category, " +
            "e.event_date, e.venue AS event_venue, o.club_name " +
            "FROM registrations r " +
            "JOIN events e ON r.event_id = e.id " +
            "JOIN organizers o ON e.organizer_id = o.id " +
            "WHERE r.event_id = ? AND e.organizer_id = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(eventId);
        params.add(organizerId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(r.full_name) LIKE ? OR LOWER(r.email) LIKE ? OR LOWER(r.roll_number) LIKE ? OR LOWER(r.registration_id) LIKE ? OR LOWER(r.department) LIKE ?) ");
            String pat = "%" + keyword.trim().toLowerCase() + "%";
            params.add(pat);
            params.add(pat);
            params.add(pat);
            params.add(pat);
            params.add(pat);
        }

        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("ALL")) {
            sql.append("AND r.status = ? ");
            params.add(status.toUpperCase().trim());
        }

        if ("name_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY r.full_name ASC");
        } else if ("roll_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY r.roll_number ASC");
        } else if ("status".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY r.status ASC, r.registration_date DESC");
        } else {
            sql.append("ORDER BY r.registration_date DESC");
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToRegistration(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Registration getRegistrationByCode(String registrationId) {
        String sql = "SELECT r.*, e.title AS event_title, e.category AS event_category, " +
                     "e.event_date, e.venue AS event_venue, o.club_name " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "JOIN organizers o ON e.organizer_id = o.id " +
                     "WHERE r.registration_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, registrationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToRegistration(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateRegistrationStatus(int id, String newStatus, int organizerId) {
        // Enforce organizer ownership of the associated event!
        String sql = "UPDATE registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "SET r.status = ? " +
                     "WHERE r.id = ? AND e.organizer_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus.toUpperCase());
            ps.setInt(2, id);
            ps.setInt(3, organizerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalRegistrationsForOrganizer(int organizerId) {
        String sql = "SELECT COUNT(*) FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE e.organizer_id = ? AND r.status != 'CANCELLED'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, organizerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Registration mapRowToRegistration(ResultSet rs) throws SQLException {
        Registration r = new Registration();
        r.setId(rs.getInt("id"));
        r.setRegistrationId(rs.getString("registration_id"));
        r.setEventId(rs.getInt("event_id"));
        r.setStudentId(rs.getInt("student_id"));
        r.setFullName(rs.getString("full_name"));
        r.setEmail(rs.getString("email"));
        r.setMobile(rs.getString("mobile"));
        r.setCollege(rs.getString("college"));
        r.setDepartment(rs.getString("department"));
        r.setYear(rs.getString("year"));
        r.setRollNumber(rs.getString("roll_number"));
        r.setTeamName(rs.getString("team_name"));
        r.setTeamMembers(rs.getString("team_members"));
        r.setAdditionalInformation(rs.getString("additional_information"));
        r.setRegistrationDate(rs.getTimestamp("registration_date"));
        r.setStatus(rs.getString("status"));

        try {
            r.setEventTitle(rs.getString("event_title"));
            r.setEventCategory(rs.getString("event_category"));
            r.setEventDate(rs.getDate("event_date"));
            r.setEventVenue(rs.getString("event_venue"));
            r.setClubName(rs.getString("club_name"));
        } catch (SQLException ignored) {}
        return r;
    }
}
