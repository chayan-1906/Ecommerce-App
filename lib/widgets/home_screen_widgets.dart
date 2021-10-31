import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/feeds_screen.dart';
import 'package:ecommerce_app/screens/upload_products_screen.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget backLayerMenu(BuildContext context) {
  return Stack(
    fit: StackFit.expand,
    children: [
      Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsConstants.starterColor,
              ColorsConstants.endColor,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      Positioned(
        top: -100.0,
        left: 140.0,
        child: Transform.rotate(
          angle: -0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white.withOpacity(0.3),
            ),
            width: 150.0,
            height: 250.0,
          ),
        ),
      ),
      Positioned(
        bottom: 0.0,
        right: 100.0,
        child: Transform.rotate(
          angle: -0.8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white.withOpacity(0.3),
            ),
            width: 150.0,
            height: 300.0,
          ),
        ),
      ),
      Positioned(
        top: -50.0,
        left: 60.0,
        child: Transform.rotate(
          angle: -0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white.withOpacity(0.3),
            ),
            width: 150.0,
            height: 200.0,
          ),
        ),
      ),
      Positioned(
        bottom: 10.0,
        right: 0.0,
        child: Transform.rotate(
          angle: -0.8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white.withOpacity(0.3),
            ),
            width: 150.0,
            height: 300.0,
          ),
        ),
      ),
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              content(
                context,
                () {
                  navigateTo(context, FeedsScreen.routeName);
                },
                getTranslated(context, 'feeds'),
                'feedIcon',
              ),
              const SizedBox(height: 10.0),
              content(
                context,
                () {
                  navigateTo(context, CartScreen.routeName);
                },
                getTranslated(context, 'cart'),
                'cartIcon',
              ),
              const SizedBox(height: 10.0),
              content(
                context,
                () {
                  navigateTo(context, WishlistScreen.routeName);
                },
                getTranslated(context, 'wishlist'),
                'wishlist',
              ),
              const SizedBox(height: 10.0),
              content(
                context,
                () {
                  navigateTo(context, UploadProductsScreen.routeName);
                },
                getTranslated(context, 'upload_new_product'),
                'upload',
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            ],
          ),
        ),
      ),
    ],
  );
}

void navigateTo(BuildContext ctx, String routeName) {
  Navigator.of(ctx).pushNamed(routeName);
}

Widget content(BuildContext ctx, Function fct, String text, String iconData) {
  return InkWell(
    onTap: () {
      return fct();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: GoogleFonts.getFont(
              'Roboto Slab',
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Icon(MyIcons.backLayerIcons[iconData]),
      ],
    ),
  );
}
