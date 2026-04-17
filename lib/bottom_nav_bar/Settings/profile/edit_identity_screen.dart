import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/theme/app_colors.dart';

class EditIdentityScreen extends StatefulWidget {
  final String type;
  final String initialValue;

  const EditIdentityScreen({
    super.key,
    required this.type,
    required this.initialValue,
  });

  @override
  State<EditIdentityScreen> createState() => _EditIdentityScreenState();
}

class _EditIdentityScreenState extends State<EditIdentityScreen> {
  late TextEditingController _controller;
  bool _isLoading = false;
  String? _apiErrorText;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateRealTime(String val) {
    bool isInvalid = false;
    if (val.trim().isEmpty) {
      isInvalid = true;
    } else if (widget.type == 'email') {
      isInvalid = !val.contains('@gmail.com');
    } else {
      isInvalid = val.length != 11 || double.tryParse(val) == null;
    }

    if (_hasError != isInvalid) {
      setState(() {
        _hasError = isInvalid;
      });
    }
  }

  Future<void> _handleSave() async {
    setState(() => _apiErrorText = null);

    _validateRealTime(_controller.text);
    if (_hasError) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final currentName = prefs.getString('user_name') ?? '';
      final currentEmail = prefs.getString('user_email') ?? '';
      final currentPhone = prefs.getString('user_phone') ?? '';

      String updateEmail = currentEmail;
      String updatePhone = currentPhone;

      if (widget.type == 'email') {
        updateEmail = _controller.text.trim();
      } else {
        updatePhone = _controller.text.trim();
      }

      final response = await ApiService().updateProfile(
        name: currentName,
        email: updateEmail,
        phone: updatePhone,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        Navigator.pop(context, true); // Go back to profile screen
      } else {
        setState(() {
          _apiErrorText = response['message'] ?? 'Failed to update';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _apiErrorText = e.toString();
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
    final isEmail = widget.type == 'email';
    final bool isErrorState = _hasError || _apiErrorText != null;

    String instructionText;
    if (_apiErrorText != null) {
      instructionText = _apiErrorText!;
    } else if (isEmail) {
      instructionText = 'Email Address must contain @gmail.com';
    } else {
      instructionText = 'Must be exactly 11 digits';
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: (24 * res.scale).toDouble(),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit ${isEmail ? "Email" : "Phone"}',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: (18 * res.scale).toDouble(),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all((24 * res.scale).toDouble()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEmail ? 'EMAIL ADDRESS' : 'PHONE NUMBER',
                  style: TextStyle(
                    fontSize: (12 * res.scale).toDouble(),
                    color: AppColors.secondaryTextColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: (8 * res.scale).toDouble()),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.05),
                        blurRadius: (10 * res.scale).toDouble(),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _controller,
                    autofocus: false,
                    keyboardType:
                        isEmail
                            ? TextInputType.emailAddress
                            : TextInputType.number,
                    style: TextStyle(
                      fontSize: (16 * res.scale).toDouble(),
                      color: AppColors.headingColor,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          left: (16 * res.scale).toDouble(),
                          right: (12 * res.scale).toDouble(),
                        ),
                        child: Icon(
                          isEmail
                              ? Icons.email_outlined
                              : Icons.phone_android_outlined,
                          color: AppColors.accentColor,
                          size: (22 * res.scale).toDouble(),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: (16 * res.scale).toDouble(),
                        vertical: (16 * res.scale).toDouble(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          (12 * res.scale).toDouble(),
                        ),
                        borderSide: BorderSide(
                          color:
                              isErrorState
                                  ? AppColors.errorColor
                                  : AppColors.transparent,
                          width: isErrorState ? 1.5 : 0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          (12 * res.scale).toDouble(),
                        ),
                        borderSide: BorderSide(
                          color:
                              isErrorState
                                  ? AppColors.errorColor
                                  : AppColors.transparent,
                          width: isErrorState ? 1.5 : 0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          (12 * res.scale).toDouble(),
                        ),
                        borderSide: BorderSide(
                          color:
                              isErrorState
                                  ? AppColors.errorColor
                                  : AppColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      if (_apiErrorText != null) {
                        setState(() => _apiErrorText = null);
                      }
                      _validateRealTime(val);
                    },
                  ),
                ),
                SizedBox(height: (12 * res.scale).toDouble()),
                Text(
                  instructionText,
                  style: TextStyle(
                    color:
                        isErrorState
                            ? AppColors.errorColor
                            : AppColors.disabledTextColor,
                    fontSize: (12 * res.scale).toDouble(),
                  ),
                ),
                SizedBox(height: (32 * res.scale).toDouble()),
                SizedBox(
                  width: double.infinity,
                  height: (55 * res.scale).toDouble(),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          (16 * res.scale).toDouble(),
                        ),
                      ),
                    ),
                    child:
                        _isLoading
                            ? SizedBox(
                              height: (20 * res.scale).toDouble(),
                              width: (20 * res.scale).toDouble(),
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              'Save Changes',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: (16 * res.scale).toDouble(),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
