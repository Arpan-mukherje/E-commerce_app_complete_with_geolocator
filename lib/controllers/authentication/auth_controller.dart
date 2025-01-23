import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app_complete/screens/dashboard/dashboard_screen.dart';
import 'package:ecommerce_app_complete/screens/authentication/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isFetchLocation = false.obs;
  var user = Rx<User?>(null);
  var name = ''.obs;
  var address = ''.obs;
  //............................................................................
  @override
  void onInit() {
    super.onInit();
    user.value = Supabase.instance.client.auth.currentUser;
    getLocation();
    requestLocationPermission();
    checkLoginStatus();
    if (user.value != null) {
      fetchUserData(user.value!.email);
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    addressController.clear();
  }

  // Fetch data from supabase Function.........................................

  Future<void> fetchUserData(String? email) async {
    if (email == null) return;

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('name, address')
          .eq('email', email)
          .single();

      if (response != null) {
        name.value = response['name'] ?? '';
        address.value = response['address'] ?? '';
      }
      log(response.toString());
    } catch (e) {
      log('Error fetching user data: ${e.toString()}');
      Get.snackbar(
        "Error",
        "Failed to fetch user data",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // get permission function......................................................

  Future<void> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied forever');
    }
  }

  // get location function.......................................................

  Future<void> getLocation() async {
    isFetchLocation(true);
    try {
      // Set location settings
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      );

      // Get the current position with the specified settings
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      // Get the address from latitude and longitude
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];

      addressController.text =
          '${place.street}, ${place.locality}, ${place.country}';
    } catch (e) {
      log(e.toString());
      Get.snackbar("Location Error", "Could not fetch location.");
    }
    isFetchLocation(false);
  }

  // Register User Function....................................................

  Future<void> registerUser() async {
    isLoading(true);
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.user != null) {
        user.value = response.user;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await Supabase.instance.client.from('users').insert([
          {
            'name': nameController.text,
            'email': emailController.text,
            'password': passwordController.text,
            'address': addressController.text,
          }
        ]);
        Get.snackbar("Signup successful",
            "please check your mail to verify your account !",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.to(() => LoginScreen());
        clearControllers();
      } else {
        Get.snackbar(
            "Registration Error", "Unknown error occurred during registration.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            duration: const Duration(seconds: 3));
      }
    } catch (e) {
      log(e.toString());
      if (e is AuthException) {
        String message = e.message.toString();

        Get.snackbar("Registration failed", message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
      isLoading(false);
    }
    isLoading(false);
  }

  // Login User Function........................................................
  Future<void> loginUser() async {
    isLoading(true);
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.user != null) {
        user.value = response.user;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await fetchUserData(response.user!.email);

        Get.offAll(() => DashboardScreen());

        Get.snackbar("Successful", "User Login Successful",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        clearControllers();
        isLoading(false);
      } else {
        Get.snackbar("Login Error", "Invalid email or password.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        isLoading(false);
      }
    } catch (e) {
      if (e is AuthException) {
        String message = e.message.toString();

        Get.snackbar("Login Error", message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
      isLoading(false);
    }
    isLoading(false);
  }

  // Logout User Function......................................................
  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      user.value = null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Get.snackbar(
        "Logout",
        "You have successfully logged out.",
      );
      clearControllers(); // Clear the fields after logout
    } catch (e) {
      Get.snackbar("Logout Error", e.toString());
    }
  }

  bool isUserLoggedIn = false;
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      user.value = Supabase.instance.client.auth.currentUser;
    }
    isUserLoggedIn = isLoggedIn;
  }
}
