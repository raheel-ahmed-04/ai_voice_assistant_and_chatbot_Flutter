// services/gemini_service.dart
import 'dart:async';

class GeminiService {
  static Future<String> getAIResponse(String prompt) async {
    // TODO: Replace with actual Gemini API call
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return "Here's what I think about: \"$prompt\" 🤖";
  }
}
