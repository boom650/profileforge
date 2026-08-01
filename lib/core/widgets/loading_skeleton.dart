import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_theme.dart';

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Palette.surface1,
      highlightColor: Palette.surface2,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Palette.surface1,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double diameter;

  const SkeletonCircle({super.key, required this.diameter});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Palette.surface1,
      highlightColor: Palette.surface2,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          color: Palette.surface1,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int count;
  final double itemHeight;

  const SkeletonList({
    super.key,
    this.count = 4,
    this.itemHeight = 72,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SkeletonCard(height: itemHeight),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double height;

  const SkeletonCard({super.key, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Palette.surface1,
      highlightColor: Palette.surface2,
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Palette.surface1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SkeletonCircle(diameter: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonBox(width: 140, height: 14, borderRadius: 7),
                  const SizedBox(height: 8),
                  SkeletonBox(width: 200, height: 10, borderRadius: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
