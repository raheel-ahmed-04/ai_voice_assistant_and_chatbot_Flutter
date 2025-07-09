import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'services/speech_service.dart';
// import 'screens/login_screen.dart';
// import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SpeechService.init(); // Initialize TTS
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Voice Assistant & Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      // routes: {
      //   '/login': (_) => LoginScreen(),
      //   '/register': (_) => RegisterScreen(),
      // },
    );
  }
}
