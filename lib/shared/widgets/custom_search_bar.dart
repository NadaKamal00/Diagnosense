import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/theme/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final dynamic res;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ((res.isTablet ? 24 : 20) * res.scale).toDouble(),
        vertical: (15 * res.scale).toDouble(),
      ),
      child: Container(
        height: (51 * res.scale).toDouble(),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular((12 * res.scale).toDouble()),
          border: Border.all(
            color: AppColors.secondaryBorderColor,
            width: (0.8 * res.scale).toDouble(),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadowColor.withOpacity(0.15),
              blurRadius: (10 * res.scale).toDouble(),
              offset: Offset(0, (4 * res.scale).toDouble()),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          style: TextStyle(fontSize: (14 * res.scale).toDouble()),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.secondaryTextColor,
              fontSize: (13 * res.scale).toDouble(),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all((15.0 * res.scale).toDouble()),
              child: SvgPicture.asset(
                'assets/Icons/search.svg',
                width: (12 * res.scale).toDouble(),
                colorFilter: ColorFilter.mode(
                  AppColors.mutedColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: (15 * res.scale).toDouble(),
            ),
          ),
        ),
      ),
    );
  }
}
