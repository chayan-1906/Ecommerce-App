import 'package:badges/badges.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/provider/wishlist_provider.dart';
import 'package:ecommerce_app/screens/feeds_products_screen.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'cart/cart_screen.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = '/feeds_screen';

  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  Future<void> _getProductsOnRefresh() async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    setState(() {});
  }

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
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final popular = ModalRoute.of(context)!.settings.arguments as String;
    List<Product> productList = productsProvider.products;
    if (popular == 'popular') {
      productList = productsProvider.findByPopular;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated(context, 'feeds'),
          style: GoogleFonts.getFont(
            'Roboto Slab',
            fontWeight: FontWeight.bold,
          ),
        ),
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
        actions: [
          Consumer<WishlistProvider>(
            builder: (_, wishlist, ch) => Badge(
              badgeColor: ColorsConstants.favBadgeColor,
              animationType: BadgeAnimationType.scale,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 1, end: 2),
              showBadge: wishlistProvider.getWishlistItems.isNotEmpty,
              badgeContent: Text(
                wishlistProvider.getWishlistItems.length.toString(),
                style: GoogleFonts.getFont(
                  'Roboto Slab',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(WishlistScreen.routeName);
                },
                icon: Icon(
                  MyIcons.productDetailsScreenIcons['wishlist_covered'],
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              badgeColor: ColorsConstants.favBadgeColor,
              animationType: BadgeAnimationType.scale,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 1, end: 2),
              showBadge: cartProvider.getCartItems.isNotEmpty,
              badgeContent: Text(
                // cartProvider.getCartItems.length.toString(),
                cartProvider.totalItems.toString(),
                style: GoogleFonts.getFont(
                  'Roboto Slab',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: Icon(
                  MyIcons.productDetailsScreenIcons['cart_covered'],
                  color: ColorsConstants.red500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      backgroundColor: Theme.of(context).cardColor,
      // backgroundColor: Colors.black12,
      body: RefreshIndicator(
        onRefresh: _getProductsOnRefresh,
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 5,
          shrinkWrap: true,
          // staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          itemCount: productList.length,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          // padding: EdgeInsets.symmetric(horizontal: 15.0),
          itemBuilder: (BuildContext context, int index) =>
              ChangeNotifierProvider.value(
            value: productList[index],
            child: const FeedProductsScreen(),
          ),
          staggeredTileBuilder: (int index) => StaggeredTile.count(5, 4.4),
        ),
      ),
    );
  }
}
