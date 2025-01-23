import 'package:get/get.dart';

import 'package:ecommerce_app_complete/data/models/product_model.dart';
import 'package:ecommerce_app_complete/data/services/shared_services/Sharedservices.dart';

class CartController extends GetxController {
  var cartItems = <ProductModel>[].obs;
  var quantities = <int>[].obs;
  @override
  void onInit() async {
    super.onInit();
    cartItems.value = await SharedServices().getCartItemsFromLocal();
    quantities.value = await SharedServices().getCartQuantitiesFromLocal();
    update();
  }

  double get totalPrice {
    double total = 0;
    for (int i = 0; i < cartItems.length; i++) {
      total += (cartItems[i].price! * quantities[i]);
    }
    return total;
  }

  void addToCart(ProductModel product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      cartItems.add(product);
      quantities.add(1);
    } else {
      quantities[index]++;
    }
    SharedServices().saveToLocal(cartItems, quantities);
  }

  void removeFromCart(ProductModel product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      cartItems.removeAt(index);
      quantities.removeAt(index);
    }
    SharedServices().saveToLocal(cartItems, quantities);
  }

  void increaseQuantity(int index) {
    quantities[index]++;
    SharedServices().saveToLocal(cartItems, quantities);
  }

  void decreaseQuantity(int index) {
    if (quantities[index] > 1) {
      quantities[index]--;
    } else {
      removeFromCart(cartItems[index]);
    }
    SharedServices().saveToLocal(cartItems, quantities);
  }
}
