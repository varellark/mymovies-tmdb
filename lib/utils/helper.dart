import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy', 'id').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  static String formatCurrency(int? amount) {
    if (amount == null || amount == 0) return '-';
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatNumber(int number) {
    return NumberFormat.compact().format(number);
  }

  static Color ratingColor(double rating) {
    if (rating >= 7.5) return const Color(0xFF4CAF50);
    if (rating >= 5.0) return const Color(0xFFFFD700);
    return const Color(0xFFE50914);
  }

  static bool isValidEmail(String email) {
    return RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    ).hasMatch(email);
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static void showSnackBar(
      BuildContext context,
      String message, {
        bool isError = false,
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFE50914)
            : const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: duration,
      ),
    );
  }

  static bool validateLogin(String email, String password) {
    return email == 'admin@mymovies.com' && password == 'admin123';
  }
}
