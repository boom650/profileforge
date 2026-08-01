import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ShimmerLoader — Premium shimmer loading skeleton.
/// Gradient-based shimmer effect that feels alive.
/// ────────────────────────────────────────────────────────────────────────────
class ShimmerLoader extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const ShimmerLoader({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  /// Standard dark shimmer
  factory ShimmerLoader.dark({Key? key, required Widget child}) {
    return ShimmerLoader(
      key: key,
      baseColor: const Color(0xFF1F2937),
      highlightColor: const Color(0xFF374151),
      child: child,
    );
  }

  /// Standard light shimmer
  factory ShimmerLoader.light({Key? key, required Widget child}) {
    return ShimmerLoader(
      key: key,
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF1F5F9),
      child: child,
    );
  }

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ??
        (dark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0));
    final highlight = widget.highlightColor ??
        (dark ? const Color(0xFF374151) : const Color(0xFFF1F5F9));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, highlight, base],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// ShimmerBox — Pre-built shimmer shapes for common loading patterns
/// ────────────────────────────────────────────────────────────────────────────
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ShimmerLoader(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// MissionCardSkeleton — Loading skeleton for mission cards
/// ────────────────────────────────────────────────────────────────────────────
class MissionCardSkeleton extends StatelessWidget {
  const MissionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF374151),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    width: 160,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            // XP badge
            Container(
              width: 50,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF374151),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileCardSkeleton — Loading skeleton for profile cards
/// ────────────────────────────────────────────────────────────────────────────
class ProfileCardSkeleton extends StatelessWidget {
  const ProfileCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF374151),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF374151),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF374151),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats row
            Row(
              children: List.generate(
                3,
                (_) => Expanded(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(10),
                    ),
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

/// ────────────────────────────────────────────────────────────────────────────
/// LeaderboardSkeleton — Loading skeleton for leaderboard list
/// ────────────────────────────────────────────────────────────────────────────
class LeaderboardSkeleton extends StatelessWidget {
  const LeaderboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ShimmerLoader(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  // Rank
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF374151),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF374151),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 50,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF374151),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // XP
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
