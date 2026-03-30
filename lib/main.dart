import 'package:application/auth/Sign%20Up/signup_screen.dart';
import 'package:application/auth/forgot%20password/verify_account_screen.dart';
import 'package:application/auth/login_screen.dart';
import 'package:application/bottom_nav_bar/Settings/settings_screen.dart';
import 'package:application/bottom_nav_bar/_navigation_menu.dart';
import 'package:application/splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/forgot password/reset_password.dart';
import 'onboarding_screen.dart';
import 'bottom_nav_bar/Home/home_screen.dart';

void main() {
  runApp(
    // DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'DiagnoSense',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF8FAFF),
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3B82F6),
            ),
            useMaterial3: true,
          ),
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          home: SplashScreen(),
        );
      },
    );
  }
}
