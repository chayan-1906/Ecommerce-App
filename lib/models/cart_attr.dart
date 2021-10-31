import 'package:flutter/cupertino.dart';

class CartAttr with ChangeNotifier {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final String price;
  final String imageUrl;

  CartAttr({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}
