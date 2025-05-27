// services/speech_service.dart

import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  static final FlutterTts _flutterTts = FlutterTts();

  /// Initialize the TTS engine with default settings
  static Future<void> init() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// Speak a given text
  static Future<void> speak(String text) async {
    await _flutterTts.stop(); // Ensure no overlapping speech
    await _flutterTts.speak(text);
  }

  /// Stop ongoing speech
  static Future<void> stop() async {
    await _flutterTts.stop();
  }
}
