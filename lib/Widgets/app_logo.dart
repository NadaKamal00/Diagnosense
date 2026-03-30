import 'package:flutter/material.dart';

/// A reusable Logo widget for Authentication screens.
/// Handles internal scaleFactor for responsiveness.
class AppLogo extends StatelessWidget {
  final double height;
  final IconData errorIcon;
  final double errorIconSize;

  const AppLogo({
    super.key,
    this.height = 80,
    this.errorIcon = Icons.medical_services,
    this.errorIconSize = 70,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final double scaleFactor =
    isTablet ? (screenWidth / 500) : (screenWidth / 375);

    return Image.asset(
      'assets/images/Logo.png',
      height: 82 * scaleFactor,
      width: 241 * scaleFactor,
      errorBuilder:
          (context, error, stackTrace) => Icon(
        errorIcon,
        size: errorIconSize * scaleFactor,
        color: const Color(0xFF2563EB),
      ),
    );
  }
}
