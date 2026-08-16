import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static AudioPlayer? _player;
  static bool enabled = true;

  static Future<void> playBell() async {
    if (!enabled) return;
    try {
      _player ??= AudioPlayer();
      await _player?.play(AssetSource('sounds/bell.mp3'));
    } catch (_) {
      // Silently fail if sound file missing or platform channels unavailable
    }
  }

  static Future<void> dispose() async {
    try {
      await _player?.dispose();
    } catch (_) {}
    _player = null;
  }
}
