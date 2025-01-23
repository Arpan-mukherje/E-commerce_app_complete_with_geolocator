// import 'dart:convert';
// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:ecommerce_app_complete/data/models/product_model.dart';
// import 'package:ecommerce_app_complete/data/services/api_services/ApiBaseServices.dart';

// class ProductController extends GetxController {
//   List<ProductModel> products = <ProductModel>[];
//   var banners = <String>[].obs;
//   var isLoading = true.obs;
//   var filteredProducts = <ProductModel>[].obs;
//   var selectedCategory = "".obs;
//   var selectedPriceRange = 0.0.obs;

//   final categories = ['All', 'Electronics', 'Fashion', 'Home Appliances'];
//   final priceRanges = [0.0, 50.0, 100.0, 500.0, 1000.0];

//   @override
//   void onInit() {
//     fetchProducts();
//     super.onInit();
//   }

//   Future<void> fetchProducts() async {
//     try {
//       isLoading(true);
//       update();
//       final response = await ApiBaseServices.getRequest(endPoint: "/products");
//       if (response.statusCode == 200) {
//         products = productModelFromJson(jsonEncode(response.data));
//         filteredProducts.value = products;
//         selectedCategory.value = 'All';
//         update();
//         log(products.toString());
//       } else {
//         products = [];
//       }
//     } catch (e) {
//       products = [];

//       print("Error fetching products: $e");
//     } finally {
//       isLoading(false);
//       update();
//     }
//   }

//   void filterProducts(String query) {
//     if (query.isEmpty) {
//       filteredProducts.value = products;
//     } else {
//       filteredProducts.value = products
//           .where((product) =>
//               product.title!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//   }

//   void filterByCategory(String category) {
//     selectedCategory.value = category;
//     if (category == 'All') {
//       filteredProducts.value = products;
//     } else {
//       filteredProducts.value =
//           products.where((product) => product.category == category).toList();
//     }
//   }

//   void filterByPriceRange(double maxPrice) {
//     selectedPriceRange.value = maxPrice;
//     filteredProducts.value =
//         products.where((product) => product.price! <= maxPrice).toList();
//   }

//   // void searchByNameAndCategory({
//   //   required String nameQuery,
//   //   required String categoryQuery,
//   // }) {
//   //   selectedCategory.value = categoryQuery;

//   //   filteredProducts.value = products.where((product) {
//   //     final matchesName = nameQuery.isEmpty ||
//   //         product.title!.toLowerCase().contains(nameQuery.toLowerCase());
//   //     final matchesCategory =
//   //         categoryQuery == 'All' || product.category == categoryQuery;
//   //     return matchesName && matchesCategory;
//   //   }).toList();
//   // }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:ecommerce_app_complete/data/models/product_model.dart';
import 'package:ecommerce_app_complete/data/services/api_services/ApiBaseServices.dart';

class ProductController extends GetxController {
  List<ProductModel> products = <ProductModel>[];
  var filteredProducts = <ProductModel>[].obs;

  var isLoading = true.obs;
  var selectedCategory = "All".obs;
  var selectedPriceRange = 1000.0.obs;

  final categories = ['All', 'Electronics', 'Fashion', 'Home Appliances'];
  final priceRanges = [0.0, 50.0, 100.0, 500.0, 1000.0];

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final response = await ApiBaseServices.getRequest(endPoint: "/products");

      if (response.statusCode == 200) {
        products = productModelFromJson(jsonEncode(response.data));
        filteredProducts.value = products;
        update();
      } else {
        products = [];
        filteredProducts.value = [];
        update();
      }
    } catch (e) {
      products = [];
      filteredProducts.value = [];
      update();

      print("Error fetching products: $e");
    } finally {
      isLoading(false);
      update();
    }
  }

  void applyFilters() {
    var tempProducts = products;
    if (selectedCategory.value != 'All') {
      tempProducts = tempProducts.where((product) {
        final mappedCategory = mapCategoryToEnum(product.category!.name);
        return mappedCategory == selectedCategory.value;
      }).toList();
    }
    tempProducts = tempProducts.where((product) {
      return product.price != null &&
          product.price! <= selectedPriceRange.value;
    }).toList();
    filteredProducts.value = tempProducts;
    update();
  }

  String mapCategoryToEnum(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return 'Electronics';
      case 'jewelery':
        return 'Fashion';
      case "men's clothing":
        return 'Fashion';
      case "women's clothing":
        return 'Fashion';
      default:
        return 'All';
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void filterByPriceRange(double maxPrice) {
    selectedPriceRange.value = maxPrice;
    applyFilters();
  }

  void filterProducts(String query) {
    filterByCategory("All");
    if (query.isEmpty) {
      applyFilters();
    } else {
      var tempProducts = filteredProducts;

      filteredProducts.value = tempProducts.where((product) {
        return product.title?.toLowerCase().contains(query.toLowerCase()) ??
            false;
      }).toList();
    }
    update();
  }
}
