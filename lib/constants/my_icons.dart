import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyIcons {
  static IconData homeIcon = Feather.home;
  static IconData homeCircleIcon = MaterialCommunityIcons.home_circle;
  static IconData feedIcon = Feather.rss;
  static IconData feedBoxIcon = MaterialCommunityIcons.rss_box;
  static IconData cartIcon = MaterialCommunityIcons.cart_outline;
  static IconData cartCoveredIcon = MaterialCommunityIcons.cart;
  static IconData accountIcon = MaterialCommunityIcons.account_outline;
  static IconData accountIconCovered = MaterialCommunityIcons.account;
  static IconData shoppingSearchIcon = MaterialCommunityIcons.shopping_search;

  static Map<String, IconData> userTileIcons = {
    'wishlist_outlined': Icons.favorite_outline_rounded,
    'chevron_right': Feather.chevron_right,
    'cartIcon': Feather.shopping_bag,
    'orders': Feather.shopping_bag,
    'email': MaterialIcons.email,
    'phone_call': Feather.phone_call,
    'local_shipping': MaterialIcons.local_shipping,
    'watch_later': MaterialIcons.watch_later,
    'language': MaterialIcons.language,
    'exit_to_app': MaterialCommunityIcons.exit_to_app,
    'theme_light_dark': MaterialCommunityIcons.theme_light_dark,
    'delete': Feather.delete,
  };

  static Map<String, IconData> cartScreenIcons = {
    'delete': Entypo.circle_with_cross,
    'minus': Entypo.circle_with_minus,
    'plus': Entypo.circle_with_plus,
    'trash': Entypo.trash,
  };

  static Map<String, IconData> feedScreenIcons = {
    'more_horizontal': Feather.more_horizontal,
    'wishlist_outlined': Icons.favorite_outline_rounded,
    'wishlist_covered': Icons.favorite_rounded,
    'cart_covered': MaterialCommunityIcons.cart,
    'cart_plus': MaterialCommunityIcons.cart_plus,
    'cart_outlined': MaterialCommunityIcons.cart_outline,
    'view': MaterialCommunityIcons.eye,
    'close': Icons.clear,
  };

  static Map<String, IconData> homeScreenIcons = {
    'chevrons_right': Feather.chevrons_right,
    'star': Entypo.star,
    'star_outlined': Entypo.star_outlined,
    'cart': MaterialCommunityIcons.cart,
    'cart_plus': MaterialCommunityIcons.cart_plus,
    'database': Feather.database,
  };

  static Map<String, IconData> backLayerIcons = {
    'feedIcon': Feather.rss,
    'cartIcon': Feather.shopping_bag,
    'wishlist': Feather.heart,
    'upload': Feather.upload,
  };

  static Map<String, IconData> wishlistScreenIcons = {
    'clear': Icons.clear,
  };

  static Map<String, IconData> productDetailsScreenIcons = {
    'save': MaterialCommunityIcons.content_save,
    'share': MaterialCommunityIcons.share_variant,
    'wishlist_outlined': Icons.favorite_outline_rounded,
    'wishlist_covered': Icons.favorite_rounded,
    'cart_covered': MaterialCommunityIcons.cart,
    'cart_outlined': MaterialCommunityIcons.cart_outline,
    'cart_plus': MaterialCommunityIcons.cart_plus,
    'buy': Icons.payment,
  };

  static Map<String, IconData> searchScreenIcons = {
    'search': MaterialCommunityIcons.shopping_search,
    'clear': Feather.x,
    'wishlist_outlined': Icons.favorite_outline_rounded,
    'wishlist_covered': Icons.favorite_rounded,
    'cart_covered': MaterialCommunityIcons.cart,
    'search_not_found': Feather.search,
  };

  static Map<String, IconData> landingPageIcons = {
    'error': MaterialIcons.error,
    'sign_up': Feather.user_plus,
    'sign_in': Feather.user_check,
    'google': MaterialCommunityIcons.google_plus_box,
  };

  static Map<String, IconData> loginScreenIcons = {
    'email': MaterialIcons.email,
    'password': MaterialIcons.lock,
    'visibility_on': MaterialIcons.visibility,
    'visibility_off': MaterialIcons.visibility_off,
    'sign_in': Feather.user_check,
  };

  static Map<String, IconData> signupScreenIcons = {
    'email': MaterialIcons.email,
    'password': MaterialIcons.lock,
    'visibility_on': MaterialIcons.visibility,
    'visibility_off': MaterialIcons.visibility_off,
    'error': MaterialIcons.error,
    'sign_up': Feather.user_plus,
    'sign_in': Feather.user_check,
    'person': MaterialIcons.person,
    'phone': MaterialIcons.phone,
    'add_a_photo': MaterialIcons.add_a_photo,
    'camera': MaterialIcons.camera_alt,
    'gallery': MaterialIcons.image,
    'remove': MaterialIcons.remove_circle,
  };

  static Map<String, IconData> uploadProductScreenIcons = {
    'camera': MaterialIcons.camera_alt,
    'gallery': MaterialIcons.image,
    'remove': MaterialIcons.remove_circle,
    'unfold_more_rounded': MaterialCommunityIcons.unfold_more_horizontal,
    'dropdown': MaterialCommunityIcons.arrow_down_drop_circle,
    'upload': Feather.upload,
  };

  static Map<String, IconData> forgetPasswordScreenIcons = {
    'email': MaterialIcons.email,
    'lock': Entypo.key,
  };

  static Map<String, IconData> orderScreenIcons = {
    'trash': Entypo.trash,
  };

  static Map<String, IconData> brandNavigationScreenIcons = {
    'database': Feather.database,
  };
}
