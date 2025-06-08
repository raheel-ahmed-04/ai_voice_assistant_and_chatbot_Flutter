import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';

class VoiceInput extends StatefulWidget {
  final Function(String) onResult;

  const VoiceInput({required this.onResult});

  @override
  _VoiceInputState createState() => _VoiceInputState();
}

class _VoiceInputState extends State<VoiceInput> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission denied');
      return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            if (val.finalResult) {
              widget.onResult(val.recognizedWords);
              setState(() => _isListening = false);
            }
          },
        );
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
          onPressed: _listen,
          color: const Color(0xFF2196F3),
          tooltip: _isListening ? 'Stop Listening' : 'Start Listening',
        ),
        if (_isListening)
          SizedBox(
            width: 80,
            height: 70,
            child: Lottie.asset(
              'assets/voice-wave.json',
              repeat: true,
            ),
          ),
      ],
    );
  }
}
