import 'package:application/core/theme/theme_provider.dart';
import 'package:application/splash_screen.dart';
import 'package:application/core/theme/app_colors.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
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
        final themeProvider = Provider.of<ThemeProvider>(context);
        
        return MaterialApp(
          title: 'DiagnoSense',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.backgroundColor,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.accentColor,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: AppColors.backgroundColor,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
              bodyColor: AppColors.primaryTextColor,
              displayColor: AppColors.primaryTextColor,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.accentColor,
              brightness: Brightness.dark,
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
