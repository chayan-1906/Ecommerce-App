import 'package:backdrop/backdrop.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/inner_screen/brand_navigation_rail.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/widgets/category_widget.dart';
import 'package:ecommerce_app/widgets/home_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _carouselImages = [
    'assets/images/carousel_1.png',
    'assets/images/carousel_2.png',
    'assets/images/carousel_3.png',
    'assets/images/carousel_4.png',
  ];

  final List _brandImages = [
    'assets/images/huawei.jpg',
    'assets/images/adidas.jpg',
    'assets/images/apple.jpg',
    'assets/images/dell.jpg',
    'assets/images/h_m.jpg',
    'assets/images/nike.jpg',
    'assets/images/samsung.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    productsProvider.fetchProducts();
    final popularItems = productsProvider.findByPopular;
    print('popularItems.length: ${popularItems.length}');

    return BackdropScaffold(
      frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      headerHeight: MediaQuery.of(context).size.height * 0.25,
      appBar: BackdropAppBar(
        title: Text(
          getTranslated(context, 'home'),
          style: GoogleFonts.getFont(
            'Roboto Slab',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackdropToggleButton(icon: AnimatedIcons.home_menu),
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
          IconButton(
            onPressed: () {},
            iconSize: 15.0,
            padding: const EdgeInsets.all(10.0),
            icon: const CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 13.0,
                backgroundImage: NetworkImage(
                    'https://i.ytimg.com/vi/ETsekJKsr3M/maxresdefault.jpg'),
              ),
            ),
          )
        ],
      ),
      backLayer: backLayerMenu(context),
      frontLayer: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel
            SizedBox(
              height: 190.0,
              width: double.infinity,
              child: Carousel(
                boxFit: BoxFit.fill,
                autoplay: true,
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: const Duration(milliseconds: 1000),
                dotSize: 5.0,
                dotIncreasedColor: const Color(0xFF172774),
                dotBgColor: Colors.transparent,
                dotPosition: DotPosition.bottomCenter,
                showIndicator: true,
                indicatorBgPadding: 5.0,
                images: [
                  ExactAssetImage(_carouselImages[0]),
                  ExactAssetImage(_carouselImages[1]),
                  ExactAssetImage(_carouselImages[2]),
                  ExactAssetImage(_carouselImages[3]),
                ],
              ),
            ),
            // Categories
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getTranslated(context, 'categories'),
                    style: GoogleFonts.getFont(
                      'Roboto Slab',
                      fontWeight: FontWeight.w800,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 180.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext ctx, int index) {
                  return CategoryWidget(index: index);
                },
                itemCount: 7,
              ),
            ),
            // Popular Brands
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    getTranslated(context, 'popular_brands'),
                    style: GoogleFonts.getFont(
                      'Roboto Slab',
                      fontWeight: FontWeight.w800,
                      fontSize: 20.0,
                    ),
                  ),
                  const Spacer(),
                  FlatButton(
                    // padding: EdgeInsets.all(8.0),
                    splashColor: Colors.redAccent.shade100,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        BrandNavigationRail.routeName,
                        arguments: {7},
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          getTranslated(context, 'more'),
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontWeight: FontWeight.w800,
                            fontSize: 15.0,
                            color: Colors.redAccent,
                          ),
                        ),
                        Icon(
                          MyIcons.homeScreenIcons['chevrons_right'],
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Swiper(
                itemBuilder: (BuildContext ctx, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      color: Colors.blueGrey,
                      child: Image.asset(
                        _brandImages[index],
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                itemCount: _brandImages.length,
                autoplay: true,
                onTap: (index) {
                  print('_brandImages[index]: ${_brandImages[index]}');
                  Navigator.of(context).pushNamed(
                    BrandNavigationRail.routeName,
                    arguments: {index},
                  );
                },
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
