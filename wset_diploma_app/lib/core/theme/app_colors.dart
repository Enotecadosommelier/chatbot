import 'package:flutter/material.dart';

/// Premium, wine-inspired palette. Kept as named constants (not scattered
/// literals) so the whole UI reads as one system and dark mode can invert
/// consistently.
class AppColors {
  AppColors._();

  static const bordeaux = Color(0xFF6B1E2C);
  static const bordeauxDark = Color(0xFF4A1420);
  static const gold = Color(0xFFC9A24B);
  static const cream = Color(0xFFF7F1E8);
  static const ink = Color(0xFF1E1B1A);
  static const slate = Color(0xFF5B5654);
  static const success = Color(0xFF3E7C4A);
  static const warning = Color(0xFFB2732B);
  static const error = Color(0xFFA23B3B);
}
