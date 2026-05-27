// features/student/presentation/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Palette (mirrors _T tokens) ─────────────────────────────────────────────
const _primary      = Color(0xFF45960A);
const _primaryDark  = Color(0xFF2E6A06);
const _primaryLight = Color(0xFFEAF3DE);
const _primaryGlow  = Color(0xFFC0DD97);
const _primaryFaint = Color(0xFFF0FAE8);
const _successDark  = Color(0xFF27500A);
const _successText  = Color(0xFF3B6D11);
const _bg           = Color(0xFFF7F8F5);
const _white        = Color(0xFFFFFFFF);
const _border       = Color(0xFFE8E8E8);
const _borderGreen  = Color(0xFFCCE8B0);
const _textDark     = Color(0xFF111111);
const _textGrey     = Color(0xFF888888);
const _textLight    = Color(0xFFBBBBBB);
const _danger       = Color(0xFFE24B4A);
const _dangerLight  = Color(0xFFFCEBEB);
const _dangerBorder = Color(0xFFF5CACA);
const _blue         = Color(0xFF185FA5);
const _blueLight    = Color(0xFFE6F1FB);
const _amber        = Color(0xFFEF9F27);
const _amberLight   = Color(0xFFFAEEDA);
const _amberDark    = Color(0xFF633806);
const _purple       = Color(0xFF3C3489);
const _purpleLight  = Color(0xFFEEEDFE);

// ─── Page ─────────────────────────────────────────────────────────────────────
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
                      iconBg: _blueLight,
                      iconColor: _blue,
                      title: 'Email',
                      value: 'arjun@gmail.com',
                    ),
                    SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.phone_rounded,
                      iconBg: _primaryLight,
                      iconColor: _successDark,
                      title: 'Phone',
                      value: '+91 9876543210',
                    ),
                    SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.location_on_rounded,
                      iconBg: _dangerLight,
                      iconColor: _danger,
                      title: 'Location',
                      value: 'Tamil Nadu, India',
                    ),
                    SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.school_rounded,
                      iconBg: _purpleLight,
                      iconColor: _purple,
                      title: 'Institution',
                      value: 'ScholarHub Institute',
                    ),
                    SizedBox(height: 20),
                    _SectionLabel(title: 'Settings'),
                    SizedBox(height: 12),
                    _SettingTile(
                      icon: Icons.notifications_active_rounded,
                      iconBg: _amberLight,
                      iconColor: _amber,
                      title: 'Notifications',
                      subtitle: 'Manage alerts & reminders',
                    ),
                    SizedBox(height: 10),
                    _SettingTile(
                      icon: Icons.lock_rounded,
                      iconBg: _blueLight,
                      iconColor: _blue,
                      title: 'Privacy & Security',
                      subtitle: 'Password, 2FA, data',
                    ),
                    SizedBox(height: 10),
                    _SettingTile(
                      icon: Icons.palette_rounded,
                      iconBg: _purpleLight,
                      iconColor: _purple,
                      title: 'Appearance',
                      subtitle: 'Theme, font size',
                    ),
                    SizedBox(height: 10),
                    _SettingTile(
                      icon: Icons.help_rounded,
                      iconBg: _primaryLight,
                      iconColor: _successDark,
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

// ─── Top bar ──────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      decoration: const BoxDecoration(
        color: _white,
        border: Border(bottom: BorderSide(color: _border, width: .5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Student profile',
                  style: TextStyle(
                    fontSize: 11,
                    color: _textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                    letterSpacing: -.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _primaryFaint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _borderGreen),
              ),
              child: const Icon(
                Icons.settings_rounded,
                color: _primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile card ─────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border, width: .6),
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _primary, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 44,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: _white, width: 2),
                ),
                child: const Icon(Icons.edit_rounded, size: 14, color: _white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Arjun Kumar',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _textDark,
              letterSpacing: -.4,
            ),
          ),
          const SizedBox(height: 4),
          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _primaryFaint,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _borderGreen),
            ),
            child: const Text(
              'AI & Machine Learning · Batch 2024',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _successText,
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Stats row
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
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _textDark,
            letterSpacing: -.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: _textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34, color: _border);
  }
}

// ─── Achievements row ─────────────────────────────────────────────────────────
class _AchievementsRow extends StatelessWidget {
  const _AchievementsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AchievementCard(
            icon: Icons.local_fire_department_rounded,
            iconBg: _amberLight,
            iconColor: _amber,
            value: '5',
            label: 'Day streak',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _AchievementCard(
            icon: Icons.star_rounded,
            iconBg: _primaryLight,
            iconColor: _primary,
            value: '4.8',
            label: 'Avg. score',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _AchievementCard(
            icon: Icons.workspace_premium_rounded,
            iconBg: _purpleLight,
            iconColor: _purple,
            value: '34',
            label: 'Badges',
          ),
        ),
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
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: .5),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _textDark,
              letterSpacing: -.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: _textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: _textDark,
        letterSpacing: -.2,
      ),
    );
  }
}

// ─── Info card ────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border, width: .5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border, width: .5),
            ),
            child: const Icon(
              Icons.edit_rounded,
              size: 14,
              color: _textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settings tile ────────────────────────────────────────────────────────────
class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _SettingTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border, width: .5),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textGrey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: _textLight,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Logout button ────────────────────────────────────────────────────────────
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
          color: _dangerLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _dangerBorder),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: _danger, size: 20),
            SizedBox(width: 8),
            Text(
              'Log out',
              style: TextStyle(
                color: _danger,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}