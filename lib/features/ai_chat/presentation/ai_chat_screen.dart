import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ai/ai_providers.dart';
import '../../../core/ai/fallback_llm_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/haptic_utils.dart';
import '../../../core/widgets/tap_scale.dart';
import '../application/ai_chat_provider.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AI Chat screen — Premium conversational UI with fallback provider display.
/// ────────────────────────────────────────────────────────────────────────────
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.mediumImpact();
    _controller.clear();
    _focusNode.requestFocus();
    await ref.read(aiChatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  String _activeProviderName() {
    try {
      final client = getFallbackClient();
      final health = client.getHealthStatus();
      for (final p in health) {
        if (!(p['isOnCooldown'] ?? true)) {
          return p['name'] ?? 'Unknown';
        }
      }
    } catch (_) {}
    return 'AI';
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);
    final aiConfigured = ref.watch(aiConfiguredProvider);

    return Scaffold(
      backgroundColor: Palette.black,
      appBar: AppBar(
        backgroundColor: Palette.surface1,
        elevation: 0,
        title: Row(
          children: [
            // Pulsing AI avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Palette.primary, Palette.accent],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ProfileForge AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _activeProviderName(),
                  style: TextStyle(
                    color: Palette.primary.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (chatState.messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.add_comment_outlined, color: Colors.white60, size: 22),
              onPressed: HapticUtils.light,
              tooltip: 'New conversation',
            ),
        ],
      ),
      body: Column(
        children: [
          // AI not configured banner
          aiConfigured.when(
            data: (configured) => configured
                ? const SizedBox.shrink()
                : _buildSetupBanner(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Error banner
          if (chatState.error != null) _buildErrorBanner(chatState.error!),

          // Messages
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessage(chatState.messages[index], index);
                    },
                  ),
          ),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildSetupBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Palette.primary.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(Icons.key, color: Palette.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI is ready — 3 providers configured with automatic failover.',
              style: TextStyle(color: Palette.primary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Palette.error.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Palette.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Palette.error, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Palette.error, size: 16),
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.read(aiChatProvider.notifier).dismissError();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.3);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Glowing orb
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Palette.primary.withValues(alpha: 0.3),
                    Palette.primary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Palette.primary, Palette.accent],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Palette.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.5, 0.5)),
            const SizedBox(height: 24),
            const Text(
              'Your Admissions Architect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 8),
            Text(
              'Ask me anything about your college\napplication strategy.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
            const SizedBox(height: 28),
            // Quick action chips
            ...List.generate(4, (i) {
              final actions = [
                ('Analyze my activities', Icons.psychology),
                ('Review my essay', Icons.article),
                ('Readiness check', Icons.assessment),
                ('Daily mission', Icons.flag),
              ];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TapScale(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _controller.text = actions[i].$1;
                    _send();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Palette.surface1,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Palette.border.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(actions[i].$2, size: 18, color: Palette.primary),
                        const SizedBox(width: 12),
                        Text(
                          actions[i].$1,
                          style: TextStyle(
                            color: Palette.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 12, color: Palette.textTertiary),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 400 + i * 100), duration: 300.ms)
                 .slideX(begin: 0.1),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, int index) {
    final isUser = message.isUser;
    final now = message.timestamp;
    final timeStr = _formatTime(now);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser
                  ? Palette.primary.withValues(alpha: 0.15)
                  : Palette.surface1,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              border: Border.all(
                color: isUser
                    ? Palette.primary.withValues(alpha: 0.25)
                    : Palette.border.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Palette.primary, Palette.accent]),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 10),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ProfileForge AI',
                          style: TextStyle(
                            color: Palette.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                SelectableText(
                  message.text,
                  style: TextStyle(
                    color: Palette.textPrimary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Timestamp + copy button row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(
                    color: Palette.textTertiary,
                    fontSize: 10,
                  ),
                ),
                if (!isUser) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(text: message.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Copied to clipboard'),
                          backgroundColor: Palette.surface2,
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                    child: Icon(Icons.copy_rounded, size: 12, color: Palette.textTertiary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms, delay: Duration(milliseconds: index * 30))
     .slideY(begin: 0.15, duration: 300.ms);
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Palette.surface1,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: Palette.border.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouncing dots
            ...List.generate(3, (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _BouncingDot(delay: i * 200),
            )),
            const SizedBox(width: 10),
            Text(
              'Thinking...',
              style: TextStyle(color: Palette.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Palette.surface1,
        border: Border(
          top: BorderSide(
            color: _isFocused
                ? Palette.primary.withValues(alpha: 0.3)
                : Palette.border.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.black,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isFocused
                        ? Palette.primary.withValues(alpha: 0.4)
                        : Palette.border.withValues(alpha: 0.2),
                    width: _isFocused ? 1.5 : 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: 'Ask about your application...',
                    hintStyle: TextStyle(color: Palette.textTertiary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            TapScale(
              onTap: ref.watch(aiChatProvider).isLoading ? null : _send,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: ref.watch(aiChatProvider).isLoading
                      ? null
                      : const LinearGradient(
                          colors: [Palette.primary, Palette.accent],
                        ),
                  color: ref.watch(aiChatProvider).isLoading
                      ? Palette.surface2
                      : null,
                  shape: BoxShape.circle,
                  boxShadow: ref.watch(aiChatProvider).isLoading
                      ? null
                      : [
                          BoxShadow(
                            color: Palette.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: -2,
                          ),
                        ],
                ),
                child: Center(
                  child: ref.watch(aiChatProvider).isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Palette.textTertiary,
                          ),
                        )
                      : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}';
  }
}

/// Bouncing dot animation for typing indicator.
class _BouncingDot extends StatefulWidget {
  final int delay;
  const _BouncingDot({this.delay = 0});

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: Palette.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
