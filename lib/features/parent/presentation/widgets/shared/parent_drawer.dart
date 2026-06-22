
// features/parent/presentation/widgets/shared/parent_drawer.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';

class ParentDrawer extends StatelessWidget {
  final String parentName;
  final VoidCallback onProfileTap;
  final VoidCallback onCommunicationTap;
  final VoidCallback onLogout;

  const ParentDrawer({
    super.key,
    required this.parentName,
    required this.onProfileTap,
    required this.onCommunicationTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: PT.bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: PT.tintPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded, color: PT.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      parentName,
                      style: PT.title3().copyWith(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: PT.separator, height: 1),
            _DrawerItem(
              icon: Icons.person_outline_rounded,
              label: 'My Profile',
              onTap: onProfileTap,
            ),
            _DrawerItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Trainer Chat',
              onTap: onCommunicationTap,
            ),
            const Spacer(),
            const Divider(color: PT.separator, height: 1),
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              color: PT.red,
              onTap: onLogout,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? PT.labelSecondary),
      title: Text(
        label,
        style: PT.subheadline(color: color ?? PT.labelPrimary),
      ),
      onTap: onTap,
    );
  }
}