// features/parent/data/models/child_model.dart
// ─────────────────────────────────────────────────────────────
// Shared data models used across parent services & widgets.
// Kept simple/JSON-driven so swapping mock data for a real API
// later only means changing the service layer, not the UI.
// ─────────────────────────────────────────────────────────────

class ChildModel {
  final String id;
  final String name;
  final String? photoUrl;
  final String course;
  final String batch;
  final String branch;
  final num attendancePercent;
  final String feeStatus; // paid | pending | overdue | partial
  final num progressPercent;
  final int xp;

  ChildModel({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.course,
    required this.batch,
    required this.branch,
    required this.attendancePercent,
    required this.feeStatus,
    required this.progressPercent,
    required this.xp,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Student',
      photoUrl: json['photo_url']?.toString(),
      course: json['course']?.toString() ?? '-',
      batch: json['batch']?.toString() ?? '-',
      branch: json['branch']?.toString() ?? '-',
      attendancePercent: json['attendance_percent'] ?? 0,
      feeStatus: json['fee_status']?.toString() ?? 'pending',
      progressPercent: json['progress_percent'] ?? 0,
      xp: (json['xp'] ?? 0) is int
          ? json['xp']
          : int.tryParse(json['xp'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'photo_url': photoUrl,
        'course': course,
        'batch': batch,
        'branch': branch,
        'attendance_percent': attendancePercent,
        'fee_status': feeStatus,
        'progress_percent': progressPercent,
        'xp': xp,
      };
}

class AttendanceRecord {
  final DateTime date;
  final String status; // present | absent | leave

  AttendanceRecord({required this.date, required this.status});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'present',
    );
  }
}

class FeeInvoice {
  final String id;
  final String title;
  final num amount;
  final String status; // paid | pending | overdue | partial
  final DateTime dueDate;
  final DateTime? paidDate;

  FeeInvoice({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.paidDate,
  });

  factory FeeInvoice.fromJson(Map<String, dynamic> json) {
    return FeeInvoice(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Fee Installment',
      amount: json['amount'] ?? 0,
      status: json['status']?.toString() ?? 'pending',
      dueDate: DateTime.tryParse(json['due_date']?.toString() ?? '') ??
          DateTime.now(),
      paidDate: json['paid_date'] != null
          ? DateTime.tryParse(json['paid_date'].toString())
          : null,
    );
  }
}

class HomeworkItem {
  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String status; // pending | submitted | late | missed

  HomeworkItem({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.status,
  });

  factory HomeworkItem.fromJson(Map<String, dynamic> json) {
    return HomeworkItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Assignment',
      subject: json['subject']?.toString() ?? 'General',
      dueDate: DateTime.tryParse(json['due_date']?.toString() ?? '') ??
          DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

class ProgressMark {
  final String subject;
  final num score;
  final num maxScore;
  final DateTime date;

  ProgressMark({
    required this.subject,
    required this.score,
    required this.maxScore,
    required this.date,
  });

  factory ProgressMark.fromJson(Map<String, dynamic> json) {
    return ProgressMark(
      subject: json['subject']?.toString() ?? 'General',
      score: json['score'] ?? 0,
      maxScore: json['max_score'] ?? 100,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class ParentNotification {
  final String id;
  final String emoji;
  final String title;
  final String subtitle;
  final String category; // attendance | fees | homework | progress | general
  final DateTime time;
  final bool read;

  ParentNotification({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.time,
    this.read = false,
  });

  factory ParentNotification.fromJson(Map<String, dynamic> json) {
    return ParentNotification(
      id: json['id']?.toString() ?? '',
      emoji: json['emoji']?.toString() ?? '🔔',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      category: json['category']?.toString() ?? 'general',
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
      read: json['read'] == true,
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final bool fromParent;
  final String text;
  final DateTime time;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.fromParent,
    required this.text,
    required this.time,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderName: json['sender_name']?.toString() ?? '',
      fromParent: json['from_parent'] == true,
      text: json['text']?.toString() ?? '',
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class TrainerContact {
  final String id;
  final String name;
  final String subject;
  final String? photoUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  TrainerContact({
    required this.id,
    required this.name,
    required this.subject,
    this.photoUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory TrainerContact.fromJson(Map<String, dynamic> json) {
    return TrainerContact(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Trainer',
      subject: json['subject']?.toString() ?? '',
      photoUrl: json['photo_url']?.toString(),
      lastMessage: json['last_message']?.toString() ?? '',
      lastMessageTime:
          DateTime.tryParse(json['last_message_time']?.toString() ?? '') ??
              DateTime.now(),
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}