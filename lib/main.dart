// main.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_screen.dart';

void main() {
  runApp(const PineSphereApp());
}

class PineSphereApp extends StatelessWidget {
  const PineSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PineSphere ERP',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}