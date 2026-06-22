// features/parent/presentation/pages/parent_profile_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../parent_theme.dart';
import '../widgets/profile/parent_info_card.dart';
import '../widgets/profile/child_info_card.dart';
import '../widgets/profile/settings_tile.dart';
import '../widgets/shared/loading_widget.dart';
import '../widgets/shared/parent_sub_app_bar.dart';

class ParentProfilePage extends StatefulWidget {
  final String selectedChildId;
  final String selectedChildName;
  final VoidCallback onLogout;

  const ParentProfilePage({
    super.key,
    required this.selectedChildId,
    required this.selectedChildName,
    required this.onLogout,
  });

  @override
  State<ParentProfilePage> createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  bool _loading = true;
  Map<String, dynamic> _parentData = {};
  Map<String, dynamic> _childData = {};
  bool _notificationsEnabled = true;
  bool _emailAlerts = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    // Load from prefs / mock data
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      final childId = widget.selectedChildId;
      final rollSuffix =
          childId.length >= 3 ? childId.substring(0, 3) : childId;
      setState(() {
        _parentData = {
          'name': prefs.getString('parent_name') ?? 'Parent Name',
          'email': prefs.getString('parent_email') ?? 'parent@example.com',
          'phone': prefs.getString('parent_phone') ?? '+91 98765 43210',
          'relation': prefs.getString('parent_relation') ?? 'Father',
        };
        _childData = {
          'name': widget.selectedChildName,
          'grade': '8',
          'section': 'A',
          'roll_number': 'KL-2024-0$rollSuffix',
          'dob': '12 March 2011',
          'blood_group': 'O+',
        };
        _loading = false;
      });
    }
  }

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Logout', style: PT.headline()),
        content: Text(
          'Are you sure you want to logout?',
          style: PT.subheadline(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: PT.subheadline(color: PT.labelTertiary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout',
                style: PT.subheadline(color: PT.red)),
          ),
        ],
      ),
    );
    if (confirm == true) widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PT.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ParentSubAppBar(
              title: 'Profile',
              showBackButton: true,
            ),
            Expanded(
              child: _loading
                  ? const ParentLoadingWidget()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                      children: [
                        // Parent card
                        ParentInfoCard(
                          name: _parentData['name'] as String,
                          email: _parentData['email'] as String,
                          phone: _parentData['phone'] as String,
                          relation: _parentData['relation'] as String,
                        ),
                        const SizedBox(height: 16),
                        // Child info
                        Text('Child Information', style: PT.title3()),
                        const SizedBox(height: 10),
                        ChildInfoCard(
                          name: _childData['name'] as String,
                          grade: _childData['grade'] as String,
                          section: _childData['section'] as String,
                          rollNumber: _childData['roll_number'] as String,
                          dateOfBirth: _childData['dob'] as String,
                          bloodGroup: _childData['blood_group'] as String,
                        ),
                        const SizedBox(height: 16),
                        // Notifications section
                        Text('Notifications', style: PT.title3()),
                        const SizedBox(height: 10),
                        Container(
                          decoration: PT.widgetCard,
                          child: Column(
                            children: [
                              SettingsTile(
                                icon: Icons.notifications_outlined,
                                iconColor: PT.blueDeep,
                                iconBg: PT.tintBlue,
                                title: 'Push Notifications',
                                subtitle: 'Alerts for attendance, fees & homework',
                                showArrow: false,
                                trailing: Switch(
                                  value: _notificationsEnabled,
                                  onChanged: (v) =>
                                      setState(() => _notificationsEnabled = v),
                                  activeColor: PT.blueDeep,
                                ),
                              ),
                              SettingsTile(
                                icon: Icons.email_outlined,
                                iconColor: PT.purple,
                                iconBg: PT.tintPurple,
                                title: 'Email Alerts',
                                subtitle: 'Weekly progress summary via email',
                                showArrow: false,
                                last: true,
                                trailing: Switch(
                                  value: _emailAlerts,
                                  onChanged: (v) =>
                                      setState(() => _emailAlerts = v),
                                  activeColor: PT.blueDeep,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Account section
                        Text('Account', style: PT.title3()),
                        const SizedBox(height: 10),
                        Container(
                          decoration: PT.widgetCard,
                          child: Column(
                            children: [
                              SettingsTile(
                                icon: Icons.lock_outline_rounded,
                                iconColor: PT.orange,
                                iconBg: PT.tintOrange,
                                title: 'Change Password',
                                onTap: () {},
                              ),
                              SettingsTile(
                                icon: Icons.language_rounded,
                                iconColor: PT.green,
                                iconBg: PT.tintGreen,
                                title: 'Language',
                                subtitle: 'English',
                                onTap: () {},
                              ),
                              SettingsTile(
                                icon: Icons.help_outline_rounded,
                                iconColor: PT.blueDeep,
                                iconBg: PT.tintBlue,
                                title: 'Help & Support',
                                onTap: () {},
                              ),
                              SettingsTile(
                                icon: Icons.logout_rounded,
                                iconColor: PT.red,
                                iconBg: PT.tintRed,
                                title: 'Logout',
                                isDestructive: true,
                                last: true,
                                onTap: _confirmLogout,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'PineSphere ERP v1.0',
                            style: PT.caption2(),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}