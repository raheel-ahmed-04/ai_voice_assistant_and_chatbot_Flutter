import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  bool _isPasswordObscured = true;

  Future<void> register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          title: Image.asset(
            'assets/lexichat-horizontal.png',
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/chatting-animation.json',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 18),
                Text(
                  'Create your LexiChat account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Register to get started',
                  style: TextStyle(fontSize: 16, color: Colors.blue[100]),
                ),
                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.blue[100]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.blue[200]),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isPasswordObscured,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.blue[100]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue[200]),
                    suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                        ? Icons.visibility
                        : Icons.visibility_off,
                      color: Colors.blue[200],
                    ),
                    onPressed: () {
                      setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                    ),
                  ),
                  ),
                ),
                if (errorMessage != null) ...[
                  SizedBox(height: 16),
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                ],
                SizedBox(height: 28),
                isLoading
                    ? CircularProgressIndicator(color: Colors.blueAccent)
                    : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1976D2),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(fontSize: 18,color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Already have an account? Login",
                            style: TextStyle(
                              color: Colors.blue[100],
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
