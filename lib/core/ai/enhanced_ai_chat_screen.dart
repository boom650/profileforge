import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/ai/ai_service.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/core/ai/psychology_adapter.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Enhanced AI Chat — Psychology-adapted conversation with premium UI.
///
/// Features:
/// - Psychology-adapted welcome message
/// - Glass morphism UI
/// - Feedback buttons (helpful/not helpful)
/// - Follow-up suggestion chips
/// - Typing indicator with shimmer
/// - Profile info sheet showing personality traits
///
/// Based on research:
/// - 03-student-psychology-behavioral-design.md
/// - 03ab-conversational-ai-ux-patterns.md
/// - 03ac-onboarding-flow-optimization.md
/// ────────────────────────────────────────────────────────────────────────────
class EnhancedAIChatScreen extends ConsumerStatefulWidget {
  const EnhancedAIChatScreen({
    super.key,
    this.profileId,
    this.initialProfile,
  });

  final String? profileId;
  final PsychologicalProfile? initialProfile;

  @override
  ConsumerState<EnhancedAIChatScreen> createState() =>
      _EnhancedAIChatScreenState();
}

class _EnhancedAIChatScreenState extends ConsumerState<EnhancedAIChatScreen>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _ai = AIService();
  final List<_ChatMessage> _messages = [];
  bool _isGenerating = false;
  bool _hasProvider = false;
  PsychologicalProfile? _profile;
  late AnimationController _profileSheetController;

  // Follow-up suggestions
  List<String> _followUpSuggestions = [];

  @override
  void initState() {
    super.initState();
    _profile = widget.initialProfile;
    _profileSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _checkProvider();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _profileSheetController.dispose();
    super.dispose();
  }

  Future<void> _checkProvider() async {
    final name = await _ai.getActiveProviderName();
    if (mounted) {
      // Load the persisted psych profile (v7) so the AI stays consistent
      // even when the user opens chat fresh from the nav bar.
      final pid = widget.profileId ?? 'local-profile';
      final persisted = await ref.read(
        psychologicalProfileProvider(pid).future,
      );
      if (mounted && persisted != null) {
        setState(() => _profile = persisted);
      }
      setState(() => _hasProvider = name != 'None');
      if (_hasProvider) {
        _addWelcomeMessage();
      }
    }
  }

  void _addWelcomeMessage() {
    final welcome = PsychologyAdapter.getPersonalizedWelcome(
      profile: _profile,
      providerName: _ai.getActiveProviderNameSync(),
    );

    setState(() {
      _messages.add(_ChatMessage(
        role: 'assistant',
        content: welcome,
        provider: _ai.getActiveProviderNameSync(),
        timestamp: DateTime.now(),
      ));
      _followUpSuggestions = PsychologyAdapter.getFollowUpSuggestions(
        profile: _profile,
        lastResponse: '',
      );
    });
  }

  Future<void> _sendMessage({String? overrideText}) async {
    final text = overrideText ?? _controller.text.trim();
    if (text.isEmpty || _isGenerating) return;

    setState(() {
      _messages.add(_ChatMessage(
        role: 'user',
        content: text,
        timestamp: DateTime.now(),
      ));
      _isGenerating = true;
      _followUpSuggestions = [];
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // Generate adapted system prompt
      final adaptedPrompt = PsychologyAdapter.generateAdaptedPrompt(
        profile: _profile,
        conversationHistory: _messages
            .where((m) => m.role == 'user' || m.role == 'assistant')
            .map((m) => ChatMessage(role: m.role, content: m.content))
            .toList(),
      );

      final chatMessages = _messages
          .where((m) => m.role == 'user' || m.role == 'assistant')
          .map((m) => ChatMessage(role: m.role, content: m.content))
          .toList();

      final response = await _ai.chat(
        messages: chatMessages,
        systemPromptOverride: adaptedPrompt,
      );

      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            role: 'assistant',
            content: response,
            provider: _ai.getActiveProviderNameSync(),
            timestamp: DateTime.now(),
          ));
          _isGenerating = false;
          _followUpSuggestions = PsychologyAdapter.getFollowUpSuggestions(
            profile: _profile,
            lastResponse: response,
          );
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            role: 'assistant',
            content: 'Sorry, something went wrong. Please try again.',
            provider: _ai.getActiveProviderNameSync(),
            timestamp: DateTime.now(),
            isError: true,
          ));
          _isGenerating = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ProfileInfoSheet(profile: _profile),
    );
  }

  void _toggleProfile() {
    if (_profileSheetController.isCompleted) {
      _profileSheetController.reverse();
    } else {
      _showProfileSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : Palette.cream,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF1A0F0A), Palette.surface0, Palette.black]
                : [
                    const Color(0xFFFBF1E3),
                    Palette.cream,
                    Colors.white
                  ],
          ),
        ),
        child: Column(
          children: [
            // ── Header ──
            _buildHeader(dark),

            // ── Messages ──
            Expanded(
              child: !_hasProvider
                  ? _buildNoProviderView(dark)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: _messages.length + (_isGenerating ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return _TypingIndicator(dark: dark);
                        }
                        return _MessageBubble(
                          message: _messages[index],
                          dark: dark,
                          onFeedback: (helpful) {
                            // TODO: Store feedback
                          },
                        );
                      },
                    ),
            ),

            // ── Follow-up Suggestions ──
            if (_followUpSuggestions.isNotEmpty && !_isGenerating)
              _buildFollowUpSuggestions(dark),

            // ── Input ──
            _buildInput(dark),
          ],
        ),
      ),
    );
  }

  /// ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(bool dark) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 8, 16, 12),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface0.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: dark
                ? Palette.border.withValues(alpha: 0.3)
                : const Color(0xFFEDE3D6),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar + Name
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: Palette.gradientPrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, size: 20, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Mentor',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
                Text(
                  _hasProvider ? 'Psychology-adapted' : 'Not configured',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color:
                        _hasProvider ? Palette.success : Palette.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // Profile button
          if (_profile != null)
            GestureDetector(
              onTap: _toggleProfile,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Palette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: Palette.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.psychology,
                  size: 18,
                  color: Palette.primary,
                ),
              ),
            ),

          const SizedBox(width: 8),

          // Refresh button
          GestureDetector(
            onTap: () {
              setState(() => _messages.clear());
              _checkProvider();
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Icon(
                Icons.refresh,
                size: 18,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ── No Provider View ─────────────────────────────────────────────────────
  Widget _buildNoProviderView(bool dark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome, size: 36, color: Colors.white),
              ),
            ).animate().scale(
                delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text(
              'AI Not Configured',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              'Add an API key to start chatting with your psychology-adapted admissions mentor.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Palette.textSecondary,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/ai-settings'),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Configure AI',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  /// ── Follow-up Suggestions ────────────────────────────────────────────────
  Widget _buildFollowUpSuggestions(bool dark) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _followUpSuggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final suggestion = _followUpSuggestions[index];
          return GestureDetector(
            onTap: () => _sendMessage(overrideText: suggestion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: dark
                    ? Palette.surface1.withValues(alpha: 0.6)
                    : Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: Palette.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                suggestion,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: Palette.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }

  /// ── Input ────────────────────────────────────────────────────────────────
  Widget _buildInput(bool dark) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface0.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: dark
                ? Palette.border.withValues(alpha: 0.3)
                : const Color(0xFFEDE3D6),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dark ? Palette.border : const Color(0xFFEDE3D6),
                ),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask about essays, activities, study tips...',
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 15,
                    color: Palette.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          GestureDetector(
            onTap: _isGenerating ? null : _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: _isGenerating ? null : Palette.gradientPrimary,
                color: _isGenerating
                    ? dark
                        ? Palette.surface2
                        : const Color(0xFFEDE3D6)
                    : null,
                borderRadius: BorderRadius.circular(9999),
                boxShadow: _isGenerating
                    ? null
                    : [
                        BoxShadow(
                          color: Palette.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: _isGenerating
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            dark ? Palette.textTertiary : Palette.textSecondary,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── Chat Message Model ─────────────────────────────────────────────────────
class _ChatMessage {
  const _ChatMessage({
    required this.role,
    required this.content,
    this.provider,
    required this.timestamp,
    this.isError = false,
  });

  final String role;
  final String content;
  final String? provider;
  final DateTime timestamp;
  final bool isError;
}

/// ── Message Bubble ─────────────────────────────────────────────────────────
class _MessageBubble extends StatefulWidget {
  const _MessageBubble({
    required this.message,
    required this.dark,
    required this.onFeedback,
  });

  final _ChatMessage message;
  final bool dark;
  final Function(bool helpful) onFeedback;

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  bool? _feedback;

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.role == 'user';
    final isError = widget.message.isError;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: isError
                        ? LinearGradient(colors: [
                            Palette.error,
                            Palette.error.withValues(alpha: 0.7)
                          ])
                        : Palette.gradientPrimary,
                  ),
                  child: Center(
                    child: Icon(
                      isError ? Icons.error_outline : Icons.auto_awesome,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Palette.primary
                        : widget.dark
                            ? Palette.surface1
                            : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: isError
                                ? Palette.error.withValues(alpha: 0.3)
                                : widget.dark
                                    ? Palette.border
                                    : const Color(0xFFEDE3D6),
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.message.content,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          height: 1.6,
                          color: isUser
                              ? Colors.white
                              : isError
                                  ? Palette.error
                                  : (widget.dark
                                      ? Palette.textPrimary
                                      : Palette.textInverse),
                        ),
                      ),
                      if (widget.message.provider != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Palette.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'via ${widget.message.provider}',
                              style: GoogleFonts.nunito(
                                fontSize: 10,
                                color: widget.dark
                                    ? Palette.textTertiary
                                    : Palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 10),
            ],
          ),

          // Feedback buttons (only for assistant messages)
          if (!isUser && !isError) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: Row(
                children: [
                  _FeedbackButton(
                    icon: Icons.thumb_up_outlined,
                    isActive: _feedback == true,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _feedback = true);
                      widget.onFeedback(true);
                    },
                    dark: widget.dark,
                  ),
                  const SizedBox(width: 8),
                  _FeedbackButton(
                    icon: Icons.thumb_down_outlined,
                    isActive: _feedback == false,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _feedback = false);
                      widget.onFeedback(false);
                    },
                    dark: widget.dark,
                  ),
                  const SizedBox(width: 8),
                  _FeedbackButton(
                    icon: Icons.copy,
                    isActive: false,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Clipboard.setData(
                          ClipboardData(text: widget.message.content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied to clipboard'),
                          backgroundColor: Palette.success,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    dark: widget.dark,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05);
  }
}

/// ── Feedback Button ────────────────────────────────────────────────────────
class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.dark,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isActive
              ? Palette.primary.withValues(alpha: 0.15)
              : dark
                  ? Palette.surface2.withValues(alpha: 0.5)
                  : const Color(0xFFF4ECE1),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isActive
                ? Palette.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isActive
              ? Palette.primary
              : dark
                  ? Palette.textTertiary
                  : Palette.textSecondary,
        ),
      ),
    );
  }
}

