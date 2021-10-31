import 'package:ecommerce_app/models/wishlist_attr.dart';
import 'package:ecommerce_app/widgets/wishlist_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../product_details_screen.dart';

class WishlistFullScreen extends StatefulWidget {
  final String productId;

  const WishlistFullScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  _WishlistFullScreenState createState() => _WishlistFullScreenState();
}

class _WishlistFullScreenState extends State<WishlistFullScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistAttr>(context);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 30.0, bottom: 10.0),
          child: Material(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            elevation: 3.0,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailsScreen.routeName,
                  arguments: widget.productId,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 80.0,
                      child: Image.network(wishlist.imageUrl),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wishlist.title,
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            '\$ ${wishlist.price}',
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        positionedRemove(context, widget.productId),
      ],
    );
  }
}
