// features/parent/data/services/fees_service.dart
// ─────────────────────────────────────────────────────────────
// Wired to real backend.
// Endpoint: GET /parent/children/{childId}/fees?parent_id=...
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_model.dart';

class FeesService {
  static const _host = 'https://shout-crisping-icing.ngrok-free.dev';
  static const _headers = {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  Future<String?> _getParentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // ── All fee invoices ─────────────────────────────────────
  Future<List<FeeInvoice>> getInvoices(String childId) async {
    final parentId = await _getParentId();
    if (parentId == null) return [];

    final response = await http.get(
      Uri.parse('$_host/parent/children/$childId/fees?parent_id=$parentId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final invoices = body['invoices'] as List<dynamic>;
      return invoices
          .map((i) => FeeInvoice(
                id: i['id'] as String,
                title: i['title'] as String,
                amount: (i['amount'] as num).toDouble(),
                status: i['status'] as String,
                dueDate: i['dueDate'] != null
                    ? DateTime.parse(i['dueDate'] as String)
                    : DateTime.now(),
                paidDate: i['paidDate'] != null
                    ? DateTime.parse(i['paidDate'] as String)
                    : null,
              ))
          .toList();
    } else {
      throw Exception('Failed to load invoices: ${response.statusCode}');
    }
  }

  // ── EMI / term-only invoices ─────────────────────────────
  Future<List<FeeInvoice>> getEmiSchedule(String childId) async {
    final invoices = await getInvoices(childId);
    return invoices.where((i) => i.title.contains('Term')).toList();
  }

  // ── Fee summary (total_due, total_paid, next_due_date) ───
  Future<Map<String, dynamic>> getFeeSummary(String childId) async {
    final parentId = await _getParentId();
    if (parentId == null) {
      return {"total_due": 0, "total_paid": 0, "next_due_date": null, "status": "pending"};
    }

    final response = await http.get(
      Uri.parse('$_host/parent/children/$childId/fees?parent_id=$parentId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final summary = Map<String, dynamic>.from(body['summary'] as Map);

      // Parse next_due_date string → DateTime so FeesStatusCard gets the type it expects
      if (summary['next_due_date'] != null) {
        summary['next_due_date'] =
            DateTime.tryParse(summary['next_due_date'] as String);
      }
      return summary;
    } else {
      throw Exception('Failed to load fee summary: ${response.statusCode}');
    }
  }

  // ── Pay invoice (stub — wire to gateway later) ───────────
  Future<bool> payInvoice(String invoiceId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}