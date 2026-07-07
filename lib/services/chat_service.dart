/// Chat Service
/// Handles communication with the backend /api/chat endpoint which forwards
/// to Hermes agent for AI-powered career guidance.
///
/// Backend contract:
/// POST /api/chat
/// Request:  { user_id, message, context?, conversation_id? }
/// Response: { message, conversation_id, suggestions?, action_items?, metadata? }

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// CHAT MESSAGE MODEL
// ═══════════════════════════════════════════════════════════════════════════

enum MessageRole { user, assistant, system }

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isStreaming;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isStreaming = false,
  });

  ChatMessage copyWith({
    String? content,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id,
      content: content ?? this.content,
      role: role,
      timestamp: timestamp,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.assistant(String content, {String? id}) {
    return ChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.system(String content) {
    return ChatMessage(
      id: 'system_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      role: MessageRole.system,
      timestamp: DateTime.now(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CHAT RESPONSE (from backend)
// ═══════════════════════════════════════════════════════════════════════════

class ChatResponse {
  final String message;
  final String conversationId;
  final List<String>? suggestions;
  final List<String>? actionItems;
  final Map<String, dynamic>? metadata;

  const ChatResponse({
    required this.message,
    required this.conversationId,
    this.suggestions,
    this.actionItems,
    this.metadata,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'] as String? ?? '',
      conversationId: json['conversation_id'] as String? ?? '',
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      actionItems: (json['action_items'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CHAT SERVICE
// ═══════════════════════════════════════════════════════════════════════════

class ChatService {
  final http.Client _client = http.Client();
  String? _currentConversationId;

  /// Get or create a conversation ID for multi-turn context.
  String get conversationId =>
      _currentConversationId ??
      DateTime.now().millisecondsSinceEpoch.toRadixString(36);

  void resetConversation() {
    _currentConversationId = null;
  }

  /// Send a chat message and get a response from the backend.
  ///
  /// The backend at /api/chat forwards to Hermes via the bridge server.
  /// Supports multi-turn conversations via conversation_id.
  Future<ChatResponse> sendMessage({
    required String userId,
    required String message,
    String? context,
  }) async {
    final requestBody = {
      'user_id': userId,
      'message': message,
      if (context != null) 'context': context,
      if (_currentConversationId != null)
        'conversation_id': _currentConversationId,
    };

    try {
      final response = await _client.post(
        Uri.parse('$backendUrl/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final chatResponse = ChatResponse.fromJson(data);

        // Store conversation ID for multi-turn context
        if (chatResponse.conversationId.isNotEmpty) {
          _currentConversationId = chatResponse.conversationId;
        }

        return chatResponse;
      } else {
        final errorBody = response.body;
        throw Exception(
          'Chat request failed (${response.statusCode}): $errorBody',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Chat connection failed: $e');
    }
  }

  /// Get conversation history from the backend.
  Future<List<Map<String, dynamic>>> getConversationHistory(
    String conversationId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$backendUrl/api/chat/$conversationId/history'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final messages = data['messages'] as List<dynamic>?;
        return messages?.cast<Map<String, dynamic>>() ?? [];
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// List all conversations for a user.
  Future<List<Map<String, dynamic>>> listConversations(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$backendUrl/api/chat/conversations/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  void dispose() {
    _client.close();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

final chatServiceProvider = Provider<ChatService>((ref) {
  final service = ChatService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Suggested starter prompts for new users
const List<Map<String, String>> chatSuggestions = [
  {
    'title': 'Profile Review',
    'prompt':
        'Can you review my profile and tell me what activities I should add to improve my chances for top universities?',
    'icon': '🎯',
  },
  {
    'title': 'Essay Ideas',
    'prompt':
        'Help me brainstorm unique personal essay topics that highlight my strengths as an Indian student applying to US colleges.',
    'icon': '✍️',
  },
  {
    'title': 'University Match',
    'prompt':
        'Based on my profile, which universities should I target? Give me reach, match, and safety suggestions.',
    'icon': '🏫',
  },
  {
    'title': 'Spike Builder',
    'prompt':
        'How can I build a compelling "spike" in my chosen field to stand out in college admissions?',
    'icon': '📈',
  },
];
