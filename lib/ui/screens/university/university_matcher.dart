import 'dart:convert';
import '../../../config/api_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';

final String apiBaseMatcher = kApiBaseUrl;

// ─── Match Result Model ─────────────────────────────────────────────────────

class MatchResult {
  final String id;
  final String name;
  final String country;
  final String city;
  final double fitScore;
  final String classification; // safety, target, reach, dream
  final double acceptanceRate;
  final double tuitionUsd;
  final int? rankingQs;
  final List<String> strengths;
  final bool hasNeedBasedAid;
  final bool hasMeritScholarships;

  const MatchResult({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.fitScore,
    required this.classification,
    required this.acceptanceRate,
    required this.tuitionUsd,
    this.rankingQs,
    this.strengths = const [],
    this.hasNeedBasedAid = false,
    this.hasMeritScholarships = false,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      fitScore: (json['fit_score'] as num?)?.toDouble() ?? 0,
      classification: json['classification'] ?? '',
      acceptanceRate: (json['acceptance_rate'] as num?)?.toDouble() ?? 0,
      tuitionUsd: (json['tuition_usd'] as num?)?.toDouble() ?? 0,
      rankingQs: json['ranking_qs'] as int?,
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      hasNeedBasedAid: json['has_need_based_aid'] as bool? ?? false,
      hasMeritScholarships: json['has_merit_scholarships'] as bool? ?? false,
    );
  }
}

// ─── Classification helpers ─────────────────────────────────────────────────

Color _classificationColor(String classification) {
  switch (classification.toLowerCase()) {
    case 'safety':
      return const Color(0xFF16A34A); // Green
    case 'target':
      return const Color(0xFF2563EB); // Blue
    case 'reach':
      return const Color(0xFFF97316); // Orange
    case 'dream':
      return const Color(0xFFDC2626); // Red
    default:
      return AppTheme.primary;
  }
}

IconData _classificationIcon(String classification) {
  switch (classification.toLowerCase()) {
    case 'safety':
      return Icons.check_circle_rounded;
    case 'target':
      return Icons.gps_fixed_rounded;
    case 'reach':
      return Icons.trending_up_rounded;
    case 'dream':
      return Icons.auto_awesome_rounded;
    default:
      return Icons.school_rounded;
  }
}

String _countryFlag(String country) {
  switch (country) {
    case 'US':
      return '🇺🇸';
    case 'UK':
      return '🇬🇧';
    case 'Canada':
      return '🇨🇦';
    case 'Australia':
      return '🇦🇺';
    case 'EU':
      return '🇪🇺';
    default:
      return '🌍';
  }
}

// ─── Interests List ─────────────────────────────────────────────────────────

const List<String> _allInterests = [
  'Computer Science',
  'Engineering',
  'Medicine',
  'Business',
  'Law',
  'Arts',
  'Science',
  'Mathematics',
  'Design',
  'Economics',
  'Psychology',
  'Architecture',
  'Education',
  'Nursing',
];

const List<String> _countryOptions = [
  'Any',
  'US',
  'UK',
  'Canada',
  'Australia',
  'EU',
];

// ─── Matcher Screen ─────────────────────────────────────────────────────────

class UniversityMatcherScreen extends ConsumerStatefulWidget {
  const UniversityMatcherScreen({super.key});

  @override
  ConsumerState<UniversityMatcherScreen> createState() =>
      _UniversityMatcherScreenState();
}

