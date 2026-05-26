import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/erp_models.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  final http.Client _client;

  Future<void> saveRecord({
    required String module,
    required String feature,
    required String title,
    required String status,
    required String notes,
    required String ownerRole,
  }) async {
    await _send(
      (baseUrl) => _client.post(
        Uri.parse('$baseUrl/api/records'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'module': module,
          'feature': feature,
          'title': title,
          'status': status,
          'notes': notes,
          'owner_role': ownerRole,
        }),
      ),
    );
  }

  Future<List<ErpRecord>> listRecords({
    required String ownerRole,
    String? module,
    String? feature,
  }) async {
    final query = <String, String>{'owner_role': ownerRole};
    if (module != null) {
      query['module'] = module;
    }
    if (feature != null) {
      query['feature'] = feature;
    }
    final response = await _send(
      (baseUrl) => _client.get(
        Uri.parse('$baseUrl/api/records').replace(queryParameters: query),
      ),
    );
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => ErpRecord.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<http.Response> _send(
    Future<http.Response> Function(String baseUrl) request,
  ) async {
    Object? lastError;
    for (final baseUrl in _candidateBaseUrls) {
      try {
        final response = await request(baseUrl);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        lastError = 'HTTP ${response.statusCode}: ${response.body}';
      } catch (error) {
        lastError = error;
      }
    }

    throw ApiException(
      'Cannot connect to FastAPI. Start backend on port 8000. '
      'For Android phone use your PC IP with --dart-define=API_BASE_URL=http://YOUR_PC_IP:8000. '
      'Last error: $lastError',
    );
  }

  List<String> get _candidateBaseUrls {
    if (_configuredBaseUrl.isNotEmpty) {
      return [_configuredBaseUrl];
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return const ['http://10.0.2.2:8000', 'http://127.0.0.1:8000'];
    }
    return const ['http://127.0.0.1:8000', 'http://localhost:8000'];
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
