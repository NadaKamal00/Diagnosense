import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final Color unselectedColor = AppColors.mutedColor;
    final Color selectedColor = AppColors.navSelectedColor;

    final double barHeight = res.isTablet ? (95 * res.scale) : 80.0;

    return Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25 * res.scale),
          topRight: Radius.circular(25 * res.scale),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navShadowLight.withOpacity(0.12),
            blurRadius: 30 * res.scale,
            offset: Offset(0, -5 * res.scale),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          canvasColor: AppColors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: AppColors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: res.isTablet ? (14 * res.scale) : 12.0,
          unselectedFontSize: res.isTablet ? (12 * res.scale) : 10.0,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
          unselectedLabelStyle: TextStyle(height: 1.0),
          items: [
            _buildNavItem("Home", 'assets/Icons/home.svg', 0, res),
            _buildNavItem("Tasks", 'assets/Icons/tasks.svg', 1, res),
            _buildNavItem("Settings", 'assets/Icons/settings.svg', 2, res),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      String label,
      String iconPath,
      int index,
      Responsive res,
      ) {
    final Color unselectedColor = AppColors.mutedColor;
    final Color selectedColor = AppColors.navSelectedColor;

    final bool isSelected = currentIndex == index;
    final double iconSize =
    res.isTablet
        ? (isSelected ? 28 : 26) * res.scale
        : (isSelected ? 22 : 20);

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.zero,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(
              isSelected ? selectedColor : unselectedColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      label: label,
    );
  }
}