class _UniversityMatcherScreenState
    extends ConsumerState<UniversityMatcherScreen> {
  // Input controllers
  final _gpaController = TextEditingController();
  final _satController = TextEditingController();
  String _selectedCountry = 'Any';
  double _budget = 50000;
  final Set<String> _selectedInterests = {};
  bool _isSubmitting = false;
  String? _error;
  List<MatchResult> _results = [];
  bool _hasSubmitted = false;

  @override
  void dispose() {
    _gpaController.dispose();
    _satController.dispose();
    super.dispose();
  }

  Future<void> _submitMatch() async {
    HapticFeedback.mediumImpact();

    // Validate inputs
    final gpa = double.tryParse(_gpaController.text);
    if (gpa == null || gpa < 0 || gpa > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid GPA (0.0 - 4.0)',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final body = {
        'gpa': gpa,
        'sat': int.tryParse(_satController.text),
        'country': _selectedCountry == 'Any' ? null : _selectedCountry,
        'budget': _budget,
        'interests': _selectedInterests.toList(),
      };

      // Remove null values
      body.removeWhere((key, value) => value == null);

      final response = await http
          .post(
            Uri.parse('$apiBaseMatcher/api/universities/match'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _results = data.map((j) => MatchResult.fromJson(j)).toList();
          _isSubmitting = false;
          _hasSubmitted = true;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isSubmitting = false;
        _hasSubmitted = true;
      });
    }
  }

  void _resetForm() {
    HapticFeedback.lightImpact();
    setState(() {
      _gpaController.clear();
      _satController.clear();
      _selectedCountry = 'Any';
      _budget = 50000;
      _selectedInterests.clear();
      _isSubmitting = false;
      _error = null;
      _results = [];
      _hasSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceBg,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'University Matcher',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        actions: [
          if (_hasSubmitted)
            IconButton(
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Reset',
            ),
        ],
      ),
      body: _hasSubmitted ? _buildResultsView() : _buildFormView(),
    );
  }

  // ── Form View ──────────────────────────────────────────────────────────

  Widget _buildFormView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'Find Your Perfect Match',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your profile and we\'ll match you with universities that fit you best.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),

          const SizedBox(height: 24),

          // GPA Input
          _buildInputSection(
            title: 'GPA',
            subtitle: 'On a 4.0 scale',
            child: TextField(
              controller: _gpaController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                hintText: 'e.g., 3.8',
                prefixIcon: const Icon(Icons.school_rounded,
                    color: AppTheme.primary, size: 20),
                filled: true,
                fillColor: context.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppTheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
              ),
              style: GoogleFonts.inter(
                fontSize: 16,
                color: context.textPrimary,
              ),
            ),
          ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.04),

          const SizedBox(height: 16),

          // SAT Input
          _buildInputSection(
            title: 'SAT Score',
            subtitle: '400 - 1600',
            child: TextField(
              controller: _satController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: InputDecoration(
                hintText: 'e.g., 1450',
                prefixIcon: const Icon(Icons.quiz_rounded,
                    color: AppTheme.secondary, size: 20),
                filled: true,
                fillColor: context.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppTheme.secondary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
              ),
              style: GoogleFonts.inter(
                fontSize: 16,
                color: context.textPrimary,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.04),

          const SizedBox(height: 16),

          // Country Dropdown
          _buildInputSection(
            title: 'Preferred Country',
            subtitle: 'Where do you want to study?',
            child: Container(
              decoration: BoxDecoration(
                color: context.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCountry,
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.primary),
                  items: _countryOptions.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          if (c != 'Any')
                            Text(
                              _countryFlag(c),
                              style: const TextStyle(fontSize: 18),
                            ),
                          if (c != 'Any') const SizedBox(width: 8),
                          Text(
                            c,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedCountry = val);
                    }
                  },
                ),
              ),
            ),
          ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.04),

          const SizedBox(height: 16),

          // Budget Slider
          _buildInputSection(
            title: 'Annual Budget',
            subtitle: '\$${(_budget / 1000).toStringAsFixed(0)}k per year',
            child: Column(
              children: [
                Slider(
                  value: _budget,
                  min: 0,
                  max: 60000,
                  divisions: 60,
                  label: '\$${(_budget / 1000).toStringAsFixed(0)}k',
                  onChanged: (val) {
                    setState(() => _budget = val);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$0',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: context.textMuted,
                      ),
                    ),
                    Text(
                      '\$60k',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.04),

          const SizedBox(height: 16),

          // Interests Chips
          _buildInputSection(
            title: 'Interests',
            subtitle: 'Select areas of interest',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allInterests.map((interest) {
                final selected = _selectedInterests.contains(interest);
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (selected) {
                        _selectedInterests.remove(interest);
                      } else {
                        _selectedInterests.add(interest);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primary.withValues(alpha: 0.12)
                          : context.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppTheme.primary
                            : context.borderColor,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      interest,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                        color: selected
                            ? AppTheme.primary
                            : context.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.04),

          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitMatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.primary.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
              child: _isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Finding Matches...',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Find My Matches',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInputSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: context.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  // ── Results View ───────────────────────────────────────────────────────

  Widget _buildResultsView() {
    if (_error != null) {
      return _buildErrorWidget();
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64, color: AppTheme.textMuted.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              'No matches found',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your criteria',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: context.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Group by classification
    final safety =
        _results.where((r) => r.classification == 'safety').toList();
    final target =
        _results.where((r) => r.classification == 'target').toList();
    final reach =
        _results.where((r) => r.classification == 'reach').toList();
    final dream =
        _results.where((r) => r.classification == 'dream').toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Summary header
        SliverToBoxAdapter(
          child: _buildResultsSummary(),
        ),
        // Safety
        if (safety.isNotEmpty) ...[
          _buildClassificationHeader(
              'Safety Schools', 'safety', safety.length),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildResultCard(safety[i]),
                ),
                childCount: safety.length,
              ),
            ),
          ),
        ],
        // Target
        if (target.isNotEmpty) ...[
          _buildClassificationHeader(
              'Target Schools', 'target', target.length),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildResultCard(target[i]),
                ),
                childCount: target.length,
              ),
            ),
          ),
        ],
        // Reach
        if (reach.isNotEmpty) ...[
          _buildClassificationHeader(
              'Reach Schools', 'reach', reach.length),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildResultCard(reach[i]),
                ),
                childCount: reach.length,
              ),
            ),
          ),
        ],
        // Dream
        if (dream.isNotEmpty) ...[
          _buildClassificationHeader(
              'Dream Schools', 'dream', dream.length),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildResultCard(dream[i]),
                ),
                childCount: dream.length,
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildResultsSummary() {
    final safety = _results.where((r) => r.classification == 'safety').length;
    final target = _results.where((r) => r.classification == 'target').length;
    final reach = _results.where((r) => r.classification == 'reach').length;
    final dream = _results.where((r) => r.classification == 'dream').length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                '${_results.length} Matches Found',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryBadge('Safety', safety, const Color(0xFF16A34A)),
              const SizedBox(width: 8),
              _buildSummaryBadge('Target', target, const Color(0xFF2563EB)),
              const SizedBox(width: 8),
              _buildSummaryBadge('Reach', reach, const Color(0xFFF97316)),
              const SizedBox(width: 8),
              _buildSummaryBadge('Dream', dream, const Color(0xFFDC2626)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }

  Widget _buildSummaryBadge(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationHeader(
      String title, String classification, int count) {
    final color = _classificationColor(classification);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
        child: Row(
          children: [
            Icon(_classificationIcon(classification),
                size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(MatchResult result) {
    final color = _classificationColor(result.classification);
    final fitPercentage = (result.fitScore * 100).toStringAsFixed(0);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showResultDetails(result);
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: flag + name + badge
              Row(
                children: [
                  Text(
                    _countryFlag(result.country),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${result.city}, ${result.country}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Classification badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      result.classification.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Fit score bar
              Row(
                children: [
                  Icon(Icons.star_rounded, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    'Fit Score: $fitPercentage%',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: result.fitScore,
                  backgroundColor: color.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 12),
              // Stats
              Row(
                children: [
                  _buildResultStat(
                      'Accept',
                      '${result.acceptanceRate.toStringAsFixed(1)}%',
                      Colors.blue),
                  const SizedBox(width: 8),
                  _buildResultStat(
                    'Tuition',
                    result.tuitionUsd > 0
                        ? '\$${(result.tuitionUsd / 1000).toStringAsFixed(0)}k'
                        : 'N/A',
                    Colors.teal,
                  ),
                  if (result.rankingQs != null) ...[
                    const SizedBox(width: 8),
                    _buildResultStat(
                        'QS Rank', '#${result.rankingQs}', Colors.purple),
                  ],
                ],
              ),
              // Strengths
              if (result.strengths.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: result.strengths.take(3).map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: color.withValues(alpha: 0.8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: context.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultDetails(MatchResult result) {
    final color = _classificationColor(result.classification);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (sheetCtx, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: context.surfaceElevated,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        Text(
                          _countryFlag(result.country),
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.name,
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: context.textPrimary,
                                ),
                              ),
                              Text(
                                '${result.city}, ${result.country}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: color.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '${result.classification.toUpperCase()} · ${(result.fitScore * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        // Fit score
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: color.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Fit Score',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: context.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(result.fitScore * 100).toStringAsFixed(0)}%',
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: result.fitScore,
                                  backgroundColor:
                                      color.withValues(alpha: 0.12),
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(color),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Stats
                        Row(
                          children: [
                            _buildDetailStat(
                                'Acceptance Rate',
                                '${result.acceptanceRate.toStringAsFixed(1)}%',
                                Colors.blue),
                            const SizedBox(width: 10),
                            _buildDetailStat(
                              'Tuition/Year',
                              result.tuitionUsd > 0
                                  ? '\$${result.tuitionUsd.toStringAsFixed(0)}'
                                  : 'N/A',
                              Colors.teal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (result.rankingQs != null)
                          _buildDetailStat('QS World Rank',
                              '#${result.rankingQs}', Colors.purple),
                        const SizedBox(height: 20),
                        // Strengths
                        if (result.strengths.isNotEmpty) ...[
                          Text(
                            'Strengths',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: result.strengths.map((s) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                      color.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: color.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  s,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],
                        // Aid info
                        Row(
                          children: [
                            _buildAidIndicator(
                                'Need-Based Aid',
                                result.hasNeedBasedAid,
                                Colors.pink),
                            const SizedBox(width: 12),
                            _buildAidIndicator(
                                'Merit Scholarships',
                                result.hasMeritScholarships,
                                Colors.amber),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: context.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAidIndicator(String label, bool available, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: available
              ? color.withValues(alpha: 0.08)
              : context.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: available ? color.withValues(alpha: 0.2) : context.borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              available ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 16,
              color: available ? color : context.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: available ? color : context.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppTheme.errorRed.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Matching failed',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: context.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
