// features/student/presentation/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const _green       = Color(0xFF58CC02);
const _greenDark   = Color(0xFF45A700);
const _orange      = Color(0xFFFF9600);
const _blue        = Color(0xFF1CB0F6);
const _blueDark    = Color(0xFF0081C8);
const _blueDeep    = Color(0xFF2B70C9);
const _red         = Color(0xFFFF4B4B);
const _redDark     = Color(0xFFCB3E3E);
const _purple      = Color(0xFFCE82FF);
const _purpleDark  = Color(0xFFB800FF);
const _yellow      = Color(0xFFFFD900);
const _coral       = Color(0xFFFF6B35);

const _bg          = Color(0xFFFDF6EC);
const _cardCream   = Color(0xFFFFFAF4);
const _border      = Color(0xFFE5E5EA);
const _textDark    = Color(0xFF1C1C1E);
const _textGrey    = Color(0xFF8E8E93);
const _textLight   = Color(0xFFC7C7CC);

const _tintGreen   = Color(0xFFEEFBDD);
const _tintBlue    = Color(0xFFE3F5FE);
const _tintOrange  = Color(0xFFFFF3E0);
const _tintRed     = Color(0xFFFFECEC);
const _tintPurple  = Color(0xFFF8EDFF);
const _tintYellow  = Color(0xFFFFFBE0);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ProfileCard(),
                    SizedBox(height: 16),
                    _AchievementsRow(),
                    SizedBox(height: 20),
                    _SectionLabel(title: 'Personal information'),
                    SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.email_rounded,
                      iconBg: _tintBlue,
                      iconColor: _blueDeep,
                      title: 'Email',
                      value: 'arjun@gmail.com',
                    ),
                    SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.phone_rounded,
                      iconBg: _tintGreen,
                      iconColor: _greenDark,
                      title: 'Phone',
                      value: '+91 9876543210',
                    ),
                    SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.location_on_rounded,
                      iconBg: _tintRed,
                      iconColor: _redDark,
                      title: 'Location',
                      value: 'Tamil Nadu, India',
                    ),
                    SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.school_rounded,
                      iconBg: _tintPurple,
                      iconColor: _purpleDark,
                      title: 'Institution',
                      value: 'ScholarHub Institute',
                    ),
                    SizedBox(height: 20),
                    _SectionLabel(title: 'Settings'),
                    SizedBox(height: 12),
                    _SettingTile(
                      icon: Icons.notifications_active_rounded,
                      iconBg: _tintOrange,
                      iconColor: _orange,
                      title: 'Notifications',
                      subtitle: 'Manage alerts & reminders',
                    ),
                    SizedBox(height: 10),
                    _SettingTile(
                      icon: Icons.lock_rounded,
                      iconBg: _tintBlue,
                      iconColor: _blueDeep,
                      title: 'Privacy & Security',
                      subtitle: 'Password, 2FA, data',
                    ),
                    SizedBox(height: 10),
                    _SettingTile(
                      icon: Icons.palette_rounded,
                      iconBg: _tintPurple,
                      iconColor: _purple,
                      title: 'Appearance',
                      subtitle: 'Theme, font size',
                    ),
                    SizedBox(height: 10),
                    _SettingTile(
                      icon: Icons.help_rounded,
                      iconBg: _tintGreen,
                      iconColor: _greenDark,
                      title: 'Help & Support',
                      subtitle: 'FAQs, contact us',
                    ),
                    SizedBox(height: 24),
                    _LogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      decoration: BoxDecoration(
        color: _cardCream,
        border: Border(bottom: BorderSide(color: _border, width: .5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student profile',
                  style: GoogleFonts.inter(
                    fontSize: 11, color: _textGrey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  'Profile',
                  style: GoogleFonts.inter(
                    fontSize: 22, fontWeight: FontWeight.w600,
                    color: _textDark, letterSpacing: -.5, height: 1.1),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: _tintBlue,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _blue.withValues(alpha: .25)),
              ),
              child: const Icon(Icons.settings_rounded, color: _blue, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border, width: .6),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _blue, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 44,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                ),
              ),
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Arjun Kumar',
            style: GoogleFonts.inter(
              fontSize: 22, fontWeight: FontWeight.w600,
              color: _textDark, letterSpacing: -.4),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _tintBlue,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _blue.withValues(alpha: .25)),
            ),
            child: Text(
              'AI & Machine Learning · Batch 2024',
              style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w600, color: _blueDark),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _ProfileStat(value: '12', label: 'Courses'),
              _VerticalDivider(),
              _ProfileStat(value: '34', label: 'Certificates'),
              _VerticalDivider(),
              _ProfileStat(value: '92%', label: 'Attendance'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
          style: GoogleFonts.inter(
            fontSize: 20, fontWeight: FontWeight.w600,
            color: _textDark, letterSpacing: -.4)),
        const SizedBox(height: 3),
        Text(label,
          style: GoogleFonts.inter(
            fontSize: 11, color: _textGrey, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 34, color: _border);
}

class _AchievementsRow extends StatelessWidget {
  const _AchievementsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _AchievementCard(
          icon: Icons.local_fire_department_rounded,
          iconBg: _tintOrange, iconColor: _orange,
          value: '5', label: 'Day streak',
        )),
        const SizedBox(width: 10),
        Expanded(child: _AchievementCard(
          icon: Icons.star_rounded,
          iconBg: _tintYellow, iconColor: _yellow,
          value: '4.8', label: 'Avg. score',
        )),
        const SizedBox(width: 10),
        Expanded(child: _AchievementCard(
          icon: Icons.workspace_premium_rounded,
          iconBg: _tintPurple, iconColor: _purple,
          value: '34', label: 'Badges',
        )),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;

  const _AchievementCard({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.value, required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: _cardCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: .5),
      ),
      child: Column(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: iconBg, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(value,
            style: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.w600,
              color: _textDark, letterSpacing: -.3)),
          const SizedBox(height: 2),
          Text(label,
            style: GoogleFonts.inter(
              fontSize: 10, color: _textGrey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: GoogleFonts.inter(
        fontSize: 17, fontWeight: FontWeight.w600,
        color: _textDark, letterSpacing: -.2));
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardCream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border, width: .5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: iconBg, borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: GoogleFonts.inter(
                    fontSize: 11, color: _textGrey, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text(value,
                  style: GoogleFonts.inter(
                    fontSize: 14, color: _textDark, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border, width: .5),
            ),
            child: const Icon(Icons.edit_rounded, size: 14, color: _textGrey),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _SettingTile({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: _cardCream,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border, width: .5),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11, color: _textGrey, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _textLight),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.mediumImpact(),
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _tintRed,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _red.withValues(alpha: .25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: _red, size: 20),
            const SizedBox(width: 8),
            Text('Log out',
              style: GoogleFonts.inter(
                color: _red, fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}