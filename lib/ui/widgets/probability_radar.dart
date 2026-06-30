import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_providers.dart';

class ProbabilityRadarChart extends StatelessWidget {
  final Map<String, AdmissionsProbability> probabilities;

  const ProbabilityRadarChart({super.key, required this.probabilities});

  @override
  Widget build(BuildContext context) {
    final pillars = [
      ('Academic', Icons.school_rounded, AppTheme.primaryBlue, 0.80),
      ('Research', Icons.science_rounded, const Color(0xFF8B5CF6), 0.05),
      ('Leadership', Icons.people_rounded, const Color(0xFFEF4444), 0.40),
      ('Service', Icons.volunteer_activism_rounded, const Color(0xFF10B981), 0.50),
      ('Creative', Icons.palette_rounded, const Color(0xFFF59E0B), 0.30),
    ];

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
          // Radar Chart
          SizedBox(
            height: 200,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 5,
                ticksTextStyle: const TextStyle(fontSize: 0),
                radarBorderData: BorderSide(color: AppTheme.primaryBlue.withValues(alpha: 0.2), width: 1),
                gridBorderData: BorderSide(color: AppTheme.primaryBlue.withValues(alpha: 0.1), width: 1),
                getTitle: (index, angle) {
                  final pillar = pillars[index];
                  return RadarChartTitle(
                    text: pillar.$1,
                    angle: angle,
                    textStyle: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  );
                },
                radarBackgroundColor: AppTheme.surfaceLight,
                dataSets: [
                  RadarDataSet(
                    fillColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                    borderColor: AppTheme.primaryBlue,
                    entryRadius: 0,
                    borderWidth: 2,
                    dataEntries: pillars.map((p) => RadarEntry(value: p.$4)).toList(),
                  ),
                ],
              ),
              swapAnimationDuration: const Duration(millis: 800),
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: pillars.map((p) => _RadarLegendItem(
              label: p.$1,
              icon: p.$2,
              value: p.$4,
              color: p.$3,
              isGap: p.$1 == 'Research',
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _RadarLegendItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final Color color;
  final bool isGap;

  const _RadarLegendItem({
    required this.label,
    required this.icon,
    required this.value,
    required this.color,
    required this.isGap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${(value * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  if (isGap) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'GAP',
                        style: GoogleFonts.inter(
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.errorRed,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Compact version for dashboard
class ProbabilityRadarCompact extends StatelessWidget {
  final Map<String, AdmissionsProbability> probabilities;

  const ProbabilityRadarCompact({super.key, required this.probabilities});

  @override
  Widget build(BuildContext context) {
    return ProbabilityRadarChart(probabilities: probabilities);
  }
}