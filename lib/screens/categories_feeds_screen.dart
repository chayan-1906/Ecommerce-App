import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/screens/feeds_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoriesFeedsScreen extends StatefulWidget {
  static const routeName = '/categories_feeds_screen';

  const CategoriesFeedsScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesFeedsScreen> createState() => _CategoriesFeedsScreenState();
}

class _CategoriesFeedsScreenState extends State<CategoriesFeedsScreen> {
  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;
    print(categoryName);
    final List<Product> productList =
        productsProvider.findByCategory(categoryName);

    return Scaffold(
      body: productList.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MyIcons.brandNavigationScreenIcons['database'],
                  size: 90.0,
                  color: ColorsConstants.red700,
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${getTranslated(context, 'no_products')} $categoryName',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Roboto Slab',
                      fontSize: 40.0,
                      color: ColorsConstants.red700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            )
          : StaggeredGridView.countBuilder(
              crossAxisCount: 6,
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) =>
                  ChangeNotifierProvider.value(
                value: productList[index],
                child: const FeedProductsScreen(),
              ),
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(3, index.isEven ? 5 : 5),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 6.0,
            ),
    );
  }
}
