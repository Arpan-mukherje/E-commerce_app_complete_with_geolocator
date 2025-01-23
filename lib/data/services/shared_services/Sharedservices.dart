import 'dart:convert';
import 'package:ecommerce_app_complete/data/models/product_model.dart';
import 'package:ecommerce_app_complete/data/services/shared_services/Preferences.dart';

class SharedServices {
  Future<void> saveToLocal(
      List<ProductModel> cartList, List<int> quantity) async {
    final List<String> cartData = [];
    final List<String> cartQuantity = [];

    for (var item in cartList) {
      cartData.add(json.encode(item.toJson()));
    }
    for (var item in quantity) {
      cartQuantity.add(item.toString());
    }
    await preferences!.setStringList("cartList", cartData);
    await preferences!.setStringList("quantity", cartQuantity);
  }

  Future<List<ProductModel>> getCartItemsFromLocal() async {
    final List<String>? cartData = preferences!.getStringList("cartList");

    if (cartData == null) {
      return [];
    }
    final List<ProductModel> cartList = [];
    for (var item in cartData) {
      cartList.add(ProductModel.fromJson(json.decode(item)));
    }

    return cartList;
  }

  Future<List<int>> getCartQuantitiesFromLocal() async {
    final List<String>? cartQuantity = preferences!.getStringList("quantity");

    if (cartQuantity == null) {
      return [];
    }
    final List<int> quantities = [];
    for (var q in cartQuantity) {
      quantities.add(int.parse(q));
    }

    return quantities;
  }

  Future<void> clearCartData() async {
    await preferences!.remove("cartList");
    await preferences!.remove("quantity");
  }
}
