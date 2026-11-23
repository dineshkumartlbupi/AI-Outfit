import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFFFF2E7E);      // Hot Pink / Magenta
  static const Color primaryDark = Color(0xFFC0155B);
  static const Color primaryLight = Color(0xFFFF65A4);
  static const Color accent = Color(0xFF8B5CF6);       // Electric Violet
  
  // Backgrounds & Surfaces
  static const Color bgDark = Color(0xFF0F0F16);
  static const Color cardDark = Color(0xFF1B1B26);
  static const Color surfaceDark = Color(0xFF242434);
  static const Color strokeDark = Color(0xFF2F2F44);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF2E7E), Color(0xFF903AFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF240E2C), Color(0xFF120E24)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldAccentGradient = LinearGradient(
    colors: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: cardDark,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Colors.white60,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: primary,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
