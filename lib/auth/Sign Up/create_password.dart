import 'package:flutter/material.dart';
import 'package:application/utils/responsive_helper.dart';
import '../login_screen.dart';
import '../../core/utils/api_service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_feedback_box.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String? resetToken;
  const CreatePasswordScreen({super.key, this.resetToken});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
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
      backgroundColor: const Color(0xFFF8FAFF),
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
                  color: const Color(0xFF0E1A34),
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
                      color: Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(29 * res.scale),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3E3E3E).withOpacity(0.25),
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

                        const AppLogo(),

                        SizedBox(height: 20 * res.scale),

                        /// Title
                        Text(
                          'Create Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24 * res.scale,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0E1A34),
                          ),
                        ),

                        // SizedBox(height: 8 * res.scale),

                        // /// SubTitle
                        // Text(
                        //   "Create a password to log in",
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
                              color: const Color(0xFF374151),
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
                                        ? Colors.red
                                        : const Color(0xFF8A94A6),
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
                              color: const Color(0xFF374151),
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
                                        ? Colors.red
                                        : const Color(0xFF8A94A6),
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

                        /// Main Button: Create Password
                        _buildCreateButton(context, res.scale),
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
          color: const Color(0xFF8A94A6),
          fontSize: 15 * scale,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: IconButton(
          onPressed: onIconPressed,
          icon: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xFF939393),
            size: 20 * scale,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFF),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20 * scale,
          vertical: 18 * scale,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scale),
          borderSide: BorderSide(
            color: hasError ? Colors.red : const Color(0xFFD1D5DB),
            width: hasError ? 1.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scale),
          borderSide: BorderSide(
            color: hasError ? Colors.red : const Color(0xFF3B82F6),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context, double scale) {
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

                // Clear errors and start loading
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
                    ? [const Color(0xFF93C5FD), const Color(0xFF60A5FA)]
                    : const [Color(0xFF2563EB), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12 * scale),
          boxShadow: [
            if (!_isLoading)
              BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.25),
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
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * scale,
                    ),
                  ),
        ),
      ),
    );
  }
}
