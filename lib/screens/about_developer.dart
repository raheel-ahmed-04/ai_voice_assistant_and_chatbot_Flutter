import 'package:flutter/material.dart';

class AboutDeveloperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFF0A2342),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            'assets/lexichat-horizontal.png',
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            color: Colors.white.withOpacity(0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/raheel1.jpg'),
                    ),
                  // CircleAvatar(
                  //   radius: 48,
                  //   backgroundColor: Color(0xFF1976D2),
                  //   child: Icon(Icons.person, size: 60, color: Colors.white),
                  // ),
                  SizedBox(height: 18),
                  Text(
                    'Raheel Ahmed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2342),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'FA22-BSE-077',
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Flutter Developer',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'This project, LexiChat, is an AI Voice Assistant & Chatbot developed as a semester project for MAD (Sir Hassan Sardar). It features Firebase authentication, Google sign-in, and a modern UI.',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Color(0xFF1976D2)),
                      SizedBox(width: 8),
                      Text(
                        'raheelqazi29@gmail.com',
                        style: TextStyle(color: Color(0xFF0A2342)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.link, color: Color(0xFF1976D2)),
                      SizedBox(width: 8),
                      Text(
                        'linkedin.com/in/raheelahmad72',
                        style: TextStyle(color: Color(0xFF0A2342)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
