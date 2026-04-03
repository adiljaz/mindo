import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const MindoApp());
}

class MindoApp extends StatelessWidget {
  const MindoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
