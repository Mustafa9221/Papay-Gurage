import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    backgroundColor: isError ? Color(0xFFEF4444) : Color(0xFF22C55E), // red or green
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 6,
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.25,
      ),
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
