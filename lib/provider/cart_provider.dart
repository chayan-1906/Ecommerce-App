import 'package:ecommerce_app/models/cart_attr.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartAttr> cartItems = {};

  Map<String, CartAttr> get getCartItems {
    return {...cartItems};
  }

  double get totalAmount {
    var total = 0.0;
    cartItems.forEach((key, value) {
      total += double.parse(value.price) * value.quantity;
    });
    return total;
  }

  int get totalItems {
    int noOfItems = 0;
    cartItems.forEach((key, value) {
      noOfItems += value.quantity;
    });
    return noOfItems;
  }

  void addProductToCart(
      String productId, String price, String title, String imageUrl) {
    if (cartItems.containsKey(productId)) {
      cartItems.update(
        productId,
        (existingCartItem) => CartAttr(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      cartItems.putIfAbsent(
        productId,
        () => CartAttr(
          id: DateTime.now().toString(),
          title: title,
          productId: productId,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void reduceCartItemByOne(String productId) {
    if (cartItems.containsKey(productId)) {
      cartItems.update(
        productId,
        (existingCartItem) => CartAttr(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}
