import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
          'Support',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              Divider(height: 1, thickness: 1, color: AppColors.dividerColor),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22 * res.scale),
                  border: Border.all(
                    color: AppColors.cardBorderColor,
                    width: 2 * res.scale,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 18 * res.scale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      'Our support team is available 24/7',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16 * res.scale,
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Call Support Button
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(double.maxFinite, 55 * res.scale),
                        side: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2 * res.scale,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34 * res.scale),
                        ),
                      ),
                      child: Text(
                        'Call Support',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 15 * res.scale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Send Email Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        fixedSize: Size(double.maxFinite, 55 * res.scale),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34 * res.scale),
                        ),
                      ),
                      child: Text(
                        'Send Email',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 15 * res.scale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
