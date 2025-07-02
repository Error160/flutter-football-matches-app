import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const String fontFamily = 'ChakraPetch';

  // Brand Colors
  static const Color primary = Color(0xFF2E3236);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color accent = Color(0xFF86F14D);
  static const Color accentSecondary = Color(0xFFE6FF48);
  
  // Surface Colors
  static const Color background = Color(0xFF2E3236);
  static const Color surface = Color(0xFF43484C);
  static const Color card = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textDark = Colors.black87;
  static const Color textDisabled = Color(0xFF757575);
  static const Color matchTime = Color(0xFF949699);
  
  // Status Colors
  static const Color success = Colors.green;
  static const Color warning = Colors.amber;
  static const Color error = Color(0xFFB00020);
  static const Color info = Colors.blue;
  static const Color live = Colors.red;
  static const Color paused = Colors.orange;

  // Button Colors
  static const Color buttonPrimary = accent;
  static const Color buttonSecondary = primary;
  static const Color buttonText = primary;
  static const Color buttonTextSecondary = white;
  
  // Icon Colors  
  static const Color iconPrimary = white;
  static const Color iconSecondary = textSecondary;
  static Color iconDisabled = grey600;
  
  // Utility Colors
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Grey Scale
  static Color grey100 = Colors.grey[100]!;
  static Color grey400 = Colors.grey[400]!;
  static Color grey500 = Colors.grey[500]!;
  static Color grey600 = Colors.grey[600]!;
  static Color grey700 = Colors.grey[700]!;

  // Dynamic Colors
  static Color borderLight = white.withValues(alpha: 0.1);
  static Color borderMedium = white.withValues(alpha: 0.2);
  static Color borderStrong = white.withValues(alpha: 0.3);
  static Color borderGrey = Colors.grey.withValues(alpha: 0.4);
  
  static Color overlay08 = white.withValues(alpha: 0.08);
  static Color overlay15 = white.withValues(alpha: 0.15);
  static Color overlay80 = white.withValues(alpha: 0.8);
  static Color blackOverlay05 = black.withValues(alpha: 0.05);
  
  static Color liveBackground = live.withValues(alpha: 0.08);
  static Color liveBackgroundStrong = live.withValues(alpha: 0.03);
  static Color liveBorder = live.withValues(alpha: 0.3);
  static Color liveAccent = live.withValues(alpha: 0.1);
  
  static Color shadowLight = black.withValues(alpha: 0.05);
  static Color shadowMedium = black.withValues(alpha: 0.1);
  static Color shadowAccent = accent.withValues(alpha: 0.3);
  static Color shadowLive = live.withValues(alpha: 0.1);
  
  // Gradients
  static const List<Color> primaryGradient = [accent, accentSecondary];
  static const List<Color> backgroundGradient = [accent, accentSecondary];
  static const List<Color> flagGradient = [Colors.red, Colors.yellow];
  static List<Color> liveGradient = [
    live.withValues(alpha: 0.08),
    live.withValues(alpha: 0.03),
  ];
  
  // Team Colors
  static const List<Color> jerseyColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
  ];
  
  // Utilities
  static Color withOpacity(Color color, double opacity) =>
      color.withValues(alpha: opacity);
  
  static Color getJerseyColor(int index) =>
      jerseyColors[index % jerseyColors.length];
  
  static Color getStatusColor(String status) {
    return switch (status.toLowerCase()) {
      'live' => live,
      'paused' => paused,
      'finished' => success,
      'cancelled' => error,
      _ => textSecondary,
    };
  }
} 