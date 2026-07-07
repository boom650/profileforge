// Essay Coach Screen - Common App & Coalition essay guidance with Indian student tips

import 'dart:convert';
import '../../config/api_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/app_theme.dart';

// ─── API Config ──────────────────────────────────────────────────────────────
final String _kApiBaseUrl = kApiBaseUrl;

// ─── Essay Prompt Model ──────────────────────────────────────────────────────
class EssayPrompt {
  final String id;
  final String platform;
  final int number;
  final String text;
  final int wordLimit;
  final List<String> tips;
  final List<String> indianStudentTips;
  final List<String> examplesOfGoodHooks;
  final List<String> commonMistakes;

  const EssayPrompt({
    required this.id,
    required this.platform,
    required this.number,
    required this.text,
    required this.wordLimit,
    required this.tips,
    required this.indianStudentTips,
    required this.examplesOfGoodHooks,
    required this.commonMistakes,
  });

  factory EssayPrompt.fromJson(Map<String, dynamic> json) {
    return EssayPrompt(
      id: json['id']?.toString() ?? '',
      platform: json['platform'] ?? 'Common App',
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      wordLimit: json['word_limit'] ?? 650,
      tips: List<String>.from(json['tips'] ?? []),
      indianStudentTips: List<String>.from(json['indian_student_tips'] ?? []),
      examplesOfGoodHooks: List<String>.from(json['examples_of_good_hooks'] ?? []),
      commonMistakes: List<String>.from(json['common_mistakes'] ?? []),
    );
  }
}

// ─── Essay Prompts State ─────────────────────────────────────────────────────
enum EssayPromptsStatus { loading, loaded, error }

class EssayPromptsState {
  final EssayPromptsStatus status;
  final List<EssayPrompt> prompts;
  final String? errorMessage;

  const EssayPromptsState({
    this.status = EssayPromptsStatus.loading,
    this.prompts = const [],
    this.errorMessage,
  });

