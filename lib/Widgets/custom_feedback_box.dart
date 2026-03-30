import 'package:flutter/material.dart';

class CustomFeedbackBox extends StatelessWidget {
  final String message;
  final bool isSuccess;
  final double scale;

  const CustomFeedbackBox({
    super.key,
    required this.message,
    required this.isSuccess,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 12 * scale,
      ),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0xFF98FFC9) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(7 * scale),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSuccess ? const Color(0xFF00C187) : Colors.red,
            fontSize: 13 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
