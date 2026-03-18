import 'package:flutter/material.dart';

class MainTheme {
  // Vibrant Green from the designs
  static const Color primaryColor = Color(0xFF00C853);
  
  // Dark Navy for toggles and specific accents
  static const Color secondaryColor = Color(0xFF101D2D);
  
  // Soft Tertiary/Light Blue-Grey
  static const Color tertiaryColor = Color(0xFF9DB2CE);
  
  // Background and surface colors
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  
  // Text colors
  static const Color textPrimary = Color(0xFF101D2D);
  static const Color textSecondary = Color(0xFF6B7280);
  
  static const Color blackishColor = Color(0xFF253237);
  static const Color greyishColor = Color(0xFFD9D9D9);
  static const Color redishColor = Color(0xFFFA5252);

  // Gradient for headers
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00C853)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}
