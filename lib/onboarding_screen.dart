import 'package:flutter/material.dart';
import 'package:application/utils/responsive_helper.dart';
import 'auth/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "image":
          "assets/images/Gemini_Generated_Image_wdbpe7wdbpe7wdbp-removebg-preview.png",
      "title": "All Your Medical Records\nIn One Place",
      "body": "Access all your medical records anytime, securely and easily.",
    },
    {
      "image": "assets/images/on2.png",
      "title": "Stay on Track With\nYour Care",
      "body": "Follow your tasks, visits, and tests\nwith clear instructions.",
    },
    {
      "image": "assets/images/on3.png",
      "title": "Get Notified Instantly",
      "body": "Receive alerts for updates,\nappointments, and new records.",
    },
  ];

  void _goToHome() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _goToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: res.isTablet ? 450 * res.scale : res.width,
            ),
            child: Column(
              children: [
                /// Skip Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * res.scale,
                    vertical: 10 * res.scale,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _goToHome,
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: const Color(0xFF397FF5),
                          fontSize: 18 * res.scale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                /// Page View
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged:
                        (value) => setState(() => _currentPage = value),
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24 * res.scale,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Image.asset(
                                  data["image"] as String,
                                  width: 300 * res.scale,
                                  height: 300 * res.scale,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) => Icon(
                                        Icons.image_not_supported,
                                        size: 100 * res.scale,
                                      ),
                                ),
                              ),
                            ),

                            SizedBox(height: 32 * res.scale),

                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  /// Title
                                  Text(
                                    data["title"] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24 * res.scale,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0E1A34),
                                      height: 1.3,
                                    ),
                                  ),

                                  SizedBox(height: 16 * res.scale),

                                  /// Body
                                  Text(
                                    data["body"] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14 * res.scale,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF09254A),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    24 * res.scale,
                    0,
                    24 * res.scale,
                    50 * res.scale,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.only(right: 6 * res.scale),
                            height: 7 * res.scale,
                            width:
                                _currentPage == index
                                    ? 22 * res.scale
                                    : 9 * res.scale,
                            decoration: BoxDecoration(
                              color:
                                  _currentPage == index
                                      ? const Color(0xFF357AF3)
                                      : const Color(0xFFB4B4B4),
                              borderRadius: BorderRadius.circular(
                                10 * res.scale,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 32 * res.scale),

                      _buildMainButton(res.scale),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton(double scale) {
    return Container(
      width: double.infinity,
      height: 59 * scale,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(42 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.25),
            blurRadius: 16 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _nextPage,
          borderRadius: BorderRadius.circular(42 * scale),
          child: Center(
            child: Text(
              _currentPage == _onboardingData.length - 1
                  ? "Get Started"
                  : "Next",
              style: TextStyle(
                fontSize: 20 * scale,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
