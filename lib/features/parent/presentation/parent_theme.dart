// features/parent/presentation/parent_theme.dart
// ─────────────────────────────────────────────────────────────
// APPLE WIDGET-STYLE DESIGN SYSTEM — PARENT MODULE
// Same strict palette as Student app, primary accent shifted to
// blue/purple family so the Parent app feels distinct at a glance
// while staying visually part of the same product family.
// STRICT PALETTE: #58CC02 #FF9600 #1CB0F6 #FF4B4B #CE82FF
//                 #FFD900 #2B70C9 #FF6B35 #45A700 #CB3E3E
//                 #0081C8 #B800FF  — NO OTHER HEX ACCENTS
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PT {
  PT._();

  // ── 12 ALLOWED PALETTE COLORS (identical values to student _T) ──
  static const green = Color(0xFF46A800);
  static const greenDark = Color(0xFF357800);
  static const orange = Color(0xFFF59000);
  static const blue = Color(0xFF14A0E0);
  static const blueDark = Color(0xFF0072B5);
  static const blueDeep = Color(0xFF2464B8);
  static const red = Color(0xFFEC3A3A);
  static const redDark = Color(0xFFB83535);
  static const purple = Color(0xFFBB6EF0);
  static const purpleDark = Color(0xFFA500E8);
  static const yellow = Color(0xFFE8C400);
  static const coral = Color(0xFFEC5F28);

  // ── PRIMARY ACCENT FOR PARENT MODULE ──
  // Student app leads with green. Parent app leads with blueDeep/purple
  // so the two roles are instantly distinguishable in the same family.
  // Make Parent look like Student by using the student primary (green)
  static const primary = green;
  static const primaryDark = greenDark;
  static const secondary = purple;

  // ── NEUTRAL BACKGROUNDS (same warm-cream system as student) ──
  static const bg = Color(0xFFFDF6EC);
  static const bgElevated = Color(0xFFFFFAF4);

  // ── CARD TINTS (very pale — derived from palette) ──
  static const tintBlue = Color(0xFFEAF8FE);
  static const tintGreen = Color(0xFFF1FBE8);
  static const tintOrange = Color(0xFFFFF1E4);
  static const tintRed = Color(0xFFFFEEEE);
  static const tintPurple = Color(0xFFF7EEFF);
  static const tintYellow = Color(0xFFFFFBE3);

  // ── TEXT ──
  static const labelPrimary = Color(0xFF1C1C1E);
  static const labelSecondary = Color(0xFF3C3C43);
  static const labelTertiary = Color(0xFF8E8E93);
  static const labelQuaternary = Color(0xFFC7C7CC);

  // ── SEPARATORS ──
  static const separator = Color(0xFFE5E5EA);
  static const separatorDark = Color(0xFF38383A);

  // ── TYPOGRAPHY (same Fredoka family as student) ──
  static TextStyle title3({Color? color}) => GoogleFonts.fredoka(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? labelPrimary,
      );

  static TextStyle headline({Color? color}) => GoogleFonts.fredoka(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color ?? labelPrimary,
      );

  static TextStyle subheadline({Color? color}) => GoogleFonts.fredoka(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? labelSecondary,
      );

  static TextStyle caption1({Color? color}) => GoogleFonts.fredoka(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color ?? labelSecondary,
      );

  static TextStyle caption2({Color? color}) => GoogleFonts.fredoka(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: color ?? labelQuaternary,
      );

  static TextStyle numeric({Color? color, double size = 15}) =>
      GoogleFonts.fredoka(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? labelPrimary,
        height: 1.0,
      );

  // ── CARD DECORATIONS (identical shape language to student) ──
  static BoxDecoration get widgetCard => BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: .8),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      );

  static BoxDecoration tintCard(Color tint) => BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tint, Color.lerp(tint, Colors.white, 0.25)!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get smallCard => BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );

  /// Status colors for fee/attendance/homework states — kept inside the
  /// 12-color palette so every page stays visually consistent.
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'present':
      case 'completed':
      case 'submitted':
      case 'good':
        return green;
      case 'pending':
      case 'due':
      case 'upcoming':
        return orange;
      case 'overdue':
      case 'absent':
      case 'late':
      case 'missed':
        return red;
      case 'partial':
      case 'leave':
        return yellow;
      default:
        return labelTertiary;
    }
  }

  static Color statusTint(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'present':
      case 'completed':
      case 'submitted':
      case 'good':
        return tintGreen;
      case 'pending':
      case 'due':
      case 'upcoming':
        return tintOrange;
      case 'overdue':
      case 'absent':
      case 'late':
      case 'missed':
        return tintRed;
      case 'partial':
      case 'leave':
        return tintYellow;
      default:
        return tintBlue;
    }
  }
}