import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ai/ai_providers.dart';
import '../../../core/ai/gemini_service.dart';

/// Chat message model
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  final String text;
  final bool isUser;
  final DateTime timestamp;
}

/// AI Chat state
class AiChatState {
  AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// AI Chat notifier — manages chat session with Gemini
class AiChatNotifier extends StateNotifier<AiChatState> {
  AiChatNotifier(this._ref) : super(AiChatState());

  final Ref _ref;
  ChatSession? _session;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final service = await _ref.read(geminiServiceProvider.future);
      if (service == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'AI not configured. Please add your Gemini API key in Settings.',
        );
        return;
      }

      // Start new session if needed
      _session ??= await service.startChat();

      final response = await _session!.sendMessage(Content.text(text));
      final responseText = response.text ?? 'No response.';

      final aiMessage = ChatMessage(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get AI response: $e',
      );
    }
  }

  void clearChat() {
    _session = null;
    state = AiChatState();
  }

  void dismissError() {
    state = state.copyWith(error: null);
  }
}

final aiChatProvider =
    StateNotifierProvider<AiChatNotifier, AiChatState>((ref) {
  return AiChatNotifier(ref);
});
