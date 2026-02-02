import 'package:flutter/material.dart';
import 'package:pet_sure/core/app_theme.dart';
import 'package:pet_sure/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      // debugShowCheckedModeBanner: false,
      home: const SplashScreen());
  }
}
