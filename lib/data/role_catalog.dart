import '../models/erp_models.dart';

const roleCatalog = <ErpRole>[
  ErpRole(
    id: 'super_admin',
    name: 'Super Admin',
    description:
        'Full platform control across branches, teams, finance, LMS, AI, and security.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 1,
        summary: 'Global analytics and AI insight center.',
        features: ['Global Analytics', 'AI Insights'],
      ),
      ErpModule(
        title: 'User Management',
        phase: 1,
        features: ['Users', 'Roles', 'Permissions'],
      ),
      ErpModule(
        title: 'Branch Management',
        phase: 1,
        features: ['Branches', 'Franchise Branches'],
      ),
      ErpModule(
        title: 'CRM',
        phase: 1,
        features: ['Leads', 'Admissions', 'Counsellors'],
      ),
      ErpModule(
        title: 'Student Management',
        phase: 1,
        features: ['Students', 'Attendance', 'Certificates'],
      ),
      ErpModule(
        title: 'LMS',
        phase: 1,
        features: ['Courses', 'Lessons', 'Assignments'],
      ),
      ErpModule(
        title: 'Finance',
        phase: 1,
        features: ['Fees', 'GST Billing', 'Expenses'],
      ),
      ErpModule(title: 'HR', phase: 1, features: ['Employees', 'Payroll']),
      ErpModule(
        title: 'AI Platform',
        phase: 2,
        features: ['AI Chatbot', 'AI Analytics'],
      ),
      ErpModule(
        title: 'Franchise',
        phase: 3,
        features: ['Revenue Sharing', 'Branch Analytics'],
      ),
      ErpModule(
        title: 'Reports',
        phase: 1,
        features: ['Student Reports', 'Revenue Reports'],
      ),
      ErpModule(title: 'Security', phase: 1, features: ['MFA', 'API Security']),
      ErpModule(title: 'Settings', phase: 1, features: ['Platform Settings']),
    ],
  ),
  ErpRole(
    id: 'branch_admin',
    name: 'Branch Admin',
    description:
        'Operate one branch: students, trainers, timetable, fees, and reports.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 1,
        features: ['Branch Analytics', 'Daily Summary'],
      ),
      ErpModule(
        title: 'Student Management',
        phase: 1,
        features: [
          'Students',
          'Attendance',
          'Enroll New Student',
          'Batch Transfer',
        ],
      ),
      ErpModule(
        title: 'Trainers',
        phase: 1,
        features: ['Trainer Allocation', 'Trainer Attendance'],
      ),
      ErpModule(
        title: 'Timetable',
        phase: 1,
        features: ['Batch Scheduling', 'Holiday Management'],
      ),
      ErpModule(
        title: 'Finance',
        phase: 1,
        features: ['Branch Fees', 'Expense Tracker'],
      ),
      ErpModule(
        title: 'Reports',
        phase: 1,
        features: ['Branch Reports', 'Export Data'],
      ),
    ],
  ),
  ErpRole(
    id: 'counsellor',
    name: 'Counsellor',
    description:
        'Convert leads into admissions with follow-ups, demo booking, and communication.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 1,
        features: ['Lead Overview', 'My Conversion Rate'],
      ),
      ErpModule(title: 'CRM', phase: 1, features: ['Leads', 'Follow-Ups']),
      ErpModule(
        title: 'Admissions',
        phase: 1,
        features: ['Admission Funnel', 'New Admission Form'],
      ),
      ErpModule(title: 'Demo Booking', phase: 1, features: ['Demo Scheduling']),
      ErpModule(title: 'Communication', phase: 2, features: ['WhatsApp CRM']),
    ],
  ),
  ErpRole(
    id: 'trainer',
    name: 'Trainer',
    description:
        'Manage classes, attendance, assignments, evaluations, timetable, and live sessions.',
    modules: [
      ErpModule(title: 'Dashboard', phase: 1, features: ['Class Summary']),
      ErpModule(
        title: 'My Classes',
        phase: 1,
        features: ['Active Classes', 'Lesson Plan'],
      ),
      ErpModule(
        title: 'Attendance',
        phase: 1,
        features: ['Mark Attendance', 'Attendance History'],
      ),
      ErpModule(
        title: 'Assignments',
        phase: 1,
        features: ['Upload Assignments', 'View Submissions'],
      ),
      ErpModule(
        title: 'Student Evaluation',
        phase: 1,
        features: ['Marks & Feedback', 'Certificate Recommendation'],
      ),
      ErpModule(
        title: 'Timetable',
        phase: 1,
        features: ['Daily Schedule', 'Leave Application'],
      ),
      ErpModule(
        title: 'Live Classes',
        phase: 2,
        features: ['Online Sessions', 'Recordings'],
      ),
    ],
  ),
  ErpRole(
    id: 'student',
    name: 'Student',
    description:
        'Learning app for courses, assignments, attendance, certificates, AI tutor, and profile.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 1,
        features: ['Learning Summary', 'Weekly Progress Streak'],
      ),
      ErpModule(
        title: 'My Courses',
        phase: 1,
        features: ['Lessons', 'Videos', 'Live Classes'],
      ),
      ErpModule(
        title: 'Assignments',
        phase: 1,
        features: ['Submit Homework', 'Marks & Feedback'],
      ),
      ErpModule(
        title: 'Attendance',
        phase: 1,
        features: ['Attendance History', 'Leave Request'],
      ),
      ErpModule(
        title: 'Coding Playground',
        phase: 3,
        features: ['Python IDE', 'My Projects'],
      ),
      ErpModule(
        title: 'AI Chatbot',
        phase: 2,
        features: ['AI Tutor', 'Practice Quiz'],
      ),
      ErpModule(
        title: 'Certificates',
        phase: 1,
        features: ['Download Certificates', 'Skill Badges'],
      ),
      ErpModule(
        title: 'Notifications',
        phase: 2,
        features: ['Alerts & Updates', 'Notification Settings'],
      ),
      ErpModule(
        title: 'Profile',
        phase: 1,
        features: ['Personal Details', 'Student ID Card'],
      ),
    ],
  ),
  ErpRole(
    id: 'parent',
    name: 'Parent',
    description:
        'Monitor child attendance, fees, progress, homework, and trainer communication.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 2,
        features: ['Child Summary', 'AI Weekly Report'],
      ),
      ErpModule(
        title: 'Attendance',
        phase: 2,
        features: ['Attendance Reports', 'Absence Alerts'],
      ),
      ErpModule(
        title: 'Fees',
        phase: 2,
        features: ['Payments', 'Invoices', 'EMI Schedule'],
      ),
      ErpModule(
        title: 'Progress Reports',
        phase: 2,
        features: ['Academic Reports', 'Skill Progress Chart'],
      ),
      ErpModule(
        title: 'Homework',
        phase: 2,
        features: ['Assignment Tracking', 'Deadline Calendar'],
      ),
      ErpModule(
        title: 'Notifications',
        phase: 2,
        features: ['Alerts', 'Notification History'],
      ),
      ErpModule(
        title: 'Communication',
        phase: 2,
        features: ['Trainer Chat', 'Raise Complaint'],
      ),
    ],
  ),
  ErpRole(
    id: 'hr',
    name: 'HR',
    description:
        'Employee profiles, payroll, leaves, documents, productivity, and performance reviews.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 1,
        features: ['Employee Analytics', 'New Joiners This Month'],
      ),
      ErpModule(
        title: 'Employees',
        phase: 1,
        features: ['Employee Profiles', 'Document Tracker'],
      ),
      ErpModule(
        title: 'Payroll',
        phase: 1,
        features: ['Salary Management', 'Salary Slip Download'],
      ),
      ErpModule(
        title: 'Leave Management',
        phase: 1,
        features: ['Leave Requests', 'Holiday Calendar'],
      ),
      ErpModule(
        title: 'Productivity',
        phase: 3,
        features: ['Trainer Rankings', 'Performance Reviews'],
      ),
    ],
  ),
  ErpRole(
    id: 'finance_team',
    name: 'Finance Team',
    description:
        'Fees, invoices, expenses, salary processing, GST exports, and revenue overview.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 1,
        features: ['Revenue Overview', 'AI Revenue Forecast'],
      ),
      ErpModule(
        title: 'Fees',
        phase: 1,
        features: ['Student Fee Collection', 'Fee Defaulters'],
      ),
      ErpModule(
        title: 'Invoices',
        phase: 1,
        features: ['GST Invoices', 'Bulk Invoice Download'],
      ),
      ErpModule(
        title: 'Expenses',
        phase: 1,
        features: ['Expense Tracking', 'Budget vs Actual'],
      ),
      ErpModule(
        title: 'Salary Processing',
        phase: 1,
        features: ['Payroll', 'Bank Transfer Log'],
      ),
      ErpModule(
        title: 'Reports',
        phase: 1,
        features: ['Financial Reports', 'GST Filing Export'],
      ),
    ],
  ),
  ErpRole(
    id: 'franchise_owner',
    name: 'Franchise Owner',
    description:
        'Branch reports, revenue sharing, trainer certification, and franchise leaderboard.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 3,
        features: ['Franchise Analytics', 'Revenue Share This Month'],
      ),
      ErpModule(
        title: 'Branch Reports',
        phase: 3,
        features: ['Performance Reports', 'Branch Comparison'],
      ),
      ErpModule(
        title: 'Revenue Sharing',
        phase: 3,
        features: ['Financial Reports', 'Payout History'],
      ),
      ErpModule(
        title: 'Trainers',
        phase: 3,
        features: ['Trainer Certifications', 'Certification Renewals'],
      ),
      ErpModule(
        title: 'Leaderboard',
        phase: 3,
        features: ['Branch Rankings', 'Monthly Top Branch Badge'],
      ),
    ],
  ),
  ErpRole(
    id: 'placement_partner',
    name: 'Placement Partner',
    description:
        'Internship tracking, resume reviews, hiring portal, interviews, and placement reports.',
    modules: [
      ErpModule(
        title: 'Dashboard',
        phase: 3,
        features: ['Placement Overview', 'AI Placement Prediction'],
      ),
      ErpModule(
        title: 'Internship Management',
        phase: 3,
        features: ['Internship Tracking'],
      ),
      ErpModule(
        title: 'Resume Builder',
        phase: 3,
        features: ['Resume Reviews'],
      ),
      ErpModule(
        title: 'Hiring Portal',
        phase: 3,
        features: ['Candidate Hiring', 'Interview Scheduler'],
      ),
      ErpModule(
        title: 'Reports',
        phase: 3,
        features: ['Placement Reports', 'Skill Gap Analysis'],
      ),
    ],
  ),
];

ErpRole roleById(String id) => roleCatalog.firstWhere(
  (role) => role.id == id,
  orElse: () => roleCatalog.first,
);
