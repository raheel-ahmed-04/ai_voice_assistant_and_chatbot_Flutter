import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';

class VoiceInput extends StatefulWidget {
  final Function(String) onResult;
  final Function(bool)? onListeningStateChanged;

  const VoiceInput({required this.onResult, this.onListeningStateChanged});

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

  Future<void> _listen() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
      widget.onListeningStateChanged?.call(false);
      return;
    }

    final micPermission = await Permission.microphone.request();
    if (micPermission != PermissionStatus.granted) {
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
          widget.onListeningStateChanged?.call(false);
        }
      },
      onError: (error) {
        setState(() {
          _isListening = false;
        });
        widget.onListeningStateChanged?.call(false);
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
      });
      widget.onListeningStateChanged?.call(true);

      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            widget.onResult(result.recognizedWords);
            setState(() {
              _isListening = false;
            });
            widget.onListeningStateChanged?.call(false);
          }
        },
      );
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
            child: Lottie.asset('assets/voice-wave.json', repeat: true),
          ),
      ],
    );
  }
}
