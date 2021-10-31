import 'package:ecommerce_app/screens/bottom_bar_screen.dart';
import 'package:ecommerce_app/screens/upload_products_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: const [
        BottomBarScreen(),
        UploadProductsScreen(),
      ],
    );
  }
}
