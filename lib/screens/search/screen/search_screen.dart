import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app_complete/controllers/product/product_controller.dart';
import 'package:ecommerce_app_complete/screens/product_detsils/screen/product_details_screen.dart';

class SearchPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: (query) => controller.filterProducts(query),
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.filteredProducts.isEmpty) {
          return const Center(child: Text("No results found."));
        }

        return ListView.builder(
          itemCount: controller.filteredProducts.length,
          itemBuilder: (context, index) {
            final product = controller.filteredProducts[index];
            return Column(
              children: [
                ListTile(
                  leading: Image.network(
                    product.image ?? '',
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.title ?? 'No Title'),
                  subtitle:
                      Text("\$${product.price?.toStringAsFixed(2) ?? '0.00'}"),
                  onTap: () {
                    Get.to(() => ProductDetailsScreen(product: product));
                  },
                ),
                const Divider()
              ],
            );
          },
        );
      }),
    );
  }
}
