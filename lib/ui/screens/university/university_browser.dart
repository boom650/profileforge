import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';
import 'university_matcher.dart';

const String apiBase = 'http://localhost:8081';

// ─── Data Model ──────────────────────────────────────────────────────────────

class ApiUniversity {
  final String id;
  final String name;
  final String country;
  final String city;
  final double acceptanceRate;
  final int? rankingUsNews;
  final int? rankingQs;
  final double tuitionUsd;
  final bool hasNeedBasedAid;
  final bool hasMeritScholarships;
  final List<String> strengths;
  final double typicalGpa;
  final int? typicalSat;
  final String? website;
  final String? deadlineEarly;
  final String? deadlineRegular;

  const ApiUniversity({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.acceptanceRate,
    this.rankingUsNews,
    this.rankingQs,
    required this.tuitionUsd,
    this.hasNeedBasedAid = false,
    this.hasMeritScholarships = false,
    this.strengths = const [],
    this.typicalGpa = 0,
    this.typicalSat,
    this.website,
    this.deadlineEarly,
    this.deadlineRegular,
  });

  factory ApiUniversity.fromJson(Map<String, dynamic> json) {
    return ApiUniversity(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      acceptanceRate: (json['acceptance_rate'] as num?)?.toDouble() ?? 0,
      rankingUsNews: json['ranking_us_news'] as int?,
      rankingQs: json['ranking_qs'] as int?,
      tuitionUsd: (json['tuition_usd'] as num?)?.toDouble() ?? 0,
      hasNeedBasedAid: json['has_need_based_aid'] as bool? ?? false,
      hasMeritScholarships: json['has_merit_scholarships'] as bool? ?? false,
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      typicalGpa: (json['typical_gpa'] as num?)?.toDouble() ?? 0,
      typicalSat: json['typical_sat'] as int?,
      website: json['website'] as String?,
      deadlineEarly: json['deadline_early'] as String?,
      deadlineRegular: json['deadline_regular'] as String?,
    );
  }
}

// ─── Country helpers ─────────────────────────────────────────────────────────

const List<String> _countryFilters = ['All', 'US', 'UK', 'Canada', 'Australia', 'EU'];

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

Color _countryColor(String country) {
  switch (country) {
    case 'US':
      return const Color(0xFF3B82F6);
    case 'UK':
      return const Color(0xFFDC2626);
    case 'Canada':
      return const Color(0xFFEF4444);
    case 'Australia':
      return const Color(0xFFF59E0B);
    case 'EU':
      return const Color(0xFF1D4ED8);
    default:
      return AppTheme.primary;
  }
}

// ─── University Browser Screen ──────────────────────────────────────────────

class UniversityBrowserScreen extends ConsumerStatefulWidget {
  const UniversityBrowserScreen({super.key});

  @override
  ConsumerState<UniversityBrowserScreen> createState() =>
      _UniversityBrowserScreenState();
}

