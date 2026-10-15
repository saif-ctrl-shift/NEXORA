-- =======================================================
-- NEXORA - College Event Management System
-- Database Schema & Realistic Seed Data
-- College: M.H. Saboo Siddik College of Engineering, Mumbai
-- =======================================================

DROP DATABASE IF EXISTS nexora_db;
CREATE DATABASE nexora_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nexora_db;

-- -------------------------------------------------------
-- Table 1: users
-- Roles: STUDENT, ORGANIZER
-- -------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'ORGANIZER') NOT NULL DEFAULT 'STUDENT',
    department VARCHAR(100),
    year VARCHAR(20),
    roll_number VARCHAR(50),
    mobile VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- Table 2: organizers
-- Associated with college clubs / committees
-- -------------------------------------------------------
CREATE TABLE organizers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    club_name VARCHAR(150) NOT NULL,
    club_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_organizer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- Table 3: events
-- Status: DRAFT, PUBLISHED, CLOSED, COMPLETED
-- -------------------------------------------------------
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    organizer_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    event_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    venue VARCHAR(150) NOT NULL,
    eligibility VARCHAR(255) DEFAULT 'All Engineering Students',
    rules TEXT,
    registration_deadline DATETIME NOT NULL,
    capacity INT NOT NULL DEFAULT 100,
    status ENUM('DRAFT', 'PUBLISHED', 'CLOSED', 'COMPLETED') NOT NULL DEFAULT 'DRAFT',
    banner VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_event_organizer FOREIGN KEY (organizer_id) REFERENCES organizers(id) ON DELETE CASCADE,
    INDEX idx_event_status (status),
    INDEX idx_event_category (category),
    INDEX idx_event_date (event_date)
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- Table 4: registrations
-- Unique registration ID format: NX-2026-XXXXX
-- Status: REGISTERED, APPROVED, REJECTED, CANCELLED
-- Unique constraint prevents duplicate student registration
-- -------------------------------------------------------
CREATE TABLE registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    registration_id VARCHAR(50) NOT NULL UNIQUE,
    event_id INT NOT NULL,
    student_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    college VARCHAR(150) NOT NULL,
    department VARCHAR(100) NOT NULL,
    year VARCHAR(20) NOT NULL,
    roll_number VARCHAR(50) NOT NULL,
    team_name VARCHAR(100),
    team_members TEXT,
    additional_information TEXT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('REGISTERED', 'APPROVED', 'REJECTED', 'CANCELLED') NOT NULL DEFAULT 'REGISTERED',
    CONSTRAINT fk_reg_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    CONSTRAINT fk_reg_student FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uq_student_event UNIQUE (student_id, event_id),
    INDEX idx_reg_code (registration_id),
    INDEX idx_reg_status (status)
) ENGINE=InnoDB;

-- =======================================================
-- SEED DATA
-- =======================================================

-- 1. Insert Organizers (Users with ORGANIZER role)
-- Passwords stored for demonstration: 'password123'
INSERT INTO users (id, full_name, email, password, role, department, year, roll_number, mobile) VALUES
(1, 'GfK Lead - Zaid Khan', 'gfg@mhssce.ac.in', 'password123', 'ORGANIZER', 'Computer Engineering', 'TE', 'CE-2023-01', '9820011223'),
(2, 'IEEE Head - Aamir Shaikh', 'ieee@mhssce.ac.in', 'password123', 'ORGANIZER', 'Information Technology', 'BE', 'IT-2022-14', '9820022334'),
(3, 'EDC Convener - Farhan Qureshi', 'edc@mhssce.ac.in', 'password123', 'ORGANIZER', 'Mechanical Engineering', 'BE', 'ME-2022-05', '9820033445'),
(4, 'Programmers Club - Rehan Ansari', 'code@mhssce.ac.in', 'password123', 'ORGANIZER', 'Computer Engineering', 'TE', 'CE-2023-42', '9820044556'),
(5, 'AI/ML Club - Sarah Patel', 'aiml@mhssce.ac.in', 'password123', 'ORGANIZER', 'Artificial Intelligence & Data Science', 'TE', 'AI-2023-19', '9820055667'),
(6, 'KWS Secretary - Bilal Siddiqui', 'kws@mhssce.ac.in', 'password123', 'ORGANIZER', 'Civil Engineering', 'BE', 'CV-2022-09', '9820066778');

