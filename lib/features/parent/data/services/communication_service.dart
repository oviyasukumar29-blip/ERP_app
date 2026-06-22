// features/parent/data/services/communication_service.dart
// ─────────────────────────────────────────────────────────────
// Trainer chat threads + complaint/feedback submission.
// MOCK MODE — see parent_api_service.dart header for swap notes.
// ─────────────────────────────────────────────────────────────

import '../models/child_model.dart';

class CommunicationService {
  Future<List<TrainerContact>> getTrainerContacts(String childId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    return [
      TrainerContact(
        id: 't1',
        name: 'Mr. Karthik Raja',
        subject: 'Robotics',
        lastMessage: 'Aarav did great in today\'s sensor lab!',
        lastMessageTime: now.subtract(const Duration(hours: 3)),
        unreadCount: 1,
      ),
      TrainerContact(
        id: 't2',
        name: 'Ms. Priya Sundar',
        subject: 'Python Coding',
        lastMessage: 'Please remind him to submit the loops worksheet.',
        lastMessageTime: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<List<ChatMessage>> getMessages(String trainerId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    return [
      ChatMessage(
        id: 'm1',
        senderId: trainerId,
        senderName: 'Trainer',
        fromParent: false,
        text: 'Aarav did great in today\'s sensor lab!',
        time: now.subtract(const Duration(hours: 3)),
      ),
      ChatMessage(
        id: 'm2',
        senderId: 'parent',
        senderName: 'You',
        fromParent: true,
        text: 'That\'s wonderful to hear, thank you!',
        time: now.subtract(const Duration(hours: 2, minutes: 50)),
      ),
    ];
  }

  Future<ChatMessage> sendMessage(String trainerId, String text) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'parent',
      senderName: 'You',
      fromParent: true,
      text: text,
      time: DateTime.now(),
    );
  }

  Future<bool> submitComplaint({
    required String childId,
    required String category,
    required String message,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Wire to POST /parent/complaints later.
    return true;
  }
}
