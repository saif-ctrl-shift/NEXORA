package com.nexora.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Reusable DatabaseConnection utility for NEXORA College Event Management System.
 * 
 * Default Configuration:
 *   Database: nexora (or nexora_db)
 *   Host:     localhost
 *   Port:     3306
 *   User:     root
 *   Password: root (or configured in db.properties / environment variables)
 * 
 * To change configuration:
 *   1. Set environment variables: NEXORA_DB_URL, NEXORA_DB_USER, NEXORA_DB_PASSWORD
 *   2. Or edit db.properties in the classpath (WEB-INF/classes/db.properties)
 *   3. Or modify the fallback constants in this class.
 */
public class DatabaseConnection {

    private static String dbUrl = "jdbc:mysql://localhost:3306/nexora?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String dbUser = "root";
    private static String dbPassword = "root";

    static {
        try {
            // Load MySQL Connector/J driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Attempt to load properties from classpath
            try (InputStream input = DatabaseConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (input != null) {
                    Properties prop = new Properties();
                    prop.load(input);
                    if (prop.getProperty("db.url") != null) dbUrl = prop.getProperty("db.url");
                    if (prop.getProperty("db.user") != null) dbUser = prop.getProperty("db.user");
                    if (prop.getProperty("db.password") != null) dbPassword = prop.getProperty("db.password");
                }
            } catch (Exception ignored) {
                // Ignore and use defaults
            }

            // Override with environment variables if present
            String envUrl = System.getenv("NEXORA_DB_URL");
            String envUser = System.getenv("NEXORA_DB_USER");
            String envPass = System.getenv("NEXORA_DB_PASSWORD");

            if (envUrl != null && !envUrl.trim().isEmpty()) dbUrl = envUrl;
            if (envUser != null && !envUser.trim().isEmpty()) dbUser = envUser;
            if (envPass != null) dbPassword = envPass;

        } catch (ClassNotFoundException e) {
            System.err.println("DatabaseConnection: MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * Get an active JDBC connection to MySQL.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    /**
     * Allow programmatic override of database credentials.
     */
    public static void setCredentials(String url, String user, String password) {
        dbUrl = url;
        dbUser = user;
        dbPassword = password;
    }

    public static String getDbUrl() {
        return dbUrl;
    }

    public static String getDbUser() {
        return dbUser;
    }

    /**
     * Safely close a connection.
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
