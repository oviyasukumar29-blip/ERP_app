// core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // ✅ CHANGE FONT HERE — swap outfitTextTheme() with any other:
    // GoogleFonts.plusJakartaSansTextTheme()
    // GoogleFonts.nunitoTextTheme()
    // GoogleFonts.poppinsTextTheme()
    // GoogleFonts.dmSansTextTheme()
    // GoogleFonts.soraTextTheme()
    final base = GoogleFonts.soraTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.white,
        brightness: Brightness.light,
      ),

      textTheme: base.copyWith(
        displayLarge: base.displayLarge?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
          letterSpacing: -0.5,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontSize: 13,
          color: AppColors.textGrey,
        ),
        labelSmall: base.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
          letterSpacing: 0.3,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        // ✅ CHANGE FONT NAME HERE TOO — must match the method above:
        // Outfit → 'Outfit'
        // Plus Jakarta Sans → 'Plus Jakarta Sans'
        // Nunito → 'Nunito'
        // Poppins → 'Poppins'
        // DM Sans → 'DM Sans'
        // Sora → 'Sora'
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: -0.3,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 0.5,
        space: 0,
      ),
    );
  }
}
