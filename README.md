# NEXORA – College Event Management System

**Institution:** M.H. Saboo Siddik College of Engineering, Byculla, Mumbai  
**Platform:** NEXORA (College Event Discovery, Registration & Management)  
**Architecture:** Model-View-Controller (MVC)  
**Stack:** Java, JSP, Java Servlets (Jakarta EE), JDBC, MySQL, Apache Tomcat 10+

---

## 1. Project Overview

**NEXORA** is a centralized, production-grade College Event Management System developed from scratch for **M.H. Saboo Siddik College of Engineering, Mumbai**. 

The platform bridges student participation and club event administration:
- **Students** discover campus hackathons, technical workshops, competitions, and seminars, register with a single click, and receive an authentic, persistent Registration ID (e.g., `NX-2026-00005`) and official digital admission pass.
- **Event Organizers** (representing campus clubs like GeeksforGeeks Chapter, IEEE Student Branch, EDC Cell, Programmers Club, AI/ML Club, and KWS Club) manage the entire lifecycle of their events—from draft curation and publishing to monitoring live capacity progress bars and updating registration approvals.

All transactions communicate directly through **Java Servlets & JDBC PreparedStatement** and persist to a real MySQL database (`nexora_db`).

---

## 2. Key Features

### Student Features
- **Student Authentication:** Secure session-based login and account registration.
- **Event Discovery & Filtering:** Browse published events with real-time category filtering (Hackathons, Workshops, Competitions, Seminars, College Events) and keyword search.
- **Live Event Details:** View venue, time slot, eligibility, guidelines, live capacity progress bars, and remaining seats.
- **Smart Registration:**
  - Auto-fills student academic details (Department, Year, Roll Number).
  - Supports Team details for Hackathons/Competitions.
  - Server-side deadline check (registration closes automatically after deadline).
  - Server-side capacity check (registration stops when capacity is reached).
  - Duplicate registration protection (prevents registering twice for the same event).
- **Official Admission Pass:** Generates a real unique verification ID (`NX-2026-XXXXX`) and printable confirmation pass.
- **Student Dashboard:** Centralized view of all registered events, status badges, and recommended upcoming fests.

### Event Organizer Features
- **Dedicated Organizer Portal:** Separate secure login flow tailored for college club heads.
- **Dashboard Metrics:** Real-time metrics computed directly from MySQL:
  - Total Events
  - Total Registrations
  - Active Published Events
  - Upcoming Events
- **Event Lifecycle (CRUD):**
  - **Save as Draft** (`DRAFT`) or **Publish** (`PUBLISHED`).
  - Edit event details, schedule, venue, capacity, rules, and deadlines.
  - Delete events (with cascading removal of registrations).
- **Participant Management:**
  - View all registered students per event.
  - Filter participants by status (`REGISTERED`, `APPROVED`, `REJECTED`, `CANCELLED`).
  - Search participants by name, email, roll number, or Registration ID.
  - Sort participants by name, roll number, or registration timestamp.
  - Update student registration status with instant database persistence.
- **Strict Role-Based Security:**
  - Students cannot access organizer routes.
  - Organizers can only edit, delete, or manage registrations for **their own events**.

---

## 3. Technology Stack

- **Frontend:** HTML5, CSS3 (Modern dark base `#080B12`, cards `#182235`, bright accents, **strictly zero purple**), Vanilla JavaScript for responsive filters and print actions.
- **Backend:** Java 17+, Java Servlets 6.0 (`jakarta.servlet.*`), JavaServer Pages 3.1 (`jakarta.servlet.jsp.*`), JSTL 3.0.
- **Database Access:** JDBC with `PreparedStatement` (SQL Injection protected), DAO Pattern, Connection Pooling-ready.
- **Database Engine:** MySQL Server 8.0+ / 8.4+.
- **Web Application Server:** Apache Tomcat 10.1+.
- **Build System:** Apache Maven 3.9+.

---

## 4. Project Structure

