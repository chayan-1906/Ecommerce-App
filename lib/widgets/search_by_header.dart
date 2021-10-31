import 'package:badges/badges.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/wishlist_provider.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/user_info_screen.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchByHeader extends SliverPersistentHeaderDelegate {
  final double flexibleSpace;
  final double backGroundHeight;
  final double stackPaddingTop;
  final double titlePaddingTop;
  final Widget title;
  // final Widget subTitle;
  // Widget leading;
  // final Widget action;
  final Widget stackChild;

  SearchByHeader({
    this.flexibleSpace = 250,
    this.backGroundHeight = 200,
    required this.stackPaddingTop,
    this.titlePaddingTop = 35,
    required this.title,
    // required this.subTitle,
    // required this.leading,
    // required this.action,
    required this.stackChild,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    var percent = shrinkOffset / (maxExtent - minExtent);
    double calculate = 1 - percent < 0 ? 0 : (1 - percent);
    return SizedBox(
      height: maxExtent,
      child: Stack(
        children: [
          Container(
            height: minExtent + ((backGroundHeight - minExtent) * calculate),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorsConstants.starterColor,
                  ColorsConstants.endColor,
                ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            right: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<WishlistProvider>(
                  builder: (_, wishlist, ch) => Badge(
                    badgeColor: ColorsConstants.favBadgeColor,
                    position: BadgePosition.topEnd(top: 1.0, end: 2.0),
                    badgeContent: Text(
                      wishlist.getWishlistItems.length.toString(),
                      style: GoogleFonts.getFont(
                        'Roboto Slab',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(WishlistScreen.routeName);
                      },
                      icon: Icon(
                        MyIcons.searchScreenIcons['wishlist_covered'],
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (_, cart, ch) => Badge(
                    badgeColor: ColorsConstants.favBadgeColor,
                    position: BadgePosition.topEnd(top: 1.0, end: 2.0),
                    badgeContent: Text(
                      cart.getCartItems.length.toString(),
                      style: GoogleFonts.getFont(
                        'Roboto Slab',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      icon: Icon(
                        MyIcons.searchScreenIcons['cart_covered'],
                        color: ColorsConstants.red500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 32.0,
            left: 10.0,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                splashColor: Colors.orangeAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserInfoScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.35,
            top: titlePaddingTop * calculate + 27,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // leading,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 1 + calculate * 0.5,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 14 * (1 - calculate),
                          ),
                          child: title,
                        ),
                      ),
                      if (calculate > 0.5) ...[
                        const SizedBox(height: 10.0),
                        Opacity(
                          opacity: calculate,
                          // child: subTitle,
                        ),
                      ],
                    ],
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 14 * calculate),
                    // child: action,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: minExtent + ((stackPaddingTop - minExtent) * calculate),
            child: Opacity(
              opacity: calculate,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: stackChild,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => flexibleSpace;

  @override
  // TODO: implement minExtent
  double get minExtent => kToolbarHeight + 25;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
