import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import the splash screen

void main() {
  runApp(TranslationApp());
}

class TranslationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bajo Translate",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Set the splash screen as the initial route
    );
  }
}