```
NEXORA/
├── pom.xml                                    # Maven configuration & dependencies
├── schema.sql                                 # Complete MySQL database DDL & seed data
├── reset_mysql_to_root.bat                    # 1-Click root password reset utility
├── start_server.bat                           # 1-Click Tomcat & NEXORA launcher
├── stop_server.bat                            # 1-Click Tomcat stopper
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── nexora/
│       │           ├── controller/            # Servlets (MVC Controllers)
│       │           │   ├── LoginServlet.java
│       │           │   ├── LogoutServlet.java
│       │           │   ├── RegisterServlet.java
│       │           │   ├── EventServlet.java
│       │           │   ├── EventDetailsServlet.java
│       │           │   ├── RegistrationServlet.java
│       │           │   ├── StudentDashboardServlet.java
│       │           │   ├── OrganizerDashboardServlet.java
│       │           │   ├── CreateEventServlet.java
│       │           │   ├── UpdateEventServlet.java
│       │           │   ├── DeleteEventServlet.java
│       │           │   ├── PublishEventServlet.java
│       │           │   └── OrganizerRegistrationServlet.java
│       │           │
│       │           ├── dao/                   # Data Access Objects (JDBC PreparedStatement)
│       │           │   ├── UserDAO.java
│       │           │   ├── OrganizerDAO.java
│       │           │   ├── EventDAO.java
│       │           │   └── RegistrationDAO.java
│       │           │
│       │           ├── model/                 # Entity POJOs (MVC Models)
│       │           │   ├── User.java
│       │           │   ├── Organizer.java
│       │           │   ├── Event.java
│       │           │   └── Registration.java
│       │           │
│       │           └── util/                  # Utilities
│       │               └── DatabaseConnection.java
│       │
│       ├── resources/
│       │   └── db.properties                  # Database configuration properties
│       │
│       └── webapp/                            # Web Application Views & Assets
│           ├── index.jsp                      # Master Landing Page (Centered Hero)
│           ├── login.jsp                      # Role-based login (Student / Organizer)
│           ├── register.jsp                   # Student sign up
│           ├── common/
│           │   ├── header.jsp                 # Top navigation bar
│           │   └── footer.jsp                 # Institutional footer
│           ├── events/
│           │   ├── event-list.jsp             # Event directory with search & filters
│           │   └── event-details.jsp          # Event details & capacity monitor
│           ├── student/
│           │   ├── dashboard.jsp              # Student dashboard & registered passes
│           │   ├── register-event.jsp         # Event registration form
│           │   └── registration-success.jsp   # Official printable admission pass
│           ├── organizer/
│           │   ├── dashboard.jsp              # Club metrics & event table
│           │   ├── create-event.jsp           # Event creation (Draft / Publish)
│           │   ├── edit-event.jsp             # Event update form
│           │   └── event-registrations.jsp    # Participant table & status updater
│           ├── css/
│           │   └── style.css                  # Dark premium theme, strictly NO PURPLE
│           ├── js/
│           │   └── main.js                    # Client-side helper scripts
│           └── WEB-INF/
│               └── web.xml                    # Web deployment descriptor
│
└── tools/                                     # Bundled runtime tools (Tomcat 10 & Maven)
    ├── apache-maven-3.9.9/
    └── apache-tomcat-10.1.34/
```

---

## 5. MySQL Installation & Database Setup

### Step 1: Ensure MySQL is running
Make sure the **MySQL80** service is running on your machine (default port `3306`).

### Step 2: Initialize Database and Seed Data
Run the included `schema.sql` script into your local MySQL instance:

```bash
mysql -u root -p < schema.sql
```
*(Enter your MySQL root password when prompted)*

This automatically creates:
- Database: `nexora_db`
- Tables: `users`, `organizers`, `events`, `registrations`
- Foreign keys with cascading deletes
- Unique constraint `uq_student_event(student_id, event_id)`
- Seed data for **M.H. Saboo Siddik College of Engineering** clubs, events, and student accounts.

---

## 6. Database Connection Configuration

