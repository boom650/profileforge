import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ClipboardHelper — Clipboard operations with feedback.
/// ────────────────────────────────────────────────────────────────────────────
class ClipboardHelper {
  ClipboardHelper._();

  /// Copy text to clipboard with optional confirmation.
  static Future<bool> copy(String text, {bool showConfirmation = true}) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Paste text from clipboard.
  static Future<String?> paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Check if clipboard has text.
  static Future<bool> hasText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text != null && data!.text!.isNotEmpty;
  }

  /// Copy and show a toast/snackbar.
  static Future<void> copyWithToast(
    BuildContext context,
    String text, {
    String message = 'Copied to clipboard',
  }) async {
    final success = await copy(text, showConfirmation: false);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

/// SelectableText with copy on long press.
class CopyableText extends StatelessWidget {
  const CopyableText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      onTap: () {
        ClipboardHelper.copyWithToast(context, text);
      },
    );
  }
}
