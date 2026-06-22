
// features/parent/presentation/widgets/fees/invoice_tile.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';
import '../../../data/models/child_model.dart';

class InvoiceTile extends StatelessWidget {
  final FeeInvoice invoice;
  final bool last;
  final VoidCallback? onPayTap;

  const InvoiceTile({
    super.key,
    required this.invoice,
    required this.last,
    this.onPayTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = PT.statusColor(invoice.status);
    final isPaid = invoice.status == 'paid';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: PT.separator, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              isPaid ? Icons.check_circle_rounded : Icons.receipt_long_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invoice.title, style: PT.subheadline(color: PT.labelPrimary)),
                const SizedBox(height: 2),
                Text(
                  isPaid
                      ? "Paid · ${_formatDate(invoice.paidDate!)}"
                      : "Due ${_formatDate(invoice.dueDate)}",
                  style: PT.caption1(color: isPaid ? PT.labelTertiary : color),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${invoice.amount.toStringAsFixed(0)}",
                style: PT.subheadline(color: PT.labelPrimary),
              ),
              if (!isPaid && onPayTap != null) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onPayTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: PT.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Pay Now",
                      style: PT.caption2(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
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