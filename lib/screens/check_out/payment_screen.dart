import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app_complete/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app_complete/data/services/shared_services/Sharedservices.dart';
import 'package:ecommerce_app_complete/screens/home/screen/home_screen.dart';

class CheckoutPage extends StatelessWidget {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final cartController = Get.put(CartController());

  CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.0.w),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.teal, width: 1.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount:",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Obx(() {
                      return Text(
                        "\$${cartController.totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              _buildTextField(nameController, "Name"),
              SizedBox(height: 15.h),
              _buildTextField(addressController, "Address"),
              SizedBox(height: 15.h),
              _buildTextField(phoneController, "Phone Number"),
              SizedBox(height: 15.h),
              _buildTextField(emailController, "Email"),
              SizedBox(height: 30.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      Get.defaultDialog(
                        title: "Order Status",
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order placed successfully!",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                        confirm: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.w,
                              vertical: 15.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false,
                            );
                            cartController.cartItems.clear();
                            cartController.quantities.clear();
                            await SharedServices().clearCartData();
                            cartController.update();

                            log('Cart Items: ${cartController.cartItems}');
                            log('Quantities: ${cartController.quantities}');
                          },
                          child: Text(
                            "Explore more",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50.w,
                      vertical: 15.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (nameController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16.0.w),
      );
      return false;
    }
    return true;
  }
}
