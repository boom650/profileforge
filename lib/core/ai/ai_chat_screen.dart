import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'ai_service.dart';

/// AI Chat — real conversation with ProfileForge AI.
class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _ai = AIService();
  final List<ChatBubble> _messages = [];
  bool _isGenerating = false;
  bool _hasProvider = false;

  @override
  void initState() {
    super.initState();
    _checkProvider();
  }

  Future<void> _checkProvider() async {
    final name = await _ai.getActiveProviderName();
    if (mounted) {
      setState(() => _hasProvider = name != 'None');
      if (_hasProvider) {
        _messages.add(ChatBubble(
          role: 'assistant',
          content: 'Hey! I\'m your ProfileForge admissions AI. Ask me about:\n\n'
              '• Essay brainstorming & feedback\n'
              '• Activity planning for your target schools\n'
              '• Study strategies for weak subjects\n'
              '• How to stand out in applications\n\n'
              'What would you like help with?',
          provider: name,
        ));
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isGenerating) return;

    setState(() {
      _messages.add(ChatBubble(role: 'user', content: text));
      _isGenerating = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final chatMessages = _messages
          .where((m) => m.role == 'user' || m.role == 'assistant')
          .map((m) => ChatMessage(role: m.role, content: m.content))
          .toList();

      final response = await _ai.chat(messages: chatMessages);

      if (mounted) {
        setState(() {
          _messages.add(ChatBubble(role: 'assistant', content: response));
          _isGenerating = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatBubble(
            role: 'assistant',
            content: 'Sorry, something went wrong. Please try again.',
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

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('AI Mentor'),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _messages.clear());
              _checkProvider();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: !_hasProvider
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 48,
                      color: Palette.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AI Not Configured',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add an API key in AI Settings to start chatting with your admissions mentor.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dark ? Palette.textSecondary : Palette.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const _AISettingsPlaceholder(),
                        ),
                      ),
                      icon: const Icon(Icons.settings),
                      label: const Text('Configure AI'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Messages.
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isGenerating ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return _TypingIndicator(dark: dark);
                      }
                      return _ChatBubbleWidget(
                        message: _messages[index],
                        dark: dark,
                      );
                    },
                  ),
                ),

                // Input.
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dark ? Palette.surface0 : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: dark ? Palette.border : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            style: TextStyle(
                              color: dark ? Palette.textPrimary : Palette.textInverse,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ask about essays, activities, study tips...',
                              hintStyle: TextStyle(
                                color: dark ? Palette.textTertiary : Palette.textSecondary,
                              ),
                              filled: true,
                              fillColor: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _isGenerating ? null : _sendMessage,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: _isGenerating
                                  ? null
                                  : Palette.gradientPrimary,
                              color: _isGenerating ? Palette.surface2 : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.send_rounded,
                              size: 20,
                              color: _isGenerating
                                  ? Palette.textTertiary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ChatBubble {
  const ChatBubble({
    required this.role,
    required this.content,
    this.provider,
  });
  final String role;
  final String content;
  final String? provider;
}

class _ChatBubbleWidget extends StatelessWidget {
  const _ChatBubbleWidget({required this.message, required this.dark});
  final ChatBubble message;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? Palette.primary
                    : (dark ? Palette.surface1 : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: dark ? Palette.border : const Color(0xFFE2E8F0),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : (dark ? Palette.textPrimary : Palette.textInverse),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  if (message.provider != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'via ${message.provider}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isUser
                            ? Colors.white.withValues(alpha: 0.6)
                            : (dark ? Palette.textTertiary : Palette.textSecondary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: Palette.gradientPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: dark ? Palette.surface1 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: dark ? Palette.border : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(delay: 0, dark: dark),
                const SizedBox(width: 4),
                _Dot(delay: 200, dark: dark),
                const SizedBox(width: 4),
                _Dot(delay: 400, dark: dark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay, required this.dark});
  final int delay;
  final bool dark;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
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
        return Opacity(
          opacity: (_controller.value + widget.delay / 1000) % 1.0 < 0.5 ? 1.0 : 0.3,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: widget.dark ? Palette.textTertiary : Palette.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

/// Placeholder for navigation — actual AI settings is in core/ai/.
class _AISettingsPlaceholder extends StatelessWidget {
  const _AISettingsPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Opening AI Settings...')));
  }
}
