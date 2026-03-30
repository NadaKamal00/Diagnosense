import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/login_screen.dart';
import '../../core/utils/api_service.dart';
import 'profile.dart';
import 'language.dart';
import 'privacy.dart';
import 'support.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoggingOut = false;
  String? _userName;
  String? _userEmail;
  bool _notificationsEnabled = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name');
      _userEmail = prefs.getString('user_email');
    });
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        // Fallback: If no token, just clear and go back
        await prefs.clear();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        return;
      }

      final data = await ApiService().logout(token);

      if (!mounted) return;

      final bool success = data['success'] == true;
      final String message =
          data['message'] ??
          (success ? 'Logout successfully.' : 'Logout failed.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        await prefs.clear();
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred during logout.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56 * res.scale,
        title: Text(
          'Settings',
          style: TextStyle(
            color: const Color(0xFF0E1A34),
            fontWeight: FontWeight.bold,
            fontSize: 20 * res.scale,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: res.isTablet ? 450 * res.scale : res.width,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: res.isTablet ? 5 * res.scale : 20 * res.scale,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20 * res.scale),

                  _buildProfileSection(context, res.scale),

                  SizedBox(
                    height: res.isTablet ? 35 * res.scale : 25 * res.scale,
                  ),

                  _buildSectionTitle('Account Settings', res.scale),
                  _buildSettingsGroup(
                    [
                      _buildSettingsItem(
                        icon: Icons.notifications_none_outlined,
                        iconColor:
                            _notificationsEnabled ? Colors.cyan : Colors.grey,
                        title: 'Allow Notifications',
                        scale: res.scale,
                        trailingOverride: CupertinoSwitch(
                          value: _notificationsEnabled,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _notificationsEnabled = !_notificationsEnabled;
                          });
                        },
                      ),
                      _buildSettingsItem(
                        icon: Icons.dark_mode_outlined,
                        iconColor: _isDarkMode ? Colors.purple : Colors.grey,
                        title: 'Dark Mode',
                        scale: res.scale,
                        trailingOverride: CupertinoSwitch(
                          value: _isDarkMode,
                          activeColor: Colors.purple,
                          onChanged: (value) {
                            setState(() {
                              _isDarkMode = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _isDarkMode = !_isDarkMode;
                          });
                        },
                      ),
                      _buildSettingsItem(
                        icon: Icons.language_outlined,
                        iconColor: Colors.orange,
                        title: 'Language',
                        trailingText: 'English',
                        scale: res.scale,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LanguageScreen(),
                              ),
                            ),
                      ),
                      _buildSettingsItem(
                        icon: Icons.lock_outline,
                        iconColor: Colors.green,
                        title: 'Privacy Policy',
                        scale: res.scale,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyScreen(),
                              ),
                            ),
                      ),
                      _buildSettingsItem(
                        icon: Icons.help_outline,
                        iconColor: Colors.teal,
                        title: 'Support & FAQ',
                        scale: res.scale,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SupportScreen(),
                              ),
                            ),
                      ),
                    ],
                    res.scale,
                    res.isTablet,
                  ),

                  SizedBox(height: 60 * res.scale),

                  _buildLogoutButton(res.scale),

                  SizedBox(height: 30 * res.scale),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, double scale) {
    return GestureDetector(
      onTap:
          () async {
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
            // Refresh data after returning from edit
            _loadUserData();
          },
      child: Container(
        padding: EdgeInsets.all(18 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20 * scale),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 15 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 17 * scale,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0E1A34),
                    ),
                  ),
                  Text(
                    _userEmail ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 13 * scale,
                      color: const Color(0xFF8A94A6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16 * scale,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double scale) {
    return Padding(
      padding: EdgeInsets.only(left: 10 * scale, bottom: 10 * scale),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14 * scale,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF8A94A6),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items, double scale, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 8 * scale : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        children:
            items.asMap().entries.map((entry) {
              int idx = entry.key;
              Widget item = entry.value;
              return Column(
                children: [
                  item,
                  if (idx < items.length - 1)
                    Divider(
                      indent: 60 * scale,
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailingText,
    Widget? trailingOverride,
    required double scale,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: trailingOverride != null ? null : onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 2 * scale,
      ),
      leading: Container(
        padding: EdgeInsets.all(8 * scale),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10 * scale),
        ),
        child: Icon(icon, color: iconColor, size: 22 * scale),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15 * scale,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF0E1A34),
        ),
      ),
      trailing:
          trailingOverride ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: TextStyle(
                    color: const Color(0xFF8A94A6),
                    fontSize: 13 * scale,
                  ),
                ),
              SizedBox(width: 5 * scale),
              Icon(
                Icons.arrow_forward_ios,
                size: 12 * scale,
                color: const Color(0xFFD1D5DB),
              ),
            ],
          ),
    );
  }

  Widget _buildLogoutButton(double scale) {
    return InkWell(
      onTap: _isLoggingOut ? null : _handleLogout,
      borderRadius: BorderRadius.circular(20 * scale),
      splashColor: Colors.red.withOpacity(0.1),
      highlightColor: Colors.red.withOpacity(0.05),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16 * scale),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(20 * scale),
          border: Border.all(
            color: Colors.red.withOpacity(0.15),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoggingOut)
              SizedBox(
                height: 20 * scale,
                width: 20 * scale,
                child: const CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(Icons.logout, color: Colors.red, size: 20 * scale),
            SizedBox(width: 10 * scale),
            Text(
              _isLoggingOut ? 'Logging out...' : 'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
