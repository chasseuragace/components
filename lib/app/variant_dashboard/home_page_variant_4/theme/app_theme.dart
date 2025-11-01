import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the job portal application.
/// Implements Contemporary Professional Minimalism design with Professional Blue Spectrum colors.
class AppTheme {
  AppTheme._();

  // Professional Blue Spectrum Colors - optimized for mobile readability
  static const Color primaryLight = Color(
    0xFF2563EB,
  ); // Core blue for CTAs and navigation
  static const Color primaryDark = Color(
    0xFF3B82F6,
  ); // Interactive elements for dark mode
  static const Color secondaryLight = Color(
    0xFF1E40AF,
  ); // Darker blue for active states
  static const Color secondaryDark = Color(
    0xFF2563EB,
  ); // Adjusted for dark mode contrast
  static const Color accentLight = Color(
    0xFF3B82F6,
  ); // Interactive elements and progress
  static const Color accentDark = Color(
    0xFF60A5FA,
  ); // Lighter accent for dark mode

  // Status Colors
  static const Color successLight = Color(
    0xFF059669,
  ); // Application confirmations
  static const Color successDark = Color(
    0xFF10B981,
  ); // Success states for dark mode
  static const Color warningLight = Color(
    0xFFD97706,
  ); // Salary alerts and prompts
  static const Color warningDark = Color(
    0xFFF59E0B,
  ); // Warning states for dark mode
  static const Color errorLight = Color(
    0xFFDC2626,
  ); // Form validation and errors
  static const Color errorDark = Color(
    0xFFF87171,
  ); // Error states for dark mode

  // Background and Surface Colors
  static const Color backgroundLight = Color(
    0xFFFAFAFA,
  ); // Primary surface reducing eye strain
  static const Color backgroundDark = Color(
    0xFF0F172A,
  ); // Dark background for night browsing
  static const Color surfaceLight = Color(
    0xFFFFFFFF,
  ); // Card backgrounds with elevation
  static const Color surfaceDark = Color(0xFF1E293B); // Dark surface for cards
  static const Color cardLight = Color(0xFFFFFFFF); // Clean card backgrounds
  static const Color cardDark = Color(0xFF334155); // Elevated dark cards

  // Text Colors - maintaining readability hierarchy
  static const Color textPrimaryLight = Color(
    0xFF111827,
  ); // High contrast for job titles
  static const Color textPrimaryDark = Color(
    0xFFF8FAFC,
  ); // Primary text for dark mode
  static const Color textSecondaryLight = Color(
    0xFF6B7280,
  ); // Supporting details and metadata
  static const Color textSecondaryDark = Color(
    0xFF94A3B8,
  ); // Secondary text for dark mode
  static const Color textDisabledLight = Color(0xFF9CA3AF); // Disabled states
  static const Color textDisabledDark = Color(
    0xFF64748B,
  ); // Disabled text for dark mode

  // Divider and Border Colors
  static const Color dividerLight = Color(0xFFE5E7EB); // Subtle separation
  static const Color dividerDark = Color(0xFF475569); // Dark mode dividers
  static const Color borderLight = Color(
    0xFFD1D5DB,
  ); // Form inputs and controls
  static const Color borderDark = Color(0xFF64748B); // Dark mode borders

  // Shadow Colors - subtle elevation
  static const Color shadowLight = Color(0x0F000000); // Light shadow for cards
  static const Color shadowDark = Color(
    0x1F000000,
  ); // Darker shadow for dark mode

  /// Light theme implementing Contemporary Professional Minimalism
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: Colors.white,
      primaryContainer: primaryLight.withAlpha(26),
      onPrimaryContainer: primaryLight,
      secondary: secondaryLight,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight.withAlpha(26),
      onSecondaryContainer: secondaryLight,
      tertiary: accentLight,
      onTertiary: Colors.white,
      tertiaryContainer: accentLight.withAlpha(26),
      onTertiaryContainer: accentLight,
      error: errorLight,
      onError: Colors.white,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: borderLight,
      outlineVariant: dividerLight,
      shadow: shadowLight,
      scrim: Colors.black54,
      inverseSurface: surfaceDark,
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    dividerColor: dividerLight,

