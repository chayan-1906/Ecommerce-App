import 'package:ecommerce_app/constants/my_icons.dart';
import 'package:ecommerce_app/localization/localization_constants.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'brand_rail_widget.dart';

class BrandNavigationRail extends StatefulWidget {
  static const routeName = '/brand_navigation_rail';

  const BrandNavigationRail({Key? key}) : super(key: key);

  @override
  _BrandNavigationRailState createState() => _BrandNavigationRailState();
}

class _BrandNavigationRailState extends State<BrandNavigationRail> {
  int _selectedIndex = 0;
  static const padding = 8.0;
  String? routeArgs;
  String? brandName;

  @override
  void didChangeDependencies() {
    routeArgs = ModalRoute.of(context)!.settings.arguments.toString();
    _selectedIndex = int.parse(
      routeArgs!.substring(1, 2),
    );
    print(routeArgs.toString());
    if (_selectedIndex == 0) {
      setState(() {
        brandName = 'Huawei';
      });
    }
    if (_selectedIndex == 1) {
      setState(() {
        brandName = 'Adidas';
      });
    }
    if (_selectedIndex == 2) {
      setState(() {
        brandName = 'Apple';
      });
    }
    if (_selectedIndex == 3) {
      setState(() {
        brandName = 'Dell';
      });
    }
    if (_selectedIndex == 4) {
      setState(() {
        brandName = 'H & M';
      });
    }
    if (_selectedIndex == 5) {
      setState(() {
        brandName = 'Nike';
      });
    }
    if (_selectedIndex == 6) {
      setState(() {
        brandName = 'Samsung';
      });
    }
    if (_selectedIndex == 7) {
      setState(() {
        brandName = 'All';
      });
    }
    print(_selectedIndex);
    print(brandName);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.minHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      minWidth: 56.0,
                      groupAlignment: 1.0,
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                          if (_selectedIndex == 0) {
                            setState(() {
                              brandName = 'Huawei';
                            });
                          }
                          if (_selectedIndex == 1) {
                            setState(() {
                              brandName = 'Adidas';
                            });
                          }
                          if (_selectedIndex == 2) {
                            setState(() {
                              brandName = 'Apple';
                            });
                          }
                          if (_selectedIndex == 3) {
                            setState(() {
                              brandName = 'Dell';
                            });
                          }
                          if (_selectedIndex == 4) {
                            setState(() {
                              brandName = 'H & M';
                            });
                          }
                          if (_selectedIndex == 5) {
                            setState(() {
                              brandName = 'Nike';
                            });
                          }
                          if (_selectedIndex == 6) {
                            setState(() {
                              brandName = 'Samsung';
                            });
                          }
                          if (_selectedIndex == 7) {
                            setState(() {
                              brandName = 'All';
                            });
                          }
                          print(_selectedIndex);
                          print(brandName);
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      leading: Column(
                        children: const [
                          SizedBox(height: 20.0),
                          Center(
                            child: CircleAvatar(
                              radius: 16.0,
                              backgroundImage: NetworkImage(
                                  'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                            ),
                          ),
                          SizedBox(height: 80.0),
                        ],
                      ),
                      selectedLabelTextStyle: GoogleFonts.getFont(
                        'Roboto Slab',
                        color: Color(0xFFFFE6BC97),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.5,
                      ),
                      unselectedLabelTextStyle: GoogleFonts.getFont(
                        'Roboto Slab',
                        fontSize: 15.0,
                        letterSpacing: 0.8,
                      ),
                      destinations: [
                        buildRotatedTextRailDestination('Huawei', padding),
                        buildRotatedTextRailDestination('Adidas', padding),
                        buildRotatedTextRailDestination('Apple', padding),
                        buildRotatedTextRailDestination('Dell', padding),
                        buildRotatedTextRailDestination('H & M', padding),
                        buildRotatedTextRailDestination('Nike', padding),
                        buildRotatedTextRailDestination('Samsung', padding),
                        buildRotatedTextRailDestination('All', padding),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ContentSpace(context: context, brandName: brandName!),
        ],
      ),
    );
  }

  NavigationRailDestination buildRotatedTextRailDestination(
      String text, double padding) {
    return NavigationRailDestination(
      icon: const SizedBox.shrink(),
      label: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: RotatedBox(
          quarterTurns: -1,
          child: Text(text),
        ),
      ),
    );
  }
}

class ContentSpace extends StatelessWidget {
  final String brandName;

  const ContentSpace(
      {Key? key, required BuildContext context, required this.brandName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final productsBrand = productsProvider.findByBrand(brandName);
    print('productsBrand $productsBrand');
    if (brandName == 'All') {
      for (int i = 0; i < productsProvider.products.length; i++) {
        productsBrand.add(productsProvider.products[i]);
      }
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 0.0, 0.0),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: productsBrand.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MyIcons.brandNavigationScreenIcons['database'],
                      size: 90.0,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${getTranslated(context, 'no_products')} $brandName',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                          fontSize: 40.0,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: productsBrand.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ChangeNotifierProvider.value(
                    value: productsBrand[index],
                    child: const BrandRailWidget(),
                  ),
                ),
        ),
      ),
    );
  }
}
