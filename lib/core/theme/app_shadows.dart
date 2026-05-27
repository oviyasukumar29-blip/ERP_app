// core/theme/app_shadows.dart

import 'package:flutter/material.dart';

class AppShadows {
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}