The database connection is managed centrally in:
[`src/main/java/com/nexora/util/DatabaseConnection.java`](file:///c:/Users/fakhruddin/Downloads/NEXORA/src/main/java/com/nexora/util/DatabaseConnection.java)
and configured via:
[`src/main/resources/db.properties`](file:///c:/Users/fakhruddin/Downloads/NEXORA/src/main/resources/db.properties)

```properties
db.url=jdbc:mysql://localhost:3306/nexora_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.user=root
db.password=root
```

### Environment Variable Overrides (Optional):
You can also override credentials without rebuilding:
- `NEXORA_DB_URL`
- `NEXORA_DB_USER`
- `NEXORA_DB_PASSWORD`

---

## 7. How to Build & Run NEXORA

### Option A: 1-Click Launch (Recommended)
Double-click `start_server.bat` in the project root:
```cmd
start_server.bat
```
This automatically sets up `JAVA_HOME` and starts Apache Tomcat 10.1.34.

Open your browser and navigate to:
**http://localhost:8080/** or **http://localhost:8080/nexora/**

To stop the server:
```cmd
stop_server.bat
```

### Option B: Build with Maven
To rebuild the project after making modifications:
```powershell
$env:JAVA_HOME = "C:\Program Files\JetBrains\PyCharm 2026.1.4\jbr"
.\tools\apache-maven-3.9.9\bin\mvn.cmd clean package
```
Then copy `target\nexora.war` into `tools\apache-tomcat-10.1.34\webapps\ROOT.war`.

---

## 8. Demo Credentials

### Event Organizers (College Clubs)
| Club / Organization | Login Email | Password | Role |
| :--- | :--- | :--- | :--- |
| **GeeksforGeeks Club** | `gfg@mhssce.ac.in` | `password123` | EVENT ORGANIZER |
| **IEEE Student Branch** | `ieee@mhssce.ac.in` | `password123` | EVENT ORGANIZER |
| **Programmers Club** | `code@mhssce.ac.in` | `password123` | EVENT ORGANIZER |
| **AI/ML Club** | `aiml@mhssce.ac.in` | `password123` | EVENT ORGANIZER |
| **EDC Club** | `edc@mhssce.ac.in` | `password123` | EVENT ORGANIZER |
| **KWS Club** | `kws@mhssce.ac.in` | `password123` | EVENT ORGANIZER |

### Student Accounts
| Student Name | Department / Year | Login Email | Password | Roll No |
| :--- | :--- | :--- | :--- | :--- |
| **Saif Ali** | Computer Engg (TE) | `saif@student.mhssce.ac.in` | `password123` | `21CO15` |
| **Fakhruddin Mansuri** | Information Tech (TE) | `fakhruddin@student.mhssce.ac.in` | `password123` | `21IT28` |
| **Hamza Sayed** | AI & DS (SE) | `hamza@student.mhssce.ac.in` | `password123` | `22AI09` |
| **Zoya Merchant** | Computer Engg (BE) | `zoya@student.mhssce.ac.in` | `password123` | `20CO44` |

*(New students can also sign up directly via the Student Registration page)*

---

## 9. End-to-End Demonstration Flow

To demonstrate the complete data flow during evaluation:

1. **Open Landing Page:** Visit `http://localhost:8080/`. Observe centered hero section, horizontal categories, featured events, and clubs.
2. **Organizer Login:** Click **Organizer Login** &rarr; enter `gfg@mhssce.ac.in` / `password123`.
3. **Organizer Dashboard:** Observe live counts for Total Events, Registrations, and Active Events.
4. **Create Event:** Click **+ Create New Event**. Enter event details and click **PUBLISH EVENT**.
5. **Logout:** Click **Logout**.
6. **Student Login:** Click **Student Login** &rarr; enter `saif@student.mhssce.ac.in` / `password123`.
7. **Find Event:** Go to **All Events** or **Student Dashboard** &rarr; select the newly published event.
8. **Register:** Click **Register Now**, review pre-filled student details, and click **Confirm Registration**.
9. **Official Pass:** An authentic Registration ID (e.g., `NX-2026-00005`) is created and an admission pass is rendered.
10. **Duplicate Prevention Check:** Return to the event and notice the register button is now locked with *"Already Registered"*.
11. **Organizer Verification:** Logout and log back in as `gfg@mhssce.ac.in`. Open your event's **Registrations** list &rarr; see the newly registered student, verify registration count increased, and click **Approve** to update status to `APPROVED`.

---

## 10. Database Verification Queries

You can verify that all actions persist directly in MySQL using standard queries:

```sql
USE nexora_db;

-- 1. View all users
SELECT id, full_name, email, role, department, year, roll_number FROM users;

-- 2. View all clubs and organizers
SELECT o.id, o.club_name, u.full_name AS lead_name, u.email 
FROM organizers o 
JOIN users u ON o.user_id = u.id;

-- 3. View all events with current registration counts
SELECT e.id, e.title, e.category, e.status, e.capacity, 
       (SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS registered_count
FROM events e;

-- 4. View all registrations
SELECT r.registration_id, r.full_name, r.roll_number, e.title AS event_title, r.status, r.registration_date 
FROM registrations r 
JOIN events e ON r.event_id = e.id 
ORDER BY r.registration_date DESC;
```

---

## 11. Troubleshooting

- **Access Denied to MySQL:** If your MySQL root password is forgotten, run `reset_mysql_to_root.bat` as Administrator to reset it to `root`.
- **Port 8080 in use:** Stop any conflicting application or change the port in `tools/apache-tomcat-10.1.34/conf/server.xml`.
- **Database Connection Error:** Verify MySQL service (`MySQL80`) is running in Windows Services and that credentials match `db.properties`.
