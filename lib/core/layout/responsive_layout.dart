import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ResponsiveLayout — Device-adaptive layout system.
///
/// Breakpoints:
/// - Mobile: < 600px
/// - Tablet: 600-1024px
/// - Desktop: > 1024px
///
/// Usage:
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileLayout(),
///   tablet: TabletLayout(),
///   desktop: DesktopLayout(),
/// )
/// ```
/// ────────────────────────────────────────────────────────────────────────────
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileMaxWidth = 600,
    this.tabletMaxWidth = 1024,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double mobileMaxWidth;
  final double tabletMaxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > tabletMaxWidth) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth > mobileMaxWidth) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// ResponsiveValue — Return different values based on screen size.
class ResponsiveValue<T> extends StatelessWidget {
  const ResponsiveValue({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileMaxWidth = 600,
    this.tabletMaxWidth = 1024,
    required this.builder,
  });

  final T mobile;
  final T? tablet;
  final T? desktop;
  final double mobileMaxWidth;
  final double tabletMaxWidth;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        T value;
        if (constraints.maxWidth > tabletMaxWidth) {
          value = desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth > mobileMaxWidth) {
          value = tablet ?? mobile;
        } else {
          value = mobile;
        }
        return builder(context, value);
      },
    );
  }
}

/// ResponsiveBuilder — Build responsive layouts with breakpoint info.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobileMaxWidth = 600,
    this.tabletMaxWidth = 1024,
  });

  final Widget Function(BuildContext context, BreakpointInfo info) builder;
  final double mobileMaxWidth;
  final double tabletMaxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final info = BreakpointInfo(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          isMobile: constraints.maxWidth <= mobileMaxWidth,
          isTablet:
              constraints.maxWidth > mobileMaxWidth &&
              constraints.maxWidth <= tabletMaxWidth,
          isDesktop: constraints.maxWidth > tabletMaxWidth,
        );
        return builder(context, info);
      },
    );
  }
}

/// BreakpointInfo — Information about current breakpoint.
class BreakpointInfo {
  final double width;
  final double height;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const BreakpointInfo({
    required this.width,
    required this.height,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  DeviceType get deviceType {
    if (isMobile) return DeviceType.mobile;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Get responsive padding.
  EdgeInsets get padding {
    if (isDesktop) return const EdgeInsets.symmetric(horizontal: 48);
    if (isTablet) return const EdgeInsets.symmetric(horizontal: 32);
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  /// Get responsive grid columns.
  int get gridColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }

  /// Get responsive card width.
  double get cardWidth {
    if (isDesktop) return (width - 96 - 36) / 4;
    if (isTablet) return (width - 64 - 24) / 3;
    return (width - 40 - 12) / 2;
  }
}

enum DeviceType { mobile, tablet, desktop }

/// ResponsiveGrid — Adaptive grid layout.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 12,
    this.runSpacing = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.mobileMaxWidth = 600,
    this.tabletMaxWidth = 1024,
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsets padding;
  final double mobileMaxWidth;
  final double tabletMaxWidth;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth > tabletMaxWidth) {
          columns = desktopColumns;
        } else if (constraints.maxWidth > mobileMaxWidth) {
          columns = tabletColumns;
        } else {
          columns = mobileColumns;
        }

        final itemWidth =
            (constraints.maxWidth - padding.horizontal - (columns - 1) * spacing) /
                columns;

        return Padding(
          padding: padding,
          child: Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: children
                .map((child) => SizedBox(width: itemWidth, child: child))
                .toList(),
          ),
        );
      },
    );
  }
}

/// ResponsivePadding — Adaptive padding.
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.mobileMaxWidth = 600,
    this.tabletMaxWidth = 1024,
  });

  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;
  final double mobileMaxWidth;
  final double tabletMaxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        EdgeInsets padding;
        if (constraints.maxWidth > tabletMaxWidth) {
          padding = desktopPadding ?? const EdgeInsets.symmetric(horizontal: 48);
        } else if (constraints.maxWidth > mobileMaxWidth) {
          padding = tabletPadding ?? const EdgeInsets.symmetric(horizontal: 32);
        } else {
          padding = mobilePadding ?? const EdgeInsets.symmetric(horizontal: 20);
        }

        return Padding(padding: padding, child: child);
      },
    );
  }
}

/// ResponsiveText — Adaptive text sizing.
class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double? fontSize;
        if (constraints.maxWidth > 1024) {
          fontSize = desktopFontSize;
        } else if (constraints.maxWidth > 600) {
          fontSize = tabletFontSize;
        } else {
          fontSize = mobileFontSize;
        }

        return Text(
          text,
          style: fontSize != null
              ? (style ?? const TextStyle()).copyWith(fontSize: fontSize)
              : style,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}
