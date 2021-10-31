import 'package:flutter/cupertino.dart';

class WishlistAttr with ChangeNotifier {
  final String id;
  final String title;
  final String price;
  final String imageUrl;

  WishlistAttr({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}
