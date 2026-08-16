import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// NetworkStatusIndicator — Real-time network status banner.
///
/// Features:
/// - Shows connection status (WiFi/Mobile/None)
/// - Animated banner with smooth transitions
/// - Auto-hides when connected
/// - Retry action when offline
/// ────────────────────────────────────────────────────────────────────────────
class NetworkStatusIndicator extends StatefulWidget {
  const NetworkStatusIndicator({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  State<NetworkStatusIndicator> createState() => _NetworkStatusIndicatorState();
}

class _NetworkStatusIndicatorState extends State<NetworkStatusIndicator>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Check initial status
    _checkStatus();

    // Listen for changes
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      _updateStatus(results.isNotEmpty ? results.first : ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    final results = await Connectivity().checkConnectivity();
    _updateStatus(results.isNotEmpty ? results.first : ConnectivityResult.none);
  }

  void _updateStatus(ConnectivityResult result) {
    final wasOffline = _isOffline;
    setState(() {
      _isOffline = result == ConnectivityResult.none;
    });

    if (_isOffline && !wasOffline) {
      _controller.forward();
    } else if (!_isOffline && wasOffline) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOffline) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Palette.error.withValues(alpha: 0.9),
                child: Row(
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'No internet connection',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (widget.onRetry != null)
                      GestureDetector(
                        onTap: widget.onRetry,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Retry',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// NetworkAwareWidget — Wraps child with network status awareness.
class NetworkAwareWidget extends StatelessWidget {
  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.offlineWidget,
  });

  final Widget child;
  final Widget? offlineWidget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final isConnected =
            snapshot.data != null && !snapshot.data!.contains(ConnectivityResult.none);

        if (!isConnected && offlineWidget != null) {
          return offlineWidget!;
        }

        return child;
      },
    );
  }
}