  EssayPromptsState copyWith({
    EssayPromptsStatus? status,
    List<EssayPrompt>? prompts,
    String? errorMessage,
  }) {
    return EssayPromptsState(
      status: status ?? this.status,
      prompts: prompts ?? this.prompts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Platforms extracted from prompts, preserving order
  List<String> get platforms {
    final seen = <String>{};
    final result = <String>[];
    for (final p in prompts) {
      if (seen.add(p.platform)) result.add(p.platform);
    }
    return result;
  }

  List<EssayPrompt> promptsForPlatform(String platform) {
    return prompts.where((p) => p.platform == platform).toList();
  }
}

// ─── Async Notifier for fetching prompts ─────────────────────────────────────
class EssayPromptsNotifier extends StateNotifier<EssayPromptsState> {
  EssayPromptsNotifier() : super(const EssayPromptsState()) {
    fetchPrompts();
  }

  Future<void> fetchPrompts() async {
    state = state.copyWith(status: EssayPromptsStatus.loading);
    try {
      final response = await http.get(
        Uri.parse('$_kApiBaseUrl/api/essay/prompts'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final prompts = data.map((e) => EssayPrompt.fromJson(e)).toList();
        state = state.copyWith(
          status: EssayPromptsStatus.loaded,
          prompts: prompts,
        );
      } else {
        state = state.copyWith(
          status: EssayPromptsStatus.error,
          errorMessage: 'Server returned ${response.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: EssayPromptsStatus.error,
        errorMessage: 'Failed to load prompts. Please check your connection.',
      );
    }
  }

  Future<void> refresh() async => fetchPrompts();
}

final essayPromptsProvider =
    StateNotifierProvider<EssayPromptsNotifier, EssayPromptsState>(
  (ref) => EssayPromptsNotifier(),
);

// ─── Word Count Indicator ────────────────────────────────────────────────────
class WordCountIndicator extends StatelessWidget {
  final int wordCount;
  final int wordLimit;

  const WordCountIndicator({
    super.key,
    required this.wordCount,
    required this.wordLimit,
  });

  Color get _color {
    final ratio = wordCount / wordLimit;
    if (ratio > 1.0) return AppTheme.errorRed;
    if (ratio >= 0.80) return AppTheme.warningAmber;
    return AppTheme.successGreen;
  }

  IconData get _icon {
    final ratio = wordCount / wordLimit;
    if (ratio > 1.0) return Icons.error_outline;
    if (ratio >= 0.80) return Icons.warning_amber_outlined;
    return Icons.check_circle_outline;
  }

  String get _label {
    final ratio = wordCount / wordLimit;
    if (ratio > 1.0) return '${wordCount - wordLimit} over limit';
    if (ratio >= 0.80) return 'Getting close';
    return '$wordCount / $wordLimit words';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color, size: 18),
          const SizedBox(width: 8),
          Text(
            _label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Bullet List Widget ──────────────────────────────────────────────────────
class _BulletList extends StatelessWidget {
  final List<String> items;
  final Color bulletColor;
  final Color? textColor;

  const _BulletList({
    required this.items,
    required this.bulletColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 7),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: bulletColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.55,
                    color: textColor ??
                        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.82),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Essay Prompt Detail Screen ──────────────────────────────────────────────
class EssayPromptDetail extends ConsumerStatefulWidget {
  final EssayPrompt prompt;

  const EssayPromptDetail({super.key, required this.prompt});

  @override
  ConsumerState<EssayPromptDetail> createState() => _EssayPromptDetailState();
}

class _EssayPromptDetailState extends ConsumerState<EssayPromptDetail> {
  late TextEditingController _draftController;
  int _wordCount = 0;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  String get _draftKey => 'essay_draft_${widget.prompt.id}';

  @override
  void initState() {
    super.initState();
    _draftController = TextEditingController();
    _draftController.addListener(_onDraftChanged);
    _loadDraft();
  }

  @override
  void dispose() {
    _draftController.removeListener(_onDraftChanged);
    _draftController.dispose();
    super.dispose();
  }

  void _onDraftChanged() {
    final text = _draftController.text;
    final words =
        text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    if (words != _wordCount || !_hasUnsavedChanges) {
      setState(() {
        _wordCount = words;
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_draftKey);
    if (saved != null && mounted) {
      _draftController.text = saved;
      _hasUnsavedChanges = false;
    }
  }

  Future<void> _saveDraft() async {
    setState(() => _isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_draftKey, _draftController.text);
      if (mounted) {
        setState(() {
          _isSaving = false;
          _hasUnsavedChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text('Draft saved', style: GoogleFonts.inter(fontSize: 14)),
              ],
            ),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e', style: GoogleFonts.inter()),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prompt = widget.prompt;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Prompt ${prompt.number}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _saveDraft,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.accentPurple),
                  )
                : const Icon(Icons.save_rounded, size: 18),
            label: Text(
              _isSaving ? 'Saving...' : 'Save Draft',
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Prompt Text Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.gradientPrimaryDark,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentPurple.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompt.text,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.font_download_outlined,
                            color: Colors.white70, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'Max ${prompt.wordLimit} words',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Tips Section ──
            if (prompt.tips.isNotEmpty) ...[
              const _SectionHeader(
                title: 'Writing Tips',
                icon: Icons.lightbulb_outline_rounded,
                color: AppTheme.accentPurple,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple
                      .withValues(alpha: isDark ? 0.08 : 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        AppTheme.accentPurple.withValues(alpha: 0.18),
                  ),
                ),
                child: _BulletList(
                  items: prompt.tips,
                  bulletColor: AppTheme.accentPurple,
                ),
              ),
              const SizedBox(height: 28),
            ],

            // ── Indian Student Tips ──
            if (prompt.indianStudentTips.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accentGold
                          .withValues(alpha: isDark ? 0.12 : 0.10),
                      AppTheme.accentGold
                          .withValues(alpha: isDark ? 0.05 : 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.accentGold.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGold.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.star_rounded,
                              color: AppTheme.accentGold, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tips for Indian Students',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentGold,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        Icon(Icons.auto_awesome,
                            color: AppTheme.accentGold.withValues(alpha: 0.5),
                            size: 16),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _BulletList(
                      items: prompt.indianStudentTips,
                      bulletColor: AppTheme.accentGold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],

            // ── Examples of Good Hooks ──
            if (prompt.examplesOfGoodHooks.isNotEmpty) ...[
              const _SectionHeader(
                title: 'Examples of Good Hooks',
                icon: Icons.format_quote_rounded,
                color: AppTheme.accentTeal,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal
                      .withValues(alpha: isDark ? 0.08 : 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        AppTheme.accentTeal.withValues(alpha: 0.20),
                  ),
                ),
                child: Column(
                  children: List.generate(
                      prompt.examplesOfGoodHooks.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\u201C',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              color: AppTheme.accentTeal,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              prompt.examplesOfGoodHooks[i],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                height: 1.55,
                                fontStyle: FontStyle.italic,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.82),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 28),
            ],

            // ── Common Mistakes ──
            if (prompt.commonMistakes.isNotEmpty) ...[
              const _SectionHeader(
                title: 'Common Mistakes to Avoid',
                icon: Icons.error_outline_rounded,
                color: AppTheme.errorRed,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed
                      .withValues(alpha: isDark ? 0.08 : 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.errorRed.withValues(alpha: 0.20),
                  ),
                ),
                child: _BulletList(
                  items: prompt.commonMistakes,
                  bulletColor: AppTheme.errorRed,
                ),
              ),
              const SizedBox(height: 28),
            ],

            // ── Draft Area ──
            const _SectionHeader(
              title: 'Your Draft',
              icon: Icons.edit_note_rounded,
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: WordCountIndicator(
                wordCount: _wordCount,
                wordLimit: prompt.wordLimit,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _wordCount > prompt.wordLimit
                      ? AppTheme.errorRed.withValues(alpha: 0.5)
                      : AppTheme.accentPurple.withValues(alpha: 0.3),
                  width: _wordCount > prompt.wordLimit ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _draftController,
                maxLines: 12,
                minLines: 8,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.7,
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Start writing your essay here...\n\nFocus on your unique story. Be authentic, specific, and reflective.',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.30),
                    height: 1.7,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Save Draft Button ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveDraft,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded, size: 20),
                label: Text(
                  _isSaving ? 'Saving Draft...' : 'Save Draft',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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

// ─── Main Essay Coach Screen ─────────────────────────────────────────────────
class EssayCoachScreen extends ConsumerStatefulWidget {
  const EssayCoachScreen({super.key});

  @override
  ConsumerState<EssayCoachScreen> createState() => _EssayCoachScreenState();
}

class _EssayCoachScreenState extends ConsumerState<EssayCoachScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // TabController will be rebuilt when platforms change via a listener
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _rebuildTabs(int count) {
    if (_tabController.length != count && count > 0) {
      final oldIndex = _tabController.index.clamp(0, count - 1);
      _tabController.dispose();
      _tabController = TabController(length: count, vsync: this);
      _tabController.index = oldIndex;
    }
  }

  void _openPrompt(EssayPrompt prompt) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EssayPromptDetail(prompt: prompt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final promptsState = ref.watch(essayPromptsProvider);
    final platforms = promptsState.platforms;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (platforms.isNotEmpty) {
      _rebuildTabs(platforms.length);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _buildHeader(isDark, promptsState),
            // ── Content ──
            Expanded(
              child: _buildContent(promptsState, platforms, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, EssayPromptsState promptsState) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppTheme.gradientPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Essay Coach',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      'Craft compelling essays for your applications',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Search Bar ──
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2D5C8),
              ),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search prompts...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Platform Tabs ──
          if (promptsState.status == EssayPromptsStatus.loaded &&
              promptsState.platforms.isNotEmpty)
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerHeight: 0,
              indicatorPadding: const EdgeInsets.only(bottom: 2),
              tabs: promptsState.platforms.map((p) => Tab(text: p)).toList(),
            ),

          if (promptsState.status == EssayPromptsStatus.loaded &&
              promptsState.platforms.isNotEmpty)
            const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildContent(
    EssayPromptsState state,
    List<String> platforms,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    switch (state.status) {
      case EssayPromptsStatus.loading:
        return _buildLoading(theme);
      case EssayPromptsStatus.error:
        return _buildError(state.errorMessage ?? 'Unknown error', theme);
      case EssayPromptsStatus.loaded:
        if (platforms.isEmpty) {
          return _buildEmpty(theme);
        }
        return TabBarView(
          controller: _tabController,
          children: platforms.map((platform) {
            return _buildPromptList(
              state.promptsForPlatform(platform),
              platform,
              theme,
              isDark,
            );
          }).toList(),
        );
    }
  }

  Widget _buildLoading(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.accentPurple.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: AppTheme.accentPurple,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading essay prompts...',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppTheme.errorRed,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(essayPromptsProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Retry',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentPurple,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.article_outlined,
                color: AppTheme.accentPurple,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No prompts available',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Essay prompts will appear here once they are added.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptList(
    List<EssayPrompt> prompts,
    String platform,
    ThemeData theme,
    bool isDark,
  ) {
    final filtered = _searchQuery.isEmpty
        ? prompts
        : prompts
            .where((p) =>
                p.text.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.tips.any((t) =>
                    t.toLowerCase().contains(_searchQuery.toLowerCase())))
            .toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
              ),
              const SizedBox(height: 16),
              Text(
                'No matching prompts',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final prompt = filtered[index];
        return _buildPromptCard(prompt, theme, isDark);
      },
    );
  }

  Widget _buildPromptCard(EssayPrompt prompt, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () => _openPrompt(prompt),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFE2D5C8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: number + word limit badge
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${prompt.number}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    prompt.text.length > 100
                        ? '${prompt.text.substring(0, 100)}...'
                        : prompt.text,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Bottom row: word limit + tag chips
            Row(
              children: [
                // Word limit badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${prompt.wordLimit} words',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentPurple,
                    ),
                  ),
                ),

                const Spacer(),

                // Has tips indicator
                if (prompt.tips.isNotEmpty)
                  _buildTag('Tips', AppTheme.accentPurple, isDark),
                if (prompt.indianStudentTips.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _buildTag('🇮🇳', AppTheme.accentGold, isDark),
                ],
                if (prompt.commonMistakes.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _buildTag('Avoid', AppTheme.errorRed, isDark),
                ],

                const SizedBox(width: 8),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
