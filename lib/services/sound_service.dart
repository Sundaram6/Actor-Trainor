import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/settings_screen.dart';

class SoundService {
  static bool enabled = true;
  AudioPlayer? _player;
  bool _enabled = true;

  void setEnabled(bool value) {
    _enabled = value;
    enabled = value;
  }

  Future<void> playTransitionTone() async {
    if (!_enabled || !enabled) return;
    try {
      _player ??= AudioPlayer();
      await _player?.play(AssetSource('sounds/transition.mp3'));
    } catch (_) {
      try {
        await _player?.play(AssetSource('sounds/bell.mp3'));
      } catch (_) {}
    }
  }

  Future<void> playCompletionTone() async {
    if (!_enabled || !enabled) return;
    try {
      _player ??= AudioPlayer();
      await _player?.play(AssetSource('sounds/complete.mp3'));
    } catch (_) {
      try {
        await _player?.play(AssetSource('sounds/bell.mp3'));
      } catch (_) {}
    }
  }

  void dispose() {
    try {
      _player?.dispose();
    } catch (_) {}
    _player = null;
  }
}

final soundServiceProvider = Provider<SoundService>((ref) {
  final service = SoundService();
  final enabled = ref.watch(soundEnabledProvider);
  service.setEnabled(enabled);
  return service;
});
