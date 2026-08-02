import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Remote Body Doubling — stub service.
/// Full implementation requires a WebRTC / SFU backend.
/// For now: provides the state model and a placeholder connection flow.
/// ────────────────────────────────────────────────────────────────────────────

enum BodyDoubleConnectionState { disconnected, connecting, connected, error }

/// A remote buddy on the other side of a real‑time focus session.
class RemoteBuddy {
  final String id;
  final String name;
  final int streakDays;
  final bool isFocusing;
  final BodyDoubleConnectionState connectionState;

  const RemoteBuddy({
    required this.id,
    required this.name,
    this.streakDays = 0,
    this.isFocusing = false,
    this.connectionState = BodyDoubleConnectionState.disconnected,
  });

  RemoteBuddy copyWith({
    String? id,
    String? name,
    int? streakDays,
    bool? isFocusing,
    BodyDoubleConnectionState? connectionState,
  }) {
    return RemoteBuddy(
      id: id ?? this.id,
      name: name ?? this.name,
      streakDays: streakDays ?? this.streakDays,
      isFocusing: isFocusing ?? this.isFocusing,
      connectionState: connectionState ?? this.connectionState,
    );
  }
}

class RemoteBodyDoubleService {
  RemoteBuddy? _currentBuddy;
  BodyDoubleConnectionState _state = BodyDoubleConnectionState.disconnected;

  RemoteBuddy? get currentBuddy => _currentBuddy;
  BodyDoubleConnectionState get state => _state;

  /// Placeholder: initiate a WebRTC / SFU connection to a buddy.
  Future<void> connect(RemoteBuddy buddy) async {
    _currentBuddy = buddy;
    _state = BodyDoubleConnectionState.connecting;
    await Future.delayed(const Duration(seconds: 2));
    // In production: actual WebRTC negotiation with a signalling server.
    _state = BodyDoubleConnectionState.connected;
    _currentBuddy = _currentBuddy!.copyWith(connectionState: _state);
  }

  Future<void> disconnect() async {
    _currentBuddy = null;
    _state = BodyDoubleConnectionState.disconnected;
  }

  /// Stub: send a focus‑sync ping (heartbeat or timer sync).
  Future<void> sendFocusPulse() async {
    if (_state != BodyDoubleConnectionState.connected) return;
    // In production: send via WebRTC data channel.
  }
}

final remoteBodyDoubleServiceProvider = Provider<RemoteBodyDoubleService>((ref) {
  return RemoteBodyDoubleService();
});
