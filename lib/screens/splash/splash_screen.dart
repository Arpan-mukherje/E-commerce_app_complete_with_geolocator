import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_app_complete/screens/authentication/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoOpacity = 0.0;
  double _logoScale = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateToHome();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _logoOpacity = 1.0;
        _logoScale = 1.0;
      });
    });
  }

  void _navigateToHome() {
    Timer(const Duration(seconds: 4), () {
      // Get.off(() => HomeScreen());

      Get.off(() => LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1500),
              opacity: _logoOpacity,
              child: AnimatedScale(
                scale: _logoScale,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOut,
                child: Image.asset(
                  "assets/online-shopping.png",
                  height: 150.h,
                  width: 150.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Animated App Name
            AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: _logoOpacity,
              child: Text(
                "Ecommerce App",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