    // AppBar Theme - clean professional header
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimaryLight,
      elevation: 2.0,
      shadowColor: shadowLight,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight),
      actionsIconTheme: IconThemeData(color: textPrimaryLight),
    ),

    // Card Theme - subtle elevation without visual heaviness
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 2.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),

    // Bottom Navigation - adaptive navigation with professional styling
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button - search functionality
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),

    // Button Themes - consistent interaction patterns
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryLight,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: primaryLight, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    // Typography - Inter font family for excellent mobile legibility
    textTheme: _buildTextTheme(isLight: true),

    // Input Decoration - minimal borders with clear focus states
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryLight, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Interactive Elements
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withAlpha(128);
        }
        return Colors.grey.shade300;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: borderLight, width: 2.0),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return borderLight;
      }),
    ),

    // Progress Indicators
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentLight,
      linearTrackColor: accentLight.withAlpha(51),
      circularTrackColor: accentLight.withAlpha(51),
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withAlpha(51),
      inactiveTrackColor: primaryLight.withAlpha(77),
      trackHeight: 4.0,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryLight,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryLight.withAlpha(230),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryLight,
      contentTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    dialogTheme: DialogThemeData(backgroundColor: surfaceLight),
  );

  /// Dark theme for comfortable night browsing
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: Colors.white,
      primaryContainer: primaryDark.withAlpha(51),
      onPrimaryContainer: primaryDark,
      secondary: secondaryDark,
      onSecondary: Colors.white,
      secondaryContainer: secondaryDark.withAlpha(51),
      onSecondaryContainer: secondaryDark,
      tertiary: accentDark,
      onTertiary: Colors.white,
      tertiaryContainer: accentDark.withAlpha(51),
      onTertiaryContainer: accentDark,
      error: errorDark,
      onError: Colors.white,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: dividerDark,
      shadow: shadowDark,
      scrim: Colors.black87,
      inverseSurface: surfaceLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,

    // AppBar Theme - dark mode styling
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textPrimaryDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark),
      actionsIconTheme: IconThemeData(color: textPrimaryDark),
    ),

    // Card Theme - dark mode cards
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 4.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),

    // Bottom Navigation - dark mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button - dark mode
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),

    // Button Themes - dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryDark,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: primaryDark, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    // Typography - dark mode
    textTheme: _buildTextTheme(isLight: false),

    // Input Decoration - dark mode
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryDark, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Interactive Elements - dark mode
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.grey.shade600;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withAlpha(128);
        }
        return Colors.grey.shade700;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: borderDark, width: 2.0),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return borderDark;
      }),
    ),

    // Progress Indicators - dark mode
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentDark,
      linearTrackColor: accentDark.withAlpha(51),
      circularTrackColor: accentDark.withAlpha(51),
    ),

    // Slider Theme - dark mode
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryDark,
      thumbColor: primaryDark,
      overlayColor: primaryDark.withAlpha(51),
      inactiveTrackColor: primaryDark.withAlpha(77),
      trackHeight: 4.0,
    ),

    // Tab Bar Theme - dark mode
    tabBarTheme: TabBarThemeData(
      labelColor: primaryDark,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip Theme - dark mode
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withAlpha(230),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // SnackBar Theme - dark mode
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryDark,
      contentTextStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    dialogTheme: DialogThemeData(backgroundColor: surfaceDark),
  );

  /// Helper method to build text theme with Inter font family
  /// Implements typography standards for excellent mobile legibility
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary = isLight
        ? textSecondaryLight
        : textSecondaryDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles - large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Headline styles - section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Title styles - job titles and important text
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
      ),

      // Body styles - main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
      ),

      // Label styles - buttons and small text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
      ),
    );
  }
}
