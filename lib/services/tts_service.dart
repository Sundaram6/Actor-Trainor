import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../screens/settings_screen.dart';

class TtsService {
  FlutterTts? _flutterTts;
  bool _enabled = true;
  bool _isInitialized = false;

  bool get isEnabled => _enabled;
  set enabled(bool value) => _enabled = value;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _flutterTts ??= FlutterTts();
      await _flutterTts?.setLanguage('en-US');
      await _flutterTts?.setSpeechRate(0.45); // calm, measured pace
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);
      _isInitialized = true;
    } catch (_) {
      // Graceful fallback for environments without TTS platform implementation
    }
  }

  Future<void> speak(String text) async {
    if (!_enabled || text.isEmpty) return;
    try {
      await init();
      await _flutterTts?.stop();
      await _flutterTts?.speak(text);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
    } catch (_) {}
  }
}

class NoopTtsService extends TtsService {
  @override
  Future<void> init() async {}

  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}
}

final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  final enabled = ref.watch(voiceInstructionsEnabledProvider);
  service.enabled = enabled;
  return service;
});
