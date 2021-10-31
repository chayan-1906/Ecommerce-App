import 'package:badges/badges.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/product_details_screen.dart';
import 'package:ecommerce_app/widgets/feeds_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedProductsScreen extends StatefulWidget {
  const FeedProductsScreen({Key? key}) : super(key: key);

  @override
  _FeedProductsScreenState createState() => _FeedProductsScreenState();
}

class _FeedProductsScreenState extends State<FeedProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
        },
        child: Container(
          height: 290.0,
          width: 250.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  // product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.0),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: 100.0,
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: Flexible(
                        fit: FlexFit.tight,
                        child: Image.network(
                          product.imageUrl,
                          height: 180.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // badge
                  Badge(
                    alignment: Alignment.center,
                    toAnimate: true,
                    animationType: BadgeAnimationType.scale,
                    shape: BadgeShape.square,
                    badgeColor: Colors.amberAccent,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8.0),
                    ),
                    badgeContent: Text(
                      'New',
                      style: GoogleFonts.getFont(
                        'Roboto Slab',
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(left: 5.0),
                  margin:
                      const EdgeInsets.only(left: 5.0, bottom: 2.0, right: 3.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4.0),
                        Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          product.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '\$ ${product.price}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.7,
                              fontSize: 16.0,
                              color: ColorsConstants.red300,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${getTranslated(context, 'only')} ${product.quantity} left',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.getFont(
                                'Roboto Slab',
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        FeedsDialog(productId: product.id),
                                  );
                                },
                                borderRadius: BorderRadius.circular(18.0),
                                child: Icon(
                                  MyIcons.feedScreenIcons['more_horizontal'],
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
