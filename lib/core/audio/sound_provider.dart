import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/audio/sound_service.dart';

final soundServiceProvider = Provider<SoundService>((ref) => SoundService.instance);
