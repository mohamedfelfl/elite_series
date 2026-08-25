import 'package:flutter/material.dart';

/// Design System Colors for "Elite Series"
/// Light: Crisp Royal Slate & Electric Blue
/// Dark: Midnight Slate & Radiant Accents
class AppColors {
  AppColors._();

  // ─── LIGHT MODE: "Elite Modern Light" ───

  static const lightPrimary = Color(0xFF0D63F8);
  static const lightPrimaryContainer = Color(0xFFE0EBFF);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightOnPrimaryContainer = Color(0xFF003D99);

  static const lightSecondary = Color(0xFFFF7A00);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightSecondaryContainer = Color(0xFFFFE8D6);
  static const lightOnSecondaryContainer = Color(0xFF662800);

  static const lightTertiary = Color(0xFF0E2246);
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightTertiaryContainer = Color(0xFFD9E2F2);
  static const lightOnTertiaryContainer = Color(0xFF051226);

  static const lightSurface = Color(0xFFF8FAFC);
  static const lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const lightSurfaceContainerLow = Color(0xFFF1F5F9);
  static const lightSurfaceContainer = Color(0xFFEAEFF5);
  static const lightSurfaceContainerHigh = Color(0xFFE2E8F0);
  static const lightSurfaceContainerHighest = Color(0xFFCBD5E1);
  static const lightOnSurface = Color(0xFF0F172A);
  static const lightOnSurfaceVariant = Color(0xFF475569);

  static const lightBackground = Color(0xFFF8FAFC);
  static const lightOnBackground = Color(0xFF0F172A);

  static const lightOutline = Color(0xFF94A3B8);
  static const lightOutlineVariant = Color(0xFFE2E8F0);

  static const lightError = Color(0xFFDC2626);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFEE2E2);
  static const lightOnErrorContainer = Color(0xFF7F1D1D);

  // ─── DARK MODE: "Elite Midnight Dark" ───

  static const darkPrimary = Color(0xFF82B1FF);
  static const darkPrimaryContainer = Color(0xFF0D3B82);
  static const darkOnPrimary = Color(0xFF002244);
  static const darkOnPrimaryContainer = Color(0xFFD6E4FF);

  static const darkSecondary = Color(0xFFFFB066);
  static const darkOnSecondary = Color(0xFF331400);
  static const darkSecondaryContainer = Color(0xFF5C2600);
  static const darkOnSecondaryContainer = Color(0xFFFFDCC2);

  static const darkTertiary = Color(0xFFA8C7FA);
  static const darkOnTertiary = Color(0xFF001D4D);
  static const darkTertiaryContainer = Color(0xFF1B3B6F);
  static const darkOnTertiaryContainer = Color(0xFFD3E3FD);

  static const darkSurface = Color(0xFF0A0F1D);
  static const darkSurfaceBright = Color(0xFF243048);
  static const darkSurfaceContainerLowest = Color(0xFF060A14);
  static const darkSurfaceContainerLow = Color(0xFF0F172A);
  static const darkSurfaceContainer = Color(0xFF141E34);
  static const darkSurfaceContainerHigh = Color(0xFF1B2844);
  static const darkSurfaceContainerHighest = Color(0xFF233456);
  static const darkOnSurface = Color(0xFFF1F5F9);
  static const darkOnSurfaceVariant = Color(0xFFCBD5E1);

  static const darkBackground = Color(0xFF0A0F1D);
  static const darkOnBackground = Color(0xFFF1F5F9);

  static const darkOutline = Color(0xFF475569);
  static const darkOutlineVariant = Color(0xFF1E293B);

  static const darkError = Color(0xFFFCA5A5);
  static const darkOnError = Color(0xFF7F1D1D);
  static const darkErrorContainer = Color(0xFF991B1B);
  static const darkOnErrorContainer = Color(0xFFFEE2E2);

  // ─── SEMANTIC COLORS ───

  static const success = Color(0xFF10B981);
  static const successContainer = Color(0xFFD1FAE5);
  static const warning = Color(0xFFF59E0B);
  static const warningContainer = Color(0xFFFEF3C7);
  static const info = Color(0xFF0284C7);
  static const infoContainer = Color(0xFFE0F2FE);

  // ─── STATUS CHIPS ───

  static const attendedChip = Color(0xFF10B981);
  static const missedChip = Color(0xFFEF4444);
  static const otherLessonChip = Color(0xFFFF7A00);

  // ─── ACTION CARD COLORS (Dashboard Quick Actions) ───

  static const actionStudent = Color(0xFF0D63F8);
  static const actionQrScanner = Color(0xFFFF7A00);
  static const actionAssistant = Color(0xFF475569);
  static const actionAssistantDir = Color(0xFF334155);
  static const actionPayment = Color(0xFF10B981);
  static const actionExam = Color(0xFF8B5CF6);
  static const actionReport = Color(0xFF0284C7);
  static const actionGroup = Color(0xFF6366F1);
  static const actionNotes = Color(0xFF0D9488);
  static const actionAdmin = Color(0xFF1E3A8A);
  static const actionHonor = Color(0xFFF59E0B);
  static const actionSettings = Color(0xFF64748B);

  // ─── RANK COLORS (Honor Board & Exams) ───

  static const rankGold = Color(0xFFFFB800);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
  static const rankFirst = Color(0xFF0D63F8);
  static const rankSecond = Color(0xFF64748B);
  static const rankThird = Color(0xFF8D6E63);

  // ─── EXAM TAB COLORS ───

  static const examTabActive = Color(0xFFD6E4FF);
  static const examTabInactive = Color(0xFFFFE8D6);
  static const examTabActiveText = Color(0xFF0D63F8);
  static const examTabInactiveText = Color(0xFFD96B00);

  // ─── GLASSMORPHISM HELPERS ───

  /// Light mode glass opacity (85%)
  static const double lightGlassOpacity = 0.85;

  /// Dark mode glass opacity (80%)
  static const double darkGlassOpacity = 0.80;

  /// Ghost border opacity (15%)
  static const double ghostBorderOpacity = 0.15;

  /// Ambient shadow opacity
  static const double ambientShadowOpacity = 0.06;
  static const double darkAmbientShadowOpacity = 0.40;
}
