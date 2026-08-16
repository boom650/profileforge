import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/compare/application/comparison_providers.dart';
import 'package:profileforge/features/compare/domain/comparison_models.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// SchoolComparisonScreen — Compare your profile against target schools.
///
/// Features:
/// - Side-by-side school comparison
/// - Profile match percentage
/// - Admission requirements display
/// - Fit analysis
/// ────────────────────────────────────────────────────────────────────────────
class SchoolComparisonScreen extends ConsumerStatefulWidget {
  const SchoolComparisonScreen({super.key});

  @override
  ConsumerState<SchoolComparisonScreen> createState() =>
      _SchoolComparisonScreenState();
}

class _SchoolComparisonScreenState extends ConsumerState<SchoolComparisonScreen> {
  final List<School> _selectedSchools = [];

  void _toggleSchool(School school) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedSchools.contains(school)) {
        _selectedSchools.remove(school);
      } else {
        if (_selectedSchools.length < 3) {
          _selectedSchools.add(school);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final comparison = ref.watch(comparisonProvider).valueOrNull ??
        const ComparisonResult(userGpa: null, matches: []);
    final allSchools = comparison.schools;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF1A0F0A), Palette.surface0, Palette.black]
                : [const Color(0xFFFBF1E3), Palette.cream, Palette.creamCard],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'School Comparison',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedSchools.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Palette.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_selectedSchools.length}/3',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Palette.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: _selectedSchools.isEmpty
                    ? _buildSchoolSelector(dark, allSchools)
                    : _buildComparisonView(dark, comparison),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolSelector(bool dark, List<School> allSchools) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select up to 3 schools to compare',
            style: TextStyle(
              fontSize: 14,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: allSchools.length,
              itemBuilder: (context, index) {
                final school = allSchools[index];
                final isSelected = _selectedSchools.contains(school);

                return GestureDetector(
                  onTap: () => _toggleSchool(school),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? school.color.withValues(alpha: 0.12)
                          : (dark
                              ? Palette.surface1.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.8)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? school.color.withValues(alpha: 0.5)
                            : (dark ? Palette.border : const Color(0xFFEDE3D6)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: school.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(school.logo, color: school.color, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                school.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: dark
                                      ? Palette.textPrimary
                                      : Palette.textInverse,
                                ),
                              ),
                              Text(
                                '${school.acceptanceRate}% acceptance • SAT ${school.avgSAT}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: dark
                                      ? Palette.textSecondary
                                      : Palette.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: school.color, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonView(bool dark, ComparisonResult comparison) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── School Cards Row ──
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedSchools.length,
              itemBuilder: (context, index) {
                return _buildSchoolCard(_selectedSchools[index], dark);
              },
            ),
          ),
          const SizedBox(height: 24),

          // ── Comparison Table ──
          _buildSectionTitle('Your Stats vs. School Averages', dark),
          const SizedBox(height: 12),
          _buildComparisonTable(dark, comparison),
          const SizedBox(height: 24),

          // ── Fit Analysis ──
          _buildSectionTitle('Fit Analysis', dark),
          const SizedBox(height: 12),
          _buildFitAnalysis(dark, comparison),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSchoolCard(School school, bool dark) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: school.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: school.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: school.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(school.logo, color: school.color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            school.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            school.strengths.take(2).join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: school.color),
          ),
          const SizedBox(height: 4),
          Text(
            '${school.acceptanceRate}% admit',
            style: TextStyle(
              fontSize: 11,
              color: school.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool dark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: dark ? Palette.textPrimary : Palette.textInverse,
      ),
    );
  }

  Widget _buildComparisonTable(bool dark, ComparisonResult comparison) {
    // The "You" column uses the user's REAL onboarding GPA.
    // SAT/ACT are not collected → honest '—' (never fabricated).
    final userGpa = comparison.userGpa;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFEDE3D6),
        ),
      ),
      child: Column(
        children: [
          // Header row
          _buildTableRow(
            '',
            ['You', ..._selectedSchools.map((s) => s.name)],
            isHeader: true,
            dark: dark,
          ),
          Divider(color: dark ? Palette.border.withValues(alpha: 0.3) : const Color(0xFFEDE3D6)),
          _buildTableRow(
            'GPA',
            [
              userGpa?.toStringAsFixed(2) ?? '—',
              ..._selectedSchools.map((s) => s.avgGPA.toStringAsFixed(2)),
            ],
            dark: dark,
          ),
          _buildTableRow(
            'SAT',
            [
              '—',
              ..._selectedSchools.map((s) => s.avgSAT.toString()),
            ],
            dark: dark,
          ),
          _buildTableRow(
            'ACT',
            ['—', ..._selectedSchools.map((s) => s.avgACT.toString())],
            dark: dark,
          ),
          _buildTableRow(
            'Admit %',
            ['—', ..._selectedSchools.map((s) => '${s.acceptanceRate}%')],
            dark: dark,
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String label, List<String> values,
      {bool isHeader = false, required bool dark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isHeader ? 12 : 13,
                fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
                color: isHeader
                    ? (dark ? Palette.textTertiary : Palette.textSecondary)
                    : (dark ? Palette.textPrimary : Palette.textInverse),
              ),
            ),
          ),
          ...values.map((v) {
            return Expanded(
              child: Center(
                child: Text(
                  v,
                  style: TextStyle(
                    fontSize: isHeader ? 12 : 14,
                    fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
                    color: isHeader
                        ? (dark ? Palette.textTertiary : Palette.textSecondary)
                        : (dark ? Palette.textPrimary : Palette.textInverse),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFitAnalysis(bool dark, ComparisonResult comparison) {
    return Column(
      children: _selectedSchools.map((school) {
        final matchPercent = comparison.matchFor(school) ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: dark
                ? Palette.surface1.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: dark ? Palette.border : const Color(0xFFEDE3D6),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: school.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(school.logo, color: school.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      school.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: matchPercent / 100,
                        minHeight: 6,
                        backgroundColor: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
                        valueColor: AlwaysStoppedAnimation(
                          matchPercent >= 80
                              ? Palette.success
                              : matchPercent >= 60
                                  ? Palette.warning
                                  : Palette.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$matchPercent%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: matchPercent >= 80
                      ? Palette.success
                      : matchPercent >= 60
                          ? Palette.warning
                          : Palette.error,
                ),
              ),
],
           ),
         );
       }).toList(),
     );
   }
 }
