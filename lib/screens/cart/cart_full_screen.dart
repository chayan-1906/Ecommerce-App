import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/models/cart_attr.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:ecommerce_app/screens/product_details_screen.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartFullScreen extends StatefulWidget {
  final String productId;

  const CartFullScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _CartFullScreenState createState() => _CartFullScreenState();
}

class _CartFullScreenState extends State<CartFullScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    final cart = Provider.of<CartAttr>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    String subTotal =
        (double.parse(cart.price) * cart.quantity).toStringAsFixed(2);

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetailsScreen.routeName,
        arguments: widget.productId,
      ),
      child: Container(
        height: 140.0,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            Container(
              width: 130.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(cart.imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 2.0, top: 2.0, bottom: 2.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              cart.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.getFont(
                                'Roboto Slab',
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.redAccent.shade100,
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () {
                                GlobalMethods.customDialog(
                                  context,
                                  getTranslated(context, 'remove_item'),
                                  getTranslated(context, 'remove_warning'),
                                  () => {
                                    cartProvider.removeItem(widget.productId),
                                    Navigator.of(context).pop(),
                                  },
                                );
                              },
                              child: SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: Icon(
                                  MyIcons.cartScreenIcons['delete'],
                                  color: Colors.redAccent,
                                  size: 22.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            getTranslated(context, 'price'),
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              // fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            '\$ ${cart.price}',
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              color: themeChange.darkTheme
                                  ? Colors.brown[100]
                                  : ColorsConstants.teal600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            getTranslated(context, 'subtotal'),
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              // fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          FittedBox(
                            child: Text(
                              '\$ $subTotal',
                              style: GoogleFonts.getFont(
                                'Roboto Slab',
                                // fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                                color: themeChange.darkTheme
                                    ? Colors.brown[100]
                                    : ColorsConstants.teal600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            getTranslated(context, 'ship_free'),
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              // fontSize: 16.0,
                              color: themeChange.darkTheme
                                  ? Colors.brown[100]
                                  : ColorsConstants.teal600,
                            ),
                          ),
                          const Spacer(),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.tealAccent.shade100,
                              borderRadius: BorderRadius.circular(32.0),
                              onTap: cart.quantity <= 1
                                  ? () {}
                                  : () {
                                      cartProvider.reduceCartItemByOne(
                                          widget.productId);
                                    },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    MyIcons.cartScreenIcons['minus'],
                                    color: cart.quantity <= 1
                                        ? Theme.of(context).disabledColor
                                        : Colors.lightBlueAccent,
                                    size: 22.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 12.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorsConstants.gradientLStart,
                                    ColorsConstants.gradientLEnd,
                                  ],
                                  stops: const [0.0, 0.7],
                                ),
                              ),
                              child: Text(
                                '${cart.quantity}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.getFont(
                                  'Roboto Slab',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.tealAccent.shade100,
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () {
                                cartProvider.addProductToCart(widget.productId,
                                    cart.price, cart.title, cart.imageUrl);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  MyIcons.cartScreenIcons['plus'],
                                  color: Colors.lightGreen,
                                  size: 22.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
