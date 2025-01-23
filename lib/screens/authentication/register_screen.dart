import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app_complete/controllers/authentication/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce_app_complete/screens/authentication/login_screen.dart';
import 'package:ecommerce_app_complete/widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register",
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
              Text('Name',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal)),
              const SizedBox(height: 8),
              customTextField(authController.nameController, 'Enter your name'),
              const SizedBox(height: 20),
              Text('Email',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal)),
              const SizedBox(height: 8),
              customTextField(
                  authController.emailController, 'Enter your email'),
              const SizedBox(height: 20),
              Text('Password',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal)),
              const SizedBox(height: 8),
              customTextField(
                  authController.passwordController, 'Enter your password',
                  obscureText: true),
              const SizedBox(height: 20),
              Text('Address',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal)),
              const SizedBox(height: 8),
              Obx(
                () => authController.isFetchLocation.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : customTextField(
                        authController.addressController,
                        'Fetching address...',
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () async {
                      await authController.getLocation();
                    },
                    child: Text(
                      "Fetch current location",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  onPressed: () {
                    if (authController.emailController.text.isEmpty ||
                        authController.passwordController.text.isEmpty ||
                        authController.addressController.text.isEmpty ||
                        authController.nameController.text.isEmpty) {
                      Get.snackbar(
                          "Validation Error", "Please fill in all fields.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white);
                    } else {
                      authController.registerUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 33.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: authController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Register',
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
                    "Already have an account? ",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Text(
                      "Login",
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
