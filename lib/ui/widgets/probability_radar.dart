import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../../services/admissions_probability/admissions_engine.dart';

/// Radar chart showing admissions probability breakdown
class ProbabilityRadarChart extends StatelessWidget {
  final AdmissionsFactorBreakdown factorBreakdown;
  final MonteCarloResult? monteCarloResult;
  final String universityName;

  const ProbabilityRadarChart({
    super.key,
    required this.factorBreakdown,
    this.monteCarloResult,
    this.universityName = '',
  });

  @override
  Widget build(BuildContext context) {
    final pillars = _buildPillars();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          if (universityName.isNotEmpty) ...[
            Text(
              universityName,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            if (monteCarloResult != null)
              _buildClassificationBadge(monteCarloResult!.classification),
            const SizedBox(height: 16),
          ],
          
          // Radar Chart
          SizedBox(
            height: 220,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 5,
                ticksTextStyle: const TextStyle(fontSize: 0),
                radarBorderData: BorderSide(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  width: 1,
                ),
                gridBorderData: BorderSide(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  width: 1,
                ),
                getTitle: (index, angle) {
                  final pillar = pillars[index];
                  return RadarChartTitle(
                    text: pillar.$1,
                    angle: angle,
                  );
                },
                radarBackgroundColor: AppTheme.surfaceLight,
                dataSets: [
                  RadarDataSet(
                    fillColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                    borderColor: AppTheme.primaryBlue,
                    entryRadius: 4,
                    borderWidth: 2,
                    dataEntries: pillars.map((p) => RadarEntry(value: p.$4)).toList(),
                  ),
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          ),
          const SizedBox(height: 20),
          
          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: pillars.map((p) => _RadarLegendItem(
              label: p.$1,
              icon: p.$2,
              value: p.$4,
              color: p.$3,
              weight: p.$5,
            )).toList(),
          ),
          
          // Monte Carlo Stats
          if (monteCarloResult != null) ...[
            const SizedBox(height: 20),
            _buildMonteCarloStats(monteCarloResult!),
          ],
        ],
      ),
    );
  }
  
  List<(String, IconData, Color, double, String)> _buildPillars() {
    final breakdownMap = factorBreakdown.toMap();
    
    return [
      ('Academics', Icons.school_rounded, AppTheme.primaryBlue, 
        breakdownMap['Academics'] ?? 0, '40pts'),
      ('Tests', Icons.assignment_turned_in_rounded, const Color(0xFF8B5CF6),
        breakdownMap['Test Scores'] ?? 0, '20pts'),
      ('Activities', Icons.emoji_events_rounded, const Color(0xFFEF4444),
        breakdownMap['Extracurricular'] ?? 0, '15pts'),
      ('Essays', Icons.edit_note_rounded, const Color(0xFF10B981),
        breakdownMap['Essays'] ?? 0, '10pts'),
      ('Recs', Icons.recommend_rounded, const Color(0xFFF59E0B),
        breakdownMap['Recommendations'] ?? 0, '5pts'),
      ('Interview', Icons.record_voice_over_rounded, const Color(0xFF06B6D4),
        breakdownMap['Interview'] ?? 0, '5pts'),
      ('Research', Icons.science_rounded, const Color(0xFFEC4899),
        breakdownMap['Research'] ?? 0, '5pts'),
    ];
  }
  
  Widget _buildClassificationBadge(ApplicationClassification classification) {
    final color = Color(AdmissionsEngine.getClassificationColor(classification));
    final label = AdmissionsEngine.getClassificationLabel(classification);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
  
  Widget _buildMonteCarloStats(MonteCarloResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: 'Mean',
                value: '${(result.mean * 100).toStringAsFixed(1)}%',
                color: AppTheme.primaryBlue,
              ),
              _StatItem(
                label: 'Median',
                value: '${(result.median * 100).toStringAsFixed(1)}%',
                color: const Color(0xFF8B5CF6),
              ),
              _StatItem(
                label: 'Std Dev',
                value: '${(result.standardDeviation * 100).toStringAsFixed(1)}%',
                color: const Color(0xFF6B7280),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: 'P25',
                value: '${(result.p25 * 100).toStringAsFixed(1)}%',
                color: const Color(0xFF10B981),
              ),
              _StatItem(
                label: 'P75',
                value: '${(result.p75 * 100).toStringAsFixed(1)}%',
                color: const Color(0xFFF59E0B),
              ),
              _StatItem(
                label: 'Range',
                value: '${(result.p10 * 100).toStringAsFixed(0)}-${(result.p90 * 100).toStringAsFixed(0)}%',
                color: const Color(0xFFEF4444),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDistributionBar(result),
        ],
      ),
    );
  }
  
  Widget _buildDistributionBar(MonteCarloResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Simulation Distribution (10,000 iterations)',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _DistributionSegment(
              label: 'Safety',
              percentage: result.safetyPercentage,
              color: const Color(0xFF10B981),
            ),
            _DistributionSegment(
              label: 'Target',
              percentage: result.targetPercentage,
              color: const Color(0xFF3B82F6),
            ),
            _DistributionSegment(
              label: 'Reach',
              percentage: result.reachPercentage,
              color: const Color(0xFFF59E0B),
            ),
            _DistributionSegment(
              label: 'Dream',
              percentage: result.dreamPercentage,
              color: const Color(0xFFEF4444),
            ),
          ],
        ),
      ],
    );
  }
}

class _RadarLegendItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final Color color;
  final String weight;

  const _RadarLegendItem({
    required this.label,
    required this.icon,
    required this.value,
    required this.color,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 12),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${(value * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    weight,
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DistributionSegment extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;

  const _DistributionSegment({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100.0,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$label $percentage%',
            style: GoogleFonts.inter(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact version for dashboard
class ProbabilityRadarCompact extends StatelessWidget {
  final AdmissionsFactorBreakdown factorBreakdown;
  final MonteCarloResult? monteCarloResult;

  const ProbabilityRadarCompact({
    super.key,
    required this.factorBreakdown,
    this.monteCarloResult,
  });

  @override
  Widget build(BuildContext context) {
    return ProbabilityRadarChart(
      factorBreakdown: factorBreakdown,
      monteCarloResult: monteCarloResult,
    );
  }
}
