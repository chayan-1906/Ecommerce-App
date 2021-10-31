import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/order_attr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderAttr> _orderList = [];

  List<OrderAttr> get getOrders {
    return [..._orderList];
  }

  Future<void> fetchOrders() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? _user = _firebaseAuth.currentUser;
    var _uid = _user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('order')
          .where('userId', isEqualTo: _uid)
          .get()
          .then((QuerySnapshot ordersSnapshot) {
        _orderList.clear();
        ordersSnapshot.docs.forEach((element) {
          // print('element.get(productBrand), ${element.get('productBrand')}');
          _orderList.insert(
            0,
            OrderAttr(
              orderId: element.get('orderId'),
              productId: element.get('productId'),
              userId: element.get('userId'),
              price: element.get('price').toString(),
              quantity: element.get('quantity').toString(),
              imageUrl: element.get('imageUrl'),
              title: element.get('title'),
              orderDate: element.get('orderDate'),
            ),
          );
        });
      });
    } catch (error) {
      print('Printing error while fetching order $error');
    }
    notifyListeners();
  }
}
