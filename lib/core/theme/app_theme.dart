import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  /// Main dark theme for the sports betting app
  static ThemeData get darkTheme {
    return ThemeData(
      // Basic theme configuration
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppColors.fontFamily,
      
      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.accent,
        onPrimary: AppColors.primary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        tertiary: AppColors.accentSecondary,
        error: AppColors.error,
        onError: AppColors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.card,
        outline: AppColors.borderMedium,
        shadow: AppColors.shadowMedium,
      ),

      // Scaffold theme
      scaffoldBackgroundColor: AppColors.background,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.iconPrimary),
        titleTextStyle: AppTextStyles.headlineMedium,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Card theme
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.buttonText,
          disabledBackgroundColor: AppColors.grey600,
          disabledForegroundColor: AppColors.textDisabled,
          elevation: 0,
          shadowColor: AppColors.shadowAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonText,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          disabledForegroundColor: AppColors.textDisabled,
          side: BorderSide(color: AppColors.borderMedium, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonText,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          disabledForegroundColor: AppColors.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTextStyles.labelMedium,
        ),
      ),

      // Icon button theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.iconPrimary,
          disabledForegroundColor: AppColors.iconDisabled,
          backgroundColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Tab bar theme
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.buttonText,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.tabLabel,
        unselectedLabelStyle: AppTextStyles.tabLabelInactive,
        indicator: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.transparent,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.caption,
        unselectedLabelStyle: AppTextStyles.caption,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) 
              ? AppColors.accent 
              : AppColors.grey600;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.accent.withValues(alpha: 0.3)
              : AppColors.grey600.withValues(alpha: 0.3);
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.accent
              : AppColors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.primary),
        side: BorderSide(color: AppColors.borderMedium, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.grey600,
        thumbColor: AppColors.accent,
        overlayColor: AppColors.accent.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.accent,
        valueIndicatorTextStyle: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
        ),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: AppColors.grey600,
        circularTrackColor: AppColors.grey600,
      ),

      // Snack bar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTextStyles.bodyMedium,
        actionTextColor: AppColors.accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        titleTextStyle: AppTextStyles.headlineSmall,
        contentTextStyle: AppTextStyles.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 24,
        shadowColor: AppColors.shadowMedium,
      ),

      // Tooltip theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        textStyle: AppTextStyles.bodySmall,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Text theme - comprehensive text styles
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: AppColors.iconPrimary,
        size: 24,
      ),

      // Primary icon theme
      primaryIconTheme: IconThemeData(
        color: AppColors.iconPrimary,
        size: 24,
      ),
    );
  }

  /// Light theme (optional - for accessibility or user preference)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppColors.fontFamily,
      
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        tertiary: AppColors.accent,
        error: AppColors.error,
        onError: AppColors.white,
        surface: AppColors.surfaceWhite,
        onSurface: AppColors.textDark,
        surfaceContainerHighest: AppColors.grey100,
        outline: AppColors.borderGrey,
        shadow: AppColors.shadowLight,
      ),

      scaffoldBackgroundColor: AppColors.surfaceLight,
      
      // Apply similar theming as dark theme but with light colors
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.textDark),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.textDark),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.textDark),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.textDark),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.textDark),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.textDark),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textDark),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.textDark),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textDark),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textDark),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.textDark),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.textDark),
      ),
    );
  }

  /// Get system UI overlay style for status bar
  static SystemUiOverlayStyle get systemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    );
  }
} 