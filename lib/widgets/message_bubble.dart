import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool fromUser;

  const MessageBubble({required this.text, required this.fromUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: fromUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: fromUser ? Colors.white : Colors.black,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () {
                // Implement text-to-speech functionality here; for now, just print the text.
                print("Speaking: $text");
              },
            ),
          ],
        ),
      ),
    );
  }
}
