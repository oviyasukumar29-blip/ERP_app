// features/parent/presentation/pages/fees_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../parent_theme.dart';
import '../widgets/shared/loading_widget.dart';
import '../widgets/shared/empty_state_widget.dart';
import '../widgets/shared/parent_sub_app_bar.dart';
import '../widgets/profile/settings_tile.dart';
import '../../data/services/fees_service.dart';
import '../../data/models/child_model.dart';

class FeesPage extends StatefulWidget {
  final String selectedChildId;
  final String selectedChildName;

  const FeesPage({
    super.key,
    required this.selectedChildId,
    required this.selectedChildName,
  });

  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  final _service = FeesService();

  List<FeeInvoice> _invoices = [];
  List<FeeInvoice> _emiSchedule = [];
  Map<String, dynamic>? _summary;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _service.getInvoices(widget.selectedChildId),
      _service.getEmiSchedule(widget.selectedChildId),
      _service.getFeeSummary(widget.selectedChildId),
    ]);
    if (mounted) {
      setState(() {
        _invoices = results[0] as List<FeeInvoice>;
        _emiSchedule = results[1] as List<FeeInvoice>;
        _summary = results[2] as Map<String, dynamic>;
        _loading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Future<void> _payInvoice(FeeInvoice invoice) async {
    final ok = await _service.payInvoice(invoice.id);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment for "${invoice.title}" submitted',
              style: GoogleFonts.fredoka(color: Colors.white)),
          backgroundColor: PT.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalDue = (_summary?['total_due'] as num?) ?? 0;
    final isPaid = totalDue == 0;
    final nextDueDate = _summary?['next_due_date'] as DateTime?;

    return Scaffold(
      backgroundColor: PT.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ParentSubAppBar(
              title: 'Fees',
              subtitle: widget.selectedChildName,
              showBackButton: true,
            ),
            Expanded(
              child: _loading
                  ? const ParentLoadingWidget()
                  : RefreshIndicator(
                      color: PT.blueDeep,
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                        children: [
                          // Balance summary hero
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isPaid ? PT.green : PT.orange,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: (isPaid ? PT.green : PT.orange)
                                      .withValues(alpha: .30),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Outstanding Balance',
                                  style: PT.subheadline(
                                      color: Colors.white.withValues(alpha: .80)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₹${totalDue.toStringAsFixed(0)}',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isPaid
                                      ? 'No pending payment for now'
                                      : nextDueDate != null
                                          ? 'Due by ${_formatDate(nextDueDate!)}'
                                          : 'Payment pending',
                                  style: PT.subheadline(
                                      color: Colors.white.withValues(alpha: .80)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Quick actions
                          Container(
                            decoration: PT.widgetCard,
                            child: Column(
                              children: [
                                SettingsTile(
                                  icon: Icons.payment_rounded,
                                  iconColor: PT.green,
                                  iconBg: PT.tintGreen,
                                  title: 'Payments',
                                  subtitle: 'Pay fees online',
                                  onTap: isPaid
                                      ? null
                                      : () {
                                          if (_invoices.isNotEmpty) {
                                            final due = _invoices.firstWhere(
                                              (i) => i.status != 'paid',
                                              orElse: () => _invoices.first,
                                            );
                                            _payInvoice(due);
                                          }
                                        },
                                ),
                                SettingsTile(
                                  icon: Icons.receipt_rounded,
                                  iconColor: PT.blue,
                                  iconBg: PT.tintBlue,
                                  title: 'Invoices',
                                  subtitle: 'Download GST invoices',
                                  last: true,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text('Invoices', style: PT.headline()),
                          const SizedBox(height: 10),
                          if (_invoices.isEmpty)
                            const EmptyStateWidget(
                              emoji: '🧾',
                              message: 'No invoices yet.',
                            )
                          else
                            Container(
                              decoration: PT.widgetCard,
                              child: Column(
                                children: List.generate(_invoices.length, (i) {
                                  final inv = _invoices[i];
                                  final color = PT.statusColor(inv.status);
                                  final tint = PT.statusTint(inv.status);
                                  final last = i == _invoices.length - 1;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: last
                                          ? null
                                          : Border(
                                              bottom: BorderSide(
                                                  color: PT.separator,
                                                  width: 0.5)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: tint,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Icon(
                                            inv.status == 'paid'
                                                ? Icons.check_circle_rounded
                                                : Icons.receipt_long_rounded,
                                            color: color,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(inv.title,
                                                  style: PT.subheadline(
                                                      color: PT.labelPrimary)),
                                              const SizedBox(height: 2),
                                              Text(
                                                inv.status == 'paid'
                                                    ? 'Paid ${inv.paidDate != null ? _formatDate(inv.paidDate!) : ''}'
                                                    : 'Due ${_formatDate(inv.dueDate)}',
                                                style: PT.caption2(
                                                    color: PT.labelTertiary),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '₹${inv.amount.toStringAsFixed(0)}',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          if (_emiSchedule.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            Text('EMI Schedule', style: PT.headline()),
                            const SizedBox(height: 10),
                            Container(
                              decoration: PT.widgetCard,
                              child: Column(
                                children:
                                    List.generate(_emiSchedule.length, (i) {
                                  final inv = _emiSchedule[i];
                                  final color = PT.statusColor(inv.status);
                                  final last = i == _emiSchedule.length - 1;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: last
                                          ? null
                                          : Border(
                                              bottom: BorderSide(
                                                  color: PT.separator,
                                                  width: 0.5)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(inv.title,
                                              style: PT.caption1(
                                                  color: PT.labelSecondary)),
                                        ),
                                        Text(
                                          '₹${inv.amount.toStringAsFixed(0)}',
                                          style: PT.caption1(color: color),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
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