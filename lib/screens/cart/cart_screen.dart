import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/screens/cart/cart_empty_screen.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/services/payment.dart';
import 'package:ecommerce_app/widgets/cart_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'cart_full_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart_screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? const Scaffold(
            body: CartEmptyScreen(),
          )
        : Scaffold(
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsConstants.starterColor,
                      ColorsConstants.endColor,
                    ],
                  ),
                ),
              ),
              title: Text(
                '${getTranslated(context, "cart")} (${cartProvider.totalItems})',
                style: GoogleFonts.getFont(
                  'Roboto Slab',
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    onPressed: () {
                      GlobalMethods.customDialog(
                        context,
                        getTranslated(context, 'clear_cart'),
                        getTranslated(context, 'clear_cart_warning'),
                        () {
                          cartProvider.clearCart();
                          Navigator.pop(context);
                        },
                      );
                    },
                    splashColor: Colors.redAccent.shade100,
                    icon: Icon(
                      MyIcons.cartScreenIcons['trash'],
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              margin: const EdgeInsets.only(bottom: 80.0),
              child: ListView.builder(
                itemBuilder: (BuildContext ctx, int index) {
                  return ChangeNotifierProvider.value(
                    value: cartProvider.getCartItems.values.toList()[index],
                    child: CartFullScreen(
                        productId:
                            cartProvider.getCartItems.keys.toList()[index]),
                  );
                },
                itemCount: cartProvider.getCartItems.length,
              ),
            ),
          );
  }
}
