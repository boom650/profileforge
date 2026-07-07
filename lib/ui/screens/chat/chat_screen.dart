/// AI Chat Screen
/// A polished chat interface connected to the backend /api/chat endpoint
/// which forwards conversations to Hermes agent for career guidance.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../services/chat_service.dart';
import '../../../providers/app_providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// CHAT STATE NOTIFIER
// ═══════════════════════════════════════════════════════════════════════════

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  String? _userId;

  ChatNotifier(this._chatService) : super(const ChatState());

  void setUserId(String? userId) {
    _userId = userId;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.isLoading) return;

    HapticFeedback.lightImpact();

    final userMessage = ChatMessage.user(content.trim());
    final newMessages = [...state.messages, userMessage];

    state = state.copyWith(
      messages: newMessages,
      isLoading: true,
      error: null,
    );

    try {
      final userId = _userId ?? 'anonymous';
      final chatResponse = await _chatService.sendMessage(
        userId: userId,
        message: content.trim(),
      );

      final assistantMessage = ChatMessage.assistant(chatResponse.message);

      state = state.copyWith(
        messages: [...newMessages, assistantMessage],
        isLoading: false,
      );
    } catch (e) {
      // Remove the streaming placeholder if it exists
      final cleanedMsgs = state.messages
          .where((m) => !(m.role == MessageRole.assistant && m.content.isEmpty))
          .toList();

      state = state.copyWith(
        messages: cleanedMsgs,
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void clearChat() {
    HapticFeedback.mediumImpact();
    state = const ChatState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ref.read(chatServiceProvider);
  final notifier = ChatNotifier(chatService);

  // Set userId from profile if available
  final profile = ref.read(studentProfileProvider);
  if (profile != null) {
    notifier.setUserId(profile.id);
  }

  return notifier;
});

// ═══════════════════════════════════════════════════════════════════════════
// CHAT SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _showScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final atBottom = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100;
      if (atBottom != _showScrollDown) {
        setState(() => _showScrollDown = !atBottom);
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    ref.read(chatProvider.notifier).sendMessage(text);

    // Scroll to bottom after a short delay to allow new message to render
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _sendSuggestion(String prompt) {
    _controller.clear();
    ref.read(chatProvider.notifier).sendMessage(prompt);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final messages = chatState.messages;
    final hasMessages = messages.isNotEmpty;

    return Scaffold(
      backgroundColor: context.surfaceBg,
      appBar: _ChatAppBar(
        hasMessages: hasMessages,
        onClear: () => _showClearDialog(context),
      ),
      body: Column(
        children: [
          // Error banner
          if (chatState.error != null)
            _ErrorBanner(
              error: chatState.error!,
              onDismiss: () => ref.read(chatProvider.notifier).clearError(),
            ),

          // Messages or empty state
          Expanded(
            child: hasMessages
                ? _MessageList(
                    messages: messages,
                    scrollController: _scrollController,
                    isLoading: chatState.isLoading,
                  )
                : _EmptyState(onSuggestionTap: _sendSuggestion),
          ),

          // Scroll-to-bottom FAB
          if (_showScrollDown)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Material(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: _scrollToBottom,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: context.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Input area
          _ChatInput(
            controller: _controller,
            focusNode: _focusNode,
            onSend: _sendMessage,
            isLoading: chatState.isLoading,
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Clear Chat',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Start a new conversation? Your current chat will be cleared.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(chatProvider.notifier).clearChat();
            },
            child: const Text('Clear', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// APP BAR
// ═══════════════════════════════════════════════════════════════════════════

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasMessages;
  final VoidCallback onClear;

  const _ChatAppBar({required this.hasMessages, required this.onClear});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: context.surfaceBg,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppTheme.gradientPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ProfileForge AI',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              Text(
                'Career Guidance',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: context.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        if (hasMessages)
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            tooltip: 'Clear chat',
            onPressed: onClear,
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final void Function(String) onSuggestionTap;

  const _EmptyState({required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AI Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.gradientPrimary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 40,
              ),
            ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.8, 0.8)),

            const SizedBox(height: 24),

            Text(
              'Hey there! 👋',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 8),

            Text(
              'I\'m your AI college admissions guide.\nAsk me anything about building your profile, writing essays, or choosing universities.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: context.textSecondary,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 32),

            // Suggestion chips
            ...List.generate(chatSuggestions.length, (index) {
              final suggestion = chatSuggestions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SuggestionCard(
                  icon: suggestion['icon']!,
                  title: suggestion['title']!,
                  prompt: suggestion['prompt']!,
                  onTap: () => onSuggestionTap(suggestion['prompt']!),
                  delay: (400 + index * 100).ms,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String prompt;
  final VoidCallback onTap;
  final Duration delay;

  const _SuggestionCard({
    required this.icon,
    required this.title,
    required this.prompt,
    required this.onTap,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      prompt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: context.textMuted,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: 0.1);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MESSAGE LIST
// ═══════════════════════════════════════════════════════════════════════════

class _MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final bool isLoading;

  const _MessageList({
    required this.messages,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // Typing indicator at the end
        if (index == messages.length && isLoading) {
          return const _TypingIndicator()
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.1);
        }

        final message = messages[index];
        final isFirst = index == 0;
        final isLast = index == messages.length - 1;

        // Don't show system messages in the bubble UI
        if (message.role == MessageRole.system) {
          return const SizedBox.shrink();
        }

        final showAvatar = message.role == MessageRole.assistant &&
            (index == 0 || messages[index - 1].role != MessageRole.assistant);

        return Padding(
          padding: EdgeInsets.only(
            top: isFirst ? 0 : 4,
            bottom: isLast ? 8 : 4,
          ),
          child: _MessageBubble(
            message: message,
            showAvatar: showAvatar,
            isNew: index == messages.length - 1,
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MESSAGE BUBBLE
// ═══════════════════════════════════════════════════════════════════════════

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final bool isNew;

  const _MessageBubble({
    required this.message,
    this.showAvatar = false,
    this.isNew = false,
  });

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    final animDelay = isNew ? 100.ms : Duration.zero;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          // AI Avatar
          if (showAvatar)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8, bottom: 4),
              decoration: BoxDecoration(
                gradient: AppTheme.gradientPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 16,
              ),
            )
          else
            const SizedBox(width: 40),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser
                  ? context.colorScheme.primary
                  : context.surfaceElevated,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isUser ? 20 : 6),
                bottomRight: Radius.circular(isUser ? 6 : 20),
              ),
              border: isUser
                  ? null
                  : Border.all(color: context.borderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: isUser ? Colors.white : context.textPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isUser
                            ? Colors.white.withValues(alpha: 0.6)
                            : context.textMuted,
                      ),
                    ),
                    if (message.isStreaming) ...[
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: isUser
                              ? Colors.white.withValues(alpha: 0.6)
                              : context.colorScheme.primary,
                        ),
                      ),
                    ],
                    if (!isUser && !message.isStreaming) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Clipboard.setData(
                              ClipboardData(text: message.content));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Copied to clipboard',
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.copy_rounded,
                          size: 12,
                          color: context.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TYPING INDICATOR
// ═══════════════════════════════════════════════════════════════════════════

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((c) {
      return Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      );
    }).toList();

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(right: 8, bottom: 4),
          decoration: BoxDecoration(
            gradient: AppTheme.gradientPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: context.surfaceElevated,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: const Radius.circular(6),
              bottomRight: const Radius.circular(20),
            ),
            border: Border.all(color: context.borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animations[index].value),
                    child: child,
                  );
                },
                child: Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ERROR BANNER
// ═══════════════════════════════════════════════════════════════════════════

class _ErrorBanner extends StatelessWidget {
  final String error;
  final VoidCallback onDismiss;

  const _ErrorBanner({required this.error, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.errorRed.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 18,
            color: AppTheme.errorRed,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.errorRed,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: AppTheme.errorRed.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CHAT INPUT
// ═══════════════════════════════════════════════════════════════════════════

class _ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isLoading;

  const _ChatInput({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isLoading,
  });

  @override
  State<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<_ChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 10
            : MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        border: Border(
          top: BorderSide(
            color: context.borderColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text input
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: context.surfaceElevated,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: widget.focusNode.hasFocus
                        ? context.colorScheme.primary.withValues(alpha: 0.5)
                        : context.borderColor,
                    width: widget.focusNode.hasFocus ? 1.5 : 1,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: context.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask about colleges, essays, profile...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15,
                      color: context.textMuted,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => widget.onSend(),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: _hasText && !widget.isLoading
                    ? context.colorScheme.primary
                    : context.borderColor,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: (_hasText && !widget.isLoading)
                      ? widget.onSend
                      : null,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: widget.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.textMuted,
                            ),
                          )
                        : Icon(
                            Icons.arrow_upward_rounded,
                            color: _hasText
                                ? Colors.white
                                : context.textMuted,
                            size: 22,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
