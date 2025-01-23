import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app_complete/controllers/authentication/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce_app_complete/screens/authentication/register_screen.dart';
import 'package:ecommerce_app_complete/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login",
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email field
              Text('Email',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal)),
              const SizedBox(height: 8),
              customTextField(
                  authController.emailController, 'Enter your email'),

              const SizedBox(height: 20),

              // Password field
              Text('Password',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal)),
              const SizedBox(height: 8),
              customTextField(
                  authController.passwordController, 'Enter your password',
                  obscureText: true),

              const SizedBox(height: 20),

              Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    if (authController.emailController.text.isEmpty ||
                        authController.passwordController.text.isEmpty) {
                      Get.snackbar(
                          "Validation Error", "Please fill in all fields.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white);
                    } else {
                      await authController.loginUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 33.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: authController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Login',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => RegisterScreen());
                    },
                    child: Text(
                      "Register",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
