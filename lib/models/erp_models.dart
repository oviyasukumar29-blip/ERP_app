class ErpRole {
  const ErpRole({
    required this.id,
    required this.name,
    required this.description,
    required this.modules,
  });

  final String id;
  final String name;
  final String description;
  final List<ErpModule> modules;
}

class ErpModule {
  const ErpModule({
    required this.title,
    required this.phase,
    required this.features,
    this.summary = '',
  });

  final String title;
  final int phase;
  final String summary;
  final List<String> features;
}

class Metric {
  const Metric(this.label, this.value, this.delta);

  final String label;
  final String value;
  final String delta;
}

class ErpRecord {
  const ErpRecord({
    required this.id,
    required this.module,
    required this.feature,
    required this.title,
    required this.status,
    required this.notes,
    required this.ownerRole,
    required this.createdAt,
  });

  final String id;
  final String module;
  final String feature;
  final String title;
  final String status;
  final String notes;
  final String ownerRole;
  final DateTime createdAt;

  factory ErpRecord.fromJson(Map<String, dynamic> json) {
    return ErpRecord(
      id: json['id'] as String,
      module: json['module'] as String,
      feature: json['feature'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String? ?? '',
      ownerRole: json['owner_role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
