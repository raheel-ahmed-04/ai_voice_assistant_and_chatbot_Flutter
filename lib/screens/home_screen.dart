import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'about_developer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFF0A2342),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white), // Drawer icon color
          title: Image.asset(
            'assets/lexichat-horizontal.png',
            height: 48,
            fit: BoxFit.contain,
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.logout, color: Colors.white),
          //     tooltip: 'Logout',
          //     onPressed: () async {
          //       await FirebaseAuth.instance.signOut();
          //       Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (_) => LoginScreen()),
          //         (route) => false,
          //       );
          //     },
          //   ),
          // ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0A2342),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1976D2)),
              accountName: Text(
                user?.displayName ?? 'User',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                user?.email ?? '',
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF1976D2), size: 40),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.code, color: Colors.white),
              title: Text(
                'About Developer',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutDeveloperPage()),
                );
              },
            ),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: Colors.white),
              title: Text(
                'Help & Support',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/ai-animation2.json',
                      width: 350,
                      height: 300,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '"Your Personal AI Voice Assistant & Chatbot"',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Made by Raheel Ahmed (FA22-BSE-077)',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ChatScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
              icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
              label: Text(
                'Start New Chat',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E88E5),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(Icons.history, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Chat History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2342),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            _ChatHistoryList(userId: user?.uid),
          ],
        ),
      ),
    );
  }
}

class _ChatHistoryList extends StatelessWidget {
  final String? userId;

  const _ChatHistoryList({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Center(
        child: Text('User not logged in', style: TextStyle(color: Colors.grey)),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('chats')
              .doc(userId)
              .collection('conversations')
              .orderBy('lastUpdated', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              'assets/loader2.json',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading chat history',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final conversations = snapshot.data?.docs;

        if (conversations == null || conversations.isEmpty) {
          return Center(
            child: Text(
              'No chat history found',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: conversations.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final doc = conversations[index];
            final lastMsg = doc['lastMessage'] ?? '';
            final lastUpdated = (doc['lastUpdated'] as Timestamp?)?.toDate();
            final title = (doc.data() as Map<String, dynamic>)['title'] ?? '';
            // Skip empty conversations (no messages, no title, no lastMessage)
            if ((lastMsg.isEmpty || lastMsg.trim().isEmpty) &&
                (title.isEmpty || title.trim().isEmpty)) {
              return SizedBox.shrink();
            }
            return ListTile(
              leading: Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF1976D2),
              ),
              title: Text(
                title.isNotEmpty
                    ? title
                    : (lastMsg.length > 40
                        ? lastMsg.substring(0, 40) + '...'
                        : lastMsg),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  lastUpdated != null
                      ? Text(
                        '${lastUpdated.toLocal()}'.split('.')[0],
                        style: TextStyle(color: Colors.grey[700]),
                      )
                      : null,
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: Text('Delete Conversation'),
                          content: Text(
                            'Are you sure you want to delete this conversation and all its messages?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                  if (confirm != true) return;
                  // Delete all messages in the conversation
                  final messagesRef = FirebaseFirestore.instance
                      .collection('chats')
                      .doc(userId)
                      .collection('conversations')
                      .doc(doc.id)
                      .collection('messages');
                  final messagesSnapshot = await messagesRef.get();
                  final batch = FirebaseFirestore.instance.batch();
                  for (var msg in messagesSnapshot.docs) {
                    batch.delete(msg.reference);
                  }
                  batch.delete(
                    FirebaseFirestore.instance
                        .collection('chats')
                        .doc(userId)
                        .collection('conversations')
                        .doc(doc.id),
                  );
                  await batch.commit();
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(conversationId: doc.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
