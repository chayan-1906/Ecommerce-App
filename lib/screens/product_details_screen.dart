import 'package:badges/badges.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:ecommerce_app/provider/wishlist_provider.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/widgets/product_details_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'feeds_products_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product_details_screen';

  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final productsList = productsProvider.products;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    print('productId: $productId');
    final product = productsProvider.findById(productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      bottomSheet: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.08,
        child: RaisedButton.icon(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          color: ColorsConstants.red400,
          onPressed: cartProvider.getCartItems.containsKey(productId)
              ? () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }
              : () {
                  cartProvider.addProductToCart(
                    productId,
                    product.price,
                    product.title,
                    product.imageUrl,
                  );
                },
          icon: Icon(
            cartProvider.getCartItems.containsKey(productId)
                ? MyIcons.productDetailsScreenIcons['cart_covered']
                : MyIcons.productDetailsScreenIcons['cart_plus'],
            color: Colors.white,
          ),
          label: Text(
            cartProvider.getCartItems.containsKey(productId)
                ? getTranslated(context, 'go_to_cart').toUpperCase()
                : getTranslated(context, 'add_to_cart').toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.getFont(
              'Roboto Slab',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            foregroundDecoration: const BoxDecoration(color: Colors.black12),
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Image.network(product.imageUrl),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 250.0),
                // share button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.greenAccent.shade200,
                    onTap: () {
                      // TODO: SHARE PRODUCT
                    },
                    borderRadius: BorderRadius.circular(30.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        MyIcons.productDetailsScreenIcons['share'],
                        size: 23.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.getFont(
                                'Roboto Slab',
                                fontWeight: FontWeight.w600,
                                fontSize: 28.0,
                              ),
                            ),
                          ),
                          // const SizedBox(height: 8.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              'US \$ ${product.price}',
                              style: GoogleFonts.getFont(
                                'Roboto Slab',
                                color: themeState.darkTheme
                                    ? Theme.of(context).disabledColor
                                    : ColorsConstants.subTitle,
                                fontWeight: FontWeight.w600,
                                fontSize: 21.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 1.0,
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              product.description,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.getFont(
                                'Roboto Slab',
                                color: themeState.darkTheme
                                    ? Theme.of(context).disabledColor
                                    : ColorsConstants.subTitle,
                                fontWeight: FontWeight.w600,
                                fontSize: 21.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 1.0,
                          ),
                          product.brand == 'Brandless'
                              ? Container()
                              : productDescription(
                                  context: context,
                                  themeState: themeState.darkTheme,
                                  title: '${getTranslated(context, 'brand')} ',
                                  value: product.brand),
                          productDescription(
                              context: context,
                              themeState: themeState.darkTheme,
                              title: '${getTranslated(context, 'quantity')}',
                              value: '${product.quantity}'),
                          productDescription(
                              context: context,
                              themeState: themeState.darkTheme,
                              title: '${getTranslated(context, 'category')}',
                              value: product.productCategoryName),
                          const SizedBox(height: 15.0),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 1.0,
                          ),
                          Container(
                            color: Theme.of(context).backgroundColor,
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(height: 10.0),
                                Text(
                                  'No reviews yet',
                                  style: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Theme.of(context).textSelectionColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 21.0,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  'Be the first review!',
                                  style: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    color: Theme.of(context).textSelectionColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(height: 70.0),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                  height: 1.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    getTranslated(context, 'suggested_products'),
                    style: GoogleFonts.getFont(
                      'Roboto Slab',
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  // margin: const EdgeInsets.only(bottom: 30.0),
                  width: double.infinity,
                  height: 360.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: productsList[index],
                        child: const FeedProductsScreen(),
                      );
                    },
                    itemCount:
                        productsList.length < 7 ? productsList.length : 7,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                getTranslated(context, 'detail'),
                style: GoogleFonts.getFont(
                  'Roboto Slab',
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.2,
                  fontSize: 20.0,
                ),
              ),
              actions: [
                // wishlist icon
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
                        wishlistProvider.addRemoveWishlist(productId,
                            product.price, product.title, product.imageUrl);
                        // Navigator.of(context).pushNamed(WishlistScreen.routeName);
                      },
                      icon: Icon(
                        wishlistProvider.getWishlistItems.containsKey(productId)
                            ? MyIcons
                                .productDetailsScreenIcons['wishlist_covered']
                            : MyIcons
                                .productDetailsScreenIcons['wishlist_outlined'],
                        color: wishlistProvider.getWishlistItems
                                .containsKey(productId)
                            ? Colors.greenAccent
                            : Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                // cart icon
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
                        cartProvider.getCartItems.containsKey(productId)
                            ? MyIcons.productDetailsScreenIcons['cart_covered']
                            : MyIcons
                                .productDetailsScreenIcons['cart_outlined'],
                        color: ColorsConstants.red500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
