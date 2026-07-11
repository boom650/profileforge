import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../weekly_targets_model.dart';

class CategoryHeader extends StatelessWidget {
  final String category;
  final int count;
  final int completedCount;

  const CategoryHeader({
    super.key,
    required this.category,
    required this.count,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final meta = getCategoryMeta(category);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(meta.icon, color: meta.color, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            meta.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$completedCount/$count',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: meta.color,
              ),
            ),
          ),
          const Spacer(),
          if (count > 0)
            Text(
              '${((completedCount / count) * 100).toInt()}%',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: completedCount == count
                    ? AppTheme.successGreen
                    : context.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}