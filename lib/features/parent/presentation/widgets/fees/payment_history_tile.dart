
// features/parent/presentation/widgets/fees/payment_history_tile.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';
import '../../../data/models/child_model.dart';

/// Read-only past-payment row, distinct from InvoiceTile (which also
/// handles unpaid/"Pay Now" states) — used in a dedicated history list.
class PaymentHistoryTile extends StatelessWidget {
  final FeeInvoice invoice;
  final bool last;

  const PaymentHistoryTile({super.key, required this.invoice, required this.last});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: PT.separator, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PT.tintGreen,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.check_rounded, color: PT.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invoice.title, style: PT.subheadline(color: PT.labelPrimary)),
                Text(
                  _formatDate(invoice.paidDate ?? invoice.dueDate),
                  style: PT.caption2(color: PT.labelTertiary),
                ),
              ],
            ),
          ),
          Text(
            "₹${invoice.amount.toStringAsFixed(0)}",
            style: PT.subheadline(color: PT.green),
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
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
}