
// features/parent/presentation/widgets/dashboard/fees_status_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

class FeesStatusCard extends StatelessWidget {
  final num dueAmount;
  final String status; // paid | pending | overdue
  final DateTime? nextDueDate;
  final VoidCallback? onTap;

  const FeesStatusCard({
    super.key,
    required this.dueAmount,
    required this.status,
    this.nextDueDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = PT.statusColor(status);
    final isPaid = status == 'paid';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: PT.smallCard,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isPaid ? Icons.check_circle_rounded : Icons.receipt_long_rounded,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fees", style: PT.caption1(color: PT.labelTertiary)),
                  Text(
                    isPaid ? "All paid" : "₹${dueAmount.toStringAsFixed(0)}",
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: PT.labelPrimary,
                    ),
                  ),
                  if (!isPaid && nextDueDate != null)
                    Text(
                      "Due ${_formatDate(nextDueDate!)}",
                      style: PT.caption2(color: color),
                    )
                  else
                    Text(
                      "No dues pending",
                      style: PT.caption2(color: PT.labelTertiary),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: PT.labelQuaternary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${date.day} ${months[date.month - 1]}";
  }
}