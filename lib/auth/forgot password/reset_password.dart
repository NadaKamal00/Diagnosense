import 'package:flutter/material.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:application/core/theme/app_colors.dart';
import '../login_screen.dart';
import '../../core/utils/api_service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_feedback_box.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? resetToken;
  const ResetPasswordScreen({super.key, this.resetToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;
  String? _passwordError;
  String? _confirmError;
  String? _successMessage;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10 * res.scale,
              left: 10 * res.scale,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20 * res.scale,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 22 * res.scale,
                  vertical: 20 * res.scale,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: res.isTablet ? 450 * res.scale : res.width,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20 * res.scale,
                      vertical: 35 * res.scale,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(29 * res.scale),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withOpacity(0.25),
                          blurRadius: 53.7 * res.scale,
                          spreadRadius: -3 * res.scale,
                          offset: Offset(0, 10 * res.scale),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30 * res.scale),

                        /// Logo
                        const AppLogo(
                          errorIcon: Icons.refresh_rounded,
                          errorIconSize: 80,
                        ),

                        SizedBox(height: 20 * res.scale),

                        /// Title
                        Text(
                          'Reset Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24 * res.scale,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ),

                        // SizedBox(height: 8 * res.scale),

                        // /// Subtitle
                        // Text(
                        //   "Your new password must be different from previously used passwords.",
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontSize: 15 * res.scale,
                        //     color: const Color(0xFF8A94A6),
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                        SizedBox(height: 25 * res.scale),

                        /// Password Label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13 * res.scale,
                              fontWeight: FontWeight.w600,
                              color: AppColors.labelColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 6 * res.scale),

                        /// Password Field
                        _buildPasswordField(
                          controller: _newPasswordController,
                          isObscured: _isNewPasswordObscured,
                          scale: res.scale,
                          hasError: _passwordError != null,
                          onIconPressed:
                              () => setState(
                                () =>
                                    _isNewPasswordObscured =
                                        !_isNewPasswordObscured,
                              ),
                        ),

                        /// Password helper / error text
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5 * res.scale,
                            left: 4 * res.scale,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _passwordError ?? 'Must be at least 8 characters',
                              style: TextStyle(
                                fontSize: 12 * res.scale,
                                color:
                                    _passwordError != null
                                        ? AppColors.errorColor
                                        : AppColors.secondaryTextColor,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16 * res.scale),

                        /// Confirm Password Label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontSize: 13 * res.scale,
                              fontWeight: FontWeight.w600,
                              color: AppColors.labelColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 6 * res.scale),

                        /// Confirm Password Field
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          isObscured: _isConfirmPasswordObscured,
                          scale: res.scale,
                          hasError: _confirmError != null,
                          onIconPressed:
                              () => setState(
                                () =>
                                    _isConfirmPasswordObscured =
                                        !_isConfirmPasswordObscured,
                              ),
                        ),

                        /// Confirm helper / error text
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5 * res.scale,
                            left: 4 * res.scale,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _confirmError ?? 'The passwords should match',
                              style: TextStyle(
                                fontSize: 12 * res.scale,
                                color:
                                    _confirmError != null
                                        ? AppColors.errorColor
                                        : AppColors.secondaryTextColor,
                              ),
                            ),
                          ),
                        ),

                        if (_successMessage != null)
                          Padding(
                            padding: EdgeInsets.only(top: 16 * res.scale),
                            child: CustomFeedbackBox(
                              message: _successMessage!,
                              isSuccess: true,
                              scale: res.scale,
                            ),
                          ),

                        SizedBox(height: 20 * res.scale),

                        /// Main Button: Reset Password
                        _buildResetButton(context, res.scale),

                        SizedBox(height: 12 * res.scale),

                        /// Outline Button: Cancel
                        _buildCancelButton(context, res.scale),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --- Password Field Builder ---
  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isObscured,
    required double scale,
    required VoidCallback onIconPressed,
    bool hasError = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      style: TextStyle(fontSize: 15 * scale),
      decoration: InputDecoration(
        hintText: isObscured ? '••••••••' : '',
        hintStyle: TextStyle(
          color: AppColors.secondaryTextColor,
          fontSize: 15 * scale,
        ),
        suffixIcon: IconButton(
          onPressed: onIconPressed,
          icon: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.mutedColor,
            size: 20 * scale,
          ),
        ),
        filled: true,
        fillColor: AppColors.backgroundColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20 * scale,
          vertical: 18 * scale,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scale),
          borderSide: BorderSide(
            color: hasError ? AppColors.errorColor : AppColors.borderColor,
            width: hasError ? 1.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scale),
          borderSide: BorderSide(
            color: hasError ? AppColors.errorColor : AppColors.accentColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, double scale) {
    return GestureDetector(
      onTap:
          _isLoading
              ? null
              : () async {
                final password = _newPasswordController.text;
                final passwordConfirmation = _confirmPasswordController.text;

                // Validate: length
                if (password.length < 8) {
                  setState(() {
                    _passwordError = 'Password must be at least 8 characters';
                    _confirmError = null;
                  });
                  return;
                }

                // Validate: match
                if (password != passwordConfirmation) {
                  setState(() {
                    _passwordError = null;
                    _confirmError = 'Passwords do not match';
                  });
                  return;
                }

                // Clear validation errors
                setState(() {
                  _passwordError = null;
                  _confirmError = null;
                  _isLoading = true;
                });

                try {
                  final data = await ApiService().resetPassword(
                    token: widget.resetToken ?? '',
                    password: password,
                    passwordConfirmation: passwordConfirmation,
                  );

                  if (!mounted) return;

                  final bool success = data['success'] == true;

                  if (success) {
                    setState(() {
                      _successMessage = 'Password updated successfully!';
                    });

                    // 2-second delay so user can read the success message
                    await Future.delayed(const Duration(seconds: 2));
                    if (!mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  } else {
                    setState(() {
                      _confirmError = 'An error occurred. Please try again.';
                    });
                  }
                } catch (e) {
                  if (!mounted) return;
                  setState(() {
                    _confirmError =
                        'An error occurred. Please check your connection.';
                  });
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
      child: Container(
        width: double.infinity,
        height: 50 * scale,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                _isLoading
                    ? [AppColors.primaryLight, AppColors.primaryMedium]
                    : const [AppColors.primaryColor, AppColors.accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12 * scale),
          boxShadow: [
            if (!_isLoading)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.25),
                blurRadius: 15 * scale,
                offset: Offset(0, 6 * scale),
              ),
          ],
        ),
        child: Center(
          child:
              _isLoading
                  ? SizedBox(
                    height: 24 * scale,
                    width: 24 * scale,
                    child: const CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text(
                    'Done',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18 * scale,
                    ),
                  ),
        ),
      ),
    );
  }

  /// --- Cancel Button Builder ---
  Widget _buildCancelButton(BuildContext context, double scale) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 50 * scale),
        side: const BorderSide(color: AppColors.mutedColor, width: .5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12 * scale),
        ),
      ),
      child: Text(
        'Cancel',
        style: TextStyle(
          color: AppColors.subtleTextColor,
          fontWeight: FontWeight.w600,
          fontSize: 15 * scale,
        ),
      ),
    );
  }
}
