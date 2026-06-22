// features/parent/presentation/widgets/shared/parent_app_bar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';
import '../../../data/models/child_model.dart';

/// Top bar reused across parent pages: branding + active-child switcher
/// on the left, notification bell + profile avatar on the right.
/// Mirrors the student app's _TopBar but adds the multi-child switcher.
class ParentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<ChildModel> children;
  final ChildModel? selectedChild;
  final ValueChanged<ChildModel> onChildChanged;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenProfile;
  final int unreadCount;

  const ParentAppBar({
    super.key,
    required this.children,
    required this.selectedChild,
    required this.onChildChanged,
    required this.onOpenNotifications,
    required this.onOpenProfile,
    this.unreadCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: PT.bg,
      child: Row(
        children: [
          GestureDetector(
            onTap: onOpenProfile,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: PT.tintPurple, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const ClipOval(
                child: Icon(
                  Icons.person_rounded,
                  color: PT.primary,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: _ChildSwitcher(
            children: children,
            selectedChild: selectedChild,
            onChildChanged: onChildChanged,
          )),
          GestureDetector(
            onTap: onOpenNotifications,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: PT.bgElevated,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    color: PT.labelTertiary,
                    size: 18,
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: -3,
                    right: -3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: PT.red,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: PT.bg, width: 1.5),
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildSwitcher extends StatelessWidget {
  final List<ChildModel> children;
  final ChildModel? selectedChild;
  final ValueChanged<ChildModel> onChildChanged;

  const _ChildSwitcher({
    required this.children,
    required this.selectedChild,
    required this.onChildChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Text("KIDLEARN", style: PT.title3());
    }

    if (children.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("KIDLEARN PARENT", style: PT.caption1(color: PT.primary)),
          Text(
            selectedChild?.name ?? children.first.name,
            style: PT.title3().copyWith(fontSize: 16),
          ),
        ],
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showChildPicker(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("KIDLEARN PARENT", style: PT.caption1(color: PT.primary)),
          Row(
            children: [
              Text(
                selectedChild?.name ?? children.first.name,
                style: PT.title3().copyWith(fontSize: 16),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.unfold_more_rounded,
                size: 16,
                color: PT.labelTertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showChildPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        decoration: const BoxDecoration(
          color: PT.bgElevated,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: PT.separator,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),
            Text("Switch Child", style: PT.title3()),
            const SizedBox(height: 12),
            ...children.map((child) {
              final isSelected = child.id == selectedChild?.id;
              return ListTile(
                onTap: () {
                  onChildChanged(child);
                  Navigator.pop(context);
                },
                leading: CircleAvatar(
                  backgroundColor: PT.tintPurple,
                  child: Icon(Icons.person_rounded, color: PT.primary),
                ),
                title: Text(child.name, style: PT.subheadline(color: PT.labelPrimary)),
                subtitle: Text(child.course, style: PT.caption1()),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded, color: PT.green)
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}