import 'package:application/core/theme/app_colors.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        toolbarHeight: 56 * res.scale,
        leadingWidth: (res.isTablet ? 100 : 70) * res.scale,
        leading: Container(
          margin: EdgeInsets.only(left: (res.isTablet ? 20 : 12) * res.scale),
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryTextColor,
              size: 20 * res.scale,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Language',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25 * res.scale,
          vertical: 20 * res.scale,
        ),
        child: Column(
          children: [
            Divider(
              height: 1 * res.scale,
              thickness: 1 * res.scale,
              color: AppColors.dividerColor,
            ),

            SizedBox(height: 30 * res.scale),

            _buildLanguageOption(
              scale: res.scale,
              title: "English",
              isSelected: selectedLanguage == 'English',
              onTap: () {
                setState(() {
                  selectedLanguage = 'English';
                });
              },
            ),

            SizedBox(height: 20 * res.scale),

            _buildLanguageOption(
              scale: res.scale,
              title: "Arabic (العربية)",
              isSelected: selectedLanguage == 'Arabic',
              onTap: () {
                setState(() {
                  selectedLanguage = 'Arabic';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required double scale,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12 * scale),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20 * scale,
          vertical: 18 * scale,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15 * scale),
          border: Border.all(
            color:
                isSelected ? AppColors.accentColor : AppColors.lightBorderColor,
            width: (isSelected ? 2 : 1.5) * scale,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16 * scale,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: AppColors.primaryTextColor,
              ),
            ),
            if (isSelected)
              CircleAvatar(
                radius: 5 * scale,
                backgroundColor: AppColors.accentColor,
              ),
          ],
        ),
      ),
    );
  }
}
