import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color deepPurple = Color(0xFF0A0D2B);
  static const Color surfacePurple = Color(0xFF151E42);
  static const Color neonCyan = Color(0xFF2DE2E6);
  static const Color neonOrange = Color(0xFFFF8A3D);
  static const Color neonMagenta = Color(0xFFB23CFF);
  static const Color neonBlue = Color(0xFF4A7BFF);
  static const Color textSecondary = Color(0xFF9AA7C7);
  static const Color cardBorder = Color(0xFF27355F);

  static const Color primaryColor = Color(0xFF7C4DFF);
  static const Color backgroundColor = deepPurple;
  static const Color surfaceColor = surfacePurple;
  static const Color textColor = Colors.white;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: neonMagenta,
        surface: surfacePurple,
        onSurface: textColor,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.orbitron(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        titleLarge: GoogleFonts.orbitron(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surfacePurple,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: cardBorder),
        ),
      ),
    );
  }

  static BoxDecoration get mainBackground => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF121B47), Color(0xFF080F34), Color(0xFF2B0F50)],
      stops: [0.0, 0.58, 1.0],
    ),
  );

  static BoxDecoration get metallicDecoration => mainBackground;

  static Gradient get fireGradient => const LinearGradient(
    colors: [neonOrange, neonMagenta, neonBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static BoxDecoration get gridDecoration => const BoxDecoration(
    color: backgroundColor,
  );

  static BoxDecoration cardDecoration({
    bool highlighted = false,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(24)),
  }) {
    return BoxDecoration(
      borderRadius: borderRadius,
      gradient: highlighted
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A2955), Color(0xFF1A1748)],
            )
          : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF16254C), Color(0xFF121B40)],
            ),
      border: Border.all(color: cardBorder),
      boxShadow: const [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    );
  }

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  );

  static Widget gradientButtonChild({
    required String text,
    required IconData icon,
  }) {
    return Ink(
      decoration: BoxDecoration(
        gradient: fireGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

