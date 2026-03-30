import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool pushEnabled = true;
  bool emailEnabled = true;
  bool smsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56 * res.scale,
        leadingWidth: (res.isTablet ? 100 : 70) * res.scale,
        leading: Container(
          margin: EdgeInsets.only(left: (res.isTablet ? 20 : 12) * res.scale),
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: const Color(0xFF0E1A34),
              size: 20 * res.scale,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: const Color(0xFF0E1A34),
            fontWeight: FontWeight.w600,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 10 * res.scale),
          Divider(
            height: 1 * res.scale,
            thickness: 1.5 * res.scale,
            color: const Color(0xFFD5D5D5),
            indent: 40 * res.scale,
            endIndent: 40 * res.scale,
          ),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 20 * res.scale,
                vertical: 25 * res.scale,
              ),
              children: [
                _buildSettingCard(
                  scale: res.scale,
                  title: "Push Notifications",
                  value: pushEnabled,
                  onChanged: (val) => setState(() => pushEnabled = val!),
                ),
                _buildSettingCard(
                  scale: res.scale,
                  title: "Email Alerts",
                  value: emailEnabled,
                  onChanged: (val) => setState(() => emailEnabled = val!),
                ),
                _buildSettingCard(
                  scale: res.scale,
                  title: "SMS Updates",
                  value: smsEnabled,
                  onChanged: (val) => setState(() => smsEnabled = val!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required double scale,
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16 * scale),
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 8 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34 * scale),
        border: Border.all(color: const Color(0xFFCDCDCD), width: .5 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5 * scale),
            ),
          ),
        ),
        child: CheckboxListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15 * scale,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0E1A34),
            ),
          ),
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF3B82F6),
          checkColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }
}
