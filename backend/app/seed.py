from sqlalchemy.orm import Session

from app.core.security import hash_password
from app.models import Module, Role, User

ROLE_DATA = [
    ("super_admin", "Super Admin", "Full control", [("Dashboard", 1, ["Global Analytics", "AI Insights"]), ("User Management", 1, ["Users", "Roles", "Permissions"]), ("Branch Management", 1, ["Branches", "Franchise Branches"]), ("CRM", 1, ["Leads", "Admissions", "Counsellors"]), ("Student Management", 1, ["Students", "Attendance", "Certificates"]), ("LMS", 1, ["Courses", "Lessons", "Assignments"]), ("Finance", 1, ["Fees", "GST Billing", "Expenses"]), ("HR", 1, ["Employees", "Payroll"]), ("AI Platform", 2, ["AI Chatbot", "AI Analytics"]), ("Franchise", 3, ["Revenue Sharing", "Branch Analytics"]), ("Reports", 1, ["Student Reports", "Revenue Reports"]), ("Security", 1, ["MFA", "API Security"]), ("Settings", 1, ["Platform Settings"])]),
    ("branch_admin", "Branch Admin", "Branch management", [("Dashboard", 1, ["Branch Analytics", "Daily Summary"]), ("Student Management", 1, ["Students", "Attendance", "Enroll New Student", "Batch Transfer"]), ("Trainers", 1, ["Trainer Allocation", "Trainer Attendance"]), ("Timetable", 1, ["Batch Scheduling", "Holiday Management"]), ("Finance", 1, ["Branch Fees", "Expense Tracker"]), ("Reports", 1, ["Branch Reports", "Export Data"])]),
    ("counsellor", "Counsellor", "Leads and admissions", [("Dashboard", 1, ["Lead Overview", "My Conversion Rate"]), ("CRM", 1, ["Leads", "Follow-Ups"]), ("Admissions", 1, ["Admission Funnel", "New Admission Form"]), ("Demo Booking", 1, ["Demo Scheduling"]), ("Communication", 2, ["WhatsApp CRM"])]),
    ("trainer", "Trainer", "Classes and evaluation", [("Dashboard", 1, ["Class Summary"]), ("My Classes", 1, ["Active Classes", "Lesson Plan"]), ("Attendance", 1, ["Mark Attendance", "Attendance History"]), ("Assignments", 1, ["Upload Assignments", "View Submissions"]), ("Student Evaluation", 1, ["Marks & Feedback", "Certificate Recommendation"]), ("Timetable", 1, ["Daily Schedule", "Leave Application"]), ("Live Classes", 2, ["Online Sessions", "Recordings"])]),
    ("student", "Student", "Learning app", [("Dashboard", 1, ["Learning Summary", "Weekly Progress Streak"]), ("My Courses", 1, ["Lessons", "Videos", "Live Classes"]), ("Assignments", 1, ["Submit Homework", "Marks & Feedback"]), ("Attendance", 1, ["Attendance History", "Leave Request"]), ("Coding Playground", 3, ["Python IDE", "My Projects"]), ("AI Chatbot", 2, ["AI Tutor", "Practice Quiz"]), ("Certificates", 1, ["Download Certificates", "Skill Badges"]), ("Notifications", 2, ["Alerts & Updates", "Notification Settings"]), ("Profile", 1, ["Personal Details", "Student ID Card"])]),
    ("parent", "Parent", "Child monitoring", [("Dashboard", 2, ["Child Summary", "AI Weekly Report"]), ("Attendance", 2, ["Attendance Reports", "Absence Alerts"]), ("Fees", 2, ["Payments", "Invoices", "EMI Schedule"]), ("Progress Reports", 2, ["Academic Reports", "Skill Progress Chart"]), ("Homework", 2, ["Assignment Tracking", "Deadline Calendar"]), ("Notifications", 2, ["Alerts", "Notification History"]), ("Communication", 2, ["Trainer Chat", "Raise Complaint"])]),
    ("hr", "HR", "Employees and payroll", [("Dashboard", 1, ["Employee Analytics", "New Joiners This Month"]), ("Employees", 1, ["Employee Profiles", "Document Tracker"]), ("Payroll", 1, ["Salary Management", "Salary Slip Download"]), ("Leave Management", 1, ["Leave Requests", "Holiday Calendar"]), ("Productivity", 3, ["Trainer Rankings", "Performance Reviews"])]),
    ("finance_team", "Finance Team", "Payments and accounts", [("Dashboard", 1, ["Revenue Overview", "AI Revenue Forecast"]), ("Fees", 1, ["Student Fee Collection", "Fee Defaulters"]), ("Invoices", 1, ["GST Invoices", "Bulk Invoice Download"]), ("Expenses", 1, ["Expense Tracking", "Budget vs Actual"]), ("Salary Processing", 1, ["Payroll", "Bank Transfer Log"]), ("Reports", 1, ["Financial Reports", "GST Filing Export"])]),
    ("franchise_owner", "Franchise Owner", "Branch reports", [("Dashboard", 3, ["Franchise Analytics", "Revenue Share This Month"]), ("Branch Reports", 3, ["Performance Reports", "Branch Comparison"]), ("Revenue Sharing", 3, ["Financial Reports", "Payout History"]), ("Trainers", 3, ["Trainer Certifications", "Certification Renewals"]), ("Leaderboard", 3, ["Branch Rankings", "Monthly Top Branch Badge"])]),
    ("placement_partner", "Placement Partner", "Hiring and internships", [("Dashboard", 3, ["Placement Overview", "AI Placement Prediction"]), ("Internship Management", 3, ["Internship Tracking"]), ("Resume Builder", 3, ["Resume Reviews"]), ("Hiring Portal", 3, ["Candidate Hiring", "Interview Scheduler"]), ("Reports", 3, ["Placement Reports", "Skill Gap Analysis"])]),
]


def seed_database(db: Session) -> None:
    for role_id, name, description, modules in ROLE_DATA:
        role = db.get(Role, role_id)
        if role is None:
            role = Role(id=role_id, name=name, description=description)
            db.add(role)
            db.flush()
        if not role.modules:
            for title, phase, features in modules:
                db.add(Module(role_id=role_id, title=title, phase=phase, features="|".join(features)))

    if db.query(User).filter(User.email == "admin@pinesphere.in").first() is None:
        db.add(
            User(
                email="admin@pinesphere.in",
                full_name="Pinesphere Admin",
                hashed_password=hash_password("postgres"),
                role_id="super_admin",
            )
        )
    db.commit()
