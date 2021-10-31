import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/wishlist_provider.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Positioned positionedRemove(BuildContext context, String productId) {
  final wishlistProvider = Provider.of<WishlistProvider>(context);

  return Positioned(
    top: 20.0,
    right: 15.0,
    child: SizedBox(
      height: 30.0,
      width: 30.0,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(0.0),
        color: ColorsConstants.red500,
        child: Icon(
          MyIcons.wishlistScreenIcons['clear'],
          color: Colors.white,
        ),
        onPressed: () {
          GlobalMethods.customDialog(
            context,
            getTranslated(context, 'remove_item'),
            getTranslated(context, 'remove_warning'),
            () {
              wishlistProvider.removeItem(productId);
              Navigator.pop(context);
            },
          );
        },
      ),
    ),
  );
}
