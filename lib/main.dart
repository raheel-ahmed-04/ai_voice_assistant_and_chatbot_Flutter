import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/speech_service.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await SpeechService.init(); // Initialize TTS
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Voice Assistant & Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
