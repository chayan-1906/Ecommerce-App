import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/models/order_attr.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:ecommerce_app/screens/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderFullScreen extends StatefulWidget {
  const OrderFullScreen({Key? key}) : super(key: key);

  @override
  _OrderFullScreenState createState() => _OrderFullScreenState();
}

class _OrderFullScreenState extends State<OrderFullScreen> {
  Future<void> _fetchProducts() async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    final order = Provider.of<OrderAttr>(context);

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetailsScreen.routeName,
        arguments: order.productId,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 130.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(order.imageUrl),
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
                      // Title
                      Text(
                        order.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Price
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
                            '\$ ${order.price}',
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
                      // Quantity
                      Row(
                        children: [
                          Text(
                            getTranslated(context, 'quantity'),
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              // fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            'x ${order.quantity}',
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              // fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: themeChange.darkTheme
                                  ? Colors.brown[100]
                                  : ColorsConstants.teal600,
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
