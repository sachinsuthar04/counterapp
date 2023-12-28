import 'package:flutter/material.dart';

class CustomSnackbar {
  // show snackbar
  static void pushSnackbar(
    BuildContext context,
    String message, {
    bool error = false,
  }) {
    // clear snackbar if any
    ScaffoldMessenger.of(context).clearSnackBars();
    // push a new snackbar with message
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? const Color(0xFFB31C11) : Colors.indigo,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // clear snackbar
  static void clearSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
