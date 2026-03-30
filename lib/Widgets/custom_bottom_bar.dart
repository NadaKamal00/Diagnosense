import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    const Color unselectedColor = Color(0xFF939393);
    const Color selectedColor = Color(0xFF387EF5);

    final double barHeight = res.isTablet ? (95 * res.scale) : 80.0;

    return Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25 * res.scale),
          topRight: Radius.circular(25 * res.scale),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B8B8B).withOpacity(0.12),
            blurRadius: 30 * res.scale,
            offset: Offset(0, -5 * res.scale),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          canvasColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
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
    const Color unselectedColor = Color(0xFF939393);
    const Color selectedColor = Color(0xFF387EF5);

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
