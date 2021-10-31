import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/wishlist_provider.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_empty_screen.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_full_screen.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/wishlist_screen';

  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return wishlistProvider.getWishlistItems.isEmpty
        ? const Scaffold(
            body: WishlistEmptyScreen(),
          )
        : Scaffold(
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
                '${getTranslated(context, 'wishlist')} (${wishlistProvider.getWishlistItems.length})',
                style: GoogleFonts.getFont(
                  'Roboto Slab',
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.customDialog(
                      context,
                      getTranslated(context, 'clear_wishlist'),
                      getTranslated(context, 'clear_wishlist_warning'),
                      () {
                        wishlistProvider.clearWishlist();
                        Navigator.pop(context);
                      },
                    );
                  },
                  splashColor: Colors.redAccent.shade100,
                  icon: Icon(MyIcons.cartScreenIcons['trash']),
                ),
              ],
            ),
            body: ListView.builder(
              itemBuilder: (BuildContext ctx, int index) {
                return ChangeNotifierProvider.value(
                  value:
                      wishlistProvider.getWishlistItems.values.toList()[index],
                  child: WishlistFullScreen(
                    productId:
                        wishlistProvider.getWishlistItems.keys.toList()[index],
                  ),
                );
              },
              itemCount: wishlistProvider.getWishlistItems.length,
            ),
          );
  }
}
