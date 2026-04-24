import 'package:flutter/material.dart';

/// A centralized repository for all colors used across the app's UI.
/// Supports both Light and Dark themes via dynamic getters.
class AppColors {
  static bool _isDark = false;

  /// Global update method called by ThemeProvider to switch the palette.
  static void updateTheme(bool isDark) {
    _isDark = isDark;
  }

  // --- Background Colors ---
  static Color get backgroundColor => _isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFF);

  // --- Brand Colors ---
  static Color get primaryColor => _isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);
  static Color get accentColor => _isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
  static Color get primaryLight => _isDark ? const Color(0xFF1E293B) : const Color(0xFF93C5FD);
  static Color get primaryMedium => _isDark ? const Color(0xFF2563EB) : const Color(0xFF60A5FA);
  static Color get primaryDeep => _isDark ? const Color(0xFF1D4ED8) : const Color(0xFF2B65D9);
  static Color get primaryMediumLight => _isDark ? const Color(0xFF60A5FA) : const Color(0xFF3A80F5);

  // --- Text Colors ---
  static Color get primaryTextColor => _isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0E1A34);
  static Color get secondaryTextColor => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF8A94A6);
  static Color get darkNavy => _isDark ? const Color(0xFFE2E8F0) : const Color(0xFF09254A);
  static Color get subtleTextColor => _isDark ? const Color(0xFFCBD5E1) : const Color(0xFF4B5563);
  static Color get mutedTextColor => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  static Color get bodyTextColor => _isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280);
  static Color get headingColor => _isDark ? const Color(0xFFF8FAFF) : const Color(0xFF1F2937);
  static Color get disabledTextColor => _isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);
  static Color get darkGreyText => _isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D2D2D);
  static Color get mediumGreyTextColor => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF646464);

  // --- UI Element Colors ---
  static Color get borderColor => _isDark ? const Color(0xFF334155) : const Color(0xFFD1D5DB);
  static Color get lightBorderColor => _isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
  static Color get inputBackgroundColor => _isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
  static Color get cardBorderColor => _isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
  static Color get secondaryBorderColor => _isDark ? const Color(0xFF475569) : const Color(0xFFCDCDCD);
  static Color get lightGrayBorder => _isDark ? const Color(0xFF334155) : const Color(0xFFD8D8D8);
  static Color get dividerColor => _isDark ? const Color(0xFF334155) : const Color(0xFFD5D5D5);
  static Color get softBorderColor => _isDark ? const Color(0xFF1E293B) : const Color(0xFFEAEAEA);

  // --- Surfaces & Shadows ---
  static Color get white => _isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  static Color get black => _isDark ? const Color(0xFFF8FAFF) : const Color(0xFF000000); // Inverse for visibility
  static Color get surfaceVariant => _isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6);
  static Color get shadowColor => _isDark ? const Color(0x66000000) : const Color(0xFF3E3E3E);
  static Color get cardShadowColor => _isDark ? const Color(0x44000000) : const Color(0xFFC9C9C9);
  static Color get primaryGradientShadow => _isDark ? const Color(0x333B82F6) : const Color(0xFF74A9FF);

  // --- Feedback & Status ---
  static Color get errorColor => _isDark ? const Color(0xFFEF4444) : const Color(0xFFF44336);
  static Color get errorLightBackground => _isDark ? const Color(0x1AEF4444) : const Color(0xFFFFF1F1);
  static Color get successColor => _isDark ? const Color(0xFF10B981) : const Color(0xFF00C187);
  static Color get successEmerald => _isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
  static Color get successGreen => _isDark ? const Color(0xFF22C55E) : const Color(0xFF4CAF50);
  static Color get deepSuccessColor => _isDark ? const Color(0xFF059669) : const Color(0xFF2E7D32);
  static Color get successLight => _isDark ? const Color(0x1A10B981) : const Color(0xFFDCFCE7);
  static Color get successText => _isDark ? const Color(0xFF34D399) : const Color(0xFF34A853);
  static Color get feedbackSuccessBg => _isDark ? const Color(0xFF064E3B) : const Color(0xFF98FFC9);
  
  static Color get warningAmber => _isDark ? const Color(0xFFF59E0B) : const Color(0xFFF59E0B);
  static Color get warningLight => _isDark ? const Color(0x1AF59E0B) : const Color(0xFFFFEDD5);
  static Color get warningText => _isDark ? const Color(0xFFF59E0B) : const Color(0xFFFF7B00);
  static Color get instructionBackground => _isDark ? const Color(0xFF1E293B) : const Color(0xFFFFF9E8);

  // --- Specialized UI Colors ---
  static Color get labelColor => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF374151);
  static Color get mutedColor => _isDark ? const Color(0xFF64748B) : const Color(0xFF939393);
  static Color get darkMutedColor => _isDark ? const Color(0xFF475569) : const Color(0xFF777777);
  static Color get iconGrey => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF667085);
  static Color get activeGreen => _isDark ? const Color(0xFF34D399) : const Color(0xFF22C55E);
  static Color get completedGrey => _isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);
  static Color get hintGrey => _isDark ? const Color(0xFF64748B) : const Color(0xFF9E9E9E);
  static Color get lightBlueSurface => _isDark ? const Color(0xFF1E293B) : const Color(0xFFEDF2FF);
  
  // --- Icons & Navigation ---
  static Color get notificationColor => _isDark ? const Color(0xFF22D3EE) : const Color(0xFF00BCD4);
  static Color get darkModeIconColor => _isDark ? const Color(0xFFC084FC) : const Color(0xFF9C27B0);
  static Color get languageIconColor => _isDark ? const Color(0xFFFB923C) : const Color(0xFFFF9800);
  static Color get supportIconColor => _isDark ? const Color(0xFF2DD4BF) : const Color(0xFF009688);
  static Color get navSelectedColor => _isDark ? const Color(0xFF60A5FA) : const Color(0xFF387EF5);
  static Color get navShadowLight => _isDark ? const Color(0x66000000) : const Color(0xFF8B8B8B);
  static Color get iconBackground => _isDark ? const Color(0xFF334155) : const Color(0xFFF0F7FF);

  // --- Feature Specific ---
  static Color get historyItemBg => _isDark ? const Color(0xFF1E293B) : const Color(0xFFE4ECFF);
  static Color get labItemBg => _isDark ? const Color(0xFF064E3B) : const Color(0xFFCCFFD6);
  static Color get radiologyItemBg => _isDark ? const Color(0xFF451A03) : const Color(0xFFFFECE4);
  static Color get radiologyIconColor => _isDark ? const Color(0xFFFB923C) : const Color(0xFFB93815);

  // --- Shimmer Effects ---
  static Color get shimmerBase => _isDark ? const Color(0xFF1E293B) : const Color(0xFFE0E0E0);
  static Color get shimmerHighlight => _isDark ? const Color(0xFF334155) : const Color(0xFFF5F5F5);
  static Color get shimmerLightBorder => _isDark ? const Color(0xFF334155) : const Color(0xFFD9D9D9);

  // --- Badge Elements ---
  static Color get pdfBadgeBackground => _isDark ? const Color(0xFF450A0A) : const Color(0xFFFFEBEE);
  static Color get pdfBadgeText => _isDark ? const Color(0xFFF87171) : const Color(0xFFEF5350);
  static Color get docBadgeBackground => _isDark ? const Color(0xFF334155) : const Color(0xFFE0E0E0);
  static Color get docBadgeText => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF818181);
  static Color get defaultBadgeBackground => _isDark ? const Color(0xFF1E293B) : const Color(0xFFF0F0F0);
  static Color get defaultBadgeText => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF666666);

  // --- Utility ---
  static const Color transparent = Colors.transparent;
}
