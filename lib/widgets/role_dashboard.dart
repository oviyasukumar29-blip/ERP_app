import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/erp_models.dart';
import '../screens/login_screen.dart';
import '../services/api_service.dart';

class RoleDashboard extends StatefulWidget {
  const RoleDashboard({super.key, required this.role});

  final ErpRole role;

  @override
  State<RoleDashboard> createState() => _RoleDashboardState();
}

class _RoleDashboardState extends State<RoleDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = widget.role;
    final phaseOne = role.modules.where((module) => module.phase == 1).length;
    final future = role.modules.length - phaseOne;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          role.name,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _bodyFor(role, phaseOne, future),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index == 3) {
            _logout();
            return;
          }
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.apps_outlined),
            selectedIcon: Icon(Icons.apps_rounded),
            label: 'Modules',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.logout_rounded),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _bodyFor(ErpRole role, int phaseOne, int future) {
    if (_selectedIndex == 1) {
      return ListView(
        key: const ValueKey('modules'),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [_ModulePanel(role: role)],
      );
    }
    if (_selectedIndex == 2) {
      return _RecordsPanel(ownerRole: role.id);
    }
    return ListView(
      key: const ValueKey('home'),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      children: [
        _HeroPanel(role: role),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Modules',
                value: '${role.modules.length}',
                accent: AppTheme.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricTile(
                label: 'Phase 1',
                value: '$phaseOne',
                accent: AppTheme.blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricTile(
                label: 'Future',
                value: '$future',
                accent: AppTheme.yellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _ModulePanel(role: role, embedded: true),
      ],
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }
}

class _ModulePanel extends StatelessWidget {
  const _ModulePanel({required this.role, this.embedded = false});

  final ErpRole role;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('modules-${role.id}-$embedded'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.apps_rounded, color: AppTheme.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      embedded ? 'Quick modules' : 'All modules',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Open CRM, leads, students, fees and more',
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
          for (final module in role.modules)
            _ModuleCard(module: module, ownerRole: role.id),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.role});

  final ErpRole role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.green, AppTheme.blue],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2258CC02),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Pinesphere ERP',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppTheme.greenDark,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            role.description,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _WhiteChip(icon: Icons.school_rounded, label: 'LMS'),
              _WhiteChip(icon: Icons.payments_rounded, label: 'Finance'),
              _WhiteChip(icon: Icons.psychology_rounded, label: 'AI Ready'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhiteChip extends StatelessWidget {
  const _WhiteChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.insights_rounded, color: accent),
            const SizedBox(height: 10),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordsPanel extends StatefulWidget {
  const _RecordsPanel({required this.ownerRole});

  final String ownerRole;

  @override
  State<_RecordsPanel> createState() => _RecordsPanelState();
}

class _RecordsPanelState extends State<_RecordsPanel> {
  final _api = ApiService();
  late Future<List<ErpRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = _api.listRecords(ownerRole: widget.ownerRole);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('records'),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Saved records',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Refresh',
              onPressed: () {
                setState(() {
                  _recordsFuture = _api.listRecords(
                    ownerRole: widget.ownerRole,
                  );
                });
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<ErpRecord>>(
          future: _recordsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasError) {
              return _EmptyState(
                icon: Icons.cloud_off_rounded,
                title: 'Backend not connected',
                message: snapshot.error.toString(),
              );
            }
            final records = snapshot.data ?? const [];
            if (records.isEmpty) {
              return const _EmptyState(
                icon: Icons.storage_rounded,
                title: 'No saved records yet',
                message:
                    'Save or register from any module and it will appear here.',
              );
            }
            return Column(
              children: [
                for (final record in records) _RecordTile(record: record),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final ErpRecord record;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.blue.withValues(alpha: 0.12),
          child: const Icon(Icons.storage_rounded, color: AppTheme.blue),
        ),
        title: Text(
          record.title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text('${record.module} / ${record.feature}\n${record.notes}'),
        isThreeLine: record.notes.isNotEmpty,
        trailing: _StatusPill(status: record.status),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = status == 'Completed'
        ? AppTheme.green
        : status == 'Pending'
        ? const Color(0xFFFF9600)
        : AppTheme.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EEF5)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: AppTheme.muted),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.muted, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module, required this.ownerRole});

  final ErpModule module;
  final String ownerRole;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        leading: CircleAvatar(
          backgroundColor: _phaseColor(module.phase).withValues(alpha: 0.14),
          child: Icon(_iconFor(module.title), color: _phaseColor(module.phase)),
        ),
        title: Text(
          module.title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          'Phase ${module.phase}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppTheme.muted,
          ),
        ),
        children: [
          if (module.summary.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  module.summary,
                  style: const TextStyle(color: AppTheme.muted),
                ),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final feature in module.features)
                ActionChip(
                  avatar: const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: AppTheme.green,
                  ),
                  label: Text(feature),
                  onPressed: () => _openFeature(context, module.title, feature),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _openFeature(BuildContext context, String module, String feature) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FeatureDetailScreen(
          module: module,
          feature: feature,
          ownerRole: ownerRole,
        ),
      ),
    );
  }

  IconData _iconFor(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('dashboard')) {
      return Icons.dashboard_rounded;
    }
    if (lower.contains('student') ||
        lower.contains('course') ||
        lower.contains('lms')) {
      return Icons.school_rounded;
    }
    if (lower.contains('finance') ||
        lower.contains('fees') ||
        lower.contains('invoice')) {
      return Icons.payments_rounded;
    }
    if (lower.contains('ai')) {
      return Icons.psychology_rounded;
    }
    if (lower.contains('attendance')) {
      return Icons.fact_check_rounded;
    }
    if (lower.contains('report')) {
      return Icons.summarize_rounded;
    }
    if (lower.contains('hr') || lower.contains('employee')) {
      return Icons.badge_rounded;
    }
    return Icons.apps_rounded;
  }

  Color _phaseColor(int phase) {
    if (phase == 1) return AppTheme.green;
    if (phase == 2) return AppTheme.blue;
    return const Color(0xFFFF9600);
  }
}

