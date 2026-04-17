import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

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
        color: isSuccess ? AppColors.feedbackSuccessBg : AppColors.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(7 * scale),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSuccess ? AppColors.successColor : AppColors.errorColor,
            fontSize: 13 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
