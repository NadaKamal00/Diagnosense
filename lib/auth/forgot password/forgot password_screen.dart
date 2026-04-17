import 'package:flutter/material.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application/auth/forgot%20password/verify_account_screen.dart';
import 'package:application/core/theme/app_colors.dart';
import '../../core/utils/api_service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_feedback_box.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _validationError;
  String? _feedbackMessage;
  bool _isFeedbackSuccess = false;

  bool _isNumeric(String s) => RegExp(r'^[0-9]+$').hasMatch(s);
  bool _isEmail(String s) => s.contains('@');

  @override
  void dispose() {
    _emailController.dispose();
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
                          errorIcon: Icons.lock_reset_rounded,
                          errorIconSize: 80,
                        ),

                        SizedBox(height: 20 * res.scale),

                        /// Title
                        Text(
                          'Forgot Your Password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24 * res.scale,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ),

                        SizedBox(height: 8 * res.scale),

                        /// Subtitle
                        Text(
                          "Please enter the email or phone number associated with your account.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15 * res.scale,
                            color: AppColors.secondaryTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 25 * res.scale),

                        /// Input Field: Email or Phone
                        _buildEmailField(res.scale),

                        if (_feedbackMessage != null &&
                            _validationError == null)
                          Padding(
                            padding: EdgeInsets.only(top: 20 * res.scale),
                            child: CustomFeedbackBox(
                              message: _feedbackMessage!,
                              isSuccess: _isFeedbackSuccess,
                              scale: res.scale,
                            ),
                          ),

                        if (_validationError != null)
                          Padding(
                            padding: EdgeInsets.only(top: 15 * res.scale),
                            child: Text(
                              _validationError!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.errorColor,
                                fontSize: 13 * res.scale,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                        SizedBox(height: 20 * res.scale),

                        _buildSendCodeButton(context, res.scale),

                        SizedBox(height: 15 * res.scale),

                        _buildBackToLogin(context, res.scale),
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

  Future<void> _handleSendCode() async {
    FocusScope.of(context).unfocus();
    final identity = _emailController.text.trim();
    if (identity.isEmpty) {
      setState(() {
        _validationError = 'Please enter an email or phone number';
        _feedbackMessage = null;
      });
      return;
    }

    // Phone Number Validation (Numeric check)
    if (_isNumeric(identity) && identity.length != 11) {
      setState(() {
        _validationError = 'Phone number must be exactly 11 digits';
        _feedbackMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _validationError = null;
      _feedbackMessage = null;
    });

    try {
      final data = await ApiService().sendForgotPasswordOTP(identity);

      if (!mounted) return;

      final bool success = data['success'] == true;
      final int? statusCode = data['status_code'];

      setState(() {
        _isFeedbackSuccess = success;
        if (success) {
          _feedbackMessage =
              _isEmail(identity)
                  ? "An OTP has been sent to your email for login. Please check your inbox"
                  : "An OTP has been sent to your phone number for login. Please check your SMS";
        } else {
          // If not successful OR status is 404, show "not registered"
          if (!success || statusCode == 404) {
            _feedbackMessage =
                _isEmail(identity)
                    ? "This email is not registered in our system"
                    : "This phone number is not registered in our system";
          } else {
            _feedbackMessage = "An error occurred. Please try again.";
          }
        }
      });

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        final token = data['data']?['token'] ?? data['token'];
        if (token != null) {
          await prefs.setString('auth_token', token);
        }

        // Add 2-second delay to let user see the success message
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => VerifyAccountScreen(
                  purpose: OTPPurpose.forgotPassword,
                  userContact: identity,
                ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isFeedbackSuccess = false;
        _feedbackMessage = "Please, check your internet connection";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildEmailField(double scaleFactor) {
    return TextField(
      controller: _emailController,
      style: TextStyle(fontSize: 15 * scaleFactor),
      decoration: InputDecoration(
        hintText: "Email or Phone number",
        hintStyle: TextStyle(
          color: AppColors.secondaryTextColor,
          fontSize: 15 * scaleFactor,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: AppColors.transparent,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20 * scaleFactor,
          vertical: 18 * scaleFactor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scaleFactor),
          borderSide: BorderSide(color: AppColors.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scaleFactor),
          borderSide: BorderSide(color: AppColors.accentColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildSendCodeButton(BuildContext context, double scaleFactor) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleSendCode,
      child: Container(
        width: double.infinity,
        height: 50 * scaleFactor,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                _isLoading
                    ? [AppColors.primaryLight, AppColors.primaryMedium]
                    : [AppColors.primaryColor, AppColors.accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14 * scaleFactor),
          boxShadow: [
            if (!_isLoading)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.25),
                blurRadius: 15 * scaleFactor,
                offset: Offset(0, 6 * scaleFactor),
              ),
          ],
        ),
        child: Center(
          child:
              _isLoading
                  ? SizedBox(
                    height: 24 * scaleFactor,
                    width: 24 * scaleFactor,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text(
                    'Send Code',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * scaleFactor,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildBackToLogin(BuildContext context, double scaleFactor) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(8 * scaleFactor),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 2 * scaleFactor,
          horizontal: 12 * scaleFactor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 13 * scaleFactor,
              color: AppColors.accentColor,
            ),
            SizedBox(width: 8 * scaleFactor),
            Text(
              'Back to login',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 13 * scaleFactor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
