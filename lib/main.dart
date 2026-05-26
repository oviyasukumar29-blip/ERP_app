import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PinesphereErpApp());
}

class PinesphereErpApp extends StatelessWidget {
  const PinesphereErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinesphere ERP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(GoogleFonts.poppinsTextTheme()),
      home: const LoginScreen(),
    );
  }
}
