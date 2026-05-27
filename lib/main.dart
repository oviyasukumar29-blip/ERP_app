// main.dart

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_screen.dart';

void main() {
  runApp(const ScholarHubApp());
}

class ScholarHubApp extends StatelessWidget {
  const ScholarHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScholarHub',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}