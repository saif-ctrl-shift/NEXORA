import os
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super(NumberedCanvas, self).showPage()
        super(NumberedCanvas, self).save()

    def draw_page_decorations(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 8.5)
        self.setFillColor(colors.HexColor("#64748B"))

        # Header (Top of every page)
        self.drawString(45, 805, "NEXORA – College Event Management System | M.H. Saboo Siddik College of Engineering")
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.6)
        self.line(45, 798, 550, 798)

        # Footer (Bottom of every page)
        self.line(45, 45, 550, 45)
        self.drawString(45, 32, "B.E. Computer Science & Engineering (AI & ML) | 4-Person Presentation Script")
        self.drawRightString(550, 32, f"Page {self._pageNumber} of {page_count}")
        self.restoreState()

def build_pdf():
    pdf_filename = "NEXORA_Presentation_Script_4_Members.pdf"
    output_path = os.path.join(r"c:\Users\fakhruddin\Downloads\NEXORA", pdf_filename)

    doc = SimpleDocTemplate(
        output_path,
        pagesize=A4,
        leftMargin=45,
        rightMargin=45,
        topMargin=54,
        bottomMargin=54
    )

    styles = getSampleStyleSheet()

    # Custom typography styles
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=20,
        leading=24,
        textColor=colors.HexColor("#0F172A"),
        alignment=1, # Center
        spaceAfter=4
    )

    subtitle_style = ParagraphStyle(
        'DocSubTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=11,
        leading=15,
        textColor=colors.HexColor("#D97706"), # Amber
        alignment=1,
        spaceAfter=12
    )

    act_header_style = ParagraphStyle(
        'ActHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=13,
        leading=16,
        textColor=colors.HexColor("#0F172A"),
        spaceBefore=14,
        spaceAfter=6,
        keepWithNext=True
    )

    speaker_saif = ParagraphStyle(
        'SpeakerSaif',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=13,
        textColor=colors.HexColor("#B45309"), # Warm Amber
        spaceBefore=9,
        spaceAfter=2,
        keepWithNext=True
    )

    speaker_asher = ParagraphStyle(
        'SpeakerAsher',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=13,
        textColor=colors.HexColor("#0284C7"), # Sky Blue
        spaceBefore=9,
        spaceAfter=2,
        keepWithNext=True
    )

    speaker_rehan = ParagraphStyle(
        'SpeakerRehan',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=13,
        textColor=colors.HexColor("#059669"), # Emerald Green
        spaceBefore=9,
        spaceAfter=2,
        keepWithNext=True
    )

    speaker_ayaan = ParagraphStyle(
        'SpeakerAyaan',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=13,
        textColor=colors.HexColor("#7C3AED"), # Purple/Violet
        spaceBefore=9,
        spaceAfter=2,
        keepWithNext=True
    )

    speaker_all = ParagraphStyle(
        'SpeakerAll',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=11,
        leading=14,
        textColor=colors.HexColor("#DC2626"), # Red/Crimson
        spaceBefore=12,
        spaceAfter=4,
        alignment=1,
        keepWithNext=True
    )

    direction_style = ParagraphStyle(
        'StageDirection',
        parent=styles['Normal'],
        fontName='Helvetica-Oblique',
        fontSize=9,
        leading=12,
        textColor=colors.HexColor("#64748B"), # Slate Gray
        spaceAfter=2
    )

    dialogue_style = ParagraphStyle(
        'Dialogue',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10,
        leading=14.5,
        textColor=colors.HexColor("#1E293B"),
        alignment=4, # Justify
        spaceAfter=6
    )

    callout_text = ParagraphStyle(
        'CalloutText',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.5,
        leading=12,
        textColor=colors.HexColor("#334155")
    )

    table_header = ParagraphStyle(
        'TableHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=9,
        leading=11,
        textColor=colors.HexColor("#FFFFFF"),
        alignment=1
    )

    table_body = ParagraphStyle(
        'TableBody',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.5,
        leading=11,
        textColor=colors.HexColor("#1E293B")
    )

    story = []

    # -------------------------------------------------------------------------
    # COVER / HEADER BANNER
    # -------------------------------------------------------------------------
    story.append(Paragraph("ANJUMAN-I-ISLAM'S M.H. SABOO SIDDIK COLLEGE OF ENGINEERING", ParagraphStyle('Sub', fontName='Helvetica-Bold', fontSize=8.5, leading=10, textColor=colors.HexColor("#64748B"), alignment=1)))
    story.append(Paragraph("DEPARTMENT OF COMPUTER SCIENCE AND ENGINEERING (AI & ML)", ParagraphStyle('Sub2', fontName='Helvetica-Bold', fontSize=8, leading=10, textColor=colors.HexColor("#94A3B8"), alignment=1, spaceAfter=8)))
    story.append(Paragraph("NEXORA – Project Presentation Script", title_style))
    story.append(Paragraph("4-MEMBER ENGAGING STAGE SCRIPT & VIVA DEFENSE GUIDE", subtitle_style))
    story.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor("#D97706"), spaceBefore=0, spaceAfter=10))

    # -------------------------------------------------------------------------
    # CAST & ROLES TABLE
    # -------------------------------------------------------------------------
    cast_data = [
        [
            Paragraph("Speaker", table_header),
            Paragraph("Student Name & PRN", table_header),
            Paragraph("Core Presentation Role", table_header),
            Paragraph("Key Segments Covered", table_header)
        ],
        [
            Paragraph("<b>Speaker 1</b>", table_body),
            Paragraph("<b>Saif Ali</b><br/>PRN: 251703", table_body),
            Paragraph("<b>The Hook & Vision</b><br/>Lead Presenter", table_body),
            Paragraph("Opening relatable question, campus problem definition, introduction to NEXORA vision, security rules.", table_body)
        ],
        [
            Paragraph("<b>Speaker 2</b>", table_body),
            Paragraph("<b>Asher Ansari</b><br/>PRN: 251711", table_body),
            Paragraph("<b>The Ground Reality & UI</b><br/>Student Flow Lead", table_body),
            Paragraph("WhatsApp/Forms friction, 5 event categories, student discovery walkthrough, campus impact.", table_body)
        ],
        [
            Paragraph("<b>Speaker 3</b>", table_body),
            Paragraph("<b>Rehan Ansari</b><br/>PRN: 251712", table_body),
            Paragraph("<b>Club Superpowers & Demo</b><br/>Organizer Lead", table_body),
            Paragraph("Capacity limits, duplicate rejection, organizer dashboard, live attendee status updating (Approve/Reject).", table_body)
        ],
        [
            Paragraph("<b>Speaker 4</b>", table_body),
            Paragraph("<b>Ayaan Sayed</b><br/>PRN: 251720", table_body),
            Paragraph("<b>Architecture & Grand Finale</b><br/>Tech Stack Anchor", table_body),
            Paragraph("Unique pass ID (NX-2026-XXXXX), MVC architecture, Servlets, JSP, JDBC, MySQL ACID persistence.", table_body)
        ]
    ]

    cast_table = Table(cast_data, colWidths=[65, 125, 140, 175])
    cast_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#0F172A")),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.HexColor("#F8FAFC"), colors.HexColor("#FFFFFF")]),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#E2E8F0")),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
    ]))

    story.append(cast_table)
    story.append(Spacer(1, 10))

    # Quick overview banner
    callout_data = [[
        Paragraph("<b>Presentation Blueprint:</b> Designed for a high-impact <b>4 to 5 minute</b> viva/presentation. Transition smoothly between speakers without pauses. Keep a laptop open at <code>http://localhost:8080/nexora/</code> to mirror the on-screen live demo cues.", callout_text)
    ]]
    callout_table = Table(callout_data, colWidths=[505])
    callout_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#FEF3C7")),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor("#F59E0B")),
        ('TOPPADDING', (0, 0), (-1, -1), 5),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 5),
        ('LEFTPADDING', (0, 0), (-1, -1), 8),
        ('RIGHTPADDING', (0, 0), (-1, -1), 8),
    ]))
    story.append(callout_table)
    story.append(Spacer(1, 8))

    # -------------------------------------------------------------------------
    # ACT 1: THE HOOK & THE CAMPUS CHAOS
    # -------------------------------------------------------------------------
    story.append(Paragraph("ACT 1: THE HOOK & THE RELATABLE CAMPUS CHAOS", act_header_style))
    story.append(HRFlowable(width="100%", thickness=0.8, color=colors.HexColor("#CBD5E1"), spaceBefore=0, spaceAfter=6))

    story.append(Paragraph("SPEAKER 1 (Saif Ali) – The Hook Question:", speaker_saif))
    story.append(Paragraph("<i>[Action: Steps forward, smiles, makes direct eye contact with the examiners and audience]</i>", direction_style))
    story.append(Paragraph('"Quick question for everyone in this room: How many times have you discovered an incredible college hackathon, coding contest, or workshop... <b>the exact day after registrations closed?</b> Or worse—scrolled through twenty different WhatsApp groups trying to find that one buried Google Form link?"', dialogue_style))

    story.append(Paragraph("SPEAKER 2 (Asher Ansari) – The Real Campus Friction:", speaker_asher))
    story.append(Paragraph("<i>[Action: Nods in agreement, steps forward smoothly to take the baton]</i>", direction_style))
    story.append(Paragraph('"Every single semester! In colleges like ours—M.H. Saboo Siddik College of Engineering—we have phenomenal active student chapters: GeeksforGeeks, IEEE, ACM, CSI, EDC, and AI/ML clubs. Every single week, someone is organizing an event. Yet, the way we manage them is stuck in the past: circulars on notice boards, scattered Instagram flyers, and informal WhatsApp forwards where vital details get lost in the noise."', dialogue_style))

    story.append(Paragraph("SPEAKER 3 (Rehan Ansari) – The Organizer's Nightmare:", speaker_rehan))
    story.append(Paragraph("<i>[Action: Energetic tone, highlighting administrative pain points]</i>", direction_style))
    story.append(Paragraph('"And think about what happens behind the scenes for club organizers! They create a Google Form. Within hours, students submit duplicates under multiple emails. There is <b>zero real-time capacity control</b>—a computer lab with only 60 workstations ends up receiving 120 registrations! On the event day, coordinators are left scrambling with paper printouts at the door, trying to guess who is genuinely registered."', dialogue_style))

    story.append(Paragraph("SPEAKER 4 (Ayaan Sayed) – The Technical Pivot:", speaker_ayaan))
    story.append(Paragraph("<i>[Action: Confident stance, introducing the solution]</i>", direction_style))
    story.append(Paragraph('"We realized this was not just a communication gap—it was a software engineering challenge waiting for a modern solution. That is why the four of us engineered <b>NEXORA</b>."', dialogue_style))

    # -------------------------------------------------------------------------
    # ACT 2: MEET NEXORA & THE STUDENT EXPERIENCE
    # -------------------------------------------------------------------------
    story.append(Paragraph("ACT 2: MEET NEXORA & THE STUDENT DISCOVERY EXPERIENCE", act_header_style))
    story.append(HRFlowable(width="100%", thickness=0.8, color=colors.HexColor("#CBD5E1"), spaceBefore=0, spaceAfter=6))

    story.append(Paragraph("SPEAKER 1 (Saif Ali) – The NEXORA Vision:", speaker_saif))
    story.append(Paragraph("<i>[Action: Points towards laptop display showing the NEXORA homepage with the golden logo]</i>", direction_style))
    story.append(Paragraph('"<b>NEXORA</b> is a centralized, production-grade College Event Management System engineered specifically for M.H. Saboo Siddik College of Engineering. The name represents a <i>nexus</i>—connecting students, college clubs, and faculty into one unified digital ecosystem."', dialogue_style))

    story.append(Paragraph("SPEAKER 2 (Asher Ansari) – Live Student Flow & Discovery:", speaker_asher))
    story.append(Paragraph("<i>[Action: Demonstrates live browsing at http://localhost:8080/nexora/]</i>", direction_style))
    story.append(Paragraph('"When a student visits NEXORA, there are no chaotic walls of text. Everything is organized into five distinct categories: <b>Hackathons, Workshops, Competitions, Seminars, and College Events</b>. A student can filter events by their favorite club, search by title, and immediately review the venue, faculty coordinator, and a <b>live real-time capacity progress bar</b>."', dialogue_style))

    story.append(Paragraph("SPEAKER 3 (Rehan Ansari) – Real-Time Capacity & Duplicate Locking:", speaker_rehan))
    story.append(Paragraph("<i>[Action: Clicks 'Register' on an active hackathon event]</i>", direction_style))
    story.append(Paragraph('"And here is where real software engineering comes in. The moment a student clicks <b>Register</b>, NEXORA runs strict server-side validations: Is the event still active? Has the deadline passed? Are seats still available? Has this student already registered? If the venue limit is reached, the registration engine dynamically locks out further submissions. And duplicate attempts are blocked instantly at both the Java Servlet level and MySQL database constraint level."', dialogue_style))

    story.append(Paragraph("SPEAKER 4 (Ayaan Sayed) – The Official Digital Registration Pass:", speaker_ayaan))
    story.append(Paragraph("<i>[Action: Displays the confirmation pass screen showing ID NX-2026-00006]</i>", direction_style))
    story.append(Paragraph('"The moment registration is successful, students do not get a simple generic message. NEXORA instantly issues an official <b>Registration Pass</b> featuring a unique serialized tracking ID—such as <b>NX-2026-00006</b>. This pass contains student credentials, verified team members, and date stamp, permanently saved under the student dashboard for seamless physical entry on event day."', dialogue_style))

    story.append(PageBreak()) # Clean page break for Act 3 & 4

    # -------------------------------------------------------------------------
    # ACT 3: THE POWERHOUSE ORGANIZER PORTAL
    # -------------------------------------------------------------------------
    story.append(Paragraph("ACT 3: THE POWERHOUSE CLUB ORGANIZER PORTAL", act_header_style))
    story.append(HRFlowable(width="100%", thickness=0.8, color=colors.HexColor("#CBD5E1"), spaceBefore=0, spaceAfter=6))

    story.append(Paragraph("SPEAKER 1 (Saif Ali) – Club Lead Empowerment:", speaker_saif))
    story.append(Paragraph("<i>[Action: Logs into Organizer Portal using gfg@mhssce.ac.in]</i>", direction_style))
    story.append(Paragraph('"Now let us look at the other side of the platform—the <b>Event Organizers</b> representing college clubs like GeeksforGeeks, IEEE, and EDC. Every organizer logs in through a dedicated Organizer Portal with strict Role-Based Access Control."', dialogue_style))

    story.append(Paragraph("SPEAKER 3 (Rehan Ansari) – Live Dashboard Metrics & Event Authoring:", speaker_rehan))
    story.append(Paragraph("<i>[Action: Highlights the four KPI cards on the Organizer Dashboard]</i>", direction_style))
    story.append(Paragraph('"Inside the dashboard, organizers see real-time institutional KPIs: Total Events, Total Student Registrations, Active Published Events, and Upcoming Schedules. Organizers can author rich event briefs, set exact capacity caps, specify eligibility rules, and choose whether to save as a private <b>DRAFT</b> or instantly <b>PUBLISH</b> to the student catalog."', dialogue_style))

    story.append(Paragraph("SPEAKER 2 (Asher Ansari) – Live Participant Management & Status Controls:", speaker_asher))
    story.append(Paragraph("<i>[Action: Clicks 'Registrations' to show the participant table with live search and status dropdown]</i>", direction_style))
    story.append(Paragraph('"Best of all, organizers can open any event\'s live participant roster. They can search students by roll number or department, view registered team members, and update their registration status—from <b>REGISTERED</b> to <b>APPROVED</b> or <b>REJECTED</b>—with immediate database synchronization!"', dialogue_style))

    story.append(Paragraph("SPEAKER 1 (Saif Ali) – Strict Privacy & Security Isolation:", speaker_saif))
    story.append(Paragraph("<i>[Action: Firm, authoritative voice on system security]</i>", direction_style))
    story.append(Paragraph('"And privacy is absolute: our session guard enforces that students cannot access organizer URLs, and organizers can only view and manage events belonging strictly to their own college club."', dialogue_style))

    # -------------------------------------------------------------------------
    # ACT 4: THE ENGINE UNDER THE HOOD (ARCHITECTURE)
    # -------------------------------------------------------------------------
    story.append(Paragraph("ACT 4: THE ENGINE UNDER THE HOOD – TECHNICAL ARCHITECTURE", act_header_style))
    story.append(HRFlowable(width="100%", thickness=0.8, color=colors.HexColor("#CBD5E1"), spaceBefore=0, spaceAfter=6))

    story.append(Paragraph("SPEAKER 4 (Ayaan Sayed) – Enterprise MVC & Java Full-Stack:", speaker_ayaan))
    story.append(Paragraph("<i>[Action: Delivers technical architecture with pride and precision]</i>", direction_style))
    story.append(Paragraph('"What makes NEXORA truly stand apart is that this is <b>NOT</b> a fake prototype with hardcoded arrays or browser localStorage. NEXORA is an authentic enterprise Full-Stack Java application architected on the classic <b>Model-View-Controller (MVC)</b> pattern:<br/>'
                           '• <b>Controller:</b> 14 Jakarta EE Java Servlets managing request routing, session lifecycle, and input sanitization.<br/>'
                           '• <b>View:</b> Server-rendered JavaServer Pages (JSP) using JSTL and Expression Language, styled with modern responsive CSS—zero heavy client frameworks required.<br/>'
                           '• <b>Model:</b> Pure POJOs coupled with the <b>Data Access Object (DAO)</b> pattern executing parameterized JDBC PreparedStatements to guarantee complete protection against SQL injection.<br/>'
                           '• <b>Database:</b> A persistent <b>MySQL 8.0</b> relational engine deployed on <b>Apache Tomcat 10</b>."', dialogue_style))

    story.append(Paragraph("SPEAKER 3 (Rehan Ansari) – ACID Reliability & Data Integrity:", speaker_rehan))
    story.append(Paragraph("<i>[Action: Emphasizing database reliability]</i>", direction_style))
    story.append(Paragraph('"Every single registration, event status, and capacity count is committed permanently to MySQL. You can restart the server, reboot the machine, and all transactional records remain 100% intact with complete ACID relational integrity."', dialogue_style))

    # -------------------------------------------------------------------------
    # ACT 5: IMPACT & GRAND FINALE
    # -------------------------------------------------------------------------
    story.append(Paragraph("ACT 5: IMPACT, FUTURE SCOPE & GRAND FINALE", act_header_style))
    story.append(HRFlowable(width="100%", thickness=0.8, color=colors.HexColor("#CBD5E1"), spaceBefore=0, spaceAfter=6))

    story.append(Paragraph("SPEAKER 2 (Asher Ansari) – Quantifiable Impact:", speaker_asher))
    story.append(Paragraph('"In summary, NEXORA replaces hundreds of scattered paper sheets and lost messages with a fast, reliable, five-second digital registration process."', dialogue_style))

    story.append(Paragraph("SPEAKER 1 (Saif Ali) – Empowering Student Clubs:", speaker_saif))
    story.append(Paragraph('"It frees our technical clubs to focus on delivering high-impact workshops and hackathons rather than fighting spreadsheet errors..."', dialogue_style))

    story.append(Paragraph("SPEAKER 4 (Ayaan Sayed) – Empowering Engineers:", speaker_ayaan))
    story.append(Paragraph('"And it ensures every engineering student at M.H. Saboo Siddik College of Engineering never misses an opportunity to learn, compete, and lead."', dialogue_style))

    story.append(Spacer(1, 4))
    story.append(Paragraph("ALL 4 SPEAKERS (Saif, Asher, Rehan, Ayaan) – Grand Closing in Unison:", speaker_all))
    story.append(Paragraph("<i>[Action: All four members stand straight, face the judges with confidence, and speak together in harmony]</i>", direction_style))
    story.append(Paragraph('<b>"This is NEXORA – Managing Events, Building Opportunities for M.H. Saboo Siddik College of Engineering!<br/>Thank you, and we are now delighted to demonstrate the live system and answer your questions!"</b>', ParagraphStyle('FinalQuote', fontName='Helvetica-Bold', fontSize=10.5, leading=15, textColor=colors.HexColor("#0F172A"), alignment=1)))

    # -------------------------------------------------------------------------
    # APPENDIX: ON-SCREEN DEMO CUES & VIVA CHEAT SHEET
    # -------------------------------------------------------------------------
    story.append(Spacer(1, 10))
    story.append(Paragraph("QUICK-REFERENCE ON-SCREEN DEMO CUES", ParagraphStyle('H2', fontName='Helvetica-Bold', fontSize=10.5, leading=13, textColor=colors.HexColor("#0F172A"), spaceBefore=8, spaceAfter=4)))

    cues_data = [
        [
            Paragraph("Act & Speaker", table_header),
            Paragraph("What to Click / Show on Screen", table_header),
            Paragraph("Target Local URL", table_header)
        ],
        [
            Paragraph("<b>Act 2</b> (Asher)", table_body),
            Paragraph("Show Homepage, scroll to 5 category pills, click 'Hackathons'", table_body),
            Paragraph("<code>http://localhost:8080/nexora/</code>", table_body)
        ],
        [
            Paragraph("<b>Act 2</b> (Ayaan)", table_body),
            Paragraph("Show confirmed registration pass card with unique ID <code>NX-2026-00006</code>", table_body),
            Paragraph("<code>.../nexora/registration-success</code>", table_body)
        ],
        [
            Paragraph("<b>Act 3</b> (Rehan)", table_body),
            Paragraph("Log in as Organizer (<code>gfg@mhssce.ac.in</code>), show 4 stat cards & event list", table_body),
            Paragraph("<code>.../nexora/organizer/dashboard</code>", table_body)
        ],
        [
            Paragraph("<b>Act 3</b> (Asher)", table_body),
            Paragraph("Click 'Registrations' for Event 11, demonstrate status change to 'APPROVED'", table_body),
            Paragraph("<code>.../event-registrations?eventId=11</code>", table_body)
        ]
    ]

    cues_table = Table(cues_data, colWidths=[95, 240, 170])
    cues_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#1E293B")),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.HexColor("#F8FAFC"), colors.HexColor("#FFFFFF")]),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#E2E8F0")),
        ('TOPPADDING', (0, 0), (-1, -1), 3),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 3),
    ]))
    story.append(cues_table)

    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF successfully generated at: {output_path}")

build_pdf()
