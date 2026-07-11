// Offline banner widget — shows a banner when the device is offline.
// Used as an overlay at the top of the app to inform users of network issues.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../connectivity/connectivity_service.dart';

/// A persistent banner that appears when the device is offline.
/// Wraps the app widget tree and listens to connectivity status.
class OfflineBanner extends ConsumerWidget {
  final Widget child;

  const OfflineBanner({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityStatusProvider);
    final isOffline = status == ConnectivityStatus.disconnected;

    return Column(
      children: [
        if (isOffline)
          Material(
            color: Colors.orange.shade700,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'You\'re offline. Some features may be unavailable.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Manual retry button
                    TextButton(
                      onPressed: () {
                        ref.invalidate(connectivityStreamProvider);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'RETRY',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}

/// Wrapper widget that starts connectivity monitoring and provides an
/// offline banner overlay. Place this around MaterialApp or its child.
class ConnectivityStatusWatcher extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectivityStatusWatcher({required this.child, super.key});

  @override
  ConsumerState<ConnectivityStatusWatcher> createState() =>
      _ConnectivityStatusWatcherState();
}

class _ConnectivityStatusWatcherState
    extends ConsumerState<ConnectivityStatusWatcher> {
  @override
  void initState() {
    super.initState();
    // Trigger connectivity service initialization on mount.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(connectivityServiceProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBanner(child: widget.child);
  }
}