import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app_complete/controllers/authentication/auth_controller.dart';
import 'package:ecommerce_app_complete/data/services/network_check/network_check.dart';
import 'package:ecommerce_app_complete/data/services/shared_services/Preferences.dart';
import 'package:ecommerce_app_complete/screens/dashboard/dashboard_screen.dart';
import 'package:ecommerce_app_complete/screens/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(
      ConnectivityController()); // Creating the instance of the ConnectivityController for checking the network connectivity

  await Supabase.initialize(
    url: 'https://adagmqoowhhgvkueudem.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFkYWdtcW9vd2hoZ3ZrdWV1ZGVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NzAxMzgsImV4cCI6MjA1MzA0NjEzOH0.3zXUmv3H_25-WZVmnUiJbAcfq6fR-PjEkHVbwxNBV5Y',
  );
  preferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: authController.isUserLoggedIn
                ? DashboardScreen()
                : const SplashScreen());
      },
    );
  }
}
