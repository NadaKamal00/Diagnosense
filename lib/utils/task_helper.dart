import 'package:flutter/material.dart';

class TaskHelper {
  /// Robust date parser for various formats (ISO, DD-MM-YYYY, DD Month).
  static DateTime? parseDueDate(String dateStr) {
    if (dateStr.isEmpty) return null;

    // Try standard parse first (ISO 8601)
    DateTime? parsed = DateTime.tryParse(dateStr);
    if (parsed != null) return parsed;

    // Handle DD-MM-YYYY or DD/MM/YYYY
    if (RegExp(r'^\d{1,2}[-/]\d{1,2}[-/]\d{2,4}').hasMatch(dateStr)) {
      final parts = dateStr.split(RegExp(r'[-/]'));
      if (parts.length >= 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        int year = int.tryParse(parts[2]) ?? DateTime.now().year;
        if (year < 100) year += 2000;

        if (day != null && month != null) {
          return DateTime(year, month, day);
        }
      }
    }

    // Handle "DD Month" or "Month DD" or "DD Month YYYY"
    final monthMap = {
      'january': 1,
      'february': 2,
      'march': 3,
      'april': 4,
      'may': 5,
      'june': 6,
      'july': 7,
      'august': 8,
      'september': 9,
      'october': 10,
      'november': 11,
      'december': 12,
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };

    final words = dateStr.toLowerCase().split(RegExp(r'[\s,]+'));
    int? day;
    int? month;
    int year = DateTime.now().year;

    for (var word in words) {
      if (monthMap.containsKey(word)) {
        month = monthMap[word];
      } else {
        final digitsOnly = word.replaceAll(RegExp(r'\D'), '');
        if (digitsOnly.isNotEmpty) {
          final num = int.parse(digitsOnly);
          if (num > 31) {
            year = num;
          } else {
            day = num;
          }
        }
      }
    }

    if (day != null && month != null) {
      return DateTime(year, month, day);
    }

    return null;
  }

  /// Determines if a task is overdue based on its due date string.
  static bool isOverdue(String? dueDate) {
    if (dueDate == null || dueDate.isEmpty) return false;
    final parsed = parseDueDate(dueDate);
    return parsed != null && parsed.isBefore(DateTime.now());
  }

  /// Returns the standardized status color for tasks.
  static Color getStatusColor({required bool isCompleted, required bool isOverdue}) {
    if (isCompleted) return const Color(0xFF939393); // Grey
    if (isOverdue) return Colors.red; // Overdue
    return Colors.green; // On time
  }

  /// Returns the decoration for the deadline section when overdue.
  static BoxDecoration? getDeadlineDecoration({
    required bool isCompleted,
    required bool isOverdue,
    required double scale,
  }) {
    if (!isCompleted && isOverdue) {
      return BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(6 * scale),
      );
    }
    return null;
  }

  /// Returns the padding for the deadline section when overdue.
  static EdgeInsets getDeadlinePadding({
    required bool isCompleted,
    required bool isOverdue,
    required double scale,
  }) {
    if (!isCompleted && isOverdue) {
      return EdgeInsets.symmetric(
        horizontal: 8 * scale,
        vertical: 4 * scale,
      );
    }
    return EdgeInsets.zero;
  }
}