-- 2. Insert Organizer Profile Details
INSERT INTO organizers (id, user_id, club_name, club_description) VALUES
(1, 1, 'GeeksforGeeks Club', 'Official GfG Student Chapter fostering algorithmic problem solving, web development, and competitive programming at MHSSCE.'),
(2, 2, 'IEEE Student Branch', 'IEEE Student Branch MHSSCE promoting technological innovation, electronics, networking, and robotics among engineers.'),
(3, 3, 'EDC Club', 'Entrepreneurship Development Cell nurturing startup culture, product incubation, and visionary leadership.'),
(4, 4, 'Programmers Club', 'Vibrant community of hackathon champions, open-source contributors, and software builders.'),
(5, 5, 'AI/ML Club', 'Premier artificial intelligence society exploring deep learning, LLMs, computer vision, and autonomous agents.'),
(6, 6, 'KWS Club', 'Kalsekar Welfare Society student committee organizing inter-college socio-technical festivals and sports.');

-- 3. Insert Students (Users with STUDENT role)
INSERT INTO users (id, full_name, email, password, role, department, year, roll_number, mobile) VALUES
(10, 'Saif Ali', 'saif@student.mhssce.ac.in', 'password123', 'STUDENT', 'Computer Engineering', 'Third Year (TE)', '21CO15', '9876543210'),
(11, 'Fakhruddin Mansuri', 'fakhruddin@student.mhssce.ac.in', 'password123', 'STUDENT', 'Information Technology', 'Third Year (TE)', '21IT28', '9876543211'),
(12, 'Hamza Sayed', 'hamza@student.mhssce.ac.in', 'password123', 'STUDENT', 'Artificial Intelligence & Data Science', 'Second Year (SE)', '22AI09', '9876543212'),
(13, 'Zoya Merchant', 'zoya@student.mhssce.ac.in', 'password123', 'STUDENT', 'Computer Engineering', 'Fourth Year (BE)', '20CO44', '9876543213');

-- 4. Insert Events
INSERT INTO events (id, organizer_id, title, category, description, event_date, start_time, end_time, venue, eligibility, rules, registration_deadline, capacity, status, banner) VALUES
(1, 1, 'Java & Spring Boot Workshop', 'Workshops', 
'Comprehensive hands-on workshop covering modern Java 21, Spring Boot REST APIs, JPA/Hibernate, and microservices architecture. Build an enterprise-grade backend from scratch with live mentorship.',
'2026-10-25', '10:00:00', '16:00:00', 'Seminar Hall 1, 4th Floor', 'SE, TE, and BE Engineering Students', 
'1. Bring your personal laptop with JDK 17+ installed.\n2. Prior basics of Java and OOP recommended.\n3. Certificates will be awarded only upon 100% attendance.',
'2026-10-24 18:00:00', 80, 'PUBLISHED', 'event_java.jpg'),

(2, 4, 'Code Clash 2026: 24-Hour Hackathon', 'Hackathons', 
'The flagship 24-hour inter-collegiate coding hackathon of MHSSCE. Tackle real-world problem statements across Web3, AI, Smart Campus, and HealthTech with industry judges and cash prizes worth ₹50,000.',
'2026-11-05', '09:00:00', '09:00:00', 'Central Computing Center, Lab 3 & 4', 'Open to all college students (Teams of 2 to 4)', 
'1. Teams must comprise 2-4 members.\n2. Projects must be coded during the hackathon hours only.\n3. GitHub commits will be monitored for originality.',
'2026-11-03 23:59:00', 120, 'PUBLISHED', 'event_hackathon.jpg'),

(3, 5, 'Agentic AI & LLMs Hands-on Workshop', 'Workshops', 
'Dive into autonomous AI workflows, multi-agent orchestration, tool-calling APIs, and production deployment using modern Python frameworks. Includes interactive demonstrations and cloud GPU credits.',
'2026-10-28', '11:00:00', '15:30:00', 'AI Research Lab, 5th Floor', 'All Engineering branches with Python fundamentals', 
'1. Participants must bring their own laptops.\n2. Basic knowledge of Python is mandatory.\n3. Discord channel access will be provided after registration.',
'2026-10-27 20:00:00', 60, 'PUBLISHED', 'event_ai.jpg'),

(4, 3, 'Startup & Entrepreneurship Bootcamp', 'Seminars', 
'Learn how to take your engineering ideas from prototype to funded venture. Featuring keynote speeches from successful MHSSCE alumni founders, venture capitalists, and pitch deck workshops.',
'2026-10-30', '14:00:00', '17:30:00', 'Main Auditorium, Ground Floor', 'Open to all students and budding entrepreneurs', 
'1. Formal or smart casual attire required.\n2. Optional pitch submission for selected seed funding.',
'2026-10-29 18:00:00', 150, 'PUBLISHED', 'event_startup.jpg'),

