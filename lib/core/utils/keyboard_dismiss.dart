import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// KeyboardDismiss — Utility to dismiss keyboard from anywhere.
/// ────────────────────────────────────────────────────────────────────────────
class KeyboardDismiss {
  KeyboardDismiss._();

  /// Dismiss keyboard by unfocusing.
  static void dismiss(BuildContext context) {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Dismiss keyboard by unfocusing (static, no context).
  static void dismissGlobal() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

/// TapToDismissKeyboard — Wraps child to dismiss keyboard on tap.
class TapToDismissKeyboard extends StatelessWidget {
  const TapToDismissKeyboard({
    super.key,
    required this.child,
    this.behavior = HitTestBehavior.translucent,
  });

  final Widget child;
  final HitTestBehavior behavior;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: () => KeyboardDismiss.dismiss(context),
      child: child,
    );
  }
}

/// KeyboardVisibilityBuilder — Builder that responds to keyboard visibility.
class KeyboardVisibilityBuilder extends StatefulWidget {
  const KeyboardVisibilityBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, bool isKeyboardVisible) builder;

  @override
  State<KeyboardVisibilityBuilder> createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateVisibility();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _updateVisibility();
  }

  void _updateVisibility() {
    final bottomInset = View.of(context).viewInsets.bottom;
    final isVisible = bottomInset > 0;
    if (isVisible != _isVisible) {
      setState(() => _isVisible = isVisible);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _isVisible);
  }
}

/// ScrollToDismissKeyboard — ScrollView that dismisses keyboard on scroll.
class ScrollToDismissKeyboard extends StatelessWidget {
  const ScrollToDismissKeyboard({
    super.key,
    required this.child,
    this.scrollController,
  });

  final Widget child;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          KeyboardDismiss.dismiss(context);
        }
        return false;
      },
      child: child,
    );
  }
}
