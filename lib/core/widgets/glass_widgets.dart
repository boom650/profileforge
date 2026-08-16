import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// GlassWidgets — Premium glass morphism components.
///
/// Based on research:
/// - 12-uiux-dark-mode-responsive-mobile.md
/// - Lusion-inspired design language
/// - Glass morphism for depth and premium feel
/// ────────────────────────────────────────────────────────────────────────────

/// GlassContainer — Base glass morphism container.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = Clay.card,
    this.opacity = 0.1,
    this.blurSigma = 10,
    this.border,
    this.gradient,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final BorderRadius borderRadius;
  final double opacity;
  final double blurSigma;
  final Border? border;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: gradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? [
                      Palette.surface1.withValues(alpha: opacity),
                      Palette.surface2.withValues(alpha: opacity * 0.8),
                    ]
                  : [
                      Palette.creamCard.withValues(alpha: opacity),
                      Palette.creamDeep.withValues(alpha: opacity * 0.9),
                    ],
            ),
        border: border ??
            Border.all(
              color: dark
                  ? Palette.border.withValues(alpha: 0.5)
                  : Palette.line.withValues(alpha: 0.6),
              width: 1,
            ),
        boxShadow: boxShadow ??
            [
              dark ? Palette.clayShadowDark : Palette.clayShadow,
              Palette.clayHighlight,
            ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// GlassButton — Glass morphism button with tap feedback.
class GlassButton extends StatefulWidget {
  const GlassButton({
    super.key,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.borderRadius = Clay.pill,
    this.border,
  });

  final VoidCallback onTap;
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Border? border;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GlassContainer(
              padding: widget.padding,
              borderRadius: widget.borderRadius,
              border: widget.border,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// GlassAppBar — Glass morphism app bar.
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showBack = true,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final canPop = Navigator.of(context).canPop();

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: preferredSize.height,
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + 8,
            16,
            8,
          ),
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
              if (showBack && canPop)
                Tooltip(
                  message: 'Back',
                  child: Semantics(
                    button: true,
                    label: 'Back',
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : Palette.creamDeep,
                          borderRadius: Clay.pill,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color:
                              dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                    ),
                  ),
                ),
              if (leading != null) leading!,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}

/// GlassCard — Simple glass card with tap support.
class GlassCardSimple extends StatelessWidget {
  const GlassCardSimple({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = Clay.card,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: padding,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
