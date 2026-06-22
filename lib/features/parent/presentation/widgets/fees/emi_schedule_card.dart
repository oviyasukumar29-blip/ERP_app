
// features/parent/presentation/widgets/fees/emi_schedule_card.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';
import '../../../data/models/child_model.dart';
import 'invoice_tile.dart';

/// Shows the term-wise / EMI-style fee schedule from the platform spec's
/// "EMI plans" feature, reusing InvoiceTile for each row.
class EmiScheduleCard extends StatelessWidget {
  final List<FeeInvoice> schedule;
  final ValueChanged<String>? onPayInvoice;

  const EmiScheduleCard({super.key, required this.schedule, this.onPayInvoice});

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) {
      return Container(
        decoration: PT.widgetCard,
        padding: const EdgeInsets.all(16),
        child: Text(
          "No installment schedule available",
          style: PT.subheadline(color: PT.labelTertiary),
        ),
      );
    }

    return Container(
      decoration: PT.widgetCard,
      child: Column(
        children: List.generate(schedule.length, (i) {
          final invoice = schedule[i];
          return InvoiceTile(
            invoice: invoice,
            last: i == schedule.length - 1,
            onPayTap: invoice.status == 'paid'
                ? null
                : () => onPayInvoice?.call(invoice.id),
          );
        }),
      ),
    );
  }
}