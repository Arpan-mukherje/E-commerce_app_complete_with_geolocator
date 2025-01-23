import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app_complete/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app_complete/data/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Image.network(
                  product.image ?? '',
                  height: 300.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 36.h),
              Divider(thickness: 1.h),
              SizedBox(height: 16.h),
              Text(
                product.title ?? 'No Title',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 28.h),
              Text(
                "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 26.h),
              Text(
                product.description ?? 'No Description',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 50.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0.r),
                    ),
                  ),
                  onPressed: () {
                    final cartController = Get.put(CartController());
                    cartController.addToCart(product);
                    Get.snackbar(
                      'Success',
                      '${product.title} added to cart',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(16.w),
                      backgroundColor: Colors.teal,
                      colorText: Colors.white,
                    );
                    cartController.update();
                  },
                  child: Text(
                    "Add to cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
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
}
