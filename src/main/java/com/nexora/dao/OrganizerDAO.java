package com.nexora.dao;

import com.nexora.model.Organizer;
import com.nexora.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrganizerDAO {

    public Organizer findByUserId(int userId) {
        String sql = "SELECT o.*, u.full_name AS organizer_name, u.email, u.mobile " +
                     "FROM organizers o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToOrganizer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Organizer findById(int id) {
        String sql = "SELECT o.*, u.full_name AS organizer_name, u.email, u.mobile " +
                     "FROM organizers o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToOrganizer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Organizer> getAllOrganizers() {
        List<Organizer> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS organizer_name, u.email, u.mobile " +
                     "FROM organizers o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.club_name ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapRowToOrganizer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean createOrganizer(Organizer org) {
        String sql = "INSERT INTO organizers (user_id, club_name, club_description) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, org.getUserId());
            ps.setString(2, org.getClubName());
            ps.setString(3, org.getClubDescription());
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        org.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Organizer mapRowToOrganizer(ResultSet rs) throws SQLException {
        Organizer o = new Organizer();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setClubName(rs.getString("club_name"));
        o.setClubDescription(rs.getString("club_description"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setOrganizerName(rs.getString("organizer_name"));
        o.setEmail(rs.getString("email"));
        o.setMobile(rs.getString("mobile"));
        return o;
    }
}
