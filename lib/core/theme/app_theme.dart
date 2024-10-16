import "package:coach_app/shared/constants/app_constants.dart";
import "package:flutter/material.dart";

import "package:coach_app/core/theme/app_colors.dart";
import "package:coach_app/core/theme/app_text_style.dart";

/// Defines the app's theme, including color schemes and widget styles.
class AppTheme {
  const AppTheme._();

  /// The color scheme for the light theme.
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryGreen,
    onPrimary: AppColors.black,
    secondary: AppColors.secondaryOrange,
    onSecondary: AppColors.black,
    error: AppColors.additionalRed,
    onError: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.black,
    tertiary: AppColors.grey50,
    onTertiary: AppColors.additionalBlack,
  );

  /// The color scheme for the dark theme.
  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryGreen,
    onPrimary: AppColors.black,
    secondary: AppColors.secondaryOrange,
    onSecondary: AppColors.black,
    error: AppColors.additionalRed,
    onError: AppColors.white,
    surface: AppColors.black,
    onSurface: AppColors.white,
    tertiary: AppColors.additionalBlack,
    onTertiary: AppColors.grey50,
  );

  /// Creates and returns a [ThemeData] object based on the specified [brightness].
  ///
  /// This method sets up the app's theme, including colors, text styles, and widget themes.
  static ThemeData theme({required Brightness brightness}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          const BorderSide(color: AppColors.black, style: BorderStyle.solid),
    );
    final colorScheme =
        brightness == Brightness.light ? lightScheme : darkScheme;

    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final width = view.physicalSize.width / view.devicePixelRatio;
    final isMobile = width < AppConstants.mobileBreakpoint;

    return ThemeData(
      fontFamily: 'Biryani',
      colorScheme: colorScheme,
      dividerColor: Colors.transparent,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.black, // Should not depend on color mode
          padding: isMobile
              ? const EdgeInsets.fromLTRB(20, 8, 20, 4)
              : const EdgeInsets.fromLTRB(20, 20, 20, 16),
          minimumSize: const Size(240, 46),
          disabledBackgroundColor: AppColors.grey100,
          disabledForegroundColor: colorScheme.onTertiary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.onSurface, width: 1),
          padding: isMobile
              ? const EdgeInsets.fromLTRB(20, 8, 20, 4)
              : const EdgeInsets.fromLTRB(20, 20, 20, 16),
          minimumSize: const Size(240, 46),
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: colorScheme.onTertiary,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.grey300,
        selectionColor: AppColors.grey300,
        selectionHandleColor: Colors.amber,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintStyle: AppTextStyle.primary16r.copyWith(
          color: AppColors.grey200,
        ),
        labelStyle: const TextStyle(color: AppColors.black),
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thickness: WidgetStatePropertyAll(4),
        crossAxisMargin: 4,
      ),
      navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(fontSize: 10, color: AppColors.white);
        }
        return const TextStyle(
          fontSize: 10,
          color: AppColors.grey300,
        );
      })),
      tabBarTheme: TabBarTheme(
        labelStyle: AppTextStyle.primary14b,
        unselectedLabelStyle: AppTextStyle.primary14r,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: colorScheme.onSurface,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