/// ── Typing Indicator ───────────────────────────────────────────────────────
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: Palette.gradientPrimary,
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, size: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: dark ? Palette.surface1 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: dark ? Palette.border : const Color(0xFFEDE3D6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AnimatedDot(delay: 0, dark: dark),
                const SizedBox(width: 5),
                _AnimatedDot(delay: 200, dark: dark),
                const SizedBox(width: 5),
                _AnimatedDot(delay: 400, dark: dark),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _AnimatedDot extends StatefulWidget {
  const _AnimatedDot({required this.delay, required this.dark});
  final int delay;
  final bool dark;

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = (_controller.value + widget.delay / 1000) % 1.0;
        final scale = value < 0.5
            ? 1.0 + (value * 2 * 0.4)
            : 1.0 - ((value - 0.5) * 2 * 0.4);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: Palette.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

/// ── Profile Info Sheet ─────────────────────────────────────────────────────
class _ProfileInfoSheet extends StatelessWidget {
  const _ProfileInfoSheet({required this.profile});
  final PsychologicalProfile? profile;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final p = profile;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: dark ? Palette.surface0 : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: dark ? Palette.border : const Color(0xFFEDE3D6),
          ),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: dark ? Palette.surface3 : Palette.line,
              borderRadius: BorderRadius.circular(9999),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: Palette.gradientPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.psychology, size: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Psychology Profile',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color:
                              dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                      Text(
                        'How the AI adapts to you',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color:
                          dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Traits
          Expanded(
            child: p == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.psychology_outlined,
                          size: 48,
                          color: Palette.primary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No profile yet',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: dark
                                ? Palette.textPrimary
                                : Palette.textInverse,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Complete the psychology onboarding\nto see your personality traits',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _TraitSection(
                        title: 'Big Five Personality',
                        traits: [
                          ('Openness', p.openness, Palette.info),
                          (
                            'Conscientiousness',
                            p.conscientiousness,
                            Palette.success
                          ),
                          ('Extraversion', p.extraversion, Palette.warning),
                          ('Agreeableness', p.agreeableness, Palette.primary),
                          ('Neuroticism', p.neuroticism, Palette.error),
                        ],
                        dark: dark,
                      ),
                      const SizedBox(height: 24),
                      _TraitSection(
                        title: 'Self-Determination Theory',
                        traits: [
                          ('Autonomy', p.autonomy, Palette.info),
                          ('Competence', p.competence, Palette.success),
                          ('Relatedness', p.relatedness, Palette.primary),
                        ],
                        dark: dark,
                      ),
                      const SizedBox(height: 24),
                      _TraitSection(
                        title: 'Growth Indicators',
                        traits: [
                          ('Growth Mindset', p.growthMindset, Palette.success),
                          ('Self-Efficacy', p.selfEfficacy, Palette.warning),
                        ],
                        dark: dark,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// ── Trait Section ──────────────────────────────────────────────────────────
class _TraitSection extends StatelessWidget {
  const _TraitSection({
    required this.title,
    required this.traits,
    required this.dark,
  });

  final String title;
  final List<(String, double, Color)> traits;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        const SizedBox(height: 12),
        ...traits.map((trait) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trait.$1,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Palette.textSecondary,
                      ),
                    ),
                    Text(
                      '${(trait.$2 * 100).round()}%',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: trait.$3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: trait.$2.clamp(0.0, 1.0),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [trait.$3, trait.$3.withValues(alpha: 0.7)],
                        ),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
