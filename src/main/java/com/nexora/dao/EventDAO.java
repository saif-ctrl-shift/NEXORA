package com.nexora.dao;

import com.nexora.model.Event;
import com.nexora.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public List<Event> getPublishedEvents(String keyword, String category) {
        List<Event> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT e.*, o.club_name, u.full_name AS organizer_name, " +
            "(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count " +
            "FROM events e " +
            "JOIN organizers o ON e.organizer_id = o.id " +
            "JOIN users u ON o.user_id = u.id " +
            "WHERE e.status = 'PUBLISHED' "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.title) LIKE ? OR LOWER(e.description) LIKE ? OR LOWER(o.club_name) LIKE ? OR LOWER(e.venue) LIKE ?) ");
            String searchPattern = "%" + keyword.trim().toLowerCase() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("ALL")) {
            sql.append("AND LOWER(e.category) = ? ");
            params.add(category.trim().toLowerCase());
        }

        sql.append("ORDER BY e.event_date ASC, e.start_time ASC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToEvent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Event> getFeaturedEvents(int limit) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, o.club_name, u.full_name AS organizer_name, " +
                     "(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count " +
                     "FROM events e " +
                     "JOIN organizers o ON e.organizer_id = o.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE e.status = 'PUBLISHED' AND e.event_date >= CURDATE() " +
                     "ORDER BY e.event_date ASC, e.capacity DESC LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToEvent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Event> getUpcomingEvents(int limit) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, o.club_name, u.full_name AS organizer_name, " +
                     "(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count " +
                     "FROM events e " +
                     "JOIN organizers o ON e.organizer_id = o.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE e.status = 'PUBLISHED' AND e.event_date >= CURDATE() " +
                     "ORDER BY e.event_date ASC LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToEvent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Event getEventById(int id) {
        String sql = "SELECT e.*, o.club_name, u.full_name AS organizer_name, " +
                     "(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count " +
                     "FROM events e " +
                     "JOIN organizers o ON e.organizer_id = o.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE e.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToEvent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Event> getEventsByOrganizerId(int organizerId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, o.club_name, u.full_name AS organizer_name, " +
                     "(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count " +
                     "FROM events e " +
                     "JOIN organizers o ON e.organizer_id = o.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE e.organizer_id = ? " +
                     "ORDER BY e.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, organizerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToEvent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int createEvent(Event event) {
        String sql = "INSERT INTO events (organizer_id, title, category, description, event_date, start_time, end_time, " +
                     "venue, eligibility, rules, registration_deadline, capacity, status, banner) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, event.getOrganizerId());
            ps.setString(2, event.getTitle());
            ps.setString(3, event.getCategory());
            ps.setString(4, event.getDescription());
            ps.setDate(5, event.getEventDate());
            ps.setTime(6, event.getStartTime());
            ps.setTime(7, event.getEndTime());
            ps.setString(8, event.getVenue());
            ps.setString(9, event.getEligibility());
            ps.setString(10, event.getRules());
            ps.setTimestamp(11, event.getRegistrationDeadline());
            ps.setInt(12, event.getCapacity());
            ps.setString(13, event.getStatus());
            ps.setString(14, event.getBanner());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateEvent(Event event) {
        // Enforce organizer_id match in WHERE clause for bulletproof security
        String sql = "UPDATE events SET title = ?, category = ?, description = ?, event_date = ?, " +
                     "start_time = ?, end_time = ?, venue = ?, eligibility = ?, rules = ?, " +
                     "registration_deadline = ?, capacity = ?, status = ?, banner = ? " +
                     "WHERE id = ? AND organizer_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, event.getTitle());
            ps.setString(2, event.getCategory());
            ps.setString(3, event.getDescription());
            ps.setDate(4, event.getEventDate());
            ps.setTime(5, event.getStartTime());
            ps.setTime(6, event.getEndTime());
            ps.setString(7, event.getVenue());
            ps.setString(8, event.getEligibility());
            ps.setString(9, event.getRules());
            ps.setTimestamp(10, event.getRegistrationDeadline());
            ps.setInt(11, event.getCapacity());
            ps.setString(12, event.getStatus());
            ps.setString(13, event.getBanner());
            ps.setInt(14, event.getId());
            ps.setInt(15, event.getOrganizerId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEvent(int eventId, int organizerId) {
        // Enforce organizer_id match in WHERE clause
        String sql = "DELETE FROM events WHERE id = ? AND organizer_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, eventId);
            ps.setInt(2, organizerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateEventStatus(int eventId, int organizerId, String newStatus) {
        String sql = "UPDATE events SET status = ? WHERE id = ? AND organizer_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, eventId);
            ps.setInt(3, organizerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getOrganizerEventCount(int organizerId) {
        String sql = "SELECT COUNT(*) FROM events WHERE organizer_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, organizerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getOrganizerUpcomingCount(int organizerId) {
        String sql = "SELECT COUNT(*) FROM events WHERE organizer_id = ? AND event_date >= CURDATE()";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, organizerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getOrganizerActiveCount(int organizerId) {
        String sql = "SELECT COUNT(*) FROM events WHERE organizer_id = ? AND status = 'PUBLISHED'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, organizerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Event mapRowToEvent(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setId(rs.getInt("id"));
        e.setOrganizerId(rs.getInt("organizer_id"));
        e.setTitle(rs.getString("title"));
        e.setCategory(rs.getString("category"));
        e.setDescription(rs.getString("description"));
        e.setEventDate(rs.getDate("event_date"));
        e.setStartTime(rs.getTime("start_time"));
        e.setEndTime(rs.getTime("end_time"));
        e.setVenue(rs.getString("venue"));
        e.setEligibility(rs.getString("eligibility"));
        e.setRules(rs.getString("rules"));
        e.setRegistrationDeadline(rs.getTimestamp("registration_deadline"));
        e.setCapacity(rs.getInt("capacity"));
        e.setStatus(rs.getString("status"));
        e.setBanner(rs.getString("banner"));
        e.setCreatedAt(rs.getTimestamp("created_at"));
        e.setUpdatedAt(rs.getTimestamp("updated_at"));

        try {
            e.setClubName(rs.getString("club_name"));
            e.setOrganizerName(rs.getString("organizer_name"));
            e.setRegistrationCount(rs.getInt("reg_count"));
        } catch (SQLException ignored) {
            // Optional columns if not in result set
        }
        return e;
    }
}
