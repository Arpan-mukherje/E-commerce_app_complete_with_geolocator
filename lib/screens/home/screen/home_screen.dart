import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_app_complete/controllers/cart/cart_controller.dart';
import 'package:ecommerce_app_complete/controllers/product/product_controller.dart';
import 'package:ecommerce_app_complete/data/services/network_check/network_check.dart';
import 'package:ecommerce_app_complete/screens/cart/cart_screen.dart';
import 'package:ecommerce_app_complete/screens/home/widget/product_card.dart';
import 'package:ecommerce_app_complete/screens/product_detsils/screen/product_details_screen.dart';
import 'package:ecommerce_app_complete/screens/search/screen/search_screen.dart';
import 'package:badges/badges.dart' as badge;

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final RxInt _currentCarouselIndex = 0.obs;
  final networkController = Get.find<ConnectivityController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isConnected = networkController.isConnected.value;
      log(isConnected.toString());
      return isConnected
          ? Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.teal,
                title: Text(
                  "Product Screen",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
                centerTitle: true,
                actions: [
                  GetBuilder<CartController>(
                    init: CartController(),
                    builder: (cartController) {
                      return badge.Badge(
                        badgeContent: Text(
                          cartController.quantities.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Get.to(() => CartPage());
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 20.w,
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: GetBuilder<ProductController>(
                  init: ProductController(),
                  builder: (controller) {
                    return controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                child: TextField(
                                  onTap: () {
                                    Get.to(() => SearchPage());
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Search products...',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DropdownButton<String>(
                                      value: controller.selectedCategory.value,
                                      items: controller.categories
                                          .map((category) => DropdownMenuItem(
                                                value: category,
                                                child: Text(category,
                                                    style: TextStyle(
                                                        fontSize: 14.sp)),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        controller.filterByCategory(value!);
                                      },
                                      hint: Text(
                                        "Category",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                    DropdownButton<double>(
                                      value:
                                          controller.selectedPriceRange.value,
                                      items: controller.priceRanges
                                          .map((priceRange) => DropdownMenuItem(
                                                value: priceRange,
                                                child: Text(
                                                  "Below :  \$${priceRange.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        controller.filterByPriceRange(value!);
                                      },
                                      hint: Text(
                                        "Price Range",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              controller.filteredProducts.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No products found",
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Column(
                                        children: [
                                          CarouselSlider(
                                            options: CarouselOptions(
                                              height: 200.h,
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                              aspectRatio: 16 / 9,
                                              viewportFraction: 0.8,
                                              onPageChanged: (index, reason) {
                                                _currentCarouselIndex.value =
                                                    index;
                                              },
                                            ),
                                            items: controller.filteredProducts
                                                .map((product) {
                                              final url = product.image!;
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0.r),
                                                child: CachedNetworkImage(
                                                  imageUrl: url,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          SizedBox(height: 10.h),
                                          Obx(
                                            () => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: List.generate(
                                                controller
                                                    .filteredProducts.length,
                                                (index) => AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 4.w),
                                                  width: _currentCarouselIndex
                                                              .value ==
                                                          index
                                                      ? 12.w
                                                      : 8.w,
                                                  height: 8.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _currentCarouselIndex
                                                                .value ==
                                                            index
                                                        ? Colors.teal
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.w,
                                    mainAxisSpacing: 10.h,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemCount: controller.filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        controller.filteredProducts[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => ProductDetailsScreen(
                                              product: product,
                                            ));
                                      },
                                      child: ProductCard(
                                        productName: product.title!,
                                        imageUrl: product.image!,
                                        price: product.price!.toString(),
                                        onTap: () {
                                          final cartController =
                                              Get.put(CartController());
                                          cartController.addToCart(product);
                                          Get.snackbar('Success',
                                              '${product.title} added to cart',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              colorText: Colors.white,
                                              backgroundColor: Colors.teal,
                                              duration:
                                                  const Duration(seconds: 2),
                                              isDismissible: true);
                                          cartController.update();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
            )
          : Scaffold(
              body: Center(
                child: Text(
                  "Oops! Please Check your network",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
    });
  }
}
