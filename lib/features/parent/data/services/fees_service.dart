// features/parent/data/services/fees_service.dart
// ─────────────────────────────────────────────────────────────
// Fee invoices, EMI schedule, and payment history for a child.
// MOCK MODE — see parent_api_service.dart header for swap notes.
// ─────────────────────────────────────────────────────────────

import '../models/child_model.dart';

class FeesService {
  Future<List<FeeInvoice>> getInvoices(String childId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    return [
      FeeInvoice(
        id: 'inv_1',
        title: 'Term 1 — Course Fee',
        amount: 15000,
        status: 'paid',
        dueDate: DateTime(now.year, now.month - 2, 5),
        paidDate: DateTime(now.year, now.month - 2, 3),
      ),
      FeeInvoice(
        id: 'inv_2',
        title: 'Term 2 — Course Fee',
        amount: 15000,
        status: 'paid',
        dueDate: DateTime(now.year, now.month - 1, 5),
        paidDate: DateTime(now.year, now.month - 1, 4),
      ),
      FeeInvoice(
        id: 'inv_3',
        title: 'Term 3 — Course Fee',
        amount: 15000,
        status: 'pending',
        dueDate: DateTime(now.year, now.month, 28),
      ),
      FeeInvoice(
        id: 'inv_4',
        title: 'Robotics Kit — One-time',
        amount: 4500,
        status: 'paid',
        dueDate: DateTime(now.year, now.month - 3, 1),
        paidDate: DateTime(now.year, now.month - 3, 1),
      ),
    ];
  }

  /// EMI-style breakdown if the course was enrolled with installments.
  Future<List<FeeInvoice>> getEmiSchedule(String childId) async {
    final invoices = await getInvoices(childId);
    return invoices.where((i) => i.title.contains('Term')).toList();
  }

  Future<Map<String, dynamic>> getFeeSummary(String childId) async {
    final invoices = await getInvoices(childId);
    final totalDue = invoices
        .where((i) => i.status != 'paid')
        .fold<num>(0, (sum, i) => sum + i.amount);
    final totalPaid = invoices
        .where((i) => i.status == 'paid')
        .fold<num>(0, (sum, i) => sum + i.amount);

    return {
      "total_due": totalDue,
      "total_paid": totalPaid,
      "next_due_date": invoices
          .where((i) => i.status != 'paid')
          .map((i) => i.dueDate)
          .fold<DateTime?>(null, (earliest, d) =>
              earliest == null || d.isBefore(earliest) ? d : earliest),
      "status": totalDue == 0 ? "paid" : "pending",
    };
  }

  Future<bool> payInvoice(String invoiceId) async {
    // Wire to real payment gateway integration later.
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
