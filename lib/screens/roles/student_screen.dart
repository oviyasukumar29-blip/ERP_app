import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../login_screen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: _pageForIndex(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: NavigationBar(
            height: 72,
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.white.withValues(alpha: 0.94),
            indicatorColor: AppTheme.green.withValues(alpha: 0.12),
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.play_lesson_outlined),
                selectedIcon: Icon(Icons.play_lesson_rounded),
                label: 'Courses',
              ),
              NavigationDestination(
                icon: Icon(Icons.task_alt_outlined),
                selectedIcon: Icon(Icons.task_alt_rounded),
                label: 'Tasks',
              ),
              NavigationDestination(
                icon: Icon(Icons.psychology_outlined),
                selectedIcon: Icon(Icons.psychology_rounded),
                label: 'AI Tutor',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageForIndex() {
    switch (_selectedIndex) {
      case 1:
        return const _CoursesPage(key: ValueKey('courses'));
      case 2:
        return const _TasksPage(key: ValueKey('tasks'));
      case 3:
        return const _AiTutorPage(key: ValueKey('ai'));
      case 4:
        return _ProfilePage(key: const ValueKey('profile'), onLogout: _logout);
      case 0:
      default:
        return _DashboardPage(key: const ValueKey('home'), onLogout: _logout);
    }
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: _StudentHeader(onLogout: onLogout),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _StreakCard(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SectionTitle(title: 'Learning overview'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.06,
            children: const [
              _StatCard(
                icon: Icons.menu_book_rounded,
                title: 'Courses Enrolled',
                value: '4',
                subtitle: '3 in progress',
                color: AppTheme.blue,
                progress: 0.72,
              ),
              _StatCard(
                icon: Icons.schedule_rounded,
                title: 'Study Hours',
                value: '12.5h',
                subtitle: 'Goal: 16h',
                color: AppTheme.green,
                progress: 0.78,
              ),
              _StatCard(
                icon: Icons.assignment_turned_in_rounded,
                title: 'Assignments',
                value: '8 / 11',
                subtitle: '3 pending',
                color: AppTheme.purple,
                progress: 0.73,
              ),
              _StatCard(
                icon: Icons.fact_check_rounded,
                title: 'Attendance',
                value: '92%',
                subtitle: 'This month',
                color: AppTheme.teal,
                progress: 0.92,
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 22)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SectionTitle(
              title: 'Pending assignments',
              action: 'View all',
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                _AssignmentCard(
                  icon: Icons.functions_rounded,
                  title: 'Algebra - Chapter 5',
                  subject: 'Mathematics',
                  due: 'Due Today',
                  color: Colors.red,
                ),
                _AssignmentCard(
                  icon: Icons.science_rounded,
                  title: 'Newton\'s Laws Worksheet',
                  subject: 'Physics',
                  due: 'Due in 2 Days',
                  color: AppTheme.orange,
                ),
                _AssignmentCard(
                  icon: Icons.history_edu_rounded,
                  title: 'Essay Writing',
                  subject: 'History',
                  due: 'Due in 5 Days',
                  color: AppTheme.green,
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SectionTitle(title: 'Live classes', action: 'Calendar'),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                _LiveClassCard(
                  title: 'Chemistry - Periodic Table',
                  teacher: 'Dr. Meera Nair',
                  time: 'Live now',
                  joined: '32 students joined',
                  live: true,
                ),
                _LiveClassCard(
                  title: 'English - Essay Writing',
                  teacher: 'Anita Sharma',
                  time: 'Starts at 11:30 AM',
                  joined: 'Room opens soon',
                ),
                _LiveClassCard(
                  title: 'Mathematics - Calculus',
                  teacher: 'Rahul Menon',
                  time: 'Starts at 2:00 PM',
                  joined: '18 enrolled',
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SectionTitle(title: 'Quick actions'),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: _QuickActionsGrid(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SectionTitle(title: 'Notifications'),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 110),
            child: Column(
              children: [
                _NotificationTile(
                  icon: Icons.warning_amber_rounded,
                  title: 'Assignment due today',
                  body: 'Algebra Chapter 5 closes at 8:00 PM.',
                  time: '10 min ago',
                  unread: true,
                ),
                _NotificationTile(
                  icon: Icons.grade_rounded,
                  title: 'Physics marks published',
                  body: 'You scored 18/20 in the motion quiz.',
                  time: '1h ago',
                ),
                _NotificationTile(
                  icon: Icons.video_camera_front_rounded,
                  title: 'Live class reminder',
                  body: 'Chemistry class is live now.',
                  time: 'Now',
                  unread: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentHeader extends StatelessWidget {
  const _StudentHeader({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Morning',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Arjun Kumar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        _IconBubble(
          icon: Icons.notifications_none_rounded,
          badge: true,
          onTap: () {},
        ),
        const SizedBox(width: 10),
        _IconBubble(icon: Icons.logout_rounded, onTap: onLogout),
        const SizedBox(width: 10),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppTheme.green, AppTheme.blue],
            ),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'AK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.onTap,
    this.badge = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, color: AppTheme.ink),
          ),
          if (badge)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFEFF8E9)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppTheme.orange.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppTheme.orange,
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5 Day Streak',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Keep learning to unlock weekly rewards',
                      style: TextStyle(
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var index = 0; index < days.length; index++)
                Expanded(
                  child: _DayPill(
                    label: days[index],
                    completed: index < 4,
                    current: index == 4,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.label,
    required this.completed,
    required this.current,
  });

  final String label;
  final bool completed;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final color = current
        ? AppTheme.blue
        : completed
        ? AppTheme.green
        : const Color(0xFFE5EAF1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: current || completed ? 1 : 0.85),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                completed || current
                    ? Icons.check_rounded
                    : Icons.circle_outlined,
                size: 18,
                color: completed || current ? Colors.white : AppTheme.muted,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        if (action != null)
          Text(
            action!,
            style: const TextStyle(
              color: AppTheme.green,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.progress,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              color: color,
              backgroundColor: color.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({
    required this.icon,
    required this.title,
    required this.subject,
    required this.due,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subject;
  final String due;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          _ColoredIcon(icon: icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  subject,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _Badge(label: due, color: color),
        ],
      ),
    );
  }
}

class _LiveClassCard extends StatelessWidget {
  const _LiveClassCard({
    required this.title,
    required this.teacher,
    required this.time,
    required this.joined,
    this.live = false,
  });

  final String title;
  final String teacher;
  final String time;
  final String joined;
  final bool live;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          _ColoredIcon(
            icon: live
                ? Icons.radio_button_checked_rounded
                : Icons.video_camera_front_rounded,
            color: live ? Colors.red : AppTheme.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  teacher,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$time • $joined',
                  style: TextStyle(
                    color: live ? Colors.red : AppTheme.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (live)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: const Size(70, 42)),
              child: const Text('Join'),
            ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.85,
      children: const [
        _ActionTile(
          icon: Icons.upload_file_rounded,
          label: 'Submit Homework',
          color: AppTheme.blue,
        ),
        _ActionTile(
          icon: Icons.psychology_rounded,
          label: 'Ask AI Tutor',
          color: AppTheme.purple,
        ),
        _ActionTile(
          icon: Icons.quiz_rounded,
          label: 'Practice Quiz',
          color: AppTheme.orange,
        ),
        _ActionTile(
          icon: Icons.workspace_premium_rounded,
          label: 'My Certificates',
          color: AppTheme.green,
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.13)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    this.unread = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          _ColoredIcon(
            icon: icon,
            color: unread ? AppTheme.green : AppTheme.muted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (unread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                time,
                style: const TextStyle(color: AppTheme.muted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoursesPage extends StatelessWidget {
  const _CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleModulePage(
      title: 'My Courses',
      subtitle: 'Lessons, videos and live classes',
      icon: Icons.play_lesson_rounded,
      children: const [
        _CourseCard(
          title: 'Robotics Foundation',
          progress: 0.72,
          meta: '12 lessons • Continue learning',
        ),
        _CourseCard(
          title: 'Python for AI',
          progress: 0.48,
          meta: '8 lessons • Video available',
        ),
        _CourseCard(
          title: 'Mathematics Booster',
          progress: 0.86,
          meta: 'Live class today',
        ),
      ],
    );
  }
}

class _TasksPage extends StatelessWidget {
  const _TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimpleModulePage(
      title: 'Assignments',
      subtitle: 'Submit homework, marks and feedback',
      icon: Icons.task_alt_rounded,
      children: [
        _UploadPanel(),
        _AssignmentCard(
          icon: Icons.functions_rounded,
          title: 'Algebra - Chapter 5',
          subject: 'Mathematics',
          due: 'Pending',
          color: Colors.red,
        ),
        _AssignmentCard(
          icon: Icons.science_rounded,
          title: 'Physics Lab Notes',
          subject: 'Physics',
          due: 'Feedback',
          color: AppTheme.green,
        ),
      ],
    );
  }
}

class _AiTutorPage extends StatelessWidget {
  const _AiTutorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimpleModulePage(
      title: 'AI Tutor',
      subtitle: 'Ask doubts and practice quizzes',
      icon: Icons.psychology_rounded,
      children: [
        _ChatBubble(
          text: 'Hi Arjun, what do you want to practice today?',
          ai: true,
        ),
        _ChatBubble(text: 'Create a quiz on Newton laws.', ai: false),
        _QuizSuggestion(
          title: 'Physics practice quiz',
          questions: '10 adaptive questions',
        ),
        _QuizSuggestion(
          title: 'Python coding challenge',
          questions: '5 beginner tasks',
        ),
      ],
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return _SimpleModulePage(
      title: 'Profile',
      subtitle: 'Personal details and student ID card',
      icon: Icons.person_rounded,
      children: [
        const _StudentIdCard(),
        const _ProfileRow(
          icon: Icons.badge_rounded,
          title: 'Student ID',
          value: 'PS-STU-1024',
        ),
        const _ProfileRow(
          icon: Icons.school_rounded,
          title: 'Course',
          value: 'AI + Robotics Track',
        ),
        const _ProfileRow(
          icon: Icons.qr_code_rounded,
          title: 'Digital ID',
          value: 'QR ready for attendance',
        ),
        ElevatedButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
        ),
        const SizedBox(height: 90),
      ],
    );
  }
}

class _SimpleModulePage extends StatelessWidget {
  const _SimpleModulePage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 110),
      children: [
        Row(
          children: [
            _ColoredIcon(icon: icon, color: AppTheme.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...children,
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.title,
    required this.progress,
    required this.meta,
  });

  final String title;
  final double progress;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _ColoredIcon(
                icon: Icons.school_rounded,
                color: AppTheme.blue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: AppTheme.green,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: AppTheme.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meta,
            style: const TextStyle(
              color: AppTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadPanel extends StatelessWidget {
  const _UploadPanel();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          const _ColoredIcon(
            icon: Icons.cloud_upload_rounded,
            color: AppTheme.purple,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Upload homework file or photo',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Upload')),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.text, required this.ai});

  final String text;
  final bool ai;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: ai ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: ai ? Colors.white : AppTheme.green,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: ai ? AppTheme.ink : Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _QuizSuggestion extends StatelessWidget {
  const _QuizSuggestion({required this.title, required this.questions});

  final String title;
  final String questions;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          const _ColoredIcon(icon: Icons.quiz_rounded, color: AppTheme.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(questions, style: const TextStyle(color: AppTheme.muted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _StudentIdCard extends StatelessWidget {
  const _StudentIdCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.green, AppTheme.blue]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Text(
              'AK',
              style: TextStyle(
                color: AppTheme.green,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arjun Kumar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'AI + Robotics Student',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 42),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          _ColoredIcon(icon: icon, color: AppTheme.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ColoredIcon extends StatelessWidget {
  const _ColoredIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}
