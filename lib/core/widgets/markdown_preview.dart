import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// MarkdownPreview — Renders markdown text with ProfileForge styling.
///
/// Supports:
/// - Headers (H1-H3)
/// - Bold, italic, strikethrough
/// - Links
/// - Lists (bulleted and numbered)
/// - Code blocks
/// - Blockquotes
/// - Horizontal rules
/// ────────────────────────────────────────────────────────────────────────────
class MarkdownPreview extends StatelessWidget {
  const MarkdownPreview({
    super.key,
    required this.markdown,
    this.textStyle,
    this.linkStyle,
  });

  final String markdown;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final baseStyle = textStyle ??
        GoogleFonts.inter(
          fontSize: 15,
          color: dark ? Palette.textPrimary : Palette.textInverse,
          height: 1.6,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _parseMarkdown(markdown, baseStyle, dark),
    );
  }

  List<Widget> _parseMarkdown(String text, TextStyle baseStyle, bool dark) {
    final lines = text.split('\n');
    final widgets = <Widget>[];
    int i = 0;

    while (i < lines.length) {
      final line = lines[i];

      // Empty line
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 12));
        i++;
        continue;
      }

      // Code block
      if (line.trim().startsWith('```')) {
        final codeLines = <String>[];
        i++;
        while (i < lines.length && !lines[i].trim().startsWith('```')) {
          codeLines.add(lines[i]);
          i++;
        }
        widgets.add(_buildCodeBlock(codeLines.join('\n'), dark));
        i++;
        continue;
      }

      // Heading
      if (line.startsWith('### ')) {
        widgets.add(_buildHeading(line.substring(4), 3, baseStyle, dark));
        i++;
        continue;
      }
      if (line.startsWith('## ')) {
        widgets.add(_buildHeading(line.substring(3), 2, baseStyle, dark));
        i++;
        continue;
      }
      if (line.startsWith('# ')) {
        widgets.add(_buildHeading(line.substring(2), 1, baseStyle, dark));
        i++;
        continue;
      }

      // Horizontal rule
      if (line.trim() == '---' || line.trim() == '***') {
        widgets.add(_buildHorizontalRule(dark));
        i++;
        continue;
      }

      // Blockquote
      if (line.startsWith('> ')) {
        widgets.add(_buildBlockquote(line.substring(2), baseStyle, dark));
        i++;
        continue;
      }

      // Unordered list
      if (line.startsWith('- ') || line.startsWith('* ')) {
        final items = <String>[];
        while (i < lines.length && (lines[i].startsWith('- ') || lines[i].startsWith('* '))) {
          items.add(lines[i].substring(2));
          i++;
        }
        widgets.add(_buildUnorderedList(items, baseStyle, dark));
        continue;
      }

      // Ordered list
      final orderedMatch = RegExp(r'^(\d+)\.\s').firstMatch(line);
      if (orderedMatch != null) {
        final items = <String>[];
        while (i < lines.length && RegExp(r'^\d+\.\s').hasMatch(lines[i])) {
          items.add(lines[i].replaceFirst(RegExp(r'^\d+\.\s'), ''));
          i++;
        }
        widgets.add(_buildOrderedList(items, baseStyle, dark));
        continue;
      }

      // Regular paragraph
      widgets.add(_buildParagraph(line, baseStyle, dark));
      i++;
    }

    return widgets;
  }

  Widget _buildHeading(String text, int level, TextStyle baseStyle, bool dark) {
    final sizes = {1: 24.0, 2: 20.0, 3: 17.0};
    final size = sizes[level] ?? 16.0;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: baseStyle.copyWith(
          fontSize: size,
          fontWeight: FontWeight.w800,
          color: dark ? Palette.textPrimary : Palette.textInverse,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text, TextStyle baseStyle, bool dark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _buildInlineFormatting(text, baseStyle, dark),
    );
  }

  Widget _buildInlineFormatting(String text, TextStyle baseStyle, bool dark) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'(\*\*(.+?)\*\*|\*(.+?)\*|~~(.+?)~~|`(.+?)`|(\[.+?\]\(.+?\)))');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before match
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }

      if (match.group(2) != null) {
        // Bold
        spans.add(TextSpan(
          text: match.group(2),
          style: baseStyle.copyWith(fontWeight: FontWeight.w700),
        ));
      } else if (match.group(3) != null) {
        // Italic
        spans.add(TextSpan(
          text: match.group(3),
          style: baseStyle.copyWith(fontStyle: FontStyle.italic),
        ));
      } else if (match.group(4) != null) {
        // Strikethrough
        spans.add(TextSpan(
          text: match.group(4),
          style: baseStyle.copyWith(decoration: TextDecoration.lineThrough),
        ));
      } else if (match.group(5) != null) {
        // Inline code
        spans.add(TextSpan(
          text: match.group(5),
          style: GoogleFonts.firaCode(
            fontSize: baseStyle.fontSize! - 1,
            color: Palette.primary,
            backgroundColor: dark
                ? Palette.surface2.withValues(alpha: 0.5)
                : const Color(0xFFF1F5F9),
          ),
        ));
      } else if (match.group(6) != null) {
        // Link
        final linkMatch = RegExp(r'\[(.+?)\]\((.+?)\)').firstMatch(match.group(6)!);
        if (linkMatch != null) {
          spans.add(TextSpan(
            text: linkMatch.group(1),
            style: baseStyle.copyWith(
              color: Palette.primary,
              decoration: TextDecoration.underline,
            ),
          ));
        }
      }

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return RichText(
      text: TextSpan(children: spans, style: baseStyle),
    );
  }

  Widget _buildCodeBlock(String code, bool dark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? Palette.surface2 : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFE2E8F0),
        ),
      ),
      child: Text(
        code,
        style: GoogleFonts.firaCode(
          fontSize: 13,
          color: dark ? Palette.textPrimary : Palette.textInverse,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBlockquote(String text, TextStyle baseStyle, bool dark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Palette.primary,
            width: 3,
          ),
        ),
        color: Palette.primary.withValues(alpha: 0.05),
      ),
      child: Text(
        text,
        style: baseStyle.copyWith(
          fontStyle: FontStyle.italic,
          color: dark ? Palette.textSecondary : Palette.textTertiary,
        ),
      ),
    );
  }

  Widget _buildUnorderedList(List<String> items, TextStyle baseStyle, bool dark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: baseStyle.copyWith(color: Palette.primary),
                ),
                Expanded(
                  child: _buildInlineFormatting(item, baseStyle, dark),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderedList(List<String> items, TextStyle baseStyle, bool dark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${i + 1}. ',
                  style: baseStyle.copyWith(
                    color: Palette.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: _buildInlineFormatting(items[i], baseStyle, dark),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHorizontalRule(bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        height: 1,
        color: dark ? Palette.border : const Color(0xFFE2E8F0),
      ),
    );
  }
}
