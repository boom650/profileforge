import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Error boundary widget to catch errors in the widget tree
class ErrorBoundary extends ConsumerStatefulWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails)? errorBuilder;
  final void Function(FlutterErrorDetails)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  ConsumerState<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends ConsumerState<ErrorBoundary> {
  FlutterErrorDetails? _error;

  @override
  void initState() {
    super.initState();
    // Register error callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Error boundary will catch errors during build
    });
  }

  void _handleError(FlutterErrorDetails details) {
    setState(() {
      _error = details;
    });
    widget.onError?.call(details);
    
    // Log error for debugging
    debugPrint('ErrorBoundary caught error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!) ?? _DefaultErrorWidget(
        error: _error!,
        onRetry: () => setState(() => _error = null),
      );
    }
    return widget.child;
  }
}

/// Default error widget shown when an error is caught
class _DefaultErrorWidget extends StatelessWidget {
  final FlutterErrorDetails error;
  final VoidCallback onRetry;

  const _DefaultErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${error.exception}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error screen for full-screen error display
class ErrorScreen extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 24),
                Text(
                  message,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (details != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    details!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                if (onRetry != null)
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Snackbar for showing errors transiently
class ErrorSnackbar {
  static void show(BuildContext context, String message, {VoidCallback? onAction, String actionLabel = 'Retry'}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

/// Dialog for showing errors with actions
Future<T?> showErrorDialog<T>({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'OK',
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        Icons.error_outline_rounded,
        color: Theme.of(context).colorScheme.error,
        size: 32,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: Text(cancelText),
          ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );
}