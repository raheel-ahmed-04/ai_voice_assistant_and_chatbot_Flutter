import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../widgets/message_bubble.dart';
import '../widgets/voice_input.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  final String? conversationId;
  final bool showHistory;
  ChatScreen({this.conversationId, this.showHistory = false});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;
  bool _isVoiceInputActive = false;
  bool _isSending = false;
  User? user;
  String? _conversationId;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _conversationId = widget.conversationId;
    if (_conversationId == null) {
      // Start a new conversation
      _startNewConversation();
    } else {
      _loadMessages();
    }
  }

  Future<void> _startNewConversation() async {
    if (user == null) return;
    // Don't create a Firestore conversation doc yet; wait for first message
    setState(() {
      _conversationId = null;
    });
    _messages.clear();
  }

  Future<void> _loadMessages() async {
    if (user == null || _conversationId == null) return;
    final snapshot =
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(user!.uid)
            .collection('conversations')
            .doc(_conversationId)
            .collection('messages')
            .orderBy('timestamp')
            .get();
    setState(() {
      _messages.clear();
      _messages.addAll(
        snapshot.docs.map(
          (doc) => Message(text: doc['text'], fromUser: doc['fromUser']),
        ),
      );
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || user == null || _isSending) return;

    setState(() {
      _isSending = true; // Disable send button
    });

    try {
      // If this is the first message, create the conversation doc now
      if (_conversationId == null) {
        final docRef = await FirebaseFirestore.instance
            .collection('chats')
            .doc(user!.uid)
            .collection('conversations')
            .add({
              'lastMessage': text,
              'lastUpdated': FieldValue.serverTimestamp(),
              'title': '', // Placeholder, will update after Gemini
            });
        setState(() {
          _conversationId = docRef.id;
        });
      }
      setState(() {
        _messages.add(Message(text: text, fromUser: true));
        _isTyping = true;
      });
      _controller.clear();
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(user!.uid)
          .collection('conversations')
          .doc(_conversationId)
          .collection('messages')
          .add({
            'text': text,
            'fromUser': true,
            'timestamp': FieldValue.serverTimestamp(),
          });
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(user!.uid)
          .collection('conversations')
          .doc(_conversationId)
          .update({
            'lastMessage': text,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
      final aiResponse = await GeminiService.getAIResponse(text);
      setState(() {
        _messages.add(Message(text: aiResponse, fromUser: false));
        _isTyping = false;
      });
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(user!.uid)
          .collection('conversations')
          .doc(_conversationId)
          .collection('messages')
          .add({
            'text': aiResponse,
            'fromUser': false,
            'timestamp': FieldValue.serverTimestamp(),
          });
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(user!.uid)
          .collection('conversations')
          .doc(_conversationId)
          .update({
            'lastMessage': aiResponse,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
      // If this is the first user+AI message pair, generate a title
      final convoDoc =
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(user!.uid)
              .collection('conversations')
              .doc(_conversationId)
              .get();
      if ((convoDoc.data()?['title'] ?? '').isEmpty) {
        // Gather the first 6 messages for title context
        final messagesSnapshot =
            await FirebaseFirestore.instance
                .collection('chats')
                .doc(user!.uid)
                .collection('conversations')
                .doc(_conversationId)
                .collection('messages')
                .orderBy('timestamp')
                .limit(6)
                .get();
        final convoText = messagesSnapshot.docs.map((d) => d['text']).join(' ');
        try {
          final title = await GeminiService.getChatTitle(convoText);
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(user!.uid)
              .collection('conversations')
              .doc(_conversationId)
              .update({'title': title.trim()});
        } catch (_) {
          // fallback: do nothing
        }
      }
    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message. Please try again.')),
      );
    } finally {
      setState(() {
        _isSending = false; // Re-enable send button
      });
    }
  }

  void _handleVoiceResult(String result) {
    setState(() {
      _controller.text = result;
      _isVoiceInputActive = false; // Reset voice input state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFF0A2342),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Image.asset(
            'assets/lexichat-horizontal.png',
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  text: message.text,
                  fromUser: message.fromUser,
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Lottie.asset(
                'assets/ai-typing-indicator.json',
                width: 150,
                height: 100,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_isVoiceInputActive, // Disable during voice input
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText:
                          _isVoiceInputActive
                              ? 'Listening...'
                              : 'Ask me anything...',
                      hintStyle: TextStyle(color: Colors.blue[100]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                VoiceInput(
                  onResult: _handleVoiceResult,
                  onListeningStateChanged: (isListening) {
                    setState(() {
                      _isVoiceInputActive = isListening;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed:
                      (_isSending ||
                              _isVoiceInputActive)
                              //  || _controller.text.trim().isEmpty)
                          ? null
                          : () => _sendMessage(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text('Send', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool fromUser;

  Message({required this.text, required this.fromUser});
}
