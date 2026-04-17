import 'package:application/core/theme/app_colors.dart';
import 'package:application/core/utils/api_service.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_isLoading) return;

    final name = widget.initialName; // Use the provided name as a static value
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    print("DEBUG: [EDIT_PROFILE] Initiating updateProfile API call:");
    print("DEBUG: [EDIT_PROFILE] - Name: $name");
    print("DEBUG: [EDIT_PROFILE] - Email: $email");
    print("DEBUG: [EDIT_PROFILE] - Phone: $phone");

    setState(() => _isLoading = true);

    final result = await ApiService().updateProfile(
      name: name,
      email: email,
      phone: phone,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ?? 'Profile updated successfully!',
          ),
          backgroundColor: AppColors.successEmerald,
        ),
      );
      Navigator.pop(context, true); // Signal success to callers
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ?? 'Update failed. Please try again.',
          ),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    // Conditional visibility: hide fields if initial value was empty
    final bool hasEmail = widget.initialEmail.isNotEmpty;
    final bool hasPhone = widget.initialPhone.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: (56 * res.scale).toDouble(),
        leadingWidth: ((res.isTablet ? 100 : 70) * res.scale).toDouble(),
        leading: Container(
          margin: EdgeInsets.only(
            left: ((res.isTablet ? 20 : 12) * res.scale).toDouble(),
          ),
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryTextColor,
              size: (20 * res.scale).toDouble(),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Contact Details',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: (18 * res.scale).toDouble(),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: (24 * res.scale).toDouble(),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      res.isTablet ? (450 * res.scale).toDouble() : res.width,
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: (24 * res.scale).toDouble()),

                    _buildNameSection(res.scale),

                    // Email (Conditional)
                    if (hasEmail)
                      _buildInputSection(
                        scale: res.scale,
                        label: "Email",
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                    // Phone (Conditional)
                    if (hasPhone)
                      _buildInputSection(
                        scale: res.scale,
                        label: "Phone Number",
                        controller: _phoneController,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                    SizedBox(height: (25 * res.scale).toDouble()),

                    _buildActionButtons(res.scale),

                    SizedBox(height: (40 * res.scale).toDouble()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputSection({
    required double scale,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: (18 * scale).toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: (14 * scale).toDouble(),
            ),
          ),
          SizedBox(height: (8 * scale).toDouble()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: (15 * scale).toDouble()),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular((16 * scale).toDouble()),
              border: Border.all(color: AppColors.surfaceVariant, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: (12 * scale).toDouble(),
                  offset: Offset(0, (4 * scale).toDouble()),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                fontSize: (15 * scale).toDouble(),
              ),
              decoration: InputDecoration(
                icon: Icon(
                  icon,
                  color: AppColors.accentColor,
                  size: (22 * scale).toDouble(),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: (16 * scale).toDouble(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection(double scale) {
    return Padding(
      padding: EdgeInsets.only(bottom: (18 * scale).toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name",
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: (14 * scale).toDouble(),
            ),
          ),
          SizedBox(height: (8 * scale).toDouble()),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: (15 * scale).toDouble(),
              vertical: (16 * scale).toDouble(),
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular((16 * scale).toDouble()),
              border: Border.all(color: AppColors.surfaceVariant, width: 1.2),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: (14 * scale).toDouble(),
                  backgroundColor: AppColors.accentColor.withOpacity(0.1),
                  child: Text(
                    widget.initialName.isNotEmpty
                        ? widget.initialName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: (14 * scale).toDouble(),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: (12 * scale).toDouble()),
                Expanded(
                  child: Text(
                    widget.initialName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      fontSize: (15 * scale).toDouble(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(double scale) {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: GestureDetector(
            onTap: _isLoading ? null : () => Navigator.pop(context),
            child: Container(
              height: (52 * scale).toDouble(),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular((15 * scale).toDouble()),
                border: Border.all(color: AppColors.secondaryBorderColor),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: (16 * scale).toDouble(),
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: (15 * scale).toDouble()),

        // Save Changes Button
        Expanded(
          child: GestureDetector(
            onTap: _isLoading ? null : _saveChanges,
            child: Container(
              height: (52 * scale).toDouble(),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.accentColor],
                ),
                borderRadius: BorderRadius.circular((18 * scale).toDouble()),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentColor.withOpacity(0.35),
                    blurRadius: (20 * scale).toDouble(),
                    offset: Offset(0, (10 * scale).toDouble()),
                  ),
                ],
              ),
              child: Center(
                child:
                    _isLoading
                        ? SizedBox(
                          width: (22 * scale).toDouble(),
                          height: (22 * scale).toDouble(),
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                        : Text(
                          'Save Changes',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: (16 * scale).toDouble(),
                          ),
                        ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
