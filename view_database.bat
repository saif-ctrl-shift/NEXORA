@echo off
setlocal
title NEXORA - MySQL Database Inspector
echo ======================================================================
echo              NEXORA COLLEGE EVENT MANAGEMENT SYSTEM
echo                   MySQL Database Data Inspector
echo ======================================================================
echo Database: nexora (Port: 3306, User: root)
echo.

set "MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"

if not exist "%MYSQL_PATH%" (
    echo [ERROR] MySQL CLI not found at "%MYSQL_PATH%".
    echo Please make sure MySQL 8.0 is installed.
    pause
    exit /b 1
)

echo ----------------------------------------------------------------------
echo 1. REGISTERED USERS (users table)
echo ----------------------------------------------------------------------
"%MYSQL_PATH%" -uroot -proot nexora -t -e "SELECT id, full_name, email, role, department, year, roll_number, mobile FROM users LIMIT 15;"

echo.
echo ----------------------------------------------------------------------
echo 2. COLLEGE CLUBS AND ORGANIZERS (organizers table)
echo ----------------------------------------------------------------------
"%MYSQL_PATH%" -uroot -proot nexora -t -e "SELECT id, user_id, club_name, created_at FROM organizers;"

echo.
echo ----------------------------------------------------------------------
echo 3. CREATED EVENTS (events table)
echo ----------------------------------------------------------------------
"%MYSQL_PATH%" -uroot -proot nexora -t -e "SELECT id, organizer_id, title, category, event_date, venue, capacity, status FROM events;"

echo.
echo ----------------------------------------------------------------------
echo 4. STUDENT REGISTRATIONS AND PASSES (registrations table)
echo ----------------------------------------------------------------------
"%MYSQL_PATH%" -uroot -proot nexora -t -e "SELECT id, registration_id, event_id, student_id, full_name, team_name, status, registration_date FROM registrations;"

echo.
echo ======================================================================
echo Total Counts:
"%MYSQL_PATH%" -uroot -proot nexora -t -e "SELECT (SELECT COUNT(*) FROM users) AS Total_Users, (SELECT COUNT(*) FROM organizers) AS Total_Clubs, (SELECT COUNT(*) FROM events) AS Total_Events, (SELECT COUNT(*) FROM registrations) AS Total_Registrations;"
echo ======================================================================
echo.
pause
