// core/utils/helpers.dart

import 'package:flutter/material.dart';

class Helpers {

  static snackBar(
    BuildContext context,
    String text,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}