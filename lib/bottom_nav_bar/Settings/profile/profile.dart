import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/shimmer_effect.dart';
import 'edit_identity_screen.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;
  String? userPhone;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');
    final phone = prefs.getString('user_phone');

    print("DEBUG: [PROFILE_SCREEN] Fetching data from prefs:");
    print("DEBUG: [PROFILE_SCREEN] - user_name: $name");
    print("DEBUG: [PROFILE_SCREEN] - user_email: $email");
    print("DEBUG: [PROFILE_SCREEN] - user_phone: $phone");

    setState(() {
      userName = name;
      userEmail = email;
      userPhone = phone;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    List<Widget> rows = [];

    rows.add(
      _buildProfileRow(
        res: res,
        icon: Icons.person_outline,
        label: "Full Name",
        value:
            (userName != null && userName!.isNotEmpty)
                ? userName!
                : "Unknown Name",
        onTap: () {},
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Username can't be changed")),
          );
        },
        showArrow: false,
      ),
    );

    if (userEmail != null && userEmail!.isNotEmpty) {
      rows.add(
        _buildProfileRow(
          res: res,
          icon: Icons.email_outlined,
          label: "Email Address",
          value: userEmail!,
          onTap: () => _navigateToEditIdentity("email", userEmail),
          onLongPress: () => _showContextMenu(context, "Email", userEmail),
          showArrow: true,
        ),
      );
    }

    if (userPhone != null && userPhone!.isNotEmpty) {
      rows.add(
        _buildProfileRow(
          res: res,
          icon: Icons.phone_android,
          label: "Phone Number",
          value: userPhone!,
          onTap: () => _navigateToEditIdentity("phone", userPhone),
          onLongPress:
              () => _showContextMenu(context, "Phone Number", userPhone),
          showArrow: true,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        toolbarHeight: (56 * res.scale).toDouble(),
        leadingWidth: ((res.isTablet ? 90 : 70) * res.scale).toDouble(),
        leading: Container(
          margin: EdgeInsets.only(
            left: ((res.isTablet ? 20 : 12) * res.scale).toDouble(),
          ),
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: (24 * res.scale).toDouble(),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: (18 * res.scale).toDouble(),
          ),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (20 * res.scale).toDouble(),
                  vertical: (24 * res.scale).toDouble(),
                ),
                child: HomeShimmer.buildProfileShimmerList(res),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: (20 * res.scale).toDouble(),
                  vertical: (24 * res.scale).toDouble(),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          (20 * res.scale).toDouble(),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.05),
                            blurRadius: (20 * res.scale).toDouble(),
                            offset: Offset(0, (10 * res.scale).toDouble()),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          (28 * res.scale).toDouble(),
                        ),
                        child: Column(
                          children: List.generate(rows.length, (index) {
                            return Column(
                              children: [
                                rows[index],
                                if (index < rows.length - 1) _buildDivider(res),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),

                    SizedBox(height: (50 * res.scale).toDouble()),

                    // SizedBox(
                    //   width: double.infinity,
                    //   height: (55 * res.scale).toDouble(),
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder:
                    //               (_) => EditProfileScreen(
                    //                 initialName: userName ?? '',
                    //                 initialEmail: userEmail ?? '',
                    //                 initialPhone: userPhone ?? '',
                    //               ),
                    //         ),
                    //       );
                    //       _loadUserData();
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF2563EB),
                    //       elevation: 2,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(
                    //           (16 * res.scale).toDouble(),
                    //         ),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Edit Profile Information',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: (16 * res.scale).toDouble(),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
    );
  }

  void _navigateToEditIdentity(String type, String? initialValue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditIdentityScreen(
              type: type,
              initialValue: initialValue ?? '',
            ),
      ),
    ).then((_) {
      _loadUserData();
    });
  }

  void _showContextMenu(BuildContext context, String type, String? value) {
    if (value == null || value.isEmpty) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: Text('Copy $type'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copied to clipboard")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text('Edit $type'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  if (type == 'Email') {
                    _navigateToEditIdentity('email', value);
                  } else {
                    _navigateToEditIdentity('phone', value);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileRow({
    required Responsive res,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
    required bool showArrow,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (16 * res.scale).toDouble(),
            vertical: (16 * res.scale).toDouble(),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all((10 * res.scale).toDouble()),
                decoration: BoxDecoration(
                  color: AppColors.iconBackground,
                  borderRadius: BorderRadius.circular(
                    (12 * res.scale).toDouble(),
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.accentColor,
                  size: (22 * res.scale).toDouble(),
                ),
              ),

              SizedBox(width: (16 * res.scale).toDouble()),

              /// title and vaue
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        fontSize: (11 * res.scale).toDouble(),
                        color: AppColors.disabledTextColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: (4 * res.scale).toDouble()),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17 * res.scale,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              if (showArrow)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: (14 * res.scale).toDouble(),
                  color: AppColors.borderColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Responsive res) {
    return Padding(
      padding: EdgeInsets.only(
        left: (16 * res.scale).toDouble(),
        right: (16 * res.scale).toDouble(),
      ),
      child: Divider(
        height: 1,
        thickness: (0.8 * res.scale).toDouble(),
        color: AppColors.hintGrey.withOpacity(0.4),
      ),
    );
  }
}
