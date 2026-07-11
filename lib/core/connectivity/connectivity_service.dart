// Connectivity monitoring service using connectivity_plus
// Provides a stream of connectivity status changes and current state.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the current network connectivity status.
enum ConnectivityStatus {
  connected,
  disconnected,
  unknown,
}

/// A connectivity report containing the current status and connection type.
@immutable
class ConnectivityReport {
  final ConnectivityStatus status;
  final List<ConnectivityResult> connectionTypes;

  const ConnectivityReport({
    required this.status,
    required this.connectionTypes,
  });

  bool get isConnected => status == ConnectivityStatus.connected;
  bool get isDisconnected => status == ConnectivityStatus.disconnected;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectivityReport &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          connectionTypes == other.connectionTypes;

  @override
  int get hashCode => Object.hash(status, connectionTypes);

  @override
  String toString() =>
      'ConnectivityReport(status: $status, types: $connectionTypes)';
}

/// Service that monitors network connectivity and exposes a stream of reports.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final StreamController<ConnectivityReport> _controller =
      StreamController<ConnectivityReport>.broadcast();

  /// Stream of connectivity reports. Listen to this to react to changes.
  Stream<ConnectivityReport> get stream => _controller.stream;

  /// Current connectivity status (last known).
  ConnectivityReport? _lastReport;
  ConnectivityReport? get lastReport => _lastReport;

  /// Initialize the service and start listening for connectivity changes.
  Future<void> initialize() async {
    // Get initial connectivity
    final results = await _connectivity.checkConnectivity();
    _updateReport(results);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateReport,
      onError: (error) {
        debugPrint('Connectivity stream error: $error');
      },
    );
  }

  void _updateReport(List<ConnectivityResult> results) {
    ConnectivityStatus status;
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      status = ConnectivityStatus.disconnected;
    } else {
      status = ConnectivityStatus.connected;
    }

    final report = ConnectivityReport(
      status: status,
      connectionTypes: results,
    );

    if (_lastReport != report) {
      _lastReport = report;
      _controller.add(report);
    }
  }

  /// Check connectivity once without subscribing to the stream.
  Future<ConnectivityReport> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateReport(results);
    return _lastReport!;
  }

  /// Dispose the service and cancel subscriptions.
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

/// Provider for the connectivity service.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider that emits connectivity reports as an async stream.
final connectivityStreamProvider = StreamProvider<ConnectivityReport>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  service.initialize(); // Fire-and-forget init — stream starts when ready
  return service.stream;
});

/// Convenience provider for the latest connectivity status.
final connectivityStatusProvider = Provider<ConnectivityStatus>((ref) {
  final report = ref.watch(connectivityStreamProvider);
  return report.when(
    data: (r) => r.status,
    loading: () => ConnectivityStatus.unknown,
    error: (_, __) => ConnectivityStatus.unknown,
  );
});