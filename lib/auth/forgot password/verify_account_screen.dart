import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:application/core/theme/app_colors.dart';
import '../sign up/create_password.dart';
import '../../core/utils/api_service.dart';
import '../../widgets/app_logo.dart';
import 'package:application/auth/forgot%20password/reset_password.dart';

enum OTPPurpose { signup, forgotPassword }

class VerifyAccountScreen extends StatefulWidget {
  final OTPPurpose purpose;
  final String userContact;

  const VerifyAccountScreen({
    super.key,
    required this.purpose,
    required this.userContact,
  });

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  // ── Controllers & Nodes ────────────────────────────────────────────────────
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // ── OTP State ──────────────────────────────────────────────────────────────
  bool? _isOtpCorrect; // null=neutral  true=green  false=red
  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage; // shown in red below fields on failure

  // ── Resend Timer ───────────────────────────────────────────────────────────
  Timer? _resendTimer;
  int _secondsLeft = 59;
  bool _timerActive = false; // false = show "Resend", true = show countdown

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    // Rebuild OTP boxes when focus changes so the blue border updates.
    for (final node in _focusNodes) {
      node.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  // ── Timer ──────────────────────────────────────────────────────────────────
  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _secondsLeft = 59;
      _timerActive = true;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft == 0) {
        timer.cancel();
        setState(() => _timerActive = false);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  // ── Resend ─────────────────────────────────────────────────────────────────
  Future<void> _handleResend() async {
    if (_timerActive || _isResending) return;

    setState(() => _isResending = true);

    try {
      final Map<String, dynamic> data;

      if (widget.purpose == OTPPurpose.forgotPassword) {
        data = await ApiService().resendCode(widget.userContact);
      } else {
        data = await ApiService().resendOTP(identity: widget.userContact);
      }

      if (!mounted) return;

      if (data['success'] == true) {
        // Clear fields, reset OTP state, restart timer.
        for (final c in _controllers) {
          c.clear();
        }
        setState(() {
          _isOtpCorrect = null;
          _errorMessage = null;
        });
        _focusNodes[0].requestFocus();
        _startResendTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message']?.toString() ?? 'OTP resent successfully',
            ),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message']?.toString() ?? 'Failed to resend. Try again.',
            ),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An error occurred. Please try again.'),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  // ── Verify ─────────────────────────────────────────────────────────────────
  Future<void> _handleVerify() async {
    final otpCode = _controllers.map((c) => c.text).join();

    if (otpCode.length < 6) {
      setState(() {
        _errorMessage = 'Please enter the full six-digit code';
        _isOtpCorrect = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isOtpCorrect = null;
      _errorMessage = null;
    });

    try {
      final data = await ApiService().verifyOTP(widget.userContact, otpCode);

      if (!mounted) return;

      final bool success = data['success'] == true;

      if (success) {
        final resetToken = data['data']?['reset_token'];

        setState(() {
          _isOtpCorrect = true;
          _errorMessage = null;
        });

        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;

        if (widget.purpose == OTPPurpose.signup) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreatePasswordScreen(resetToken: resetToken),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(resetToken: resetToken),
            ),
          );
        }
      } else {
        // Extract the most descriptive error message available.
        String msg = 'Invalid or expired OTP';
        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;
          final firstKey = errors.keys.first;
          final val = errors[firstKey];
          if (val is List && val.isNotEmpty) {
            msg = val.first.toString();
          } else {
            msg = val.toString();
          }
        } else if (data['message'] != null) {
          msg = data['message'].toString();
        }

        setState(() {
          _isOtpCorrect = false;
          _errorMessage = msg;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isOtpCorrect = false;
        _errorMessage = 'Verification failed. Please check your connection.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    final String title =
        widget.purpose == OTPPurpose.signup
            ? 'Verify Your Account'
            : 'Reset Password';
    final String subTitle =
        widget.purpose == OTPPurpose.signup
            ? 'Please enter the code to verify your account'
            : 'Please enter the 6 digit code sent to';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Back button ─────────────────────────────────────────────────
            Positioned(
              top: 10 * res.scale,
              left: 10 * res.scale,
              child: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(8 * res.scale),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20 * res.scale,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Card ────────────────────────────────────────────────────────
            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24 * res.scale,
                    vertical: 20 * res.scale,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: (res.isTablet ? 420 : res.width) * res.scale,
                    ),
                    child: Container(
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

                          const AppLogo(
                            errorIcon: Icons.verified_user_outlined,
                            errorIconSize: 75,
                          ),

                          SizedBox(height: 30 * res.scale),

                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22 * res.scale,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                          ),

                          SizedBox(height: 8 * res.scale),

                          Text(
                            subTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13 * res.scale,
                              color: AppColors.mutedTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.userContact,
                            style: TextStyle(
                              fontSize: 14 * res.scale,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),

                          SizedBox(height: 32 * res.scale),

                          // ── OTP Row ──────────────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              6,
                              (i) => _buildOtpBox(i, res.scale, res.isTablet),
                            ),
                          ),

                          // ── Feedback below OTP ───────────────────────────
                          if (_isOtpCorrect == true)
                            Padding(
                              padding: EdgeInsets.only(top: 10 * res.scale),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.successColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Accepted',
                                    style: TextStyle(
                                      color: AppColors.successColor,
                                      fontSize: 13 * res.scale,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (_errorMessage != null)
                            Padding(
                              padding: EdgeInsets.only(top: 10 * res.scale),
                              child: Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.errorColor,
                                  fontSize: 13 * res.scale,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                          SizedBox(height: 24 * res.scale),

                          // ── Verify Button ─────────────────────────────────
                          _buildVerifyButton(res.scale),

                          SizedBox(height: 16 * res.scale),

                          // ── Resend row (always shown below button) ────────
                          _buildResendRow(res.scale),
                        ],
                      ),
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

  // ── OTP Box ────────────────────────────────────────────────────────────────
  Widget _buildOtpBox(int index, double scale, bool isTablet) {
    // Determine border colour based on state + focus.
    final Color borderColor;
    if (_isOtpCorrect == true) {
      borderColor = AppColors.successColor; // green
    } else if (_isOtpCorrect == false) {
      borderColor = AppColors.errorColor;
    } else if (_focusNodes[index].hasFocus) {
      borderColor = AppColors.primaryColor; // blue when focused
    } else {
      borderColor = AppColors.lightBorderColor; // default grey
    }

    return SizedBox(
      width: (isTablet ? 42 : 45) * scale,
      height: (isTablet ? 50 : 54) * scale,
      child: RawKeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.backspace) {
              if (_controllers[index].text.isEmpty && index > 0) {
                // Field is already empty → move to previous and clear it.
                _controllers[index - 1].clear();
                _focusNodes[index - 1].requestFocus();
              }
              // If field has a character, the TextField handles deletion
              // and onChanged fires with '' which we also handle below.
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackgroundColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12 * scale),
            border: Border.all(color: borderColor, width: 1.5 * scale),
          ),
          child: Center(
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20 * scale,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                if (value.isNotEmpty) {
                  // Reset error state when user starts typing again.
                  if (_isOtpCorrect == false) {
                    setState(() {
                      _isOtpCorrect = null;
                      _errorMessage = null;
                    });
                  }
                  if (index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  } else {
                    // Last field filled → close keyboard.
                    _focusNodes[index].unfocus();
                  }
                } else {
                  // Character was deleted via the keyboard key.
                  if (index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Verify Button ──────────────────────────────────────────────────────────
  Widget _buildVerifyButton(double scale) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleVerify,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54 * scale,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                _isLoading
                    ? [AppColors.primaryLight, AppColors.primaryMedium]
                    : [AppColors.primaryColor, AppColors.accentColor],
          ),
          borderRadius: BorderRadius.circular(14 * scale),
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
                    'Verify Code',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * scale,
                    ),
                  ),
        ),
      ),
    );
  }

  // ── Resend Row ─────────────────────────────────────────────────────────────
  Widget _buildResendRow(double scale) {
    // While timer is active → "Request new code in XX"
    if (_timerActive) {
      return Text(
        'Request new code in ${_secondsLeft.toString().padLeft(2, '0')}',
        style: TextStyle(
          color: AppColors.disabledTextColor,
          fontSize: 13 * scale,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    // Timer finished → "Didn't receive code?  Resend"
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive code? ",
          style: TextStyle(
            color: AppColors.mutedTextColor,
            fontSize: 13 * scale,
          ),
        ),
        GestureDetector(
          onTap: _isResending ? null : _handleResend,
          child: Text(
            _isResending ? 'Resending…' : 'Resend',
            style: TextStyle(
              color:
                  _isResending
                      ? AppColors.disabledTextColor
                      : AppColors.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 13 * scale,
            ),
          ),
        ),
      ],
    );
  }
}
