import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// The complete theme data for the Student Management System.
///
/// Two themes: Light ("The Academic Atelier") and Dark ("The Scholarly Midnight").
/// Both follow Material 3 logic with bespoke premium execution:
/// - No 1px borders — tonal surface shifts only
/// - No standard shadows — ambient 32px blur, ghost borders at 15% opacity
/// - Card radius: 28px (XL), Button radius: 16px (LG)
/// - Glassmorphism for floating elements
class AppTheme {
  AppTheme._();

  // ─── SHARED CONSTANTS ───

  static const double cardRadius = 28.0;
  static const double buttonRadius = 16.0;
  static const double chipRadius = 50.0; // Full roundness
  static const double inputRadius = 12.0;
  static const double moduleSpacing = 28.0; // 1.75rem
  static const double listItemSpacing = 14.4; // 0.9rem

  // ─── LIGHT THEME ───

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimaryContainer: AppColors.lightOnPrimaryContainer,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondaryContainer: AppColors.lightOnSecondaryContainer,
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightOnTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      onTertiaryContainer: AppColors.lightOnTertiaryContainer,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      errorContainer: AppColors.lightErrorContainer,
      onErrorContainer: AppColors.lightOnErrorContainer,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,
      surfaceContainerLowest: AppColors.lightSurfaceContainerLowest,
      surfaceContainerLow: AppColors.lightSurfaceContainerLow,
      surfaceContainer: AppColors.lightSurfaceContainer,
      surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
      surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightSurface,
      textTheme: AppTypography.textTheme(
        displayColor: AppColors.lightOnSurface,
        bodyColor: AppColors.lightOnSurface,
      ),

      // App Bar — glass effect applied in widgets
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface.withValues(
          alpha: AppColors.lightGlassOpacity,
        ),
        foregroundColor: AppColors.lightOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineSmall(
          color: AppColors.lightOnSurface,
        ),
      ),

      // Cards — 28px radius, no borders, tonal surface
      cardTheme: CardThemeData(
        color: AppColors.lightSurfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Buttons — 16px radius, primary fill
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.labelLarge(),
        ),
      ),

      // Text Buttons — ghost style
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.labelLarge(),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: BorderSide(
            color: AppColors.lightOutlineVariant.withValues(
              alpha: AppColors.ghostBorderOpacity,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.labelLarge(),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimaryContainer,
        foregroundColor: AppColors.lightOnPrimaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
      ),

      // Input fields — Filled style, no bottom stroke
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide(color: AppColors.lightError, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: AppTypography.bodyMedium(
          color: AppColors.lightOnSurfaceVariant,
        ),
        hintStyle: AppTypography.bodyMedium(
          color: AppColors.lightOnSurfaceVariant,
        ),
      ),

      // Chips — full roundness
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSecondaryContainer,
        labelStyle: AppTypography.labelMedium(
          color: AppColors.lightOnSecondaryContainer,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(cardRadius)),
        ),
      ),

      // Divider — should NOT be used, but if it is, use ghost border
      dividerTheme: DividerThemeData(
        color: AppColors.lightOutlineVariant.withValues(
          alpha: AppColors.ghostBorderOpacity,
        ),
        thickness: 1,
      ),

      // Navigation Rail (desktop)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.lightSurfaceContainerLow,
        indicatorColor: AppColors.lightPrimaryContainer.withValues(alpha: 0.3),
        selectedIconTheme: IconThemeData(color: AppColors.lightPrimary),
        unselectedIconTheme: IconThemeData(
          color: AppColors.lightOnSurfaceVariant,
        ),
        labelType: NavigationRailLabelType.all,
      ),

      // Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.lightSurfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(cardRadius),
          ),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightOnSurface,
        contentTextStyle: AppTypography.bodyMedium(
          color: AppColors.lightSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(inputRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Data Table
      dataTableTheme: DataTableThemeData(
        headingTextStyle: AppTypography.labelLarge(
          color: AppColors.lightOnSurfaceVariant,
        ),
        dataTextStyle: AppTypography.bodyMedium(
          color: AppColors.lightOnSurface,
        ),
        headingRowColor: WidgetStateProperty.all(
          AppColors.lightSurfaceContainerLow,
        ),
        dataRowColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  // ─── DARK THEME ───

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkOnTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      onTertiaryContainer: AppColors.darkOnTertiaryContainer,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      errorContainer: AppColors.darkErrorContainer,
      onErrorContainer: AppColors.darkOnErrorContainer,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
      surfaceBright: AppColors.darkSurfaceBright,
      surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
      surfaceContainerLow: AppColors.darkSurfaceContainerLow,
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkSurface,
      textTheme: AppTypography.textTheme(
        displayColor: AppColors.darkOnSurface,
        bodyColor: AppColors.darkOnSurface,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface.withValues(
          alpha: AppColors.darkGlassOpacity,
        ),
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineSmall(
          color: AppColors.darkOnSurface,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Buttons — Gradient applied via widget decoration
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.labelLarge(),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.labelLarge(),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: BorderSide(
            color: AppColors.darkOutlineVariant.withValues(
              alpha: AppColors.ghostBorderOpacity,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: AppTypography.labelLarge(),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimaryContainer,
        foregroundColor: AppColors.darkOnPrimaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
      ),

      // Input fields — Filled, no bottom stroke, secondary active bar
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide(color: AppColors.darkSecondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide(color: AppColors.darkError, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: AppTypography.bodyMedium(
          color: AppColors.darkOnSurfaceVariant,
        ),
        hintStyle: AppTypography.bodyMedium(
          color: AppColors.darkOnSurfaceVariant,
        ),
      ),

      // Chips — royal purple accent
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSecondaryContainer,
        labelStyle: AppTypography.labelMedium(
          color: AppColors.darkOnSecondaryContainer,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(cardRadius)),
        ),
      ),

      // Divider — ghost border
      dividerTheme: DividerThemeData(
        color: AppColors.darkOutlineVariant.withValues(
          alpha: AppColors.ghostBorderOpacity,
        ),
        thickness: 1,
      ),

      // Navigation Rail (desktop)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.darkSurfaceContainerLow,
        indicatorColor: AppColors.darkPrimaryContainer.withValues(alpha: 0.3),
        selectedIconTheme: IconThemeData(color: AppColors.darkPrimary),
        unselectedIconTheme: IconThemeData(
          color: AppColors.darkOnSurfaceVariant,
        ),
        labelType: NavigationRailLabelType.all,
      ),

      // Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.darkSurfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(cardRadius),
          ),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkOnSurface,
        contentTextStyle: AppTypography.bodyMedium(
          color: AppColors.darkSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(inputRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Data Table
      dataTableTheme: DataTableThemeData(
        headingTextStyle: AppTypography.labelLarge(
          color: AppColors.darkOnSurfaceVariant,
        ),
        dataTextStyle: AppTypography.bodyMedium(color: AppColors.darkOnSurface),
        headingRowColor: WidgetStateProperty.all(
          AppColors.darkSurfaceContainerLow,
        ),
        dataRowColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
