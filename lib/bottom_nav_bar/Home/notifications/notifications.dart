import 'package:flutter/material.dart';

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
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: (isTablet ? 24 : 20) * scaleFactor,
                vertical: 25 * scaleFactor,
              ),
              children: [
                _buildNotificationCard(
                  scaleFactor,
                  title: "HbA1c Test Overdue",
                  subtitle:
                      "Dr. Smith has requested a repeat test. Please schedule soon.",
                  time: "2h ago",
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFF2563EB),
                ),
                _buildNotificationCard(
                  scaleFactor,
                  title: "Nephrology Appointment",
                  subtitle: "Upcoming appointment tomorrow at 10:00 AM.",
                  time: "Yesterday",
                  icon: Icons.access_time,
                  iconColor: const Color(0xFF2563EB),
                ),
                _buildNotificationCard(
                  scaleFactor,
                  title: "Lipid Panel Results",
                  subtitle: "Your recent lab results are ready for view.",
                  time: "2d ago",
                  icon: Icons.description_outlined,
                  iconColor: const Color(0xFF34A853),
                ),
              ],
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
    required IconData icon,
    required Color iconColor,
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
            child: Icon(icon, color: iconColor, size: 20 * scaleFactor),
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
