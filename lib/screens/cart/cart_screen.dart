import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app_complete/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app_complete/data/services/network_check/network_check.dart';
import 'package:ecommerce_app_complete/screens/check_out/payment_screen.dart';

class CartPage extends StatelessWidget {
  final cartController = Get.put(CartController());
  final networkController = Get.find<ConnectivityController>();

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isConnected = networkController.isConnected.value;

      return !isConnected
          ? Scaffold(
              body: Center(
                child: Text(
                  "Oops! Please Check your network",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  "Cart",
                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                ),
                backgroundColor: Colors.teal,
              ),
              body: GetBuilder<CartController>(
                builder: (controller) => controller.cartItems.isNotEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.cartItems.length,
                              itemBuilder: (context, index) {
                                final product = controller.cartItems[index];
                                return Column(
                                  children: [
                                    SizedBox(height: 20.h),
                                    ListTile(
                                      leading: Image.network(
                                        product.image!,
                                        height: 100.h,
                                        width: 90.w,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                        product.title!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "\$${(product.price! * controller.quantities[index]).toStringAsFixed(2)}",
                                            style: TextStyle(
                                              color: Colors.teal,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () {
                                                  controller
                                                      .decreaseQuantity(index);
                                                  controller.update();
                                                },
                                              ),
                                              Text(
                                                controller.quantities[index]
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 16.sp),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  controller
                                                      .increaseQuantity(index);
                                                  controller.update();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          controller.removeFromCart(product);
                                          controller.update();
                                        },
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => CheckoutPage());
                            },
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
                            child: Text(
                              "Proceed to Checkout",
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      )
                    : Center(
                        child: Text(
                          "No items in the cart",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
              ),
            );
    });
  }
}
