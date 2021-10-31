import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BrandRailWidget extends StatefulWidget {
  const BrandRailWidget({Key? key}) : super(key: key);

  @override
  _BrandRailWidgetState createState() => _BrandRailWidgetState();
}

class _BrandRailWidgetState extends State<BrandRailWidget> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetailsScreen.routeName,
          arguments: product.id),
      child: Container(
        //  color: Colors.red,
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        margin: const EdgeInsets.only(right: 20.0, bottom: 5.0, top: 18.0),
        constraints: const BoxConstraints(
            minHeight: 150, minWidth: double.infinity, maxHeight: 180.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
              ),
            ),
            FittedBox(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(5.0, 5.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                width: 160.0,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 4,
                      style: GoogleFonts.getFont(
                        'Roboto Slab',
                        color: Theme.of(context).textSelectionColor,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FittedBox(
                      child: Text(
                        'US ${product.price} \$',
                        maxLines: 1,
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.4,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      product.productCategoryName,
                      style: GoogleFonts.getFont(
                        'Roboto Slab',
                        color: Colors.grey,
                        fontSize: 18.0,
                      ),
                    ),
                    // TextStyle(color: Colors.grey, fontSize: 18.0)),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
