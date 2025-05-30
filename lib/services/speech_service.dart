// services/speech_service.dart

import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class SpeechService {
  static final FlutterTts _flutterTts = FlutterTts();

  /// Initialize the TTS engine with default settings
  static Future<void> init() async {
    try {
      // Set platform-specific initialization if needed
      if (!kIsWeb) {
        await _flutterTts.setLanguage("en-US");
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setVolume(1.0);
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setVoice({
          // 'name': 'th-th-x-thd-network',
          // 'locale': 'th-TH',
          // 'name': 'ru-ru-x-rud-local',
          // 'locale': 'ru-RU',
          'name': 'it-it-x-itd-local',
          'locale': 'it-IT',
        });
      }
      
    } catch (e) {
      debugPrint("TTS Initialization Error: $e");
    }
  }

  /// Speak a given text
  static Future<void> speak(String text) async {
    try {
      await _flutterTts.stop(); // Prevent overlapping speech
      await _flutterTts.speak(text);
      // List<dynamic> voices = await _flutterTts.getVoices;
      // print("Voices are $voices");
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  /// Stop ongoing speech
  static Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint("TTS Stop Error: $e");
    }
  }
}