class _UniversityBrowserScreenState
    extends ConsumerState<UniversityBrowserScreen> {
  String _selectedCountry = 'All';
  bool _isLoading = true;
  String? _error;
  List<ApiUniversity> _universities = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUniversities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final uri = _selectedCountry == 'All'
          ? Uri.parse('$apiBase/api/universities')
          : Uri.parse(
              '$apiBase/api/universities?country=${Uri.encodeComponent(_selectedCountry)}');

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timed out'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _universities =
              data.map((j) => ApiUniversity.fromJson(j)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<ApiUniversity> get _filteredUniversities {
    if (_selectedCountry == 'All') return _universities;
    return _universities
        .where((u) => u.country == _selectedCountry)
        .toList();
  }

  void _openDetails(ApiUniversity uni) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UniversityDetailSheet(university: uni),
    );
  }

  void _openMatcher() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const UniversityMatcherScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceBg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openMatcher,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: Text(
          'Find My Match',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildCountryFilters()),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primary,
                ),
              ),
            )
          else if (_error != null)
            SliverFillRemaining(child: _buildErrorWidget())
          else ...[
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                '${_filteredUniversities.length} Universities',
                Icons.school_rounded,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildUniversityCard(_filteredUniversities[i], i),
                  ),
                  childCount: _filteredUniversities.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats
              Row(
                children: [
                  _buildStatBubble('${_universities.length}', 'Universities'),
                  const SizedBox(width: 12),
                  _buildStatBubble(
                    '${_universities.where((u) => u.country == 'US').length}',
                    'US',
                  ),
                  const SizedBox(width: 12),
                  _buildStatBubble(
                    '${_universities.where((u) => u.country == 'UK').length}',
                    'UK',
                  ),
                  const SizedBox(width: 12),
                  _buildStatBubble(
                    '${_universities.where((u) => u.country == 'Canada').length}',
                    'Canada',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'University Browser',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05),
              const SizedBox(height: 6),
              Text(
                'Discover the best universities worldwide',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBubble(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
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
    );
  }

  // ── Country Filters ─────────────────────────────────────────────────────

  Widget _buildCountryFilters() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _countryFilters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (ctx, i) {
            final country = _countryFilters[i];
            final selected = _selectedCountry == country;
            return AnimatedScale(
              scale: selected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (country != 'All')
                      Text(
                        _countryFlag(country),
                        style: const TextStyle(fontSize: 14),
                      ),
                    if (country != 'All') const SizedBox(width: 4),
                    Text(
                      country,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                        color: selected ? AppTheme.primary : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                selected: selected,
                selectedColor: AppTheme.primary.withValues(alpha: 0.1),
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedCountry = country);
                  _loadUniversities();
                },
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                side: BorderSide(
                  color: selected ? AppTheme.primary : AppTheme.textMuted,
                  width: selected ? 1.5 : 1,
                ),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 100 * i));
          },
        ),
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, IconData icon, {int? count}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── University Card ─────────────────────────────────────────────────────

  Widget _buildUniversityCard(ApiUniversity uni, int index) {
    final countryColor = _countryColor(uni.country);
    return GestureDetector(
      onTap: () => _openDetails(uni),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: flag + country badge
              Row(
                children: [
                  Text(
                    _countryFlag(uni.country),
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uni.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${uni.city}, ${uni.country}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Stats row
              Row(
                children: [
                  _buildMiniStat(
                    'Acceptance',
                    '${uni.acceptanceRate.toStringAsFixed(1)}%',
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildMiniStat(
                    'Tuition/yr',
                    uni.tuitionUsd > 0
                        ? '\$${(uni.tuitionUsd / 1000).toStringAsFixed(0)}k'
                        : 'N/A',
                    Colors.teal,
                  ),
                  if (uni.typicalSat != null) ...[
                    const SizedBox(width: 12),
                    _buildMiniStat(
                      'SAT',
                      '${uni.typicalSat}',
                      Colors.orange,
                    ),
                  ],
                  if (uni.rankingQs != null) ...[
                    const SizedBox(width: 12),
                    _buildMiniStat(
                      'QS Rank',
                      '#${uni.rankingQs}',
                      Colors.purple,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              // Strengths chips
              if (uni.strengths.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: uni.strengths.take(2).map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: countryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: countryColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        s,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: countryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              // Aid badges
              if (uni.hasNeedBasedAid || uni.hasMeritScholarships) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (uni.hasNeedBasedAid)
                      _buildBadge('Need-Based Aid', Icons.favorite_rounded,
                          Colors.pink),
                    if (uni.hasNeedBasedAid && uni.hasMeritScholarships)
                      const SizedBox(width: 8),
                    if (uni.hasMeritScholarships)
                      _buildBadge(
                          'Merit Scholarships', Icons.star_rounded, Colors.amber),
                  ],
                ),
              ],
            ],
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: 60 * index))
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.04),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
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

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error Widget ────────────────────────────────────────────────────────

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
              'Failed to load universities',
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
              onPressed: _loadUniversities,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
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

// ─── University Detail Bottom Sheet ─────────────────────────────────────────

class _UniversityDetailSheet extends StatelessWidget {
  final ApiUniversity university;

  const _UniversityDetailSheet({required this.university});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    Text(
                      _countryFlag(university.country),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            university.name,
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: context.textPrimary,
                            ),
                          ),
                          Text(
                            '${university.city}, ${university.country}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Key stats grid
                    _buildStatsGrid(context),
                    const SizedBox(height: 20),

                    // Rankings section
                    if (university.rankingQs != null ||
                        university.rankingUsNews != null) ...[
                      _buildSectionTitle('Rankings', Icons.emoji_events_rounded, context),
                      const SizedBox(height: 10),
                      _buildRankingsCard(context),
                      const SizedBox(height: 20),
                    ],

                    // Strengths
                    if (university.strengths.isNotEmpty) ...[
                      _buildSectionTitle('Strengths', Icons.auto_awesome_rounded, context),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: university.strengths.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  _countryColor(university.country)
                                      .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _countryColor(university.country)
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              s,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _countryColor(university.country),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Aid & Scholarships
                    _buildSectionTitle(
                        'Aid & Scholarships', Icons.volunteer_activism_rounded, context),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildAidCard(
                          'Need-Based Aid',
                          university.hasNeedBasedAid,
                          Icons.favorite_rounded,
                          Colors.pink,
                          context,
                        , context),
                        const SizedBox(width: 10),
                        _buildAidCard(
                          'Merit Scholarships',
                          university.hasMeritScholarships,
                          Icons.star_rounded,
                          Colors.amber,
                          context,
                        , context),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Deadlines
                    if (university.deadlineEarly != null ||
                        university.deadlineRegular != null) ...[
                      _buildSectionTitle(
                          'Deadlines', Icons.calendar_today_rounded, context),
                      const SizedBox(height: 10),
                      _buildDeadlinesCard(context),
                      const SizedBox(height: 20),
                    ],

                    // Typical Admitted Student
                    _buildSectionTitle(
                        'Typical Admitted Student', Icons.person_rounded, context),
                    const SizedBox(height: 10),
                    _buildTypicalStudentCard(context),
                    const SizedBox(height: 20),

                    // Website
                    if (university.website != null &&
                        university.website!.isNotEmpty) ...[
                      _buildSectionTitle('Website', Icons.language_rounded, context),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          // Would launch URL — show snackbar for now
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Opening ${university.website}',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500),
                              ),
                              backgroundColor: AppTheme.successGreen,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.open_in_new_rounded,
                                  size: 18, color: AppTheme.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  university.website!,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.0,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildStatTile('Acceptance Rate',
            '${university.acceptanceRate.toStringAsFixed(1)}%', Colors.blue, context),
        _buildStatTile(
          'Tuition/Year',
          university.tuitionUsd > 0
              ? '\\$${university.tuitionUsd.toStringAsFixed(0)}'
              : 'N/A',
          Colors.teal,
          context,
        ),
        if (university.typicalSat != null)
          _buildStatTile(
              'Typical SAT', '${university.typicalSat}', Colors.orange, context),
        _buildStatTile(
            'Typical GPA', university.typicalGpa.toStringAsFixed(2), Colors.purple, context),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: context.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          if (university.rankingQs != null) ...[
            Expanded(
              child: Column(
                children: [
                  Text(
                    '#${university.rankingQs}',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  Text(
                    'QS World',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (university.rankingUsNews != null)
              Container(
                width: 1,
                height: 40,
                color: context.borderColor,
              ),
          ],
          if (university.rankingUsNews != null) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '#${university.rankingUsNews}',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary,
                    ),
                  ),
                  Text(
                    'US News',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAidCard(
      String label, bool hasAid, IconData icon, Color color, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: hasAid
              ? color.withValues(alpha: 0.08)
              : context.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasAid ? color.withValues(alpha: 0.2) : context.borderColor,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: hasAid ? color : context.textMuted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: hasAid ? color : context.textMuted,
                    ),
                  ),
                  Text(
                    hasAid ? 'Available' : 'Not Available',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: hasAid
                          ? color.withValues(alpha: 0.8)
                          : context.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlinesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          if (university.deadlineEarly != null) ...[
            Row(
              children: [
                Icon(Icons.bolt_rounded,
                    size: 16, color: AppTheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Early Decision: ',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textSecondary,
                  ),
                ),
                Text(
                  university.deadlineEarly!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (university.deadlineRegular != null)
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 16, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Regular Decision: ',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textSecondary,
                  ),
                ),
                Text(
                  university.deadlineRegular!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTypicalStudentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTypicalStat('GPA', university.typicalGpa.toStringAsFixed(2), context),
          Container(width: 1, height: 40, color: context.borderColor),
          _buildTypicalStat(
            'SAT',
            university.typicalSat?.toString() ?? 'N/A',
            context,
          , context),
          Container(width: 1, height: 40, color: context.borderColor),
          _buildTypicalStat(
            'Acceptance',
            '${university.acceptanceRate.toStringAsFixed(1)}%',
            context,
          , context),
        ],
      ),
    );
  }

  Widget _buildTypicalStat(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: context.textSecondary,
          ),
        ),
      ],
    );
  }
}
