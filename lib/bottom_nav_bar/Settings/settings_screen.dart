import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/shimmer_effect.dart';
import 'support.dart';
import 'privacy.dart';
import 'language.dart';
import 'profile/profile.dart';
import '../../core/utils/api_service.dart';
import '../../auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:application/utils/responsive_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoggingOut = false;
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  bool _notificationsEnabled = true;
  bool _isProfileLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _userName = prefs.getString('user_name');
          _userEmail = prefs.getString('user_email');
          _userPhone = prefs.getString('saved_user_phone');
          print("Loaded Phone from Prefs: $_userPhone");
        });
      }
    } catch (e) {
      debugPrint('Error loading user data in Settings: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProfileLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
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
          backgroundColor:
              success ? AppColors.successGreen : AppColors.errorColor,
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
        SnackBar(
          content: Text('An error occurred during logout.'),
          backgroundColor: AppColors.errorColor,
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
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        toolbarHeight: 56 * res.scale,
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20 * res.scale,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal:
                res.isTablet
                    ? (40 * res.scale).toDouble()
                    : (20 * res.scale).toDouble(),
            vertical: (20 * res.scale).toDouble(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: (10 * res.scale).toDouble()),
              _buildProfileSection(context, res.scale, res.isTablet),

              SizedBox(height: res.isTablet ? 35 * res.scale : 25 * res.scale),

              _buildSectionTitle('Account Settings', res.scale),
              _buildSettingsGroup(
                [
                  _buildSettingsItem(
                    icon: Icons.notifications_none_outlined,
                    iconColor:
                        _notificationsEnabled
                            ? AppColors.notificationColor
                            : AppColors.mutedColor,
                    title: 'Allow Notifications',
                    scale: res.scale,
                    isTablet: res.isTablet,
                    trailingOverride: CupertinoSwitch(
                      value: _notificationsEnabled,
                      activeColor: AppColors.successGreen,
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
                    iconColor:
                        isDark
                            ? AppColors.darkModeIconColor
                            : AppColors.mutedColor,
                    title: 'Dark Mode',
                    scale: res.scale,
                    isTablet: res.isTablet,
                    trailingOverride: CupertinoSwitch(
                      value: isDark,
                      activeColor: AppColors.darkModeIconColor,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    ),
                    onTap: () {
                      themeProvider.toggleTheme(!isDark);
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.language_outlined,
                    iconColor: AppColors.languageIconColor,
                    title: 'Language',
                    trailingText: 'English',
                    scale: res.scale,
                    isTablet: res.isTablet,
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
                    iconColor: AppColors.successGreen,
                    title: 'Privacy Policy',
                    scale: res.scale,
                    isTablet: res.isTablet,
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
                    iconColor: AppColors.supportIconColor,
                    title: 'Support & FAQ',
                    scale: res.scale,
                    isTablet: res.isTablet,
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

              _buildLogoutButton(res.scale, res.isTablet),

              SizedBox(height: 30 * res.scale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    double scale,
    bool isTablet,
  ) {
    if (_isProfileLoading) {
      return HomeShimmer.buildProfileShimmer(scale: scale, isTablet: isTablet);
    }
    return GestureDetector(
      onTap: () async {
        await Navigator.of(
          context,
          rootNavigator: true,
        ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
        _loadUserData();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 * scale : 18 * scale,
          vertical: isTablet ? 24 * scale : 18 * scale,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20 * scale),
          border: Border.all(color: AppColors.cardBorderColor, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
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
                    _userName ?? 'Guest Patient',
                    style: TextStyle(
                      fontSize: 17 * scale,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      String subTitle = "No contact info";
                      if (_userEmail != null && _userEmail!.isNotEmpty) {
                        subTitle = _userEmail!;
                      } else if (_userPhone != null && _userPhone!.isNotEmpty) {
                        subTitle = _userPhone!;
                      }
                      return Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 13 * scale,
                          color: AppColors.secondaryTextColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16 * scale,
              color: AppColors.mutedColor.withOpacity(0.5),
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
          color: AppColors.secondaryTextColor,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items, double scale, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 12 * scale : 0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(color: AppColors.cardBorderColor, width: 1),
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
                      color: AppColors.hintGrey.withOpacity(0.1),
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
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: trailingOverride != null ? null : onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 * scale : 16 * scale,
        vertical: isTablet ? 6 * scale : 2 * scale,
      ),
      leading: Container(
        width: (isTablet ? 50 : 40) * scale,
        height: (isTablet ? 50 : 40) * scale,
        alignment: Alignment.center,
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
          color: AppColors.primaryTextColor,
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
                    color: AppColors.secondaryTextColor,
                    fontSize: 13 * scale,
                  ),
                ),
              SizedBox(width: 5 * scale),
              Icon(
                Icons.arrow_forward_ios,
                size: 12 * scale,
                color: AppColors.borderColor,
              ),
            ],
          ),
    );
  }

  Widget _buildLogoutButton(double scale, bool isTablet) {
    return InkWell(
      onTap: _isLoggingOut ? null : _handleLogout,
      borderRadius: BorderRadius.circular(20 * scale),
      splashColor: AppColors.errorColor.withOpacity(0.1),
      highlightColor: AppColors.errorColor.withOpacity(0.05),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 20 * scale : 16 * scale,
        ),
        decoration: BoxDecoration(
          color: AppColors.errorLightBackground,
          borderRadius: BorderRadius.circular(20 * scale),
          border: Border.all(
            color: AppColors.errorColor.withOpacity(0.15),
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
                child: CircularProgressIndicator(
                  color: AppColors.errorColor,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(Icons.logout, color: AppColors.errorColor, size: 20 * scale),
            SizedBox(width: 10 * scale),
            Text(
              _isLoggingOut ? 'Logging out...' : 'Logout',
              style: TextStyle(
                color: AppColors.errorColor,
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