class FeatureDetailScreen extends StatefulWidget {
  const FeatureDetailScreen({
    super.key,
    required this.module,
    required this.feature,
    required this.ownerRole,
  });

  final String module;
  final String feature;
  final String ownerRole;

  @override
  State<FeatureDetailScreen> createState() => _FeatureDetailScreenState();
}

class _FeatureDetailScreenState extends State<FeatureDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _api = ApiService();
  String _status = 'Active';
  bool _saving = false;
  late Future<List<ErpRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = _loadRecords();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.feature)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE8EEF5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppTheme.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: AppTheme.green,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.module,
                        style: const TextStyle(
                          color: AppTheme.greenDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        widget.feature,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '${widget.feature} title',
                    prefixIcon: const Icon(Icons.title_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Notes / details',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.flag_rounded),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'Completed',
                      child: Text('Completed'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _status = value ?? _status),
                ),
                const SizedBox(height: 18),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(_buttonLabel),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Appears here after save',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: () =>
                    setState(() => _recordsFuture = _loadRecords()),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          FutureBuilder<List<ErpRecord>>(
            future: _recordsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return _EmptyState(
                  icon: Icons.cloud_off_rounded,
                  title: 'Backend not connected',
                  message: snapshot.error.toString(),
                );
              }
              final records = snapshot.data ?? const [];
              if (records.isEmpty) {
                return const _EmptyState(
                  icon: Icons.inbox_rounded,
                  title: 'Nothing saved yet',
                  message: 'Fill the form and tap Save Record or Register.',
                );
              }
              return Column(
                children: [
                  for (final record in records) _RecordTile(record: record),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String get _buttonLabel {
    final feature = widget.feature.toLowerCase();
    if (feature.contains('admission') ||
        feature.contains('student') ||
        feature.contains('employee') ||
        feature.contains('register') ||
        feature.contains('enroll')) {
      return 'Register';
    }
    return 'Save Record';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _api.saveRecord(
        module: widget.module,
        feature: widget.feature,
        title: _titleController.text.trim(),
        status: _status,
        notes: _notesController.text.trim(),
        ownerRole: widget.ownerRole,
      );
      if (!mounted) return;
      setState(() {
        _recordsFuture = _loadRecords();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to PostgreSQL successfully.')),
      );
      _titleController.clear();
      _notesController.clear();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<List<ErpRecord>> _loadRecords() {
    return _api.listRecords(
      ownerRole: widget.ownerRole,
      module: widget.module,
      feature: widget.feature,
    );
  }
}
