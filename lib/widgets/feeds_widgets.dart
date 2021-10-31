import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:ecommerce_app/provider/wishlist_provider.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedsDialog extends StatelessWidget {
  final String productId;
  const FeedsDialog({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final product = productsProvider.findById(productId);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 100.0,
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Image.network(
                product.imageUrl,
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // wishlist
                    Flexible(
                      child: dialogContent(context, 0, () {
                        wishlistProvider.addRemoveWishlist(productId,
                            product.price, product.title, product.imageUrl);
                        Navigator.of(context).canPop()
                            ? Navigator.of(context).pop()
                            : null;
                      }),
                    ),
                    // view product
                    Flexible(
                      child: dialogContent(context, 1, () {
                        Navigator.of(context)
                            .pushNamed(
                              ProductDetailsScreen.routeName,
                              arguments: product.id,
                            )
                            .then((value) => Navigator.of(context).canPop()
                                ? Navigator.of(context).pop()
                                : null);
                      }),
                    ),
                    // cart
                    Flexible(
                      child: dialogContent(
                          context,
                          2,
                          cartProvider.getCartItems.containsKey(productId)
                              ? () {
                                  Navigator.of(context)
                                      .pushNamed(CartScreen.routeName);
                                }
                              : () {
                                  cartProvider.addProductToCart(
                                    productId,
                                    product.price,
                                    product.title,
                                    product.imageUrl,
                                  );
                                  Navigator.of(context).canPop()
                                      ? Navigator.of(context).pop()
                                      : null;
                                }),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.3),
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  splashColor: Colors.grey,
                  onTap: () =>
                      Navigator.canPop(context) ? Navigator.pop(context) : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      MyIcons.feedScreenIcons['close'],
                      size: 28.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dialogContent(BuildContext context, int index, Function func) {
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    List<IconData?> _dialogIcons = [
      wishlistProvider.getWishlistItems.containsKey(productId)
          ? MyIcons.feedScreenIcons['wishlist_covered']
          : MyIcons.feedScreenIcons['wishlist_outlined'],
      MyIcons.feedScreenIcons['view'],
      cartProvider.getCartItems.containsKey(productId)
          ? MyIcons.feedScreenIcons['cart_covered']
          : MyIcons.feedScreenIcons['cart_plus'],
      MyIcons.feedScreenIcons['delete'],
    ];

    List<String> _texts = [
      wishlistProvider.getWishlistItems.containsKey(productId)
          ? getTranslated(context, 'go_to_wishlist').toUpperCase()
          : getTranslated(context, 'add_to_wishlist').toUpperCase(),
      getTranslated(context, 'view_product'),
      cartProvider.getCartItems.containsKey(productId)
          ? getTranslated(context, 'go_to_cart').toUpperCase()
          : getTranslated(context, 'add_to_cart').toUpperCase(),
    ];

    List<Color> _colors = [
      wishlistProvider.getWishlistItems.containsKey(productId)
          ? Colors.greenAccent
          : ColorsConstants.title,
      Theme.of(context).textSelectionColor,
      cartProvider.getCartItems.containsKey(productId)
          ? Colors.redAccent
          : ColorsConstants.title,
    ];

    final themeChange = Provider.of<ThemeProvider>(context);
    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            func();
          },
          splashColor: Colors.orangeAccent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Icon(
                        _dialogIcons[index],
                        color: _colors[index],
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      _texts[index],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Roboto Slab',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        color: themeChange.darkTheme
                            ? Theme.of(context).disabledColor
                            : ColorsConstants.subTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
