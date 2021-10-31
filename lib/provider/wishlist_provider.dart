import 'package:ecommerce_app/models/wishlist_attr.dart';
import 'package:flutter/cupertino.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistAttr> _wishlistItems = {};

  Map<String, WishlistAttr> get getWishlistItems {
    return {..._wishlistItems};
  }

  void addRemoveWishlist(
      String productId, String price, String title, String imageUrl) {
    if (_wishlistItems.containsKey(productId)) {
      removeItem(productId);
    } else {
      _wishlistItems.putIfAbsent(
        productId,
        () => WishlistAttr(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _wishlistItems.remove(productId);
    notifyListeners();
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
