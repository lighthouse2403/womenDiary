import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppleLoginPage(),
    );
  }
}

class AppleLoginPage extends StatefulWidget {
  @override
  _AppleLoginPageState createState() => _AppleLoginPageState();
}

class _AppleLoginPageState extends State<AppleLoginPage> {
  String? email;
  bool? isPrivateEmail;

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      // Decode identity token to get is_private_email
      final parts = credential.identityToken!.split('.');
      final payload = base64.normalize(parts[1]);
      final decoded = json.decode(utf8.decode(base64Url.decode(payload)));

      setState(() {
        email = credential.email ?? decoded['email'];
        isPrivateEmail = decoded['is_private_email'] == true;
      });
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apple Login Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (email != null) Text('Email: $email'),
            if (isPrivateEmail != null)
              Text('Is Private Email: $isPrivateEmail'),
            const SizedBox(height: 30),
            SignInWithAppleButton(
              onPressed: signInWithApple,
            ),
          ],
        ),
      ),
    );
  }
}
