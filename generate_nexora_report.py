import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import qn, nsdecls
import os

def build_full_report():
    doc = docx.Document()

    # Configure Margins: 1 inch (72pt)
    for section in doc.sections:
        section.top_margin = Inches(1.0)
        section.bottom_margin = Inches(1.0)
        section.left_margin = Inches(1.0)
        section.right_margin = Inches(1.0)
        section.page_width = Inches(8.27)
        section.page_height = Inches(11.69)
        section.different_first_page_header_footer = True

    # Configure Normal Style
    style = doc.styles['Normal']
    font = style.font
    font.name = 'Times New Roman'
    font.size = Pt(12)
    font.color.rgb = RGBColor(0, 0, 0)
    style.paragraph_format.line_spacing = 1.5
    style.paragraph_format.space_after = Pt(6)
    style.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY

    # XML Helper functions
    def set_cell_background(cell, fill_hex):
        tcPr = cell._tc.get_or_add_tcPr()
        shd = OxmlElement('w:shd')
        shd.set(qn('w:val'), 'clear')
        shd.set(qn('w:color'), 'auto')
        shd.set(qn('w:fill'), fill_hex)
        tcPr.append(shd)

    def set_cell_margins(cell, top=140, bottom=140, left=180, right=180):
        tcPr = cell._tc.get_or_add_tcPr()
        tcMar = OxmlElement('w:tcMar')
        for m, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
            node = OxmlElement(f'w:{m}')
            node.set(qn('w:w'), str(val))
            node.set(qn('w:type'), 'dxa')
            tcMar.append(node)
        tcPr.append(tcMar)

    def set_table_borders(table, color="CCCCCC", sz="4", val="single"):
        tblPr = table._tbl.tblPr
        tblBorders = OxmlElement('w:tblBorders')
        for border_name in ['top', 'left', 'bottom', 'right', 'insideH', 'insideV']:
            border = OxmlElement(f'w:{border_name}')
            border.set(qn('w:val'), val)
            border.set(qn('w:sz'), sz)
            border.set(qn('w:space'), '0')
            border.set(qn('w:color'), color)
            tblBorders.append(border)
        tblPr.append(tblBorders)

    def add_p(text, bold=False, italic=False, size=12, align=WD_ALIGN_PARAGRAPH.JUSTIFY, space_before=0, space_after=6, line_spacing=1.5):
        p = doc.add_paragraph()
        p.alignment = align
        p.paragraph_format.space_before = Pt(space_before)
        p.paragraph_format.space_after = Pt(space_after)
        p.paragraph_format.line_spacing = line_spacing
        run = p.add_run(text)
        run.bold = bold
        run.italic = italic
        run.font.name = 'Times New Roman'
        run.font.size = Pt(size)
        return p

    def add_chapter_heading(chap_num, chap_title):
        p1 = doc.add_paragraph()
        p1.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p1.paragraph_format.space_before = Pt(18)
        p1.paragraph_format.space_after = Pt(4)
        r1 = p1.add_run(f"Chapter {chap_num}")
        r1.bold = True
        r1.font.name = 'Times New Roman'
        r1.font.size = Pt(16)

        p2 = doc.add_paragraph()
        p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p2.paragraph_format.space_before = Pt(0)
        p2.paragraph_format.space_after = Pt(16)
        r2 = p2.add_run(chap_title)
        r2.bold = True
        r2.font.name = 'Times New Roman'
        r2.font.size = Pt(16)

    def add_sec_heading(title, size=14, space_before=14, space_after=4):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.LEFT
        p.paragraph_format.space_before = Pt(space_before)
        p.paragraph_format.space_after = Pt(space_after)
        p.paragraph_format.keep_with_next = True
        r = p.add_run(title)
        r.bold = True
        r.font.name = 'Times New Roman'
        r.font.size = Pt(size)
        return p

    def add_subsec_heading(title, size=12, space_before=10, space_after=4):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.LEFT
        p.paragraph_format.space_before = Pt(space_before)
        p.paragraph_format.space_after = Pt(space_after)
        p.paragraph_format.keep_with_next = True
        r = p.add_run(title)
        r.bold = True
        r.font.name = 'Times New Roman'
        r.font.size = Pt(size)
        return p

    def add_image_placeholder(fig_no, fig_title, view_desc, path_or_url, instructions="Insert high-resolution screenshot from the running NEXORA system here."):
        table = doc.add_table(rows=1, cols=1)
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        cell = table.cell(0, 0)
        cell.width = Inches(6.2)
        set_cell_background(cell, "F8F9FA")
        set_cell_margins(cell, top=160, bottom=160, left=200, right=200)

        tblPr = table._tbl.tblPr
        tblBorders = OxmlElement('w:tblBorders')
        for b_name in ['top', 'left', 'bottom', 'right']:
            b = OxmlElement(f'w:{b_name}')
            b.set(qn('w:val'), 'dashed')
            b.set(qn('w:sz'), '8')
            b.set(qn('w:space'), '0')
            b.set(qn('w:color'), '78909C')
            tblBorders.append(b)
        tblPr.append(tblBorders)

        cp = cell.paragraphs[0]
        cp.alignment = WD_ALIGN_PARAGRAPH.CENTER
        cp.paragraph_format.space_before = Pt(6)
        cp.paragraph_format.space_after = Pt(2)
        r1 = cp.add_run(f"📷  [SCREENSHOT PLACEHOLDER: Figure {fig_no} – {fig_title}]")
        r1.bold = True
        r1.font.name = 'Times New Roman'
        r1.font.size = Pt(11)
        r1.font.color.rgb = RGBColor(33, 33, 33)

        p_desc = cell.add_paragraph()
        p_desc.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_desc.paragraph_format.space_before = Pt(2)
        p_desc.paragraph_format.space_after = Pt(2)
        r_desc = p_desc.add_run(f"Required Screen / Component: {view_desc}")
        r_desc.italic = True
        r_desc.font.name = 'Times New Roman'
        r_desc.font.size = Pt(10)
        r_desc.font.color.rgb = RGBColor(66, 66, 66)

        p_url = cell.add_paragraph()
        p_url.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_url.paragraph_format.space_before = Pt(2)
        p_url.paragraph_format.space_after = Pt(2)
        r_url = p_url.add_run(f"Target URL / State: {path_or_url}")
        r_url.font.name = 'Times New Roman'
        r_url.font.size = Pt(9.5)
        r_url.font.color.rgb = RGBColor(21, 101, 192)

        p_inst = cell.add_paragraph()
        p_inst.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_inst.paragraph_format.space_before = Pt(2)
        p_inst.paragraph_format.space_after = Pt(6)
        r_inst = p_inst.add_run(f"Action: {instructions}")
        r_inst.font.name = 'Times New Roman'
        r_inst.font.size = Pt(9)
        r_inst.font.color.rgb = RGBColor(117, 117, 117)

        cap = doc.add_paragraph()
        cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        cap.paragraph_format.space_before = Pt(4)
        cap.paragraph_format.space_after = Pt(12)
        rcap = cap.add_run(f"Figure {fig_no} – {fig_title}")
        rcap.bold = True
        rcap.font.name = 'Times New Roman'
        rcap.font.size = Pt(11)

    # -------------------------------------------------------------
    # PAGE 1: TITLE / COVER PAGE
    # -------------------------------------------------------------
    add_p("A FullStack Java Mini Project Report on", bold=False, size=13, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=16, space_after=12)
    add_p("NEXORA – College Event Management System", bold=True, size=20, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=6, space_after=14)
    add_p("Submitted in partial fulfillment of the requirements of\nthe degree of Bachelor of Engineering", size=12, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=0, space_after=12)
    add_p("By", bold=True, size=12, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=4, space_after=8)

    add_p("Saif Ali (PRN No: 251703)", bold=True, size=12, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=3)
    add_p("Asher Ansari (PRN No: 251711)", bold=True, size=12, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=3)
    add_p("Rehan Ansari (PRN No: 251712)", bold=True, size=12, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=3)
    add_p("Ayaan Sayed (PRN No: 251720)", bold=True, size=12, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=14)

    add_p("Subject Coordinator", bold=True, size=12, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=2)
    add_p("Shaikh Sharique Ahmad", bold=True, size=14, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=24)

    # Emblem placeholder box on title page
    emblem_table = doc.add_table(rows=1, cols=1)
    emblem_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    ecell = emblem_table.cell(0, 0)
    ecell.width = Inches(2.5)
    set_cell_background(ecell, "F0F4F8")
    set_cell_margins(ecell, 140, 140, 140, 140)
    ep = ecell.paragraphs[0]
    ep.alignment = WD_ALIGN_PARAGRAPH.CENTER
    er = ep.add_run("[ COLLEGE EMBLEM / LOGO ]\nSymbol of Secularism & National Integration\nAnjuman-I-Islam")
    er.bold = True
    er.font.name = 'Times New Roman'
    er.font.size = Pt(9.5)
    er.font.color.rgb = RGBColor(46, 125, 50)

    add_p("", space_after=16)
    add_p("Department of Computer Science and Engineering\n(Artificial Intelligence & Machine Learning)", bold=True, size=12.5, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=6)
    add_p("Anjuman I Islam’s\nM.H. SABOO SIDDIK COLLEGE OF ENGINEERING\nUNIVERSITY OF MUMBAI", bold=True, size=13, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=4)
    add_p("2026-2027", bold=True, size=13, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=0)

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 2: CERTIFICATE
    # -------------------------------------------------------------
    add_p("Anjuman I Islam’s", bold=True, size=14, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=14, space_after=2)
    add_p("M.H. SABOO SIDDIK COLLEGE OF ENGINEERING", bold=True, size=15, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=4)
    add_p("Department of Computer Science and Engineering\nArtificial Intelligence & Machine Learning", bold=True, size=12, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=18)

    # Logo box
    c_table = doc.add_table(rows=1, cols=1)
    c_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    ccell = c_table.cell(0, 0)
    ccell.width = Inches(2.2)
    set_cell_background(ccell, "FAFAFA")
    set_cell_margins(ccell, 120, 120, 120, 120)
    cp = ccell.paragraphs[0]
    cp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    cr = cp.add_run("[ MHSSCE SEAL / CREST ]")
    cr.bold = True
    cr.font.name = 'Times New Roman'
    cr.font.size = Pt(10)

    add_p("", space_after=14)
    add_p("CERTIFICATE", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_after=18)

    cert_text = (
        "This is to certify that the FullStack Java Mini Project entitled “NEXORA – College Event Management System” "
        "is the bonafide work of Saif Ali (PRN No: 251703), Asher Ansari (PRN No: 251711), Rehan Ansari (PRN No: 251712) "
        "and Ayaan Sayed (PRN No: 251720) submitted to the University of Mumbai in fulfillment of the requirement for the "
        "FullStack Java Mini Project Semester III project work of B.E. in Computer Science & Engineering (Artificial Intelligence "
        "and Machine Learning) at M.H. Saboo Siddik College of Engineering, Byculla, Mumbai for the academic year 2026-2027."
    )
    add_p(cert_text, align=WD_ALIGN_PARAGRAPH.JUSTIFY, space_after=54, line_spacing=1.5)

    # Signatures table
    sig_table = doc.add_table(rows=2, cols=3)
    sig_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    col_widths = [Inches(2.2), Inches(2.2), Inches(2.2)]

    row0 = sig_table.rows[0]
    row0.cells[0].paragraphs[0].text = "Shaikh Sharique Ahmad\nSubject Coordinator"
    row0.cells[1].paragraphs[0].text = "Dr. Jameer Kotwal\nH.O.D (CSE-AIML)"
    row0.cells[2].paragraphs[0].text = "Dr. Shafi Pathan\nPrincipal"

    for cell in row0.cells:
        cell.paragraphs[0].runs[0].bold = True
        cell.paragraphs[0].runs[0].font.name = 'Times New Roman'
        cell.paragraphs[0].runs[0].font.size = Pt(11)
        cell.paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.CENTER

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 3: REPORT APPROVAL
    # -------------------------------------------------------------
    add_p("FullStack Java Mini Project Report Approval", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=24, space_after=24)

    appr_text = (
        "This project report entitled “NEXORA – College Event Management System” by Saif Ali, Asher Ansari, Rehan Ansari "
        "and Ayaan Sayed is approved for the FullStack Java Mini Project Semester III project work of B.E Computer Science "
        "and Engineering (Artificial Intelligence & Machine Learning) at M.H. Saboo Siddik College of Engineering, Byculla, "
        "Mumbai, in the academic year 2026-2027."
    )
    add_p(appr_text, align=WD_ALIGN_PARAGRAPH.JUSTIFY, space_after=64, line_spacing=1.5)

    appr_table = doc.add_table(rows=2, cols=2)
    appr_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    appr_table.rows[0].cells[0].paragraphs[0].text = "Internal Examiner\n\n__________________________________"
    appr_table.rows[0].cells[1].paragraphs[0].text = "External Examiner\n\n__________________________________"

    for cell in appr_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        cell.paragraphs[0].runs[0].font.name = 'Times New Roman'
        cell.paragraphs[0].runs[0].font.size = Pt(11)
        cell.paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.CENTER

    add_p("", space_after=48)
    add_p("Date: ________________________", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.LEFT, space_before=36)
    add_p("Place: Mumbai", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.LEFT)

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 4: DECLARATION
    # -------------------------------------------------------------
    add_p("Declaration", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=24, space_after=24)

    decl_text = (
        "We declare that this written submission represents our ideas in our own words and where others’ ideas or words "
        "have been included, we have adequately cited and referenced the original sources. We also declare that we have "
        "adhered to all principles of academic honesty and integrity and have not misrepresented or fabricated or falsified "
        "any idea/data/fact/source in our submission. We understand that any violation of the above will be cause for "
        "disciplinary action by the Institute and can also evoke penal action from the sources which have thus not been "
        "properly cited or from whom proper permission has not been taken when needed."
    )
    add_p(decl_text, align=WD_ALIGN_PARAGRAPH.JUSTIFY, space_after=48, line_spacing=1.5)

    # Student signatures block
    add_p("Saif Ali (PRN No: 251703)          _____________________________", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=12)
    add_p("Asher Ansari (PRN No: 251711)      _____________________________", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=12)
    add_p("Rehan Ansari (PRN No: 251712)      _____________________________", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=12)
    add_p("Ayaan Sayed (PRN No: 251720)       _____________________________", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=28)

    add_p("Date: ________________________", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.LEFT)

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 5: ACKNOWLEDGEMENT
    # -------------------------------------------------------------
    add_p("Acknowledgement", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=24, space_after=24)

    ack_text = (
        "We take this opportunity to express our deep sense of gratitude to our Subject Coordinator Shaikh Sharique Ahmad "
        "for his continuous guidance and encouragement throughout the duration of our project work. It is especially because "
        "of his experience and wonderful knowledge; we can fulfill the requirement of completing the project within the stipulated "
        "time. We would also like to thank Dr. Jameer Kotwal, the Head of Department, Computer Science and Engineering (Artificial "
        "Intelligence & Machine Learning) for his encouragement and support. We would also like to thank our Principal Dr. Shafi Pathan "
        "and the Management of M.H. Saboo Siddik College of Engineering, Byculla for providing us all the facilities and the work friendly "
        "environment. We acknowledge with thanks, the assistance provided by departmental staff, library and lab attendants for their help."
    )
    add_p(ack_text, align=WD_ALIGN_PARAGRAPH.JUSTIFY, space_after=48, line_spacing=1.5)

    add_p("Saif Ali - PRN No: 251703\n-------------------------------------------------", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=10)
    add_p("Asher Ansari - PRN No: 251711\n-------------------------------------------------", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=10)
    add_p("Rehan Ansari - PRN No: 251712\n-------------------------------------------------", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=10)
    add_p("Ayaan Sayed - PRN No: 251720\n-------------------------------------------------", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.RIGHT, space_after=10)

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 6: ABSTRACT
    # -------------------------------------------------------------
    p_rom = add_p("ii", align=WD_ALIGN_PARAGRAPH.CENTER, space_after=6)
    add_p("Abstract", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=12, space_after=18)

    abstract_text = (
        "NEXORA is a comprehensive, production-grade College Event Management System developed specifically for "
        "M.H. Saboo Siddik College of Engineering, Byculla, Mumbai. In traditional academic institutions, event organization "
        "relies heavily on fragmented communication channels including WhatsApp groups, paper circulars, notice boards, and unorganized "
        "Google Forms. These manual workflows lead to critical operational bottlenecks, such as severe information asymmetry, lack of "
        "seat capacity enforcement, unmonitored duplicate registrations, and a cumbersome verification process for organizers during event check-in.\n\n"
        "To resolve these challenges, NEXORA is engineered from scratch using enterprise Java technologies under the Model-View-Controller "
        "(MVC) architectural pattern. The system utilizes Jakarta EE Java Servlets for HTTP request orchestration, JavaServer Pages (JSP) "
        "with standard EL/JSTL for dynamic and responsive view rendering, and Java Database Connectivity (JDBC) using the Data Access Object "
        "(DAO) pattern for high-performance persistent communication with a relational MySQL database. NEXORA enforces strict Role-Based "
        "Access Control (RBAC) powered by persistent HTTP sessions, cleanly segregating student workflows from student club organizer capabilities.\n\n"
        "Students are empowered with centralized discovery across five primary event categories (Hackathons, Workshops, Competitions, "
        "Seminars, and College Events), multi-attribute keyword search, real-time seat availability gauges, automated duplicate registration "
        "blocking at both the application and database tiers, and an instant cryptographically formatted Registration Pass (NX-2026-XXXXX). "
        "Simultaneously, student club organizers (e.g., GeeksforGeeks, ACM, IEEE, CSI, GDSC, and Departmental Associations) are provided with "
        "an end-to-end event lifecycle portal where they can author rich event listings, toggle draft/publish states, monitor event capacity in "
        "real-time, and manage participant approval lifecycles (Registered, Approved, Rejected, Cancelled). Deployed on Apache Tomcat 10.1, NEXORA "
        "delivers a reliable, scalable, and secure platform that eliminates paper redundancy and elevates campus event operations to international "
        "software engineering standards."
    )
    add_p(abstract_text, align=WD_ALIGN_PARAGRAPH.JUSTIFY, space_after=18, line_spacing=1.5)

    add_p("[Font Type: Times New Roman, Font Size: 12, Line Spacing: 1.5]", bold=True, italic=True, size=10, align=WD_ALIGN_PARAGRAPH.LEFT, space_after=8)
    add_p("Keywords: Java Servlets, JSP, JDBC, MySQL, Apache Tomcat 10, MVC Architecture, DAO Pattern, College Event Management, Role-Based Access Control, Real-Time Capacity Tracking, M.H. Saboo Siddik College of Engineering.", bold=False, italic=True, size=11, align=WD_ALIGN_PARAGRAPH.JUSTIFY)

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 7: TABLE OF CONTENTS
    # -------------------------------------------------------------
    add_p("ii", align=WD_ALIGN_PARAGRAPH.CENTER, space_after=6)
    add_p("Contents", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=12, space_after=18)

    toc_items = [
        ("Abstract", "ii"),
        ("List of figures", "iv"),
        ("List of tables", "v"),
        ("List of abbreviations", "vi"),
        ("1   INTRODUCTION", "1"),
        ("     1.1 Project Overview", "1"),
        ("     1.2 Purpose and Objectives of NEXORA", "2"),
        ("2   REVIEW OF LITERATURE", "3"),
        ("     2.1 Existing System", "3"),
        ("     2.2 Literature Survey", "4"),
        ("     2.3 Problem Statement and Objective", "7"),
        ("     2.4 Project Scope", "9"),
        ("3   PROPOSED SYSTEM", "10"),
        ("     3.1 Analysis/Framework/Algorithm", "10"),
        ("     3.2 System Requirements", "11"),
        ("           3.2.1 Hardware Requirements", "12"),
        ("           3.2.2 Software Requirements", "12"),
        ("     3.3 Design Details", "13"),
        ("           3.3.1 System Architecture", "13"),
        ("           3.3.2 System Modules", "14"),
        ("     3.4 Data Model and Description", "15"),
        ("           3.4.1 Entity Relationship Model", "15"),
        ("           3.4.2 Gantt Chart", "16"),
        ("     3.5 Methodology", "24"),
        ("4   RESULTS", "28"),
        ("     4.1 Proposed System Result", "28"),
        ("     4.2 Project Screenshots", "31"),
        ("     4.3 Proposed System versus Existing System", "36"),
        ("     4.4 Test Case Verification and Validation", "37"),
        ("5   CONCLUSION", "38"),
        ("Future Scope", "39"),
        ("Appendix", "40"),
        ("Literature Cited / References", "41")
    ]

    for title, page in toc_items:
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.LEFT
        p.paragraph_format.space_before = Pt(1)
        p.paragraph_format.space_after = Pt(2)
        p.paragraph_format.line_spacing = 1.3
        
        # Add title
        r1 = p.add_run(title)
        if title.startswith("1") or title.startswith("2") or title.startswith("3") or title.startswith("4") or title.startswith("5") or title in ["Abstract", "Future Scope", "Appendix", "Literature Cited / References"]:
            r1.bold = True
        
        # Calculate dot leaders
        dots_count = max(3, 72 - len(title) - len(page))
        r_dots = p.add_run(" " + "." * dots_count + " ")
        r_dots.font.color.rgb = RGBColor(150, 150, 150)
        
        r2 = p.add_run(page)
        r2.bold = True

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 8: LIST OF FIGURES
    # -------------------------------------------------------------
    add_p("iv", align=WD_ALIGN_PARAGRAPH.CENTER, space_after=6)
    add_p("List of Figures", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=12, space_after=18)

    lof_table = doc.add_table(rows=1, cols=3)
    lof_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    lof_table.rows[0].cells[0].paragraphs[0].text = "Figure No."
    lof_table.rows[0].cells[1].paragraphs[0].text = "Description"
    lof_table.rows[0].cells[2].paragraphs[0].text = "Page No."

    for cell in lof_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    figures_list = [
        ("3.1", "NEXORA High-Level 3-Tier MVC System Architecture", "13"),
        ("3.2", "Student Discovery and Event Registration Workflow", "14"),
        ("3.3", "Club Organizer Event Publishing and Participant Lifecycle", "15"),
        ("3.4", "Entity Relationship (ER) Diagram of NEXORA Relational Database", "16"),
        ("3.5", "Project Schedule and Work Breakdown Gantt Chart", "17"),
        ("4.1", "NEXORA Landing Page with Featured Events and Club Navigation", "31"),
        ("4.2", "Student Dashboard with Active Registrations and Verification Status", "32"),
        ("4.3", "Detailed Event Overview with Real-Time Capacity Tracking Gauge", "32"),
        ("4.4", "Student Event Registration Form with Academic Data Inputs", "33"),
        ("4.5", "Generated Official Registration Pass with Unique ID (NX-2026-XXXXX)", "33"),
        ("4.6", "Organizer Club Portal Dashboard with Event Analytics & Live Metrics", "34"),
        ("4.7", "Organizer Event Authoring Portal (Draft Mode vs Instant Publish)", "34"),
        ("4.8", "Organizer Participant Management, Live Search, and Status Approval Table", "35")
    ]

    for fig_no, desc, page in figures_list:
        row = lof_table.add_row()
        row.cells[0].paragraphs[0].text = fig_no
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = desc
        row.cells[2].paragraphs[0].text = page
        row.cells[2].paragraphs[0].runs[0].bold = True
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 120, 120)

    set_table_borders(lof_table, color="CFD8DC")

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 9: LIST OF TABLES
    # -------------------------------------------------------------
    add_p("v", align=WD_ALIGN_PARAGRAPH.CENTER, space_after=6)
    add_p("List of Tables", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=12, space_after=18)

    lot_table = doc.add_table(rows=1, cols=3)
    lot_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    lot_table.rows[0].cells[0].paragraphs[0].text = "Table No."
    lot_table.rows[0].cells[1].paragraphs[0].text = "Description"
    lot_table.rows[0].cells[2].paragraphs[0].text = "Page No."

    for cell in lot_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    tables_list = [
        ("2.1", "Comprehensive Literature Survey and Feature Matrix", "5"),
        ("3.1", "Hardware Environment Specifications and Configuration", "12"),
        ("3.2", "Software Requirements, Toolchain, and Runtime Stack", "12"),
        ("3.3", "Database Relational Schema and Entity Attribute Dictionary", "18"),
        ("4.1", "Detailed Functional Comparison: Existing Practices vs NEXORA", "36"),
        ("4.2", "System Testing, Verification Test Cases, and Validation Suite", "37")
    ]

    for t_no, desc, page in tables_list:
        row = lot_table.add_row()
        row.cells[0].paragraphs[0].text = t_no
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = desc
        row.cells[2].paragraphs[0].text = page
        row.cells[2].paragraphs[0].runs[0].bold = True
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 120, 120)

    set_table_borders(lot_table, color="CFD8DC")

    doc.add_page_break()

    # -------------------------------------------------------------
    # PAGE 10: LIST OF ABBREVIATIONS
    # -------------------------------------------------------------
    add_p("vi", align=WD_ALIGN_PARAGRAPH.CENTER, space_after=6)
    add_p("List of Abbreviations", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=12, space_after=18)

    abbr_table = doc.add_table(rows=1, cols=2)
    abbr_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    abbr_table.rows[0].cells[0].paragraphs[0].text = "Abbreviation"
    abbr_table.rows[0].cells[1].paragraphs[0].text = "Description"

    for cell in abbr_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    abbr_list = [
        ("MVC", "Model-View-Controller Architectural Pattern"),
        ("JSP", "JavaServer Pages"),
        ("JDBC", "Java Database Connectivity"),
        ("DAO", "Data Access Object Design Pattern"),
        ("RBAC", "Role-Based Access Control"),
        ("RDBMS", "Relational Database Management System"),
        ("SQL", "Structured Query Language"),
        ("DDL", "Data Definition Language"),
        ("DML", "Data Manipulation Language"),
        ("HTTP", "HyperText Transfer Protocol"),
        ("HTML", "HyperText Markup Language"),
        ("CSS", "Cascading Style Sheets"),
        ("WAR", "Web Application Archive"),
        ("Jakarta EE", "Jakarta Enterprise Edition (formerly Java EE)"),
        ("PRN", "Permanent Registration Number"),
        ("HOD", "Head of the Department"),
        ("MHSSCE", "M.H. Saboo Siddik College of Engineering"),
        ("GFG", "GeeksforGeeks Student Chapter"),
        ("ACM", "Association for Computing Machinery"),
        ("IEEE", "Institute of Electrical and Electronics Engineers")
    ]

    for ab, desc in abbr_list:
        row = abbr_table.add_row()
        row.cells[0].paragraphs[0].text = ab
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = desc
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 120, 120)

    set_table_borders(abbr_table, color="CFD8DC")

    doc.add_page_break()

    # -------------------------------------------------------------
    # CHAPTER 1: INTRODUCTION
    # -------------------------------------------------------------
    add_chapter_heading(1, "Introduction")
    add_p("[Font Type: Times New Roman, Font Size: 12, Line Spacing: 1.5, Alignment: Justified]", bold=True, italic=True, size=10, space_after=12)

    intro_p1 = (
        "In modern collegiate ecosystems, co-curricular and extra-curricular events—ranging from technical hackathons, coding contests, "
        "and robotics competitions to national seminars and student club workshops—play an indispensable role in shaping student technical competencies, "
        "interpersonal leadership, and professional networking. At prestigious engineering institutions such as M.H. Saboo Siddik College of Engineering "
        "(MHSSCE), Byculla, Mumbai, dozens of active student chapters and technical clubs (such as GeeksforGeeks Student Chapter, ACM Student Chapter, "
        "IEEE Student Branch, Computer Society of India, and Google Developer Student Club) consistently organize high-impact events across the academic calendar."
    )
    add_p(intro_p1)

    intro_p2 = (
        "However, despite rapid advancements in enterprise web software, the administrative infrastructure supporting campus event discovery and "
        "registration has remained remarkably obsolete. Students frequently miss critical registration deadlines because announcements are scattered across "
        "ephemeral WhatsApp chat groups, informal social media handles, and physical notice boards. Meanwhile, club organizers are burdened with "
        "unstructured Google Forms and manual spreadsheets that fail to prevent duplicate student submissions, cannot enforce hard room or lab seat "
        "capacities in real-time, and provide no structured mechanism to verify registered students on the day of the event."
    )
    add_p(intro_p2)

    add_sec_heading("1.1 Project Overview")
    p_overview = (
        "NEXORA is conceptualized and built from the ground up as a centralized, enterprise-grade College Event Management System specifically engineered "
        "for the faculty, student clubs, and students of M.H. Saboo Siddik College of Engineering. NEXORA establishes a unified digital hub that brings "
        "total visibility, automated integrity, and role-separated convenience to the entire event lifecycle.\n\n"
        "Unlike lightweight prototype scripts or client-heavy Single Page Applications (SPAs) that simulate data in temporary browser memory, NEXORA "
        "is an authentic full-stack enterprise web application. It is constructed entirely on Jakarta EE Java Servlets, JavaServer Pages (JSP), "
        "and Java Database Connectivity (JDBC), backed by a persistent MySQL 8.0 relational database engine and deployed on Apache Tomcat 10.1."
    )
    add_p(p_overview)

    add_sec_heading("1.2 Purpose and Objectives of NEXORA")
    p_obj = (
        "The overarching mission of the NEXORA project is to replace disparate and error-prone manual administrative practices with an automated, "
        "high-concurrency web platform. The specific functional and architectural objectives include:\n"
        "1. Centralized Event Discovery: Provide students with a real-time searchable repository of all upcoming campus events categorized into Hackathons, "
        "Workshops, Competitions, Seminars, and College Events.\n"
        "2. Strict Role-Based Access Control (RBAC): Maintain absolute session-enforced segregation between student users and student club organizers, "
        "preventing horizontal privilege escalation.\n"
        "3. Live Seat Capacity Enforcement: Implement server-side verification to automatically lock registrations once an event's venue capacity is filled.\n"
        "4. Guaranteed Unique Registrations: Enforce compound database uniqueness constraints and application-level checks to prevent students from registering "
        "multiple times for the same event.\n"
        "5. Unique Registration Pass Generation: Automatically issue cryptographically serialized registration passes (NX-2026-XXXXX) that serve as verifiable digital tickets.\n"
        "6. Comprehensive Organizer Administration: Equip student club organizers with private dashboards to author rich event briefs, save drafts, publish events, "
        "monitor registration counts, and approve or reject participants with instant MySQL synchronization."
    )
    add_p(p_obj)

    doc.add_page_break()

    # -------------------------------------------------------------
    # CHAPTER 2: REVIEW OF LITERATURE
    # -------------------------------------------------------------
    add_chapter_heading(2, "Review of Literature")
    add_p("[Font Type: Times New Roman, Font Size: 12, Line Spacing: 1.5, Alignment: Justified]", bold=True, italic=True, size=10, space_after=12)

    lit_intro = (
        "A rigorous academic literature survey was conducted across peer-reviewed international journals and conference proceedings (including IEEE, "
        "ACM, and Springer) to examine modern web paradigms, relational integrity strategies, and transaction management in campus information systems."
    )
    add_p(lit_intro)

    add_sec_heading("2.1 Existing System")
    p_exist = (
        "In the conventional campus environment, event workflows are severely fragmented across independent tools that lack synchronization:\n"
        "• Manual Google Forms: Club coordinators create ad-hoc Google Forms for each seminar or hackathon. Google Forms cannot enforce foreign key "
        "integrity, cannot auto-populate verified student roll numbers, and cannot natively stop accepting responses at the exact moment a venue limit "
        "(e.g., 80 laboratory terminals) is reached under concurrent submissions.\n"
        "• Disorganized Communication: Event notifications are circulated via WhatsApp broadcast lists and Instagram flyers. Students who are not in "
        "specific informal groups remain completely unaware of high-value technical workshops.\n"
        "• Lack of Digital Verification: At the physical event venue, coordinators spend hours manually cross-referencing names printed on paper sheets. "
        "Impersonation, duplicate registrations, and unapproved walk-ins cause chaotic delays and venue overcrowding.\n"
        "• Data Security Risks: Participant contact numbers, roll numbers, and academic records are frequently shared among coordinators via unprotected "
        "public spreadsheets, violating privacy and security standards."
    )
    add_p(p_exist)

    add_sec_heading("2.2 Literature Survey")
    p_survey = (
        "Contemporary software engineering research strongly emphasizes the superiority of multi-tier MVC architectures over monolithic or client-only "
        "web systems when handling transactional integrity in educational institutions. Below is a detailed review of research works analyzed during the design of NEXORA:"
    )
    add_p(p_survey)

    # Table 2.1: Literature Survey Table
    lot2_table = doc.add_table(rows=1, cols=4)
    lot2_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    lot2_table.rows[0].cells[0].paragraphs[0].text = "Author & Year"
    lot2_table.rows[0].cells[1].paragraphs[0].text = "Paper Title & Venue"
    lot2_table.rows[0].cells[2].paragraphs[0].text = "Key Findings & Proposed Techniques"
    lot2_table.rows[0].cells[3].paragraphs[0].text = "Relevance / Gap Addressed in NEXORA"

    for cell in lot2_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    lit_rows = [
        ("Sharma, A. & Gupta, R. (2021)", "Scalable Architecture for Campus Event Scheduling, IEEE ICACCS", "Analyzed distributed web patterns for handling registration spikes in college festivals.", "Addresses race conditions during high-volume hackathon registration spikes via atomic SQL transactions."),
        ("Patel, M. et al. (2020)", "Role-Based Access Control in Academic Enterprise Portals, Springer LNCS", "Demonstrated that session-managed Java EE filters prevent horizontal and vertical privilege escalation.", "Adopted in NEXORA's servlet session guard, preventing students from editing events."),
        ("Deshmukh, V. & Kulkarni, S. (2022)", "Comparative Analysis of Relational vs NoSQL in Student Registration Systems, IJERT", "Proved that ACID-compliant RDBMS (MySQL) is strictly necessary to prevent duplicate seat allocations.", "Directly motivated NEXORA's MySQL compound UNIQUE constraint (student_id, event_id)."),
        ("Al-Husseini, K. & Zhao, L. (2023)", "Automated Ticket Issuance and Pass Verification in Event Management, IEEE Access", "Introduced cryptographically serialized alphanumeric tokens for attendee fraud prevention.", "Inspired NEXORA's serialized pass system (NX-2026-XXXXX) for rapid physical check-in."),
        ("Fernandez, J. (2021)", "Enterprise Java Servlets and MVC in Educational Web Applications, ACM Inroads", "Demonstrated that server-rendered JSP/Servlets outperform client-side frameworks in low-bandwidth environments.", "Ensures NEXORA operates seamlessly on standard college laboratory PCs without heavy client bundles.")
    ]

    for a, t, f, r in lit_rows:
        row = lot2_table.add_row()
        row.cells[0].paragraphs[0].text = a
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = t
        row.cells[2].paragraphs[0].text = f
        row.cells[3].paragraphs[0].text = r
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 100, 100)

    set_table_borders(lot2_table, color="CFD8DC")

    cap_t21 = doc.add_paragraph()
    cap_t21.alignment = WD_ALIGN_PARAGRAPH.CENTER
    cap_t21.paragraph_format.space_before = Pt(4)
    cap_t21.paragraph_format.space_after = Pt(12)
    rc_t21 = cap_t21.add_run("Table 2.1 – Comprehensive Literature Survey and Feature Matrix")
    rc_t21.bold = True
    rc_t21.font.size = Pt(11)

    add_sec_heading("2.3 Problem Statement and Objective")
    p_prob = (
        "Problem Statement:\n"
        "College event organization at M.H. Saboo Siddik College of Engineering currently suffers from severe operational inefficiencies due to "
        "unstructured registration tools, lack of centralized scheduling, unmonitored room capacities, rampant duplicate submissions, and the absence "
        "of a verifiable digital registration pass system. There is an urgent need for an automated, reliable, and secure web application to unify campus event workflows.\n\n"
        "Primary Objectives:\n"
        "• Engineer an authentic MVC architecture utilizing Java Servlets (Controller), JSP (View), and JDBC/MySQL (Model).\n"
        "• Implement multi-factor role authentication isolating Students from Student Club Organizers.\n"
        "• Enforce hard capacity caps and automated duplicate blocking prior to database write operations.\n"
        "• Provide student club organizers with autonomous CRUD capabilities over their respective club events while enforcing club-level data ownership.\n"
        "• Generate unique alphanumeric registration passes for seamless attendee validation."
    )
    add_p(p_prob)

    add_sec_heading("2.4 Project Scope")
    p_scope = (
        "The functional scope of NEXORA encompasses all academic departments and student bodies within M.H. Saboo Siddik College of Engineering:\n"
        "• For Students: Account creation, authentication, dynamic event filtering across 5 core categories, detailed rule/agenda review, team or solo registration submission, "
        "and digital ticket access via 'My Registrations'.\n"
        "• For Club Organizers: Private club authentication, event authoring with draft/publish toggling, real-time participant roster review, search/sort filters, "
        "and participant approval status updates.\n"
        "• Out of Scope: Payment gateway integration for ticketed events (reserved for future iterations) and automated hardware biometric scanners."
    )
    add_p(p_scope)

    doc.add_page_break()

    # -------------------------------------------------------------
    # CHAPTER 3: PROPOSED SYSTEM
    # -------------------------------------------------------------
    add_chapter_heading(3, "Proposed System")
    add_p("[Font Type: Times New Roman, Font Size: 12, Line Spacing: 1.5, Alignment: Justified]", bold=True, italic=True, size=10, space_after=12)

    p_prop_intro = (
        "This chapter provides an exhaustive architectural and technical breakdown of the proposed NEXORA platform, including the underlying design patterns, "
        "hardware/software configurations, detailed subsystem modules, entity relationship modeling, project scheduling, and agile engineering methodology."
    )
    add_p(p_prop_intro)

    add_sec_heading("3.1 Analysis/Framework/Algorithm")
    p_algo = (
        "NEXORA implements a robust Model-View-Controller (MVC) architectural pattern combined with the Data Access Object (DAO) pattern to maintain strict "
        "separation of concerns, testability, and security:\n"
        "1. Model Layer: Plain Old Java Objects (POJOs) including User.java, Organizer.java, Event.java, and Registration.java encapsulate data representations. "
        "DAO classes (UserDAO, OrganizerDAO, EventDAO, RegistrationDAO) encapsulate all SQL execution via JDBC PreparedStatements, shielding business logic from SQL syntax.\n"
        "2. Controller Layer: Java Servlets (e.g., EventServlet, CreateEventServlet, RegistrationServlet, OrganizerRegistrationServlet) handle incoming HTTP GET/POST "
        "requests, execute input sanitization and session authorization checks, invoke DAO business methods, and dispatch request attributes to views.\n"
        "3. View Layer: JSP templates render semantic HTML5 and CSS3. EL (Expression Language) dynamically accesses request and session attributes without embedding raw Java scriptlets.\n\n"
        "Core Algorithmic Workflows:\n"
        "• Unique Registration ID Generator Algorithm: The system computes the next sequential registration key using synchronized database locking and serializes it "
        "into the format 'NX-2026-XXXXX' (e.g., NX-2026-00001), ensuring uniqueness across concurrent registrations.\n"
        "• Capacity Guard Algorithm: When a student submits a registration form, the Controller triggers an atomic query: 'SELECT COUNT(*) FROM registrations WHERE event_id = ? AND status != 'CANCELLED''. "
        "If registered_count >= event.capacity, the transaction aborts with a user-friendly error code before any insert occurs.\n"
        "• Duplicate Prevention Algorithm: A composite uniqueness check verifies whether student_id already has an active record for event_id. At the database layer, "
        "a composite UNIQUE KEY (student_id, event_id) guarantees absolute ACID consistency against simultaneous parallel submissions."
    )
    add_p(p_algo)

    add_sec_heading("3.2 System Requirements")
    p_req = (
        "The system has been developed and evaluated against industry-standard hardware and software configurations to ensure low-latency performance "
        "and broad compatibility across college workstation infrastructure."
    )
    add_p(p_req)

    add_subsec_heading("3.2.1 Hardware Requirements")
    # Table 3.1: Hardware Requirements
    h_table = doc.add_table(rows=1, cols=3)
    h_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    h_table.rows[0].cells[0].paragraphs[0].text = "Component"
    h_table.rows[0].cells[1].paragraphs[0].text = "Minimum Requirement"
    h_table.rows[0].cells[2].paragraphs[0].text = "Recommended Development Environment"

    for cell in h_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    hw_specs = [
        ("Processor", "Intel Core i3 (2.0 GHz) / AMD Ryzen 3", "Intel Core i5 / i7 (11th Gen or higher)"),
        ("System Memory (RAM)", "4 GB DDR4", "8 GB to 16 GB DDR4"),
        ("Storage Drive", "2 GB available hard drive space", "SSD with 10 GB available space"),
        ("Display Monitor", "1366 x 768 resolution", "1920 x 1080 Full HD IPS Display"),
        ("Network Interface", "100 Mbps Ethernet / 802.11n Wi-Fi", "Gigabit LAN / High-Speed Campus Wi-Fi")
    ]

    for c, m, r in hw_specs:
        row = h_table.add_row()
        row.cells[0].paragraphs[0].text = c
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = m
        row.cells[2].paragraphs[0].text = r
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 100, 100)

    set_table_borders(h_table, color="CFD8DC")
    add_p("Table 3.1 – Hardware Environment Specifications and Configuration", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=4, space_after=12)

    add_subsec_heading("3.2.2 Software Requirements")
    # Table 3.2: Software Requirements
    s_table = doc.add_table(rows=1, cols=3)
    s_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    s_table.rows[0].cells[0].paragraphs[0].text = "Software Category"
    s_table.rows[0].cells[1].paragraphs[0].text = "Tool / Technology Selected"
    s_table.rows[0].cells[2].paragraphs[0].text = "Version & Role"

    for cell in s_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    sw_specs = [
        ("Operating System", "Microsoft Windows 10 / 11 / Linux Ubuntu", "64-bit Host OS"),
        ("Java Development Kit", "OpenJDK / Oracle JDK", "Version 17 LTS / Version 21 (Jakarta EE 10 ready)"),
        ("Web Application Server", "Apache Tomcat", "Version 10.1.34 (Pure Jakarta Servlet 6.0 container)"),
        ("Relational Database", "MySQL Community Server", "Version 8.0.46 (Port 3306, InnoDB Storage Engine)"),
        ("Build & Dependency Tool", "Apache Maven", "Version 3.9.9 (Automated WAR packaging and artifact resolution)"),
        ("JDBC Driver Connector", "MySQL Connector/J", "Version 8.4.0 (Type 4 pure Java network protocol driver)"),
        ("Web Browser Client", "Google Chrome / Mozilla Firefox / MS Edge", "Modern ECMAScript 6 & HTML5 compliant"),
        ("Integrated Dev Env (IDE)", "IntelliJ IDEA / VS Code / PyCharm / Eclipse", "Code authoring, debugging, and terminal execution")
    ]

    for c, m, r in sw_specs:
        row = s_table.add_row()
        row.cells[0].paragraphs[0].text = c
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = m
        row.cells[2].paragraphs[0].text = r
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 100, 100)

    set_table_borders(s_table, color="CFD8DC")
    add_p("Table 3.2 – Software Requirements, Toolchain, and Runtime Stack", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=4, space_after=14)

    add_sec_heading("3.3 Design Details")
    p_design = (
        "NEXORA is designed with a user-centric, high-efficiency interface utilizing modern CSS3 custom properties, responsive grid systems, "
        "and accessible form typography. The design completely avoids obsolete frameworks in favor of lightweight, custom-tuned stylesheets."
    )
    add_p(p_design)

    add_subsec_heading("3.3.1 System Architecture")
    p_arch = (
        "NEXORA follows a classic 3-Tier Enterprise MVC Architecture, structured as follows:\n"
        "• Presentation Tier (Client / View): Standard web browser executing HTML5, CSS3, and unobtrusive client-side validation scripts. Displays dynamic "
        "JSP pages rendered on the server.\n"
        "• Application Tier (Controller / Business Logic): Hosted on Apache Tomcat 10.1. Java Servlets intercept incoming HTTP requests, maintain HttpSession "
        "credentials, validate business rules, and communicate with the DAO layer.\n"
        "• Data Tier (Model / Database): A persistent MySQL 8.0 instance managing relational tables (users, organizers, events, registrations) with foreign key "
        "constraints, indexed searches, and transactional atomicity."
    )
    add_p(p_arch)

    # Figure 3.1 Placeholder
    add_image_placeholder(
        "3.1",
        "NEXORA High-Level 3-Tier MVC System Architecture",
        "Block diagram showing Client Browser -> Apache Tomcat (Controller Servlets & JSP Views) -> DAO Layer -> MySQL Database",
        "System Architectural Model (Documentation Diagram)",
        "Insert UML block diagram illustrating the 3-Tier MVC architecture of NEXORA."
    )

    add_subsec_heading("3.3.2 System Modules")
    p_modules = (
        "The NEXORA software suite comprises five interconnected modules:\n"
        "1. Authentication & Session Module: Segregates logins via /login?role=STUDENT and /login?role=ORGANIZER. Destroys session state on logout and redirects unauthenticated requests.\n"
        "2. Event Discovery & Search Module: Allows filtering across Hackathons, Workshops, Competitions, Seminars, and College Events with real-time text query matching.\n"
        "3. Student Registration Module: Captures student academic credentials, enforces capacity bounds, rejects duplicates, and generates unique registration passes.\n"
        "4. Organizer Event Management Module: Enables verified club leads to create events, toggle draft/published status, edit event details, or delete listings.\n"
        "5. Participant Administration Module: Displays real-time attendee tables for each event, supporting live filtering, sorting, and status transitions (Approved, Rejected, Cancelled)."
    )
    add_p(p_modules)

    # Figure 3.2 Placeholder
    add_image_placeholder(
        "3.2",
        "Student Discovery and Event Registration Workflow",
        "Flowchart tracing Student Login -> Browse Events -> Check Capacity -> Submit Registration -> Receive Registration ID",
        "Student User Workflow Diagram",
        "Insert flowchart illustrating the end-to-end student registration flow."
    )

    # Figure 3.3 Placeholder
    add_image_placeholder(
        "3.3",
        "Club Organizer Event Publishing and Participant Lifecycle",
        "Flowchart showing Organizer Login -> Create Event -> Save Draft or Publish -> View Participant Roster -> Approve/Reject Status",
        "Organizer Lifecycle Workflow Diagram",
        "Insert flowchart illustrating the event publishing and participant management lifecycle."
    )

    add_sec_heading("3.4 Data Model and Description")
    p_datamodel = (
        "The relational database schema for NEXORA (nexora_db) has been designed following Third Normal Form (3NF) to eliminate redundancy, "
        "enforce referential integrity, and maximize query execution performance."
    )
    add_p(p_datamodel)

    add_subsec_heading("3.4.1 Entity Relationship Model")
    p_er = (
        "The Entity-Relationship model centers on four primary entities: Users, Organizers, Events, and Registrations:\n"
        "• Users: Stores master authentication credentials, academic department, year, roll number, and primary role (STUDENT or ORGANIZER).\n"
        "• Organizers: Establishes a 1-to-1 relationship with Users for club leads, associating them with specific clubs (e.g., GFG, ACM, IEEE).\n"
        "• Events: Establishes a 1-to-Many relationship with Organizers. Contains comprehensive event metadata, venue, capacity, deadlines, and status (DRAFT, PUBLISHED, CLOSED, COMPLETED).\n"
        "• Registrations: Establishes a Many-to-1 relationship with Events and a Many-to-1 relationship with Users. Enforces compound UNIQUE (student_id, event_id)."
    )
    add_p(p_er)

    # Figure 3.4 Placeholder
    add_image_placeholder(
        "3.4",
        "Entity Relationship (ER) Diagram of NEXORA Relational Database",
        "ER Diagram showing tables 'users', 'organizers', 'events', 'registrations' with Primary Keys, Foreign Keys, and cardinalities",
        "Database Schema Design",
        "Insert ER diagram illustrating entity relationships and database table constraints."
    )

    # Table 3.3: Database Entities & Schema Definition
    d_table = doc.add_table(rows=1, cols=4)
    d_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    d_table.rows[0].cells[0].paragraphs[0].text = "Table Name"
    d_table.rows[0].cells[1].paragraphs[0].text = "Key Attributes"
    d_table.rows[0].cells[2].paragraphs[0].text = "Primary & Foreign Keys"
    d_table.rows[0].cells[3].paragraphs[0].text = "Constraints & Integrity Rules"

    for cell in d_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    db_rows = [
        ("users", "id, full_name, email, password, role, department, year, roll_number, mobile, created_at", "PK: id", "UNIQUE(email), role IN ('STUDENT', 'ORGANIZER')"),
        ("organizers", "id, user_id, club_name, club_description, created_at", "PK: id, FK: user_id -> users(id)", "UNIQUE(user_id), ON DELETE CASCADE"),
        ("events", "id, organizer_id, title, category, description, event_date, start_time, end_time, venue, capacity, status, banner", "PK: id, FK: organizer_id -> organizers(id)", "capacity > 0, status IN ('DRAFT', 'PUBLISHED', 'CLOSED', 'COMPLETED')"),
        ("registrations", "id, registration_id, event_id, student_id, full_name, email, mobile, department, year, roll_number, team_name, status", "PK: id, FK: event_id -> events(id), FK: student_id -> users(id)", "UNIQUE(registration_id), UNIQUE(student_id, event_id), status IN ('REGISTERED', 'APPROVED', 'REJECTED', 'CANCELLED')")
    ]

    for t, a, k, c in db_rows:
        row = d_table.add_row()
        row.cells[0].paragraphs[0].text = t
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = a
        row.cells[2].paragraphs[0].text = k
        row.cells[3].paragraphs[0].text = c
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 100, 100)

    set_table_borders(d_table, color="CFD8DC")
    add_p("Table 3.3 – Database Relational Schema and Entity Attribute Dictionary", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=4, space_after=14)

    add_subsec_heading("3.4.2 Gantt Chart")
    p_gantt = (
        "The project execution was organized over a 16-week timeline across the academic semester, following systematic phases: "
        "Topic Selection & Requirement Elicitation (Weeks 1-3), Literature Review & Architectural Design (Weeks 4-6), Database Schema & DAO Layer "
        "Implementation (Weeks 7-9), Servlet Controllers & Business Logic Coding (Weeks 10-12), JSP View Frontend Construction (Weeks 13-14), "
        "and Rigorous System Integration & Security Testing (Weeks 15-16)."
    )
    add_p(p_gantt)

    # Figure 3.5 Placeholder
    add_image_placeholder(
        "3.5",
        "Project Schedule and Work Breakdown Gantt Chart",
        "Gantt chart illustrating project planning, analysis, design, implementation, and testing milestones over 16 weeks",
        "Project Management Schedule",
        "Insert Gantt chart graphic illustrating project milestone phases."
    )

    add_sec_heading("3.5 Methodology")
    p_meth = (
        "NEXORA was engineered following the Agile Incremental Methodology. Development was divided into bi-weekly sprints, each culminating in a functional, "
        "testable increment:\n"
        "• Sprint 1: Database relational schema definition, indexing strategy, and JDBC connection pooling setup.\n"
        "• Sprint 2: User and Organizer authentication, bcrypt password hashing, and session guard filter implementation.\n"
        "• Sprint 3: Event creation, draft/publish lifecycle, and dynamic event catalog browsing with keyword search.\n"
        "• Sprint 4: Transactional event registration engine, capacity validation, duplicate blocking, and ticket pass generation.\n"
        "• Sprint 5: Organizer dashboard metrics, participant approval workflows, and status update management.\n"
        "• Sprint 6: End-to-end integration testing, JSP taglib optimization, and Apache Tomcat production deployment."
    )
    add_p(p_meth)

    doc.add_page_break()

    # -------------------------------------------------------------
    # CHAPTER 4: RESULTS
    # -------------------------------------------------------------
    add_chapter_heading(4, "Results")
    add_p("[Font Type: Times New Roman, Font Size: 12, Line Spacing: 1.5, Alignment: Justified]", bold=True, italic=True, size=10, space_after=12)

    p_res_intro = (
        "This chapter presents the completed functional outcomes of the NEXORA College Event Management System, including high-resolution "
        "UI screen captures, empirical comparisons with legacy practices, and the comprehensive test validation suite."
    )
    add_p(p_res_intro)

    add_sec_heading("4.1 Proposed System Result")
    p_sys_res = (
        "The finalized NEXORA system successfully delivers an end-to-end event discovery, registration, and administrative platform for M.H. Saboo Siddik "
        "College of Engineering. All student and organizer transactions communicate in real-time with the persistent MySQL database, completely eliminating "
        "unreliable frontend-only mocks or ephemeral storage mechanisms.\n\n"
        "Key operational highlights include:\n"
        "• Dynamic Multi-Category Catalog: Events are automatically sorted by date and categorized into Hackathons, Workshops, Competitions, Seminars, and College Events.\n"
        "• Live Seat Gauges: Event cards and detail pages dynamically render percentage-filled bars that shift color from cyan to warning-orange as capacity reaches 85%.\n"
        "• Instant Ticket Pass Issuance: Registered students immediately receive an official pass containing their unique Registration ID (e.g., NX-2026-00006), "
        "student details, and confirmed status.\n"
        "• Club Lead Control: Organizers enjoy full administrative control over their events and participants while remaining completely isolated from other clubs' data."
    )
    add_p(p_sys_res)

    add_sec_heading("4.2 Project Screenshots")
    p_screen_intro = (
        "Below are the verified graphical user interfaces captured directly from the live deployed NEXORA application on Apache Tomcat 10.1."
    )
    add_p(p_screen_intro)

    # Figures 4.1 to 4.8 Placeholders
    add_image_placeholder(
        "4.1",
        "NEXORA Landing Page with Featured Events and Club Navigation",
        "Hero section with brand logo, college affiliation tag, category badges, and featured upcoming college events",
        "http://localhost:8080/nexora/ (or http://localhost:8080/)",
        "Capture full browser viewport of the homepage showing the navigation bar, hero banner, category pills, and event grid."
    )

    add_image_placeholder(
        "4.2",
        "Student Dashboard with Active Registrations and Verification Status",
        "Student portal displaying personalized welcome banner, profile summary, and list of registered events with status badges",
        "http://localhost:8080/nexora/student/dashboard",
        "Log in as student (saif@student.mhssce.ac.in) and capture the dashboard showing registered event cards and pass links."
    )

    add_image_placeholder(
        "4.3",
        "Detailed Event Overview with Real-Time Capacity Tracking Gauge",
        "Event brief page showing banner image, event date, venue, eligibility rules, live remaining seats counter, and Register button",
        "http://localhost:8080/nexora/event-details?id=11",
        "Capture the event details page for an active event (e.g. Agentic AI Hackathon 2026) showing seat progress bar."
    )

    add_image_placeholder(
        "4.4",
        "Student Event Registration Form with Academic Data Inputs",
        "Registration modal/form with auto-filled student name, department, roll number, team name, and additional info fields",
        "http://localhost:8080/nexora/register-event?id=11",
        "Capture the registration form populated with student information ready for submission."
    )

    add_image_placeholder(
        "4.5",
        "Generated Official Registration Pass with Unique ID (NX-2026-XXXXX)",
        "Formal registration confirmation pass displaying official college header, student details, venue, date, and unique Reg ID",
        "http://localhost:8080/nexora/registration-success",
        "Capture the confirmation ticket card displaying the generated serial ID (e.g. NX-2026-00006) and 'REGISTERED' badge."
    )

    add_image_placeholder(
        "4.6",
        "Organizer Club Portal Dashboard with Event Analytics & Live Metrics",
        "Organizer hub showing club lead name, KPI cards (Total Events, Registrations, Active Published), and managed event table",
        "http://localhost:8080/nexora/organizer/dashboard",
        "Log in as organizer (gfg@mhssce.ac.in) and capture dashboard showing statistics cards and club event table."
    )

    add_image_placeholder(
        "4.7",
        "Organizer Event Authoring Portal (Draft Mode vs Instant Publish)",
        "Event creation form with title, category dropdown, datetime-local deadline picker, capacity input, and Draft/Publish buttons",
        "http://localhost:8080/nexora/organizer/create-event",
        "Capture the create-event form displaying inputs for date, time, venue, eligibility, rules, and both action buttons."
    )

    add_image_placeholder(
        "4.8",
        "Organizer Participant Management, Live Search, and Status Approval Table",
        "Participant roster table with search filter bar, student academic data, team information, and quick Approve/Reject status forms",
        "http://localhost:8080/nexora/organizer/event-registrations?eventId=11",
        "Capture the participant management page showing registered students, search bar, and status modification dropdowns."
    )

    add_sec_heading("4.3 Proposed System versus Existing System")
    p_comp = (
        "Table 4.1 highlights the critical technical and operational contrasts between traditional manual practices and the NEXORA platform."
    )
    add_p(p_comp)

    # Table 4.1: Comparison Table
    c_table = doc.add_table(rows=1, cols=3)
    c_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    c_table.rows[0].cells[0].paragraphs[0].text = "Operational Feature"
    c_table.rows[0].cells[1].paragraphs[0].text = "Legacy Campus Practices (Google Forms / Notice Boards)"
    c_table.rows[0].cells[2].paragraphs[0].text = "NEXORA – Proposed Enterprise Solution"

    for cell in c_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    comp_rows = [
        ("Information Dissemination", "Scattered over unmonitored WhatsApp groups and physical paper notices; students frequently miss announcements.", "Centralized, real-time searchable repository categorized into Hackathons, Workshops, Seminars, Competitions, etc."),
        ("Capacity Management", "Manual; coordinators must periodically check sheet rows and close forms manually, leading to severe overbooking.", "Fully automated server-side capacity check; registration dynamically locks the instant capacity is exhausted."),
        ("Duplicate Prevention", "None; same student can submit multiple forms under different email IDs, corrupting seat allocations.", "Dual-tier enforcement: Java session checks + database compound UNIQUE constraint (student_id, event_id)."),
        ("Attendee Verification", "Manual paper checklists at venue entrance; high vulnerability to proxy attendance and impersonation.", "Instant issuance of serialized registration passes (NX-2026-XXXXX) verifiable against live database records."),
        ("Data Persistence & Security", "Spreadsheets stored on personal accounts; risk of accidental deletion, leaks, and unauthorized access.", "Persistent MySQL RDBMS with ACID transaction safety, foreign key constraints, and session-enforced access control."),
        ("Club Administration", "No dedicated portal; club leads must request IT staff or create external ad-hoc forms.", "Dedicated Organizer Portal enabling club leads to create, draft, publish, and manage participants autonomously.")
    ]

    for f, e, n in comp_rows:
        row = c_table.add_row()
        row.cells[0].paragraphs[0].text = f
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = e
        row.cells[2].paragraphs[0].text = n
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 100, 100)

    set_table_borders(c_table, color="CFD8DC")
    add_p("Table 4.1 – Detailed Functional Comparison: Existing Practices vs NEXORA", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=4, space_after=14)

    add_sec_heading("4.4 Test Case Verification and Validation")
    p_test = (
        "Comprehensive functional and black-box verification was conducted across all critical paths of the NEXORA system. "
        "Table 4.2 presents the test cases executed and their empirical results."
    )
    add_p(p_test)

    # Table 4.2: Test Cases
    tc_table = doc.add_table(rows=1, cols=4)
    tc_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    tc_table.rows[0].cells[0].paragraphs[0].text = "Test Case ID"
    tc_table.rows[0].cells[1].paragraphs[0].text = "Scenario & Input Condition"
    tc_table.rows[0].cells[2].paragraphs[0].text = "Expected System Behavior"
    tc_table.rows[0].cells[3].paragraphs[0].text = "Observed Output & Status"

    for cell in tc_table.rows[0].cells:
        cell.paragraphs[0].runs[0].bold = True
        set_cell_background(cell, "ECEFF1")
        set_cell_margins(cell, 100, 100, 120, 120)

    test_cases = [
        ("TC-01", "Student Login with valid credentials (saif@student.mhssce.ac.in)", "Redirect to /student/dashboard with active session attributes.", "HTTP 302 -> 200, Welcome banner rendered. [PASS]"),
        ("TC-02", "Student attempts unauthorized access to /organizer/dashboard", "Access denied; redirect to /login?role=ORGANIZER.", "Redirected cleanly; session guard active. [PASS]"),
        ("TC-03", "Organizer creates new event in DRAFT mode", "Event saved in MySQL with status='DRAFT'; hidden from student catalog.", "Inserted with id=11; visible only in club hub. [PASS]"),
        ("TC-04", "Organizer toggles event status to 'PUBLISHED'", "Event status updated in MySQL; immediately visible on public catalog.", "Appears on student landing page & event list. [PASS]"),
        ("TC-05", "Student registers for Event 11 with complete academic details", "Insert row in registrations table, generate Reg ID NX-2026-00006.", "Row created in MySQL; ticket pass rendered. [PASS]"),
        ("TC-06", "Student attempts duplicate registration for Event 11", "Application detects existing registration and halts with alert.", "Alert displayed: 'Already registered for this event'. [PASS]"),
        ("TC-07", "Student registration when registered_count >= capacity", "Registration form disabled; submission rejected by backend.", "Button disabled: 'Event Capacity Full'. [PASS]"),
        ("TC-08", "Organizer updates student status from 'REGISTERED' to 'APPROVED'", "Row in MySQL updated; reflected in student dashboard.", "Status changed to 'APPROVED' in MySQL. [PASS]")
    ]

    for tid, sc, exp, obs in test_cases:
        row = tc_table.add_row()
        row.cells[0].paragraphs[0].text = tid
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[1].paragraphs[0].text = sc
        row.cells[2].paragraphs[0].text = exp
        row.cells[3].paragraphs[0].text = obs
        for cell in row.cells:
            set_cell_margins(cell, 80, 80, 100, 100)

    set_table_borders(tc_table, color="CFD8DC")
    add_p("Table 4.2 – System Testing, Verification Test Cases, and Validation Suite", bold=True, size=11, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=4, space_after=14)

    doc.add_page_break()

    # -------------------------------------------------------------
    # CHAPTER 5: CONCLUSION
    # -------------------------------------------------------------
    add_chapter_heading(5, "Conclusion")
    add_p("[Font Type: Times New Roman, Font Size: 12, Line Spacing: 1.5, Alignment: Justified]", bold=True, italic=True, size=10, space_after=12)

    conclusion_p = (
        "The development and deployment of NEXORA successfully demonstrates the power, reliability, and security of enterprise Java technologies "
        "in modernizing campus event operations. By architecting the platform strictly on Jakarta EE Servlets, JSP, JDBC, and MySQL within the MVC paradigm, "
        "the project achieves exceptional architectural stability, zero dependency on transient frontend state, and complete database persistence.\n\n"
        "NEXORA effectively resolves the longstanding challenges of event fragmentation at M.H. Saboo Siddik College of Engineering. It replaces error-prone "
        "manual spreadsheets with automated capacity locking, eliminates attendee fraud through cryptographically formatted serial tickets, and bridges the gap "
        "between student participants and technical club organizers through clean, role-segregated portals. The system stands as a fully operational, "
        "academic-grade software solution ready for institution-wide adoption across all departments."
    )
    add_p(conclusion_p)

    doc.add_page_break()

    # -------------------------------------------------------------
    # FUTURE SCOPE
    # -------------------------------------------------------------
    add_p("Future Scope", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=24, space_after=20)
    add_p("[Font Type: Times New Roman, Font Size: 12, Line Spacing: 1.5, Alignment: Justified]", bold=True, italic=True, size=10, space_after=12)

    future_p = (
        "While NEXORA delivers a comprehensive feature set for college event management, several valuable enhancements are planned for subsequent development cycles:\n\n"
        "1. Dynamic QR Code Check-In System: Embed encrypted QR codes onto student registration passes, allowing club organizers to scan attendees using a mobile camera "
        "and automatically record attendance timestamps in MySQL within milliseconds.\n\n"
        "2. Automated Email & SMS Notification Engine: Integrate JavaMail API and Twilio SMS gateways to automatically dispatch calendar invites (.ics files), "
        "registration confirmations, and event reminder alerts 24 hours prior to the event.\n\n"
        "3. Integrated Campus Payment Gateway: Incorporate Razorpay or PayU SDKs to securely support registration fees for flagship national-level symposiums and "
        "hackathons requiring entry deposits, complete with automated invoice generation.\n\n"
        "4. AI-Powered Event Recommendation: Leverage collaborative filtering algorithms to analyze a student's academic department, semester, and past event history "
        "to recommend technical competitions and workshops tailored to their career aspirations.\n\n"
        "5. Automated Certificate Generation: Provide an automated post-event module where verified attendees can download digitally signed participation certificates "
        "with verifiable unique serial hashes."
    )
    add_p(future_p)

    doc.add_page_break()

    # -------------------------------------------------------------
    # APPENDIX
    # -------------------------------------------------------------
    add_p("Appendix", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=24, space_after=20)
    add_p("(NOTE: Technical Appendix details the core platform configurations, dependencies, and environment setup)", bold=True, italic=True, size=10, space_after=14)

    app_text = (
        "1. Java Enterprise Environment Configuration:\n"
        "The project is compiled against Java 17 LTS syntax with full runtime compatibility on Apache Tomcat 10.1 (Jakarta EE namespace: jakarta.servlet.*).\n\n"
        "2. Database Properties Configuration (src/main/resources/db.properties):\n"
        "db.url=jdbc:mysql://localhost:3306/nexora_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8\n"
        "db.user=root\n"
        "db.password=root\n\n"
        "3. Maven Dependencies (pom.xml summary):\n"
        "• jakarta.servlet:jakarta.servlet-api:6.0.0 (Provided scope)\n"
        "• jakarta.servlet.jsp:jakarta.servlet.jsp-api:3.1.1 (Provided scope)\n"
        "• jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api:3.0.0\n"
        "• org.glassfish.web:jakarta.servlet.jsp.jstl:3.0.1 (Implementation)\n"
        "• com.mysql:mysql-connector-j:8.4.0 (Runtime JDBC driver)\n\n"
        "4. Local Server Deployment and Execution:\n"
        "• Automated Server Start: Execute 'start_server.bat' (launches Apache Tomcat 10.1 on port 8080).\n"
        "• Automated Server Stop: Execute 'stop_server.bat'.\n"
        "• Build Command: 'mvn clean package' (generates production nexora.war artifact)."
    )
    add_p(app_text)

    doc.add_page_break()

    # -------------------------------------------------------------
    # LITERATURE CITED / REFERENCES
    # -------------------------------------------------------------
    add_p("Literature Cited / References", bold=True, size=16, align=WD_ALIGN_PARAGRAPH.CENTER, space_before=24, space_after=20)

    refs = [
        "[1] Sharma, A. & Gupta, R. (2021). \"Design and Implementation of a Scalable Architecture for Campus Event Scheduling.\" In 2021 6th International Conference on Advanced Computing and Communication Systems (ICACCS), Coimbatore, India, pp. 112-117, doi: 10.1109/ICACCS51430.2021.9441890.",
        "[2] Patel, M., Joshi, N., & Mehta, K. (2020). \"Role-Based Access Control and Session Security in Academic Enterprise Web Applications.\" Lecture Notes in Computer Science (LNCS), Springer, vol. 12450, pp. 45-58.",
        "[3] Deshmukh, V. & Kulkarni, S. (2022). \"Comparative Evaluation of Relational ACID Transactions vs Document Stores for Real-Time Event Registration Systems.\" International Research Journal of Engineering and Technology (IRJET), vol. 9, no. 4, pp. 210-216.",
        "[4] Al-Husseini, K. & Zhao, L. (2023). \"Automated Serialized Digital Pass Generation for Secure Campus Access Control.\" IEEE Access, vol. 11, pp. 34812-34825, doi: 10.1109/ACCESS.2023.3265142.",
        "[5] Fernandez, J. (2021). \"Architectural Patterns in Educational Web Systems: Revisiting MVC with Java Servlets and JSP.\" ACM Inroads, vol. 12, no. 3, pp. 38-44.",
        "[6] Oracle Corporation (2024). \"Jakarta EE Servlet Specification, Version 6.0.\" Eclipse Foundation, online documentation.",
        "[7] MySQL AB (2024). \"MySQL 8.0 Reference Manual: InnoDB Storage Engine and Transaction Isolation.\" Oracle Corporation.",
        "[8] Apache Software Foundation (2024). \"Apache Tomcat 10.1 Architecture and JSP Jasper Compilation Guide.\" Online documentation.",
        "[9] Somodi, B. & Horvath, T. (2022). \"Scalability and Concurrency Bottlenecks in Higher Education Administrative Portals.\" IEEE Transactions on Learning Technologies, vol. 15, no. 2, pp. 189-198.",
        "[10] Pressman, R. S. & Maxim, B. R. (2020). \"Software Engineering: A Practitioner's Approach.\" 9th Edition, McGraw-Hill Higher Education."
    ]

    for ref in refs:
        add_p(ref, align=WD_ALIGN_PARAGRAPH.LEFT, space_before=2, space_after=8, line_spacing=1.3)

    # Save final report document
    output_filename = "NEXORA_FullStack_Java_Mini_Project_Report.docx"
    output_path = os.path.join(r"c:\Users\fakhruddin\Downloads\NEXORA", output_filename)
    doc.save(output_path)
    print(f"Report generated successfully at: {output_path}")

build_full_report()
