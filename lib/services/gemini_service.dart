import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "AIzaSyDlR5kE0_7lwmE1nWfj9jIeWWysloPIw60";
  static const String _apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

  static Future<String> getAIResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "Give concise answer to my question: $prompt"},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      throw Exception("Failed to get AI response: ${response.statusCode}");
    }
  }

  static Future<String> getChatTitle(String conversation) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "write a simple title for this chat in less than 5 words, single line be generic: $conversation",
              },
            ],
          },
        ],
      }),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      throw Exception(
        "Failed to get chat title: " + response.statusCode.toString(),
      );
    }
  }
}
