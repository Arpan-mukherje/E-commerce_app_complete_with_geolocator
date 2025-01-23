import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app_complete/controllers/authentication/auth_controller.dart';
import 'package:ecommerce_app_complete/screens/authentication/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce_app_complete/screens/home/screen/home_screen.dart';

class DashboardScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              _showLogoutDialog(context);
            },
            color: Colors.white,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name:',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Text(
                  authController.name.value,
                  style: GoogleFonts.poppins(fontSize: 16),
                );
              }),
              const SizedBox(height: 8),
              Text(
                'Email:',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Text(
                  authController.user.value?.email ?? '',
                  style: GoogleFonts.poppins(fontSize: 16),
                );
              }),
              const SizedBox(height: 20),
              Text(
                'Address:',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Text(
                  authController.address.value,
                  style: GoogleFonts.poppins(fontSize: 16),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // log(authController.address.value);
                  // log(authController.name.value);
                  Get.to(() => HomeScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'Go to Product List',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                await authController.logout();
                Get.offAll(() => LoginScreen());
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }
}