(5, 2, 'College Innovation Competition (InnoTech)', 'Competitions', 
'Inter-departmental hardware and software project exhibition showcasing cutting-edge engineering capstones, IoT devices, robotics, and patentable innovations.',
'2026-11-12', '09:30:00', '16:30:00', 'Engineering Quadrangle & Mechanical Labs', 'Diploma and Degree Engineering Students', 
'1. Working hardware prototype or software demo required.\n2. Display poster of A1 size must be brought by the team.',
'2026-11-10 17:00:00', 50, 'PUBLISHED', 'event_innotech.jpg'),

(6, 6, 'Annual College Cultural & Tech Euphoria', 'College Events', 
'The grand annual college socio-technical gathering featuring cultural showcases, gaming tournaments, project arenas, and musical celebrations.',
'2026-11-20', '09:00:00', '20:00:00', 'MHSSCE Campus Ground & Auditorium', 'All MHSSCE Students and Faculty', 
'1. Valid College ID card is mandatory for entry.\n2. Discipline must be maintained at all times.',
'2026-11-18 22:00:00', 300, 'PUBLISHED', 'event_college.jpg'),

(7, 4, 'Web Development Masterclass: Next.js & Cloud', 'Workshops', 
'Master modern frontend architectures, server components, TypeScript, and edge deployments with senior developers.',
'2026-10-18', '10:00:00', '14:00:00', 'Web Tech Lab, 3rd Floor', 'FE to BE Students', 
'Prerequisites: HTML, CSS, JavaScript fundamentals.',
'2026-10-17 18:00:00', 75, 'PUBLISHED', 'event_web.jpg'),

(8, 5, 'Technical Seminar on Emerging Technologies', 'Seminars', 
'Expert talks by industry leaders on Quantum Computing, Cyber Defense in 2026, and Autonomous Robotics.',
'2026-11-02', '11:00:00', '13:30:00', 'Audio-Visual Room, 2nd Floor', 'All Engineering Departments', 
'Active participation encouraged during Q&A session.',
'2026-11-01 12:00:00', 100, 'PUBLISHED', 'event_seminar.jpg'),

(9, 1, 'Algorithmic Problem Solving Draft Session', 'Workshops', 
'Draft syllabus for upcoming winter competitive programming series.',
'2026-12-01', '10:00:00', '12:00:00', 'Room 302', 'GfG Club Members', 
'Internal club review.',
'2026-11-30 18:00:00', 30, 'DRAFT', 'event_algo.jpg');

-- 5. Insert Sample Registrations
INSERT INTO registrations (registration_id, event_id, student_id, full_name, email, mobile, college, department, year, roll_number, team_name, team_members, additional_information, registration_date, status) VALUES
('NX-2026-00001', 1, 10, 'Saif Ali', 'saif@student.mhssce.ac.in', '9876543210', 'M.H. Saboo Siddik College of Engineering', 'Computer Engineering', 'Third Year (TE)', '21CO15', 'Solo', '', 'Interested in Spring Cloud microservices.', '2026-10-06 10:15:00', 'APPROVED'),
('NX-2026-00002', 2, 10, 'Saif Ali', 'saif@student.mhssce.ac.in', '9876543210', 'M.H. Saboo Siddik College of Engineering', 'Computer Engineering', 'Third Year (TE)', '21CO15', 'CodeWarriors', 'Saif Ali, Fakhruddin Mansuri, Hamza Sayed', 'We will build an AI-driven campus accessibility tool.', '2026-10-06 11:20:00', 'REGISTERED'),
('NX-2026-00003', 1, 11, 'Fakhruddin Mansuri', 'fakhruddin@student.mhssce.ac.in', '9876543211', 'M.H. Saboo Siddik College of Engineering', 'Information Technology', 'Third Year (TE)', '21IT28', 'Solo', '', 'Excited for backend development.', '2026-10-06 12:45:00', 'REGISTERED'),
('NX-2026-00004', 3, 12, 'Hamza Sayed', 'hamza@student.mhssce.ac.in', '9876543212', 'M.H. Saboo Siddik College of Engineering', 'Artificial Intelligence & Data Science', 'Second Year (SE)', '22AI09', 'Solo', '', 'Working on LLM agent benchmarks.', '2026-10-06 14:00:00', 'REGISTERED');

-- Verify summary counts
SELECT 'Database nexora_db successfully created with seed data!' AS message;
