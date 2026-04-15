import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/api_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final double scaleFactor =
        isTablet ? (screenWidth / 500) : (screenWidth / 375);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56 * scaleFactor,
        leadingWidth: (isTablet ? 90 : 70) * scaleFactor,
        leading: Container(
          margin: EdgeInsets.only(left: (isTablet ? 20 : 12) * scaleFactor),
          alignment: Alignment.centerLeft,
          child: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(8 * scaleFactor),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: const Color(0xFF0E1A34),
                    size: 20 * scaleFactor,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: const Color(0xFF0E1A34),
            fontWeight: FontWeight.bold,
            fontSize: 18 * scaleFactor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10 * scaleFactor),
          Divider(
            height: 1,
            thickness: .5,
            color: const Color(0xFFD5D5D5),
            indent: 40 * scaleFactor,
            endIndent: 40 * scaleFactor,
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: ApiService().getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final response = snapshot.data;
                final List<dynamic> notifications = response?['data'] ?? [];

                if (notifications.isEmpty) {
                  return Center(
                    child: Text(
                      "No notifications available",
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 14 * scaleFactor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: (isTablet ? 24 : 20) * scaleFactor,
                    vertical: 25 * scaleFactor,
                  ),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final String title = notification['title'] ?? 'No Title';
                    final String subtitle =
                        notification['description'] ?? 'No Description';
                    final String time = notification['time'] ?? '';

                    Widget iconWidget;
                    Color defaultIconColor = const Color(0xFF2563EB);

                    if (title == "Task") {
                      iconWidget = SvgPicture.asset(
                        'assets/Icons/tasks.svg',
                        width: 20 * scaleFactor,
                        height: 20 * scaleFactor,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF34A853),
                          BlendMode.srcIn,
                        ),
                      );
                    } else if (title == "Medication") {
                      iconWidget = Icon(
                        Symbols.pill,
                        color: AppColors.primaryMediumLight,
                        size: 20 * scaleFactor,
                      );
                    } else if (title == "Next Visit" || title == "New Visit") {
                      iconWidget = SvgPicture.asset(
                        'assets/Icons/clock.svg',
                        width: 17 * scaleFactor, // Visually adjusted size
                        height: 17 * scaleFactor,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryColor,
                          BlendMode.srcIn,
                        ),
                      );
                    } else {
                      iconWidget = Icon(
                        Icons.info_outline,
                        color: defaultIconColor,
                        size: 20 * scaleFactor,
                      );
                    }

                    return _buildNotificationCard(
                      scaleFactor,
                      title: title,
                      subtitle: subtitle,
                      time: time,
                      iconWidget: iconWidget,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    double scaleFactor, {
    required String title,
    required String subtitle,
    required String time,
    required Widget iconWidget,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16 * scaleFactor),
      padding: EdgeInsets.all(20 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scaleFactor),
        border: Border.all(
          color: const Color(0xFFCDCDCD),
          width: .5 * scaleFactor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10 * scaleFactor,
            offset: Offset(0, 4 * scaleFactor),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// icon background
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14 * scaleFactor,
              vertical: 12 * scaleFactor,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(6 * scaleFactor),
            ),
            child: iconWidget,
          ),

          SizedBox(width: 15 * scaleFactor),

          /// text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13 * scaleFactor,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0E1A34),
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    Text(
                      time,
                      style: TextStyle(
                        color: const Color(0xFF2A66FF),
                        fontSize: 11 * scaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6 * scaleFactor),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: const Color(0xFF8A94A6),
                    fontSize: 11 * scaleFactor,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
