import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/glass_widgets.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ExpandableCard — Glass card that expands/collapses on tap.
///
/// Features:
/// - Smooth height animation
/// - Custom header and body
/// - Optional trailing widget
/// - Haptic feedback
/// ────────────────────────────────────────────────────────────────────────────
class ExpandableCard extends StatefulWidget {
  const ExpandableCard({
    super.key,
    required this.header,
    required this.body,
    this.trailing,
    this.initiallyExpanded = false,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 8),
    this.borderColor,
  });

  final Widget header;
  final Widget body;
  final Widget? trailing;
  final bool initiallyExpanded;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? borderColor;

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return GlassContainer(
      margin: widget.margin,
      padding: EdgeInsets.zero,
      border: widget.borderColor != null
          ? Border.all(color: widget.borderColor!)
          : null,
      child: Column(
        children: [
          // ── Header ──
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: widget.padding,
              child: Row(
                children: [
                  Expanded(child: widget.header),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: 8),
                    widget.trailing!,
                  ],
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _iconRotation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _iconRotation.value * 3.14159,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: dark ? Palette.textTertiary : Palette.textSecondary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── Body ──
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                widget.padding.left,
                0,
                widget.padding.right,
                widget.padding.bottom,
              ),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}

/// ExpandableFAQ — FAQ-style expandable items.
class ExpandableFAQ extends StatelessWidget {
  const ExpandableFAQ({
    super.key,
    required this.items,
    this.margin = const EdgeInsets.only(bottom: 8),
  });

  final List<FAQItem> items;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return ExpandableCard(
          margin: margin,
          header: Text(
            item.question,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark(context)
                  ? Palette.textPrimary
                  : Palette.textInverse,
            ),
          ),
          body: Text(
            item.answer,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: isDark(context)
                  ? Palette.textSecondary
                  : Palette.textTertiary,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});
}
