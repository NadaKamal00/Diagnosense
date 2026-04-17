import 'package:application/auth/forgot%20password/forgot%20password_screen.dart';
import 'package:flutter/material.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:application/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bottom_nav_bar/_navigation_menu.dart';
import 'sign up/signup_screen.dart';
import '../../core/utils/api_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_feedback_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isObscured = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _fieldError; // inline error message
  bool _fieldSuccess = false;

  bool _isEmail(String s) => s.contains('@');

  @override
  void initState() {
    super.initState();
    _loadRememberMeData();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberMeData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('saved_identity') ?? '';
        _passwordController.text = prefs.getString('saved_password') ?? '';
      }
    });
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final identity = _emailController.text.trim();
    final password = _passwordController.text;

    if (identity.isEmpty || password.isEmpty) {
      setState(() {
        _fieldError = 'Please enter both identity and password';
        _fieldSuccess = false;
      });
      return;
    }

    // Clear previous feedback
    setState(() {
      _fieldError = null;
      _fieldSuccess = false;
    });

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiService().login(
        identity: identity,
        password: password,
      );

      if (!mounted) return;

      final bool success = data['success'] == true;

      if (success) {
        setState(() {
          _fieldSuccess = true;
          _fieldError = null;
        });
        final prefs = await SharedPreferences.getInstance();

        // Store Token
        final token = data['data']?['token'];
        if (token != null) {
          await prefs.setString('auth_token', token);
        }

        // Handle Remember Me
        if (_rememberMe) {
          await prefs.setBool('remember_me', true);
          await prefs.setString('saved_identity', identity);
          await prefs.setString('saved_password', password);
        } else {
          await prefs.remove('remember_me');
          await prefs.remove('saved_identity');
          await prefs.remove('saved_password');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationMenu()),
        );
      } else {
        // Identity-based error message
        setState(() {
          _fieldSuccess = false;
          _fieldError =
              _isEmail(identity)
                  ? 'Email or password incorrect. Please try again'
                  : 'Phone number or password incorrect. Please try again';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _fieldSuccess = false;
        _fieldError = 'Login failed. Please check your connection.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22 * res.scale,
                vertical: 20 * res.scale,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: (res.isTablet ? 420 : res.width) * res.scale,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// --- Login Card ---
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24 * res.scale,
                        vertical: 40 * res.scale,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(28 * res.scale),
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
                          const AppLogo(),

                          SizedBox(height: 20 * res.scale),

                          /// Title
                          Text(
                            'Login to your account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24 * res.scale,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),

                          SizedBox(height: 6 * res.scale),

                          SizedBox(height: 25 * res.scale),

                          /// Email Field
                          _buildTextField(
                            hint: 'Email or Phone Number',
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            scaleFactor: res.scale,
                            hasError: _fieldError != null,
                            isSuccess: _fieldSuccess,
                            onChanged:
                                (_) => setState(() {
                                  _fieldError = null;
                                  _fieldSuccess = false;
                                }),
                          ),

                          SizedBox(height: 12 * res.scale),

                          /// Password Field
                          _buildTextField(
                            hint: 'Password',
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            isPassword: true,
                            isObscured: _isObscured,
                            scaleFactor: res.scale,
                            hasError: _fieldError != null,
                            isSuccess: _fieldSuccess,
                            onIconPressed:
                                () =>
                                    setState(() => _isObscured = !_isObscured),
                            onChanged:
                                (_) => setState(() {
                                  _fieldError = null;
                                  _fieldSuccess = false;
                                }),
                          ),

                          /// Error Feedback Box
                          if (_fieldError != null)
                            Padding(
                              padding: EdgeInsets.only(top: 12 * res.scale),
                              child: CustomFeedbackBox(
                                message: _fieldError!,
                                isSuccess: false,
                                scale: res.scale,
                              ),
                            ),

                          /// Remember Me & Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  /// Checkbox
                                  SizedBox(
                                    height: 16 * res.scale,
                                    width: 16 * res.scale,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged:
                                          (value) => setState(
                                            () => _rememberMe = value!,
                                          ),
                                      activeColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          2.5 * res.scale,
                                        ),
                                      ),
                                      side: BorderSide(
                                        color: AppColors.disabledTextColor,
                                        width: 1 * res.scale,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 8 * res.scale),

                                  /// Remember Me Text
                                  Text(
                                    "Remember Me",
                                    style: TextStyle(
                                      color: AppColors.subtleTextColor,
                                      fontSize: 13 * res.scale,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),

                              /// Forgot Password
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 13 * res.scale,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12 * res.scale),

                          /// Login Button
                          _buildLoginButton(context, res.scale),

                          SizedBox(height: 17 * res.scale),

                          /// Sign Up
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Don’t have an Account? ",
                                style: TextStyle(
                                  color: AppColors.mutedTextColor,
                                  fontSize: 13 * res.scale,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const FirstLoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 13 * res.scale,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, double scale) {
    return InkWell(
      onTap: _isLoading ? null : _handleLogin,
      child: Container(
        width: double.infinity,
        height: 50 * scale,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                _isLoading
                    ? [AppColors.primaryLight, AppColors.primaryMedium]
                    : [AppColors.primaryColor, AppColors.accentColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
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
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * scale,
                      letterSpacing: 1,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required double scaleFactor,
    FocusNode? focusNode,
    bool isPassword = false,
    bool? isObscured,
    VoidCallback? onIconPressed,
    ValueChanged<String>? onChanged,
    bool hasError = false,
    bool isSuccess = false,
  }) {
    Color borderColor = AppColors.borderColor;
    Color focusedBorderColor = AppColors.accentColor;
    double borderWidth = 1;

    if (hasError) {
      borderColor = AppColors.errorColor;
      focusedBorderColor = AppColors.errorColor;
      borderWidth = 1.5;
    } else if (isSuccess) {
      borderColor = AppColors.successColor;
      focusedBorderColor = AppColors.successColor;
      borderWidth = 1.5;
    }

    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword ? (isObscured ?? true) : false,
      style: TextStyle(fontSize: 15 * scaleFactor, fontWeight: FontWeight.w600),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.secondaryTextColor,
          fontSize: 15 * scaleFactor,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  onPressed: onIconPressed,
                  icon: Icon(
                    isObscured!
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.disabledTextColor,
                    size: 20 * scaleFactor,
                  ),
                )
                : null,
        filled: true,
        fillColor: AppColors.transparent,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20 * scaleFactor,
          vertical: 18 * scaleFactor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scaleFactor),
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scaleFactor),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
      ),
    );
  }
